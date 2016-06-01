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

      iex> Ratchet.EEx.eex_content("lolwat", ["Content"])
      [
        "<%= if Ratchet.Data.content?(lolwat) do %>",
        "<%= Ratchet.Data.content(lolwat) %>",
        "<% else %>",
        "Content",
        "<% end %>",
      ]
  """
  def eex_content(property, default) do
    [
      "<%= if Ratchet.Data.content?(#{property}) do %>",
      "<%= Ratchet.Data.content(#{property}) %>",
      "<% else %>",
      default,
      eex_close,
    ] |> List.flatten
  end

  @doc """
  Build an EEx statement fetching attributes

      iex> Ratchet.EEx.eex_attributes("lolwat", [])
      "<%= Ratchet.Data.attributes(lolwat, []) %>"
  """
  def eex_attributes(property, attributes) do
    "<%= Ratchet.Data.attributes(#{property}, #{inspect attributes}) %>"
  end

  @doc """
  Spit out an EEx ending
  """
  def eex_close do
    "<% end %>"
  end
end
