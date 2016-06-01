defmodule Ratchet.TransformerTest do
  use ExUnit.Case, async: true
  alias Ratchet.Transformer
  doctest Transformer

  @ratchet_list_ast {"ul", [], [
      {"li", [{"data-prop", "name"}], []},
    ]}

  @eex_list_ast {"ul", [], [
        "<%= for name <- Ratchet.Data.property(data, :name) |> Ratchet.Data.prepare do %>",
        {"li", ["<%= Ratchet.Data.attributes(name, [{\"data-prop\", \"name\"}]) %>"], [
          "<%= if Ratchet.Data.content?(name) do %>",
          "<%= Ratchet.Data.content(name) %>",
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
      "<%= for foo <- Ratchet.Data.property(data, :foo) |> Ratchet.Data.prepare do %>",
      {"div", ["<%= Ratchet.Data.attributes(foo, [{\"data-prop\", \"foo\"}]) %>"], [
        "<%= if Ratchet.Data.content?(foo) do %>",
        "<%= Ratchet.Data.content(foo) %>",
        "<% else %>",
        "<% end %>",
      ]},
      "<% end %>",
    ]
  end
end
