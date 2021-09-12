defmodule TodoApp.Repo do
  use Ecto.Repo,
    otp_app: :todoApp,
    adapter: Ecto.Adapters.Postgres
end
