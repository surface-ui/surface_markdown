defmodule SurfaceMarkdown.MixProject do
  use Mix.Project

  @version "0.3.0"

  def project do
    [
      app: :surface_markdown,
      version: @version,
      elixir: "~> 1.8",
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
      {:ex_doc, ">= 0.19.0", only: :docs},
      {:floki, "~> 0.25.0", only: :test},
      {:jason, "~> 1.0"},
      {:surface, "~> 0.7.0"},
      {:earmark, "~> 1.4"}
    ]
  end

  defp docs do
    [
      main: "Surface",
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
