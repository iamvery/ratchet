defmodule Ratchet.HtmlTest do
  use ExUnit.Case, async: true
  alias Ratchet.Html
  doctest Html

  test "apply content" do
    element = {"div", [], []}
    result = Html.apply(element, "Content")

    assert result == {"div", [], ["Content"]}
  end
end
