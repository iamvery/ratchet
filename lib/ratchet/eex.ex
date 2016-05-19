defmodule Ratchet.EEx do
  @doc """
  Build an EEx list comprehension from a scope and a property

      iex> Ratchet.EEx.eex_comprehension_open("foo", "bar")
      "<%= for bar <- List.wrap(foo.bar) do %>"
  """
  def eex_comprehension_open(scope, property) do
    "<%= for #{property} <- List.wrap(#{scope}.#{property}) do %>"
  end

  @doc """
  Build an EEx statement fetching content

      iex> Ratchet.EEx.eex_content("lolwat")
      "<%= Ratchet.Data.content(lolwat) %>"
  """
  def eex_content(property) do
    "<%= Ratchet.Data.content(#{property}) %>"
  end

  @doc """
  Spit out an EEx ending
  """
  def eex_close do
    "<% end %>"
  end
end
