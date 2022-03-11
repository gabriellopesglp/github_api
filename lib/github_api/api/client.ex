defmodule GithubApi.Api.Client do
  use Tesla

  alias GithubApi.{Error, Repository}
  alias Tesla.Env

  @base_url "https://api.github.com"

  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.Headers, [{"User-Agent", "Elixir-GitHub-Api"}]

  def get_repos(url \\ @base_url, username) do
    "#{url}/users/#{username}/repos"
    |> get()
    |> handle_get()
  end

  defp handle_get({:ok, %Env{status: 200, body: body}}) do
    with repos <- Enum.map(body, &map_repo/1) do
      {:ok, repos}
    end
  end

  defp handle_get({:ok, %Env{status: 400, body: _body}}) do
    {:error, Error.build_bad_request("Bad request getting repos")}
  end

  defp handle_get({:ok, %Env{status: 404, body: _body}}) do
    {:error, Error.build_not_found("User not found")}
  end

  defp handle_get({:error, reason}) do
    {:error, Error.build_bad_request(reason)}
  end

  defp map_repo(repo) do
    with {:ok, repo} <- Repository.build(repo), do: repo
  end
end
