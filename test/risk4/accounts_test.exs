defmodule Risk4.AccountsTest do
  use Risk4.DataCase

  alias Risk4.Accounts

  import Risk4.AccountsFixtures
  alias Risk4.Accounts.{Login, LoginToken}

  describe "get_login_by_email/1" do
    test "does not return the login if the email does not exist" do
      refute Accounts.get_login_by_email("unknown@example.com")
    end

    test "returns the login if the email exists" do
      %{id: id} = login = login_fixture()
      assert %Login{id: ^id} = Accounts.get_login_by_email(login.email)
    end
  end

  describe "get_login_by_email_and_password/2" do
    test "does not return the login if the email does not exist" do
      refute Accounts.get_login_by_email_and_password("unknown@example.com", "hello world!")
    end

    test "does not return the login if the password is not valid" do
      login = login_fixture()
      refute Accounts.get_login_by_email_and_password(login.email, "invalid")
    end

    test "returns the login if the email and password are valid" do
      %{id: id} = login = login_fixture()

      assert %Login{id: ^id} =
               Accounts.get_login_by_email_and_password(login.email, valid_login_password())
    end
  end

  describe "get_login!/1" do
    test "raises if id is invalid" do
      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_login!(-1)
      end
    end

    test "returns the login with the given id" do
      %{id: id} = login = login_fixture()
      assert %Login{id: ^id} = Accounts.get_login!(login.id)
    end
  end

  describe "register_login/1" do
    test "requires email and password to be set" do
      {:error, changeset} = Accounts.register_login(%{})

      assert %{
               password: ["can't be blank"],
               email: ["can't be blank"]
             } = errors_on(changeset)
    end

    test "validates email and password when given" do
      {:error, changeset} = Accounts.register_login(%{email: "not valid", password: "not valid"})

      assert %{
               email: ["must have the @ sign and no spaces"],
               password: ["should be at least 12 character(s)"]
             } = errors_on(changeset)
    end

    test "validates maximum values for email and password for security" do
      too_long = String.duplicate("db", 100)
      {:error, changeset} = Accounts.register_login(%{email: too_long, password: too_long})
      assert "should be at most 160 character(s)" in errors_on(changeset).email
      assert "should be at most 72 character(s)" in errors_on(changeset).password
    end

    test "validates email uniqueness" do
      %{email: email} = login_fixture()
      {:error, changeset} = Accounts.register_login(%{email: email})
      assert "has already been taken" in errors_on(changeset).email

      # Now try with the upper cased email too, to check that email case is ignored.
      {:error, changeset} = Accounts.register_login(%{email: String.upcase(email)})
      assert "has already been taken" in errors_on(changeset).email
    end

    test "registers logins with a hashed password" do
      email = unique_login_email()
      {:ok, login} = Accounts.register_login(valid_login_attributes(email: email))
      assert login.email == email
      assert is_binary(login.hashed_password)
      assert is_nil(login.confirmed_at)
      assert is_nil(login.password)
    end
  end

  describe "change_login_registration/2" do
    test "returns a changeset" do
      assert %Ecto.Changeset{} = changeset = Accounts.change_login_registration(%Login{})
      assert changeset.required == [:password, :email]
    end

    test "allows fields to be set" do
      email = unique_login_email()
      password = valid_login_password()

      changeset =
        Accounts.change_login_registration(
          %Login{},
          valid_login_attributes(email: email, password: password)
        )

      assert changeset.valid?
      assert get_change(changeset, :email) == email
      assert get_change(changeset, :password) == password
      assert is_nil(get_change(changeset, :hashed_password))
    end
  end

  describe "change_login_email/2" do
    test "returns a login changeset" do
      assert %Ecto.Changeset{} = changeset = Accounts.change_login_email(%Login{})
      assert changeset.required == [:email]
    end
  end

  describe "apply_login_email/3" do
    setup do
      %{login: login_fixture()}
    end

    test "requires email to change", %{login: login} do
      {:error, changeset} = Accounts.apply_login_email(login, valid_login_password(), %{})
      assert %{email: ["did not change"]} = errors_on(changeset)
    end

    test "validates email", %{login: login} do
      {:error, changeset} =
        Accounts.apply_login_email(login, valid_login_password(), %{email: "not valid"})

      assert %{email: ["must have the @ sign and no spaces"]} = errors_on(changeset)
    end

    test "validates maximum value for email for security", %{login: login} do
      too_long = String.duplicate("db", 100)

      {:error, changeset} =
        Accounts.apply_login_email(login, valid_login_password(), %{email: too_long})

      assert "should be at most 160 character(s)" in errors_on(changeset).email
    end

    test "validates email uniqueness", %{login: login} do
      %{email: email} = login_fixture()
      password = valid_login_password()

      {:error, changeset} = Accounts.apply_login_email(login, password, %{email: email})

      assert "has already been taken" in errors_on(changeset).email
    end

    test "validates current password", %{login: login} do
      {:error, changeset} =
        Accounts.apply_login_email(login, "invalid", %{email: unique_login_email()})

      assert %{current_password: ["is not valid"]} = errors_on(changeset)
    end

    test "applies the email without persisting it", %{login: login} do
      email = unique_login_email()
      {:ok, login} = Accounts.apply_login_email(login, valid_login_password(), %{email: email})
      assert login.email == email
      assert Accounts.get_login!(login.id).email != email
    end
  end

  describe "deliver_login_update_email_instructions/3" do
    setup do
      %{login: login_fixture()}
    end

    test "sends token through notification", %{login: login} do
      token =
        extract_login_token(fn url ->
          Accounts.deliver_login_update_email_instructions(login, "current@example.com", url)
        end)

      {:ok, token} = Base.url_decode64(token, padding: false)
      assert login_token = Repo.get_by(LoginToken, token: :crypto.hash(:sha256, token))
      assert login_token.login_id == login.id
      assert login_token.sent_to == login.email
      assert login_token.context == "change:current@example.com"
    end
  end

  describe "update_login_email/2" do
    setup do
      login = login_fixture()
      email = unique_login_email()

      token =
        extract_login_token(fn url ->
          Accounts.deliver_login_update_email_instructions(%{login | email: email}, login.email, url)
        end)

      %{login: login, token: token, email: email}
    end

    test "updates the email with a valid token", %{login: login, token: token, email: email} do
      assert Accounts.update_login_email(login, token) == :ok
      changed_login = Repo.get!(Login, login.id)
      assert changed_login.email != login.email
      assert changed_login.email == email
      assert changed_login.confirmed_at
      assert changed_login.confirmed_at != login.confirmed_at
      refute Repo.get_by(LoginToken, login_id: login.id)
    end

    test "does not update email with invalid token", %{login: login} do
      assert Accounts.update_login_email(login, "oops") == :error
      assert Repo.get!(Login, login.id).email == login.email
      assert Repo.get_by(LoginToken, login_id: login.id)
    end

    test "does not update email if login email changed", %{login: login, token: token} do
      assert Accounts.update_login_email(%{login | email: "current@example.com"}, token) == :error
      assert Repo.get!(Login, login.id).email == login.email
      assert Repo.get_by(LoginToken, login_id: login.id)
    end

    test "does not update email if token expired", %{login: login, token: token} do
      {1, nil} = Repo.update_all(LoginToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      assert Accounts.update_login_email(login, token) == :error
      assert Repo.get!(Login, login.id).email == login.email
      assert Repo.get_by(LoginToken, login_id: login.id)
    end
  end

  describe "change_login_password/2" do
    test "returns a login changeset" do
      assert %Ecto.Changeset{} = changeset = Accounts.change_login_password(%Login{})
      assert changeset.required == [:password]
    end

    test "allows fields to be set" do
      changeset =
        Accounts.change_login_password(%Login{}, %{
          "password" => "new valid password"
        })

      assert changeset.valid?
      assert get_change(changeset, :password) == "new valid password"
      assert is_nil(get_change(changeset, :hashed_password))
    end
  end

  describe "update_login_password/3" do
    setup do
      %{login: login_fixture()}
    end

    test "validates password", %{login: login} do
      {:error, changeset} =
        Accounts.update_login_password(login, valid_login_password(), %{
          password: "not valid",
          password_confirmation: "another"
        })

      assert %{
               password: ["should be at least 12 character(s)"],
               password_confirmation: ["does not match password"]
             } = errors_on(changeset)
    end

    test "validates maximum values for password for security", %{login: login} do
      too_long = String.duplicate("db", 100)

      {:error, changeset} =
        Accounts.update_login_password(login, valid_login_password(), %{password: too_long})

      assert "should be at most 72 character(s)" in errors_on(changeset).password
    end

    test "validates current password", %{login: login} do
      {:error, changeset} =
        Accounts.update_login_password(login, "invalid", %{password: valid_login_password()})

      assert %{current_password: ["is not valid"]} = errors_on(changeset)
    end

    test "updates the password", %{login: login} do
      {:ok, login} =
        Accounts.update_login_password(login, valid_login_password(), %{
          password: "new valid password"
        })

      assert is_nil(login.password)
      assert Accounts.get_login_by_email_and_password(login.email, "new valid password")
    end

    test "deletes all tokens for the given login", %{login: login} do
      _ = Accounts.generate_login_session_token(login)

      {:ok, _} =
        Accounts.update_login_password(login, valid_login_password(), %{
          password: "new valid password"
        })

      refute Repo.get_by(LoginToken, login_id: login.id)
    end
  end

  describe "generate_login_session_token/1" do
    setup do
      %{login: login_fixture()}
    end

    test "generates a token", %{login: login} do
      token = Accounts.generate_login_session_token(login)
      assert login_token = Repo.get_by(LoginToken, token: token)
      assert login_token.context == "session"

      # Creating the same token for another login should fail
      assert_raise Ecto.ConstraintError, fn ->
        Repo.insert!(%LoginToken{
          token: login_token.token,
          login_id: login_fixture().id,
          context: "session"
        })
      end
    end
  end

  describe "get_login_by_session_token/1" do
    setup do
      login = login_fixture()
      token = Accounts.generate_login_session_token(login)
      %{login: login, token: token}
    end

    test "returns login by token", %{login: login, token: token} do
      assert session_login = Accounts.get_login_by_session_token(token)
      assert session_login.id == login.id
    end

    test "does not return login for invalid token" do
      refute Accounts.get_login_by_session_token("oops")
    end

    test "does not return login for expired token", %{token: token} do
      {1, nil} = Repo.update_all(LoginToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      refute Accounts.get_login_by_session_token(token)
    end
  end

  describe "delete_login_session_token/1" do
    test "deletes the token" do
      login = login_fixture()
      token = Accounts.generate_login_session_token(login)
      assert Accounts.delete_login_session_token(token) == :ok
      refute Accounts.get_login_by_session_token(token)
    end
  end

  describe "deliver_login_confirmation_instructions/2" do
    setup do
      %{login: login_fixture()}
    end

    test "sends token through notification", %{login: login} do
      token =
        extract_login_token(fn url ->
          Accounts.deliver_login_confirmation_instructions(login, url)
        end)

      {:ok, token} = Base.url_decode64(token, padding: false)
      assert login_token = Repo.get_by(LoginToken, token: :crypto.hash(:sha256, token))
      assert login_token.login_id == login.id
      assert login_token.sent_to == login.email
      assert login_token.context == "confirm"
    end
  end

  describe "confirm_login/1" do
    setup do
      login = login_fixture()

      token =
        extract_login_token(fn url ->
          Accounts.deliver_login_confirmation_instructions(login, url)
        end)

      %{login: login, token: token}
    end

    test "confirms the email with a valid token", %{login: login, token: token} do
      assert {:ok, confirmed_login} = Accounts.confirm_login(token)
      assert confirmed_login.confirmed_at
      assert confirmed_login.confirmed_at != login.confirmed_at
      assert Repo.get!(Login, login.id).confirmed_at
      refute Repo.get_by(LoginToken, login_id: login.id)
    end

    test "does not confirm with invalid token", %{login: login} do
      assert Accounts.confirm_login("oops") == :error
      refute Repo.get!(Login, login.id).confirmed_at
      assert Repo.get_by(LoginToken, login_id: login.id)
    end

    test "does not confirm email if token expired", %{login: login, token: token} do
      {1, nil} = Repo.update_all(LoginToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      assert Accounts.confirm_login(token) == :error
      refute Repo.get!(Login, login.id).confirmed_at
      assert Repo.get_by(LoginToken, login_id: login.id)
    end
  end

  describe "deliver_login_reset_password_instructions/2" do
    setup do
      %{login: login_fixture()}
    end

    test "sends token through notification", %{login: login} do
      token =
        extract_login_token(fn url ->
          Accounts.deliver_login_reset_password_instructions(login, url)
        end)

      {:ok, token} = Base.url_decode64(token, padding: false)
      assert login_token = Repo.get_by(LoginToken, token: :crypto.hash(:sha256, token))
      assert login_token.login_id == login.id
      assert login_token.sent_to == login.email
      assert login_token.context == "reset_password"
    end
  end

  describe "get_login_by_reset_password_token/1" do
    setup do
      login = login_fixture()

      token =
        extract_login_token(fn url ->
          Accounts.deliver_login_reset_password_instructions(login, url)
        end)

      %{login: login, token: token}
    end

    test "returns the login with valid token", %{login: %{id: id}, token: token} do
      assert %Login{id: ^id} = Accounts.get_login_by_reset_password_token(token)
      assert Repo.get_by(LoginToken, login_id: id)
    end

    test "does not return the login with invalid token", %{login: login} do
      refute Accounts.get_login_by_reset_password_token("oops")
      assert Repo.get_by(LoginToken, login_id: login.id)
    end

    test "does not return the login if token expired", %{login: login, token: token} do
      {1, nil} = Repo.update_all(LoginToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      refute Accounts.get_login_by_reset_password_token(token)
      assert Repo.get_by(LoginToken, login_id: login.id)
    end
  end

  describe "reset_login_password/2" do
    setup do
      %{login: login_fixture()}
    end

    test "validates password", %{login: login} do
      {:error, changeset} =
        Accounts.reset_login_password(login, %{
          password: "not valid",
          password_confirmation: "another"
        })

      assert %{
               password: ["should be at least 12 character(s)"],
               password_confirmation: ["does not match password"]
             } = errors_on(changeset)
    end

    test "validates maximum values for password for security", %{login: login} do
      too_long = String.duplicate("db", 100)
      {:error, changeset} = Accounts.reset_login_password(login, %{password: too_long})
      assert "should be at most 72 character(s)" in errors_on(changeset).password
    end

    test "updates the password", %{login: login} do
      {:ok, updated_login} = Accounts.reset_login_password(login, %{password: "new valid password"})
      assert is_nil(updated_login.password)
      assert Accounts.get_login_by_email_and_password(login.email, "new valid password")
    end

    test "deletes all tokens for the given login", %{login: login} do
      _ = Accounts.generate_login_session_token(login)
      {:ok, _} = Accounts.reset_login_password(login, %{password: "new valid password"})
      refute Repo.get_by(LoginToken, login_id: login.id)
    end
  end

  describe "inspect/2 for the Login module" do
    test "does not include password" do
      refute inspect(%Login{password: "123456"}) =~ "password: \"123456\""
    end
  end
end
