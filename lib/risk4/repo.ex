defmodule Risk4.Repo do
  use Ecto.Repo,
    otp_app: :risk4,
    adapter: Ecto.Adapters.Postgres
end
