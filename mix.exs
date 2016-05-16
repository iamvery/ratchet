defmodule Ratchet.Mixfile do
  use Mix.Project

  def project do
    [app: :ratchet,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description,
     package: package,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:floki, "~> 0.8"}, # HTML parser
    ]
  end

  defp description do
    """
    Transform plain HTML views with data
    """
  end

  defp package do
    [
      name: :ratchet,
      files: ~W(lib mix.exs README.md),
      maintainers: ["Jay Hayes"],
      links: %{"GitHub" => "https://github.com/iamvery/ratchet"},
    ]
  end
end
