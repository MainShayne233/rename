defmodule RenameTest do
  use ExUnit.Case

  @test_copy_dir "test_copy"
  @old_app_name "Rename"
  @old_app_otp "rename"
  @new_app_name "ToDoTwitterClone"
  @new_app_otp "to_do_twitter_clone"
  

  test "should properly rename app with default options" do
    create_copy_of_app()
    Rename.run(
      {@old_app_name, @new_app_name}, 
      {@old_app_otp, @new_app_otp}, 
      starting_directory: @test_copy_dir
    )
    #    assert File.read!(@test_copy_dir <> "/mix.exs") |> String.contains?(@new_app_name)
    #    assert File.read!(@test_copy_dir <> "/mix.exs") |> String.contains?(@old_app_name) == false
    #    assert File.dir?(@test_copy_dir <> "./lib/" <> @new_app_otp <> ".ex")
    #    delete_copy_of_app()
  end


  defp create_copy_of_app do
    File.mkdir(@test_copy_dir)
    File.ls!
    |> Enum.each(fn path -> 
      cond do
        File.dir?(path) and not_ignored_path(path) ->
          System.cmd("cp", ["-r", path, @test_copy_dir])
        true ->
          File.cp!(path, @test_copy_dir)
      end
    end)
  end

  defp delete_copy_of_app() do
    System.cmd("rm", ["-rf", @test_copy_dir])
  end


  defp not_ignored_path(path) do
    [
      "_build",
      "deps", 
      @test_copy_dir,
      ".git",
    ]
    |> Enum.find(&(&1 == path)) == nil
  end

end
