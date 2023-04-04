defmodule Risk4Web.LoginSessionController do
  use Risk4Web, :controller

  alias Risk4.Accounts
  alias Risk4Web.LoginAuth

  def create(conn, %{"_action" => "registered"} = params) do
    create(conn, params, "Account created successfully!")
  end

  def create(conn, %{"_action" => "password_updated"} = params) do
    conn
    |> put_session(:login_return_to, ~p"/logins/settings")
    |> create(params, "Password updated successfully!")
  end

  def create(conn, params) do
    create(conn, params, "Welcome back!")
  end

  defp create(conn, %{"login" => login_params}, info) do
    %{"email" => email, "password" => password} = login_params

    if login = Accounts.get_login_by_email_and_password(email, password) do
      conn
      |> put_flash(:info, info)
      |> LoginAuth.log_in_login(login, login_params)
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      conn
      |> put_flash(:error, "Invalid email or password")
      |> put_flash(:email, String.slice(email, 0, 160))
      |> redirect(to: ~p"/logins/log_in")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> LoginAuth.log_out_login()
  end
end
