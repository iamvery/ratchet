defmodule Ratchet.RendererTest do
  use ExUnit.Case, async: true
  alias Ratchet.Renderer
  doctest Renderer

  @template """
  <section>
    <article data-scope="posts">
      <p data-prop="body"></p>
      <ul>
        <li data-prop="comments"></li>
      </ul>
    </article>
  </section>
  """

  test "render/2" do
    data = %{posts: [
        %{body: "Thoughts and opinions.", comments: ["I disagree."]},
        %{body: "JavaScript is dead.", comments: ["WAT", "YAY"]},
      ]}

    rendered = """
    <section>
      <article data-scope="posts">
        <p data-prop="body">Thoughts and opinions.</p>
        <ul>
          <li data-prop="comments">I disagree.</li>
        </ul>
      </article>
      <article data-scope="posts">
        <p data-prop="body">JavaScript is dead.</p>
        <ul>
          <li data-prop="comments">WAT</li>
          <li data-prop="comments">YAY</li>
        </ul>
      </article>
    </section>
    """ |> Floki.parse |> Floki.raw_html

    assert Ratchet.Renderer.render(@template, data) == rendered
  end
end
