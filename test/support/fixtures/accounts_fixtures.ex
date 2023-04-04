defmodule Risk4.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Risk4.Accounts` context.
  """

  def unique_login_email, do: "login#{System.unique_integer()}@example.com"
  def valid_login_password, do: "hello world!"

  def valid_login_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_login_email(),
      password: valid_login_password()
    })
  end

  def login_fixture(attrs \\ %{}) do
    {:ok, login} =
      attrs
      |> valid_login_attributes()
      |> Risk4.Accounts.register_login()

    login
  end

  def extract_login_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end
