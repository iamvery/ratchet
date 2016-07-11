defmodule Ratchet.Data do
  @doc """
  Returns a new, empty Ratchet data structure

      iex> Ratchet.Data.new
      %{}
  """
  def new, do: %{}

  @doc """
  Adds property to data

      iex> Ratchet.Data.scope(%{}, :foo, "bar")
      %{foo: "bar"}
  """
  def scope(data, property, property_data) do
    Map.put(data, property, property_data)
  end
end
