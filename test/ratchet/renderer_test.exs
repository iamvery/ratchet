defmodule Ratchet.RendererTest do
  use ExUnit.Case, async: true
  alias Ratchet.Renderer
  doctest Renderer

  @template """
  <section>
    <article data-scope="posts">
      <p data-prop="body"></p>
      <a data-prop="link"></a>
      <ul>
        <li data-prop="comments"></li>
      </ul>
    </article>
  </section>
  """

  test "render/2" do
    data = %{posts: [
        %{body: "Thoughts and opinions.", link: {"Google", href: "https://google.com"}, comments: ["I disagree."]},
        %{body: "JavaScript is dead.", link: {"Iamvery", href: "https://iamvery.com"}, comments: ["WAT", "YAY"]},
      ]}

    rendered = """
    <section>
      <article data-scope="posts">
        <p data-prop="body">Thoughts and opinions.</p>
        <a href="https://google.com" data-prop="link">Google</a>
        <ul>
          <li data-prop="comments">I disagree.</li>
        </ul>
      </article>
      <article data-scope="posts">
        <p data-prop="body">JavaScript is dead.</p>
        <a href="https://iamvery.com" data-prop="link">Iamvery</a>
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
