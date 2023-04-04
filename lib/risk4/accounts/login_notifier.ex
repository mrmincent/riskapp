defmodule Risk4.Accounts.LoginNotifier do
  import Swoosh.Email

  alias Risk4.Mailer

  # Delivers the email using the application mailer.
  defp deliver(recipient, subject, body) do
    email =
      new()
      |> to(recipient)
      |> from({"Risk4", "contact@example.com"})
      |> subject(subject)
      |> text_body(body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(login, url) do
    deliver(login.email, "Confirmation instructions", """

    ==============================

    Hi #{login.email},

    You can confirm your account by visiting the URL below:

    #{url}

    If you didn't create an account with us, please ignore this.

    ==============================
    """)
  end

  @doc """
  Deliver instructions to reset a login password.
  """
  def deliver_reset_password_instructions(login, url) do
    deliver(login.email, "Reset password instructions", """

    ==============================

    Hi #{login.email},

    You can reset your password by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end

  @doc """
  Deliver instructions to update a login email.
  """
  def deliver_update_email_instructions(login, url) do
    deliver(login.email, "Update email instructions", """

    ==============================

    Hi #{login.email},

    You can change your email by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end
end
