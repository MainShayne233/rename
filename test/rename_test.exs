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
    mix_file = File.read!(@test_copy_dir <> "/mix.exs")
    assert mix_file |> String.contains?(@new_app_name)
    assert mix_file |> String.contains?(@new_app_otp)
    assert mix_file |> String.contains?(@old_app_name) == false
    main_module = File.read!(@test_copy_dir <> "/lib/" <> @new_app_otp <> ".ex")
    assert main_module |> String.contains?(@new_app_name)
    assert main_module |> String.contains?(@old_app_name) == false
    readme = File.read!(@test_copy_dir <> "/README.md")
    assert readme |> String.contains?(@new_app_name)
    assert readme |> String.contains?(@new_app_otp)
    assert readme |> String.contains?(@old_app_name) == false
    delete_copy_of_app()
  end

  test "should give proper error for invalid params" do
    assert Rename.run(
      {@old_app_name, @new_app_name}, 
      starting_directory: @test_copy_dir
    ) == {:error, "bad params"}
  end

  test "rename mix task works" do

  end

  defp create_copy_of_app do
    File.mkdir(@test_copy_dir)
    File.ls!
    |> Enum.each(fn path -> 
      if not_ignored_path(path) do
        System.cmd("cp", ["-r", path, @test_copy_dir])
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
