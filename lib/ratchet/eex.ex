defmodule Ratchet.EEx do
  @moduledoc """
  Generates EEx in compiled Ratchet templates
  """

  @doc """
  Build an EEx list comprehension from a scope and a property

      iex> Ratchet.EEx.eex_comprehension_open("foo", "bar")
      "<%= for bar <- Ratchet.Template.property(foo, :bar) |> Ratchet.Template.prepare do %>"
  """
  def eex_comprehension_open(scope, property) do
    property = String.to_atom(property)
    "<%= for #{property} <- Ratchet.Template.property(#{scope}, #{inspect property}) |> Ratchet.Template.prepare do %>"
  end

  @doc """
  Build an EEx statement fetching content

      iex> Ratchet.EEx.eex_content("lolwat", ["Content"])
      [
        "<%= if Ratchet.Template.content?(lolwat) do %>",
        "<%= Ratchet.Template.content(lolwat) %>",
        "<% else %>",
        "Content",
        "<% end %>",
      ]
  """
  def eex_content(property, default) do
    [
      "<%= if Ratchet.Template.content?(#{property}) do %>",
      "<%= Ratchet.Template.content(#{property}) %>",
      "<% else %>",
      default,
      eex_close,
    ] |> List.flatten
  end

  @doc """
  Build an EEx statement fetching attributes

      iex> Ratchet.EEx.eex_attributes("lolwat", [])
      "<%= Ratchet.Template.attributes(lolwat, []) %>"
  """
  def eex_attributes(property, attributes) do
    "<%= Ratchet.Template.attributes(#{property}, #{inspect attributes}) %>"
  end

  @doc """
  Spit out an EEx ending
  """
  def eex_close do
    "<% end %>"
  end
end
