defmodule Ratchet.HtmlTest do
  use ExUnit.Case, async: true
  alias Ratchet.Html
  doctest Html

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
