defmodule GithubApiWeb.FallbackController do
  use GithubApiWeb, :controller

  alias GithubApi.Error

  alias GithubApiWeb.ErrorView

  def call(conn, {:error, %Error{status: status, message: message}}) do
    conn
    |> put_status(status)
    |> put_view(ErrorView)
    |> render("error.json", message: message)
  end
end
