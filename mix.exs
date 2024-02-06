defmodule SurfaceMarkdown.MixProject do
  use Mix.Project

  @version "0.6.1"

  def project do
    [
      app: :surface_markdown,
      version: @version,
      elixir: "~> 1.13",
      description: "A Markdown component for Surface",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      package: package()
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:surface, "~> 0.8"},
      {:earmark, "~> 1.4"},
      {:jason, "~> 1.0"},
      {:floki, "~> 0.35", only: :test},
      {:ex_doc, ">= 0.31.1", only: :docs},
    ]
  end

  defp docs do
    [
      main: "Surface.Components.Markdown",
      extras: ["LICENSE"],
      source_ref: "v#{@version}",
      source_url: "https://github.com/surface-ui/surface_markdown"
    ]
  end

  defp package do
    %{
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/surface-ui/surface_markdown"}
    }
  end
end
