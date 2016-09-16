# Ratchet

[![Build Status][travis-img]][travis] [![Hex Version][hex-img]][hex]

[travis-img]: https://travis-ci.org/iamvery/ratchet.svg?branch=master
[travis]: https://travis-ci.org/iamvery/ratchet
[hex-img]: https://img.shields.io/hexpm/v/ratchet.svg
[hex]: https://hex.pm/packages/ratchet

Ratchet is a friendly little transformer that's here to fix your views.

For use with [Phoenix][phoenix], check out [PhoenixRatchet][phoenix-ratchet].

For more information, see the [Documentation][docs].

Given a plain HTML view template like this:

```html
<section>
  <article data-prop="posts">
    <h2 data-prop="title"></h2>
    <p data-prop="body"></p>
    <a data-prop="permalink"></a>
    <ul>
      <li data-prop="comments"></li>
    </ul>
  </article>
</section>
```

It can be transformed into your final view by applying data:

```elixir
data = %{
  posts: [
    %{title: "Ratchet is here!", body: "Hope you like it", permalink: {"Iamvery", href: "https://iamvery.com"}, comments: ["Not bad"]},
    %{title: "Robots", body: "What's the deal with them?", permalink: {"Google", href: "https://google.com"}, comments: ["Yea!", "Nah"]},
  ]
}
```

```html
<section>
  <article data-prop="posts">
    <h2 data-prop="title">Ratchet is here!</h2>
    <p data-prop="body">Hope you like it</p>
    <a href="https://iamvery.com" data-prop="permalink">Iamvery</a>
    <ul>
      <li data-prop="comments">Not bad</li>
    </ul>
  </article>
  <article data-prop="posts">
    <h2 data-prop="title">Robots</h2>
    <p data-prop="body">What's the deal with them?</p>
    <a href="https://google.com" data-prop="permalink">Google</a>
    <ul>
      <li data-prop="comments">Yea!</li>
      <li data-prop="comments">Nah</li>
    </ul>
  </article>
</section>
```

## Installation

1. Install with Hex:

   ```elixir
   def deps do
     [{:ratchet, "~> 0.2.1"}]
   end
   ```

## Background

Ratchet is inspired by [Pakyow's][pakyow] [view transformation protocol][vtp].
One of the benefits of this style of view templates is designers don't have to learn whatever the latest templating language.
Instead views are plain HTML and CSS.
One you get this from design, you can sprinkle in the appropriate properties for data binding.

## Release

1. Bump the version in `mix.exs`.
1. Commit version with Git tag `vX.X.X`.
1. Publish to Hex

   ```
   $ mix hex.publish docs
   ```


[phoenix]: http://www.phoenixframework.org/
[phoenix-ratchet]: https://github.com/iamvery/phoenix_ratchet
[pakyow]: https://pakyow.org
[docs]: https://hexdocs.pm/ratchet
[vtp]: https://pakyow.org/docs/concepts/view-transformation-protocol
