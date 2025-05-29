defmodule CanaryPoc.Repo do
  use Ecto.Repo,
    otp_app: :canary_poc,
    adapter: Ecto.Adapters.Postgres
end
