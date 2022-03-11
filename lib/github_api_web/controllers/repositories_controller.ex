defmodule GithubApiWeb.RepositoriesController do
  use GithubApiWeb, :controller

  alias GithubApiWeb.FallbackController

  action_fallback(FallbackController)

  def index(conn, %{"username" => username}) do
    with {:ok, repos} <- GithubApi.get_repos_from_user(username) do
      conn
      |> put_status(:ok)
      |> render("repos.json", repos: repos)
    end
  end
end
