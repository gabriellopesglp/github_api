defmodule GithubApiWeb.RepositoriesView do
  use GithubApiWeb, :view

  alias GithubApi.Repository

  def render("repos.json", %{repos: [%Repository{} | _] = repos}) do
    %{"repos" => repos}
  end
end
