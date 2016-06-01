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
  <div data-prop="foo">
    <div data-prop="bar">Nothing to see here</div>
  </div>
  """ |> Floki.parse |> Floki.raw_html

  test "empty data renders unaffected template" do
    assert Renderer.render(@template, %{}) == @template
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

  test "tuple data with plain text updates content and attributes" do
    data = %{foo: {"Fido", class: "pet"}}

    rendered = """
    <div class="pet" data-prop="foo">Fido</div>
    """ |> Floki.parse |> Floki.raw_html

    assert Renderer.render(@template, data) == rendered
  end

  test "map data binds to internal property" do
    data = %{foo: %{bar: "The content"}}

    rendered = """
    <div data-prop="foo">
      <div data-prop="bar">The content</div>
    </div>
    """ |> Floki.parse |> Floki.raw_html

    assert Renderer.render(@template, data) == rendered
  end

  test "tuple data with map binds to internal property and updates attributes" do
    data = %{foo: {%{bar: {"Fido", class: "dog"}}, class: "pet"}}

    rendered = """
    <div class="pet" data-prop="foo">
      <div class="dog" data-prop="bar">Fido</div>
    </div>
    """ |> Floki.parse |> Floki.raw_html

    assert Renderer.render(@template, data) == rendered
  end
end
