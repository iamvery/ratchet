# Ratchet

[![Build Status](https://travis-ci.org/iamvery/ratchet.svg?branch=master)](https://travis-ci.org/iamvery/ratchet)

Ratchet is an implementation of [Pakyow's][pakyow] [view transformation protocol][vtp].

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add ratchet to your list of dependencies in `mix.exs`:

        def deps do
          [{:ratchet, "~> 0.0.1"}]
        end

  2. Ensure ratchet is started before your application:

        def application do
          [applications: [:ratchet]]
        end


[pakyow]: https://pakyow.org
[vtp]: https://pakyow.org/docs/concepts/view-transformation-protocol
