defmodule Issues.MixProject do
  use Mix.Project

  def project do
    [
      app: :issues,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      source_url: "https://github.com/mnorth719/issues",
      name: "Issues",
      deps: deps(),
      escript: escript_config()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      { :httpoison, "~> 1.0.0" },
      { :poison,    "~> 3.1" },
      { :ex_doc,    "~> 0.19" },
      { :earmark,   "~> 1.3" },
    ]
  end

  defp escript_config do
    [
      main_module: Issues.CLI
    ]
  end
end
