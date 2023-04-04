defmodule Risk4Web.LoginSessionControllerTest do
  use Risk4Web.ConnCase, async: true

  import Risk4.AccountsFixtures

  setup do
    %{login: login_fixture()}
  end

  describe "POST /logins/log_in" do
    test "logs the login in", %{conn: conn, login: login} do
      conn =
        post(conn, ~p"/logins/log_in", %{
          "login" => %{"email" => login.email, "password" => valid_login_password()}
        })

      assert get_session(conn, :login_token)
      assert redirected_to(conn) == ~p"/"

      # Now do a logged in request and assert on the menu
      conn = get(conn, ~p"/")
      response = html_response(conn, 200)
      assert response =~ login.email
      assert response =~ ~p"/logins/settings"
      assert response =~ ~p"/logins/log_out"
    end

    test "logs the login in with remember me", %{conn: conn, login: login} do
      conn =
        post(conn, ~p"/logins/log_in", %{
          "login" => %{
            "email" => login.email,
            "password" => valid_login_password(),
            "remember_me" => "true"
          }
        })

      assert conn.resp_cookies["_risk4_web_login_remember_me"]
      assert redirected_to(conn) == ~p"/"
    end

    test "logs the login in with return to", %{conn: conn, login: login} do
      conn =
        conn
        |> init_test_session(login_return_to: "/foo/bar")
        |> post(~p"/logins/log_in", %{
          "login" => %{
            "email" => login.email,
            "password" => valid_login_password()
          }
        })

      assert redirected_to(conn) == "/foo/bar"
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Welcome back!"
    end

    test "login following registration", %{conn: conn, login: login} do
      conn =
        conn
        |> post(~p"/logins/log_in", %{
          "_action" => "registered",
          "login" => %{
            "email" => login.email,
            "password" => valid_login_password()
          }
        })

      assert redirected_to(conn) == ~p"/"
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Account created successfully"
    end

    test "login following password update", %{conn: conn, login: login} do
      conn =
        conn
        |> post(~p"/logins/log_in", %{
          "_action" => "password_updated",
          "login" => %{
            "email" => login.email,
            "password" => valid_login_password()
          }
        })

      assert redirected_to(conn) == ~p"/logins/settings"
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Password updated successfully"
    end

    test "redirects to login page with invalid credentials", %{conn: conn} do
      conn =
        post(conn, ~p"/logins/log_in", %{
          "login" => %{"email" => "invalid@email.com", "password" => "invalid_password"}
        })

      assert Phoenix.Flash.get(conn.assigns.flash, :error) == "Invalid email or password"
      assert redirected_to(conn) == ~p"/logins/log_in"
    end
  end

  describe "DELETE /logins/log_out" do
    test "logs the login out", %{conn: conn, login: login} do
      conn = conn |> log_in_login(login) |> delete(~p"/logins/log_out")
      assert redirected_to(conn) == ~p"/"
      refute get_session(conn, :login_token)
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Logged out successfully"
    end

    test "succeeds even if the login is not logged in", %{conn: conn} do
      conn = delete(conn, ~p"/logins/log_out")
      assert redirected_to(conn) == ~p"/"
      refute get_session(conn, :login_token)
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Logged out successfully"
    end
  end
end
