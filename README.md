# Ratchet

[![Build Status](https://travis-ci.org/iamvery/ratchet.svg?branch=master)](https://travis-ci.org/iamvery/ratchet)

Ratchet is an implementation of [Pakyow's][pakyow] [view transformation protocol][vtp].

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add ratchet to your list of dependencies in `mix.exs`:

        def deps do
          [{:ratchet, "~> 0.0.1"}]
        end

## Release

1. Bump the version in `mix.exs.
1. Commit version with Git tag `vX.X.X`.
1. Publish to Hex

   ```
   $ mix do hex.publish, hex.docs
   ```


[pakyow]: https://pakyow.org
[vtp]: https://pakyow.org/docs/concepts/view-transformation-protocol
