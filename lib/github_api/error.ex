defmodule GithubApi.Error do
  @keys [:status, :message]

  @enforce_keys @keys

  defstruct @keys

  def build(status, message) do
    %__MODULE__{
      status: status,
      message: message
    }
  end

  def build_bad_request(message), do: build(:bad_request, message)

  def build_not_found(message), do: build(:not_found, message)
end
