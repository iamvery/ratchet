defmodule Ratchet.HtmlTest do
  use ExUnit.Case, async: true
  alias Ratchet.Html
  doctest Html

  @list {"ul", [], [
      {"li", [{"data-prop", "name"}], []},
    ]}

  test "transform element with data" do
    data = %{"name" => ["Jay", "Les"]}
    result = Html.transform(@list, data)

    assert result == {"ul", [], [
        {"li", [{"data-prop", "name"}], ["Jay"]},
        {"li", [{"data-prop", "name"}], ["Les"]},
      ]}
  end

  test "transform scoped element with data" do
    view = {"div", [], [
        {"p", [{"data-scope", "article"}, {"data-prop", "body"}], []}
      ]}
    data = %{"body" => "Contents"}
    result = Html.transform(view, "article", data)

    assert result == {"div", [], [
        {"p", [{"data-scope", "article"}, {"data-prop", "body"}], ["Contents"]}
      ]}
  end

  test "get property from attribute list" do
    attributes = [{"class", "large"}, {"data-prop", "name"}]
    result = Html.get_property(attributes)

    assert result == {:ok, "name"}
  end

  test "property not in list" do
    attributes =[{"class", "small"}, {"name", "leon"}]
    result = Html.get_property(attributes)

    assert result == :error
  end

  test "apply content" do
    element = {"div", [], []}
    result = Html.apply(element, "Content")

    assert result == {"div", [], ["Content"]}
  end

  test "apply list of content" do
    element = {"div", [], []}
    result = Html.apply(element, ["one", "two"])

    assert result == [{"div", [], ["one"]}, {"div", [], ["two"]}]
  end
end
