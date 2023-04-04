defmodule Risk4Web.LoginSettingsLiveTest do
  use Risk4Web.ConnCase

  alias Risk4.Accounts
  import Phoenix.LiveViewTest
  import Risk4.AccountsFixtures

  describe "Settings page" do
    test "renders settings page", %{conn: conn} do
      {:ok, _lv, html} =
        conn
        |> log_in_login(login_fixture())
        |> live(~p"/logins/settings")

      assert html =~ "Change Email"
      assert html =~ "Change Password"
    end

    test "redirects if login is not logged in", %{conn: conn} do
      assert {:error, redirect} = live(conn, ~p"/logins/settings")

      assert {:redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"/logins/log_in"
      assert %{"error" => "You must log in to access this page."} = flash
    end
  end

  describe "update email form" do
    setup %{conn: conn} do
      password = valid_login_password()
      login = login_fixture(%{password: password})
      %{conn: log_in_login(conn, login), login: login, password: password}
    end

    test "updates the login email", %{conn: conn, password: password, login: login} do
      new_email = unique_login_email()

      {:ok, lv, _html} = live(conn, ~p"/logins/settings")

      result =
        lv
        |> form("#email_form", %{
          "current_password" => password,
          "login" => %{"email" => new_email}
        })
        |> render_submit()

      assert result =~ "A link to confirm your email"
      assert Accounts.get_login_by_email(login.email)
    end

    test "renders errors with invalid data (phx-change)", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/logins/settings")

      result =
        lv
        |> element("#email_form")
        |> render_change(%{
          "action" => "update_email",
          "current_password" => "invalid",
          "login" => %{"email" => "with spaces"}
        })

      assert result =~ "Change Email"
      assert result =~ "must have the @ sign and no spaces"
    end

    test "renders errors with invalid data (phx-submit)", %{conn: conn, login: login} do
      {:ok, lv, _html} = live(conn, ~p"/logins/settings")

      result =
        lv
        |> form("#email_form", %{
          "current_password" => "invalid",
          "login" => %{"email" => login.email}
        })
        |> render_submit()

      assert result =~ "Change Email"
      assert result =~ "did not change"
      assert result =~ "is not valid"
    end
  end

  describe "update password form" do
    setup %{conn: conn} do
      password = valid_login_password()
      login = login_fixture(%{password: password})
      %{conn: log_in_login(conn, login), login: login, password: password}
    end

    test "updates the login password", %{conn: conn, login: login, password: password} do
      new_password = valid_login_password()

      {:ok, lv, _html} = live(conn, ~p"/logins/settings")

      form =
        form(lv, "#password_form", %{
          "current_password" => password,
          "login" => %{
            "email" => login.email,
            "password" => new_password,
            "password_confirmation" => new_password
          }
        })

      render_submit(form)

      new_password_conn = follow_trigger_action(form, conn)

      assert redirected_to(new_password_conn) == ~p"/logins/settings"

      assert get_session(new_password_conn, :login_token) != get_session(conn, :login_token)

      assert Phoenix.Flash.get(new_password_conn.assigns.flash, :info) =~
               "Password updated successfully"

      assert Accounts.get_login_by_email_and_password(login.email, new_password)
    end

    test "renders errors with invalid data (phx-change)", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/logins/settings")

      result =
        lv
        |> element("#password_form")
        |> render_change(%{
          "current_password" => "invalid",
          "login" => %{
            "password" => "too short",
            "password_confirmation" => "does not match"
          }
        })

      assert result =~ "Change Password"
      assert result =~ "should be at least 12 character(s)"
      assert result =~ "does not match password"
    end

    test "renders errors with invalid data (phx-submit)", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/logins/settings")

      result =
        lv
        |> form("#password_form", %{
          "current_password" => "invalid",
          "login" => %{
            "password" => "too short",
            "password_confirmation" => "does not match"
          }
        })
        |> render_submit()

      assert result =~ "Change Password"
      assert result =~ "should be at least 12 character(s)"
      assert result =~ "does not match password"
      assert result =~ "is not valid"
    end
  end

  describe "confirm email" do
    setup %{conn: conn} do
      login = login_fixture()
      email = unique_login_email()

      token =
        extract_login_token(fn url ->
          Accounts.deliver_login_update_email_instructions(%{login | email: email}, login.email, url)
        end)

      %{conn: log_in_login(conn, login), token: token, email: email, login: login}
    end

    test "updates the login email once", %{conn: conn, login: login, token: token, email: email} do
      {:error, redirect} = live(conn, ~p"/logins/settings/confirm_email/#{token}")

      assert {:live_redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"/logins/settings"
      assert %{"info" => message} = flash
      assert message == "Email changed successfully."
      refute Accounts.get_login_by_email(login.email)
      assert Accounts.get_login_by_email(email)

      # use confirm token again
      {:error, redirect} = live(conn, ~p"/logins/settings/confirm_email/#{token}")
      assert {:live_redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"/logins/settings"
      assert %{"error" => message} = flash
      assert message == "Email change link is invalid or it has expired."
    end

    test "does not update email with invalid token", %{conn: conn, login: login} do
      {:error, redirect} = live(conn, ~p"/logins/settings/confirm_email/oops")
      assert {:live_redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"/logins/settings"
      assert %{"error" => message} = flash
      assert message == "Email change link is invalid or it has expired."
      assert Accounts.get_login_by_email(login.email)
    end

    test "redirects if login is not logged in", %{token: token} do
      conn = build_conn()
      {:error, redirect} = live(conn, ~p"/logins/settings/confirm_email/#{token}")
      assert {:redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"/logins/log_in"
      assert %{"error" => message} = flash
      assert message == "You must log in to access this page."
    end
  end
end
