defmodule Slackernews.Repo do
  use Ecto.Repo,
    otp_app: :slackernews,
    adapter: Ecto.Adapters.Postgres
end
