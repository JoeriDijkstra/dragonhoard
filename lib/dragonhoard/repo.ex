defmodule Dragonhoard.Repo do
  use Ecto.Repo,
    otp_app: :dragonhoard,
    adapter: Ecto.Adapters.Postgres
end
