defmodule RatchetTest do
  use ExUnit.Case
  doctest Ratchet

  @view """
  <div>
    <div data-scope="article">
      <p data-prop="body">Content</p>
      <ul>
        <li data-prop="comments">First!</li>
      </ul>
    </div>
  </div>
  """

  test "transform view with data" do
    data = %{"body" => "View transformation protocol!", "comments" => ["It seems great!", "We'll see how it goes..."]}
    transformed = Ratchet.transform(@view, "article", data)

    expected = """
    <div>
      <div data-scope="article">
        <p data-prop="body">View transformation protocol!</p>
        <ul>
          <li data-prop="comments">It seems great!</li>
          <li data-prop="comments">We'll see how it goes...</li>
        </ul>
      </div>
    </div>
    """ |> Floki.parse |> Floki.raw_html

    assert transformed === expected
  end
end
