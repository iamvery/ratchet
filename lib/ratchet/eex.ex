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
  Build an EEx statement fetching attributes

      iex> Ratchet.EEx.eex_attributes("lolwat", [])
      "<%= Ratchet.Data.attributes(lolwat, []) %>"
  """
  if Code.ensure_loaded?(Phoenix.HTML) do
    def eex_attributes(property, attributes) do
      "<%= Phoenix.HTML.raw Ratchet.Data.attributes(#{property}, #{inspect attributes}) %>"
    end
  else
    def eex_attributes(property, attributes) do
      "<%= Ratchet.Data.attributes(#{property}, #{inspect attributes}) %>"
    end
  end

  @doc """
  Spit out an EEx ending
  """
  def eex_close do
    "<% end %>"
  end
end
