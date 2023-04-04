defmodule Risk4Web.LoginLoginLiveTest do
  use Risk4Web.ConnCase

  import Phoenix.LiveViewTest
  import Risk4.AccountsFixtures

  describe "Log in page" do
    test "renders log in page", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/logins/log_in")

      assert html =~ "Log in"
      assert html =~ "Register"
      assert html =~ "Forgot your password?"
    end

    test "redirects if already logged in", %{conn: conn} do
      result =
        conn
        |> log_in_login(login_fixture())
        |> live(~p"/logins/log_in")
        |> follow_redirect(conn, "/")

      assert {:ok, _conn} = result
    end
  end

  describe "login login" do
    test "redirects if login login with valid credentials", %{conn: conn} do
      password = "123456789abcd"
      login = login_fixture(%{password: password})

      {:ok, lv, _html} = live(conn, ~p"/logins/log_in")

      form =
        form(lv, "#login_form", login: %{email: login.email, password: password, remember_me: true})

      conn = submit_form(form, conn)

      assert redirected_to(conn) == ~p"/"
    end

    test "redirects to login page with a flash error if there are no valid credentials", %{
      conn: conn
    } do
      {:ok, lv, _html} = live(conn, ~p"/logins/log_in")

      form =
        form(lv, "#login_form",
          login: %{email: "test@email.com", password: "123456", remember_me: true}
        )

      conn = submit_form(form, conn)

      assert Phoenix.Flash.get(conn.assigns.flash, :error) == "Invalid email or password"

      assert redirected_to(conn) == "/logins/log_in"
    end
  end

  describe "login navigation" do
    test "redirects to registration page when the Register button is clicked", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/logins/log_in")

      {:ok, _login_live, login_html} =
        lv
        |> element(~s|main a:fl-contains("Sign up")|)
        |> render_click()
        |> follow_redirect(conn, ~p"/logins/register")

      assert login_html =~ "Register"
    end

    test "redirects to forgot password page when the Forgot Password button is clicked", %{
      conn: conn
    } do
      {:ok, lv, _html} = live(conn, ~p"/logins/log_in")

      {:ok, conn} =
        lv
        |> element(~s|main a:fl-contains("Forgot your password?")|)
        |> render_click()
        |> follow_redirect(conn, ~p"/logins/reset_password")

      assert conn.resp_body =~ "Forgot your password?"
    end
  end
end
