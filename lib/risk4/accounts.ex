defmodule Risk4.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Risk4.Repo

  alias Risk4.Accounts.{Login, LoginToken, LoginNotifier}

  ## Database getters

  @doc """
  Gets a login by email.

  ## Examples

      iex> get_login_by_email("foo@example.com")
      %Login{}

      iex> get_login_by_email("unknown@example.com")
      nil

  """
  def get_login_by_email(email) when is_binary(email) do
    Repo.get_by(Login, email: email)
  end

  @doc """
  Gets a login by email and password.

  ## Examples

      iex> get_login_by_email_and_password("foo@example.com", "correct_password")
      %Login{}

      iex> get_login_by_email_and_password("foo@example.com", "invalid_password")
      nil

  """
  def get_login_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    login = Repo.get_by(Login, email: email)
    if Login.valid_password?(login, password), do: login
  end

  @doc """
  Gets a single login.

  Raises `Ecto.NoResultsError` if the Login does not exist.

  ## Examples

      iex> get_login!(123)
      %Login{}

      iex> get_login!(456)
      ** (Ecto.NoResultsError)

  """
  def get_login!(id), do: Repo.get!(Login, id)

  ## Login registration

  @doc """
  Registers a login.

  ## Examples

      iex> register_login(%{field: value})
      {:ok, %Login{}}

      iex> register_login(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def register_login(attrs) do
    %Login{}
    |> Login.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking login changes.

  ## Examples

      iex> change_login_registration(login)
      %Ecto.Changeset{data: %Login{}}

  """
  def change_login_registration(%Login{} = login, attrs \\ %{}) do
    Login.registration_changeset(login, attrs, hash_password: false, validate_email: false)
  end

  ## Settings

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the login email.

  ## Examples

      iex> change_login_email(login)
      %Ecto.Changeset{data: %Login{}}

  """
  def change_login_email(login, attrs \\ %{}) do
    Login.email_changeset(login, attrs, validate_email: false)
  end

  @doc """
  Emulates that the email will change without actually changing
  it in the database.

  ## Examples

      iex> apply_login_email(login, "valid password", %{email: ...})
      {:ok, %Login{}}

      iex> apply_login_email(login, "invalid password", %{email: ...})
      {:error, %Ecto.Changeset{}}

  """
  def apply_login_email(login, password, attrs) do
    login
    |> Login.email_changeset(attrs)
    |> Login.validate_current_password(password)
    |> Ecto.Changeset.apply_action(:update)
  end

  @doc """
  Updates the login email using the given token.

  If the token matches, the login email is updated and the token is deleted.
  The confirmed_at date is also updated to the current time.
  """
  def update_login_email(login, token) do
    context = "change:#{login.email}"

    with {:ok, query} <- LoginToken.verify_change_email_token_query(token, context),
         %LoginToken{sent_to: email} <- Repo.one(query),
         {:ok, _} <- Repo.transaction(login_email_multi(login, email, context)) do
      :ok
    else
      _ -> :error
    end
  end

  defp login_email_multi(login, email, context) do
    changeset =
      login
      |> Login.email_changeset(%{email: email})
      |> Login.confirm_changeset()

    Ecto.Multi.new()
    |> Ecto.Multi.update(:login, changeset)
    |> Ecto.Multi.delete_all(:tokens, LoginToken.login_and_contexts_query(login, [context]))
  end

  @doc ~S"""
  Delivers the update email instructions to the given login.

  ## Examples

      iex> deliver_login_update_email_instructions(login, current_email, &url(~p"/logins/settings/confirm_email/#{&1})")
      {:ok, %{to: ..., body: ...}}

  """
  def deliver_login_update_email_instructions(%Login{} = login, current_email, update_email_url_fun)
      when is_function(update_email_url_fun, 1) do
    {encoded_token, login_token} = LoginToken.build_email_token(login, "change:#{current_email}")

    Repo.insert!(login_token)
    LoginNotifier.deliver_update_email_instructions(login, update_email_url_fun.(encoded_token))
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the login password.

  ## Examples

      iex> change_login_password(login)
      %Ecto.Changeset{data: %Login{}}

  """
  def change_login_password(login, attrs \\ %{}) do
    Login.password_changeset(login, attrs, hash_password: false)
  end

  @doc """
  Updates the login password.

  ## Examples

      iex> update_login_password(login, "valid password", %{password: ...})
      {:ok, %Login{}}

      iex> update_login_password(login, "invalid password", %{password: ...})
      {:error, %Ecto.Changeset{}}

  """
  def update_login_password(login, password, attrs) do
    changeset =
      login
      |> Login.password_changeset(attrs)
      |> Login.validate_current_password(password)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:login, changeset)
    |> Ecto.Multi.delete_all(:tokens, LoginToken.login_and_contexts_query(login, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{login: login}} -> {:ok, login}
      {:error, :login, changeset, _} -> {:error, changeset}
    end
  end

  ## Session

  @doc """
  Generates a session token.
  """
  def generate_login_session_token(login) do
    {token, login_token} = LoginToken.build_session_token(login)
    Repo.insert!(login_token)
    token
  end

  @doc """
  Gets the login with the given signed token.
  """
  def get_login_by_session_token(token) do
    {:ok, query} = LoginToken.verify_session_token_query(token)
    Repo.one(query)
  end

  @doc """
  Deletes the signed token with the given context.
  """
  def delete_login_session_token(token) do
    Repo.delete_all(LoginToken.token_and_context_query(token, "session"))
    :ok
  end

  ## Confirmation

  @doc ~S"""
  Delivers the confirmation email instructions to the given login.

  ## Examples

      iex> deliver_login_confirmation_instructions(login, &url(~p"/logins/confirm/#{&1}"))
      {:ok, %{to: ..., body: ...}}

      iex> deliver_login_confirmation_instructions(confirmed_login, &url(~p"/logins/confirm/#{&1}"))
      {:error, :already_confirmed}

  """
  def deliver_login_confirmation_instructions(%Login{} = login, confirmation_url_fun)
      when is_function(confirmation_url_fun, 1) do
    if login.confirmed_at do
      {:error, :already_confirmed}
    else
      {encoded_token, login_token} = LoginToken.build_email_token(login, "confirm")
      Repo.insert!(login_token)
      LoginNotifier.deliver_confirmation_instructions(login, confirmation_url_fun.(encoded_token))
    end
  end

  @doc """
  Confirms a login by the given token.

  If the token matches, the login account is marked as confirmed
  and the token is deleted.
  """
  def confirm_login(token) do
    with {:ok, query} <- LoginToken.verify_email_token_query(token, "confirm"),
         %Login{} = login <- Repo.one(query),
         {:ok, %{login: login}} <- Repo.transaction(confirm_login_multi(login)) do
      {:ok, login}
    else
      _ -> :error
    end
  end

  defp confirm_login_multi(login) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:login, Login.confirm_changeset(login))
    |> Ecto.Multi.delete_all(:tokens, LoginToken.login_and_contexts_query(login, ["confirm"]))
  end

  ## Reset password

  @doc ~S"""
  Delivers the reset password email to the given login.

  ## Examples

      iex> deliver_login_reset_password_instructions(login, &url(~p"/logins/reset_password/#{&1}"))
      {:ok, %{to: ..., body: ...}}

  """
  def deliver_login_reset_password_instructions(%Login{} = login, reset_password_url_fun)
      when is_function(reset_password_url_fun, 1) do
    {encoded_token, login_token} = LoginToken.build_email_token(login, "reset_password")
    Repo.insert!(login_token)
    LoginNotifier.deliver_reset_password_instructions(login, reset_password_url_fun.(encoded_token))
  end

  @doc """
  Gets the login by reset password token.

  ## Examples

      iex> get_login_by_reset_password_token("validtoken")
      %Login{}

      iex> get_login_by_reset_password_token("invalidtoken")
      nil

  """
  def get_login_by_reset_password_token(token) do
    with {:ok, query} <- LoginToken.verify_email_token_query(token, "reset_password"),
         %Login{} = login <- Repo.one(query) do
      login
    else
      _ -> nil
    end
  end

  @doc """
  Resets the login password.

  ## Examples

      iex> reset_login_password(login, %{password: "new long password", password_confirmation: "new long password"})
      {:ok, %Login{}}

      iex> reset_login_password(login, %{password: "valid", password_confirmation: "not the same"})
      {:error, %Ecto.Changeset{}}

  """
  def reset_login_password(login, attrs) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:login, Login.password_changeset(login, attrs))
    |> Ecto.Multi.delete_all(:tokens, LoginToken.login_and_contexts_query(login, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{login: login}} -> {:ok, login}
      {:error, :login, changeset, _} -> {:error, changeset}
    end
  end
end
