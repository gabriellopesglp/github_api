defmodule GithubApi.Repo do
  use Ecto.Repo,
    otp_app: :github_api,
    adapter: Ecto.Adapters.Postgres
end
