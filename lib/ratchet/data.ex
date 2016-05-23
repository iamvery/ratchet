defmodule Ratchet.Data do
  @doc """
  Extract content from a data property

      iex> Data.content("text")
      "text"
      iex> Data.content({"text", []})
      "text"
  """
  def content(text) when is_binary(text), do: text
  def content({text, _attributes}), do: text
end
