defmodule Ratchet.RendererTest do
  use ExUnit.Case, async: true
  alias Ratchet.Renderer
  doctest Renderer

  @template """
  <h2>Articles</h2>
  <article class="post" data-prop="posts">
    <p data-prop="body"></p>
    <a data-prop="link"></a>
    <ul>
      <li data-prop="comments"></li>
    </ul>
  </article>
  """

  test "render/2" do
    data = %{toplevel: "", posts: [
        %{body: "Thoughts and opinions.", link: {"Google", href: "https://google.com"}, comments: ["I disagree."]},
        %{body: "JavaScript is dead.", link: {"Iamvery", href: "https://iamvery.com"}, comments: ["WAT", "YAY"]},
      ]}

    rendered = """
    <h2>Articles</h2>
    <article class="post" data-prop="posts">
      <p data-prop="body">Thoughts and opinions.</p>
      <a href="https://google.com" data-prop="link">Google</a>
      <ul>
        <li data-prop="comments">I disagree.</li>
      </ul>
    </article>
    <article class="post" data-prop="posts">
      <p data-prop="body">JavaScript is dead.</p>
      <a href="https://iamvery.com" data-prop="link">Iamvery</a>
      <ul>
        <li data-prop="comments">WAT</li>
        <li data-prop="comments">YAY</li>
      </ul>
    </article>
    """ |> Floki.parse |> Floki.raw_html

    assert Ratchet.Renderer.render(@template, data) == rendered
  end

  @template """
  <div data-prop="foo"></div>
  """ |> Floki.parse |> Floki.raw_html

  test "empty data renders unaffected template" do
    data = %{foo: {nil, []}}
    assert Renderer.render(@template, data) == @template
  end

  test "plain text data replaces template" do
    data = %{foo: "The content"}

    rendered = """
    <div data-prop="foo">The content</div>
    """ |> Floki.parse |> Floki.raw_html

    assert Renderer.render(@template, data) == rendered
  end

  test "list data results in multiple elements" do
    data = %{foo: ["First", "Second", "Third"]}

    rendered = """
    <div data-prop="foo">First</div>
    <div data-prop="foo">Second</div>
    <div data-prop="foo">Third</div>
    """ |> Floki.parse |> Floki.raw_html

    assert Renderer.render(@template, data) == rendered
  end
end
