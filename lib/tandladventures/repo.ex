defmodule Tandladventures.Repo do
  use Ecto.Repo,
    otp_app: :tandladventures,
    adapter: Ecto.Adapters.Postgres
end
