defmodule Ratchet.Html do
  @doc """
  Apply content to an element

      iex> Html.apply({"div", [], []}, "Content")
      {"div", [], ["Content"]}
  """
  def apply({tag, attributes, _children}, content) do
    {tag, attributes, [content]}
  end
end
