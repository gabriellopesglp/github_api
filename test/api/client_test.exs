defmodule GithubApi.Api.ClientTest do
  use ExUnit.Case, async: true

  alias GithubApi.Api.Client
  alias GithubApi.{Error, Repository}
  alias Plug.Conn

  describe "get_repos/1" do
    setup do
      bypass = Bypass.open()

      {:ok, bypass: bypass}
    end

    test "When there is a valid username, returns the repositories", %{bypass: bypass} do
      username = "gabriellopesglp"

      url = endpoint_url(bypass.port)

      body = File.read!("test/resources/repositories/gabriellopesglp.json")

      Bypass.expect(bypass, "GET", "/users/#{username}/repos", fn conn ->
        conn
        |> Conn.put_resp_header("content-type", "application/json")
        |> Conn.resp(200, body)
      end)

      response = Client.get_repos(url, username)

      expected_response =
        {:ok,
         [
           %Repository{
             description: "CRUD com pedidos de comida por usuário",
             html_url: "https://github.com/gabriellopesglp/rockelivery",
             id: 457_157_248,
             name: "rockelivery",
             stargazers_count: 0
           },
           %Repository{
             description: nil,
             html_url: "https://github.com/gabriellopesglp/exmeal_v2",
             id: 468_007_722,
             name: "exmeal_v2",
             stargazers_count: 0
           }
         ]}

      assert response == expected_response
    end

    test "when user not exists, returns an error", %{bypass: bypass} do
      username = "gabriellopesglp"

      url = endpoint_url(bypass.port)

      Bypass.expect(bypass, "GET", "users/#{username}/repos", fn conn ->
        conn
        |> Conn.put_resp_header("content-type", "application/json")
        |> Conn.resp(404, "")
      end)

      response = Client.get_repos(url, username)

      expected_response = {
        :error,
        %Error{
          message: "User not found",
          status: :not_found
        }
      }

      assert expected_response == response
    end

    test "when returns bad request getting the repositories, returns an error", %{bypass: bypass} do
      username = "gabriellopesglp"

      url = endpoint_url(bypass.port)

      Bypass.expect(bypass, "GET", "users/#{username}/repos", fn conn ->
        conn
        |> Conn.put_resp_header("content-type", "application/json")
        |> Conn.resp(400, "")
      end)

      response = Client.get_repos(url, username)

      expected_response = {
        :error,
        %Error{
          message: "Bad request getting repos",
          status: :bad_request
        }
      }

      assert expected_response == response
    end

    test "When there is a generic error, returns an error", %{bypass: bypass} do
      username = "gabriellopesglp"

      url = endpoint_url(bypass.port)

      Bypass.down(bypass)

      response = Client.get_repos(url, username)

      expected_response = {:error, %Error{message: :econnrefused, status: :bad_request}}

      assert response == expected_response
    end

    defp endpoint_url(port), do: "http://localhost:#{port}/"
  end
end
