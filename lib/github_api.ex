defmodule GithubApi do
  alias GithubApi.Repositories.Get, as: GetRepos

  defdelegate get_repos_from_user(username), to: GetRepos, as: :from_user
end
