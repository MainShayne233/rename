defmodule Rename.Mixfile do
  use Mix.Project

  def project do
    [
      app: :rename,
      version: "0.1.0",
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        "coveralls": :test, 
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
      ]
    ]
  end

  defp deps do
    [
      {:excoveralls, "~> 0.6", only: :test}
    ]
  end

end
