defmodule Risk4.Repo.Migrations.CreateLoginsAuthTables do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:logins) do
      add :email, :citext, null: false
      add :hashed_password, :string, null: false
      add :confirmed_at, :naive_datetime
      timestamps()
    end

    create unique_index(:logins, [:email])

    create table(:logins_tokens) do
      add :login_id, references(:logins, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      timestamps(updated_at: false)
    end

    create index(:logins_tokens, [:login_id])
    create unique_index(:logins_tokens, [:context, :token])
  end
end
