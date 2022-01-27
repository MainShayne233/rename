defmodule Rename.UnitCase do
  @moduledoc false
  use ExUnit.CaseTemplate

  using do
    quote do
      import Rename.UnitCase
    end
  end

  def create_copy_of_app(test_copy_dir) do
    File.mkdir(test_copy_dir)

    File.ls!()
    |> Enum.filter(fn path ->
      File.dir?(path) ||
        Path.extname(path) in ~w(.ex .exs .md) ||
        Path.basename(path) == ".gitignore"
    end)
    |> Enum.reject(&(&1 in ignored_paths(test_copy_dir)))
    |> Enum.each(fn path ->
      System.cmd("cp", ["-r", path, test_copy_dir])
    end)
  end

  def delete_copy_of_app(test_copy_dir) do
    System.cmd("rm", ["-rf", test_copy_dir])
  end

  defp ignored_paths(test_copy_dir) do
    [
      "_build",
      "deps",
      test_copy_dir,
      ".git",
      ".elixir_ls"
    ]
  end
end
