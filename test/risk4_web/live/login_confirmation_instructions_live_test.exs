defmodule Risk4Web.LoginConfirmationInstructionsLiveTest do
  use Risk4Web.ConnCase

  import Phoenix.LiveViewTest
  import Risk4.AccountsFixtures

  alias Risk4.Accounts
  alias Risk4.Repo

  setup do
    %{login: login_fixture()}
  end

  describe "Resend confirmation" do
    test "renders the resend confirmation page", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/logins/confirm")
      assert html =~ "Resend confirmation instructions"
    end

    test "sends a new confirmation token", %{conn: conn, login: login} do
      {:ok, lv, _html} = live(conn, ~p"/logins/confirm")

      {:ok, conn} =
        lv
        |> form("#resend_confirmation_form", login: %{email: login.email})
        |> render_submit()
        |> follow_redirect(conn, ~p"/")

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "If your email is in our system"

      assert Repo.get_by!(Accounts.LoginToken, login_id: login.id).context == "confirm"
    end

    test "does not send confirmation token if login is confirmed", %{conn: conn, login: login} do
      Repo.update!(Accounts.Login.confirm_changeset(login))

      {:ok, lv, _html} = live(conn, ~p"/logins/confirm")

      {:ok, conn} =
        lv
        |> form("#resend_confirmation_form", login: %{email: login.email})
        |> render_submit()
        |> follow_redirect(conn, ~p"/")

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "If your email is in our system"

      refute Repo.get_by(Accounts.LoginToken, login_id: login.id)
    end

    test "does not send confirmation token if email is invalid", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/logins/confirm")

      {:ok, conn} =
        lv
        |> form("#resend_confirmation_form", login: %{email: "unknown@example.com"})
        |> render_submit()
        |> follow_redirect(conn, ~p"/")

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "If your email is in our system"

      assert Repo.all(Accounts.LoginToken) == []
    end
  end
end
