defmodule RenameTest do
  use ExUnit.Case

  test "should properly rename app with default options" do
    create_copy_of_app()
    Rename.run({"Rename", "ToDoTwitterClone"}, {"rename", "to_do_twitter_clone"}, [starting_directory: "./test_copy"])
    delete_copy_of_app()
  end


  defp create_copy_of_app do
    File.mkdir("test_copy")
    File.ls!
    |> Enum.each(fn path -> 
      if File.dir?(path) and not_ignored_path(path) do
        System.cmd("cp", ["-r", path, "test_copy"])
      end
    end)
  end

  defp delete_copy_of_app() do
    System.cmd("rm", ["-rf", "test_copy"])
  end


  defp not_ignored_path(path) do
    [
      "_build",
      "deps", 
      "test_copy",
      ".git",
    ]
    |> Enum.find(&(&1 == path)) == nil
  end

end
