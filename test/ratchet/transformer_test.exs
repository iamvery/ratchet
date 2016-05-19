defmodule Ratchet.TransformerTest do
  use ExUnit.Case, async: true
  alias Ratchet.Transformer
  doctest Transformer

  @ratchet_list_ast {"div", [], [
      {"ul", [{"data-scope", "list"}], [
        {"li", [{"data-prop", "name"}], []},
      ]},
    ]}

  @eex_list_ast {"div", [], [
        "<%= for list <- List.wrap(data.list) do %>",
        {"ul", [{"data-scope", "list"}], [
          "<%= for name <- List.wrap(list.name) do %>",
          {"li", [{"data-prop", "name"}], ["<%= Ratchet.Data.content(name) %>"]},
          "<% end %>",
        ]},
        "<% end %>",
      ]}

  test "transform/1 transforms tree to include EEx statements for scopes and properties" do
    result = Transformer.transform(@ratchet_list_ast)

    assert result == @eex_list_ast
  end

  test "transform element with text content" do
    ast = {"div", [], ["Content"]}
    result = Transformer.transform(ast)

    assert result == ast
  end
end
