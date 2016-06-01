defmodule Ratchet.EEx do
  @moduledoc """
  Generates EEx in compiled Ratchet templates
  """

  @doc """
  Build an EEx list comprehension from a scope and a property

      iex> Ratchet.EEx.eex_comprehension_open("foo", "bar")
      "<%= for bar <- Ratchet.Data.property(foo, :bar) |> Ratchet.Data.prepare do %>"
  """
  def eex_comprehension_open(scope, property) do
    property = String.to_atom(property)
    "<%= for #{property} <- Ratchet.Data.property(#{scope}, #{inspect property}) |> Ratchet.Data.prepare do %>"
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
