defmodule Genetic.MixProject do
  use Mix.Project

  def project do
    [
      app: :genetic,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Genetic.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:libgraph, "~> 0.13"},
      {:gnuplot, "~> 1.19"}
      # {:alex, "~> 0.3.1"}
    ]
  end
end
