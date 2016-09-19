defmodule Ratchet.TransformerTest do
  use ExUnit.Case, async: true
  alias Ratchet.Transformer
  doctest Transformer

  @ratchet_list_ast {"ul", [], [
      {"li", [{"data-prop", "name"}], []},
    ]}

  @eex_list_ast {"ul", [], [
        "<%= for name <- Ratchet.Template.property(data, :name) |> Ratchet.Template.prepare do %>",
        {"li", ["<%= Ratchet.Template.attributes(name, [{\"data-prop\", \"name\"}]) %>"], [
          "<%= if Ratchet.Template.content?(name) do %>",
          "<%= Ratchet.Template.content(name) %>",
          "<% else %>",
          "<% end %>",
        ]},
        "<% end %>",
      ]}

  test "transform/1 transforms tree to include EEx statements for properties" do
    result = Transformer.transform(@ratchet_list_ast)

    assert result == @eex_list_ast
  end

  test "transform element with text content" do
    ast = {"div", [], ["Content"]}
    result = Transformer.transform(ast)

    assert result == ast
  end

  test "transform with adjacent top-level element" do
    ast = [{"h2", [], []}, {"div", [{"data-prop", "foo"}], []}]
    result = Transformer.transform(ast)

    assert result == [
      {"h2", [], []},
      "<%= for foo <- Ratchet.Template.property(data, :foo) |> Ratchet.Template.prepare do %>",
      {"div", ["<%= Ratchet.Template.attributes(foo, [{\"data-prop\", \"foo\"}]) %>"], [
        "<%= if Ratchet.Template.content?(foo) do %>",
        "<%= Ratchet.Template.content(foo) %>",
        "<% else %>",
        "<% end %>",
      ]},
      "<% end %>",
    ]
  end
end
