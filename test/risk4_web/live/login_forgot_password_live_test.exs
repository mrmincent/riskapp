defmodule Risk4Web.LoginForgotPasswordLiveTest do
  use Risk4Web.ConnCase

  import Phoenix.LiveViewTest
  import Risk4.AccountsFixtures

  alias Risk4.Accounts
  alias Risk4.Repo

  describe "Forgot password page" do
    test "renders email page", %{conn: conn} do
      {:ok, lv, html} = live(conn, ~p"/logins/reset_password")

      assert html =~ "Forgot your password?"
      assert has_element?(lv, ~s|a[href="#{~p"/logins/register"}"]|, "Register")
      assert has_element?(lv, ~s|a[href="#{~p"/logins/log_in"}"]|, "Log in")
    end

    test "redirects if already logged in", %{conn: conn} do
      result =
        conn
        |> log_in_login(login_fixture())
        |> live(~p"/logins/reset_password")
        |> follow_redirect(conn, ~p"/")

      assert {:ok, _conn} = result
    end
  end

  describe "Reset link" do
    setup do
      %{login: login_fixture()}
    end

    test "sends a new reset password token", %{conn: conn, login: login} do
      {:ok, lv, _html} = live(conn, ~p"/logins/reset_password")

      {:ok, conn} =
        lv
        |> form("#reset_password_form", login: %{"email" => login.email})
        |> render_submit()
        |> follow_redirect(conn, "/")

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "If your email is in our system"

      assert Repo.get_by!(Accounts.LoginToken, login_id: login.id).context ==
               "reset_password"
    end

    test "does not send reset password token if email is invalid", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/logins/reset_password")

      {:ok, conn} =
        lv
        |> form("#reset_password_form", login: %{"email" => "unknown@example.com"})
        |> render_submit()
        |> follow_redirect(conn, "/")

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "If your email is in our system"
      assert Repo.all(Accounts.LoginToken) == []
    end
  end
end
