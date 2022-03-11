defmodule GithubApi.Repositories.Get do
  alias GithubApi.Api.Client

  def from_user(username), do: Client.get_repos(username)
end
