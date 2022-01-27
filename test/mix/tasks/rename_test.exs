defmodule Mix.Tasks.RenameTest do
  use Rename.UnitCase

  @test_copy_dir "test_copy"
  @old_app_name "Rename"
  @old_app_otp "rename"
  @new_app_name "ToDoTwitterClone"
  @new_app_otp "to_do_twitter_clone"

  describe "run/1" do
    test "rename mix task works" do
      create_copy_of_app(@test_copy_dir)

      Mix.Tasks.Rename.run([
        @old_app_name,
        @new_app_name,
        @old_app_otp,
        @new_app_otp,
        "--starting-directory",
        @test_copy_dir,
        "--ignore-directories",
        "foo"
      ])

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

      delete_copy_of_app(@test_copy_dir)
    end
  end

  test "rename mix task should give proper error for bad params" do
    {stdout, 0} = System.cmd("mix", ["rename", "not", "enought", "params"])

    assert stdout =~ """
           Did not provide required app and otp names
           Call should look like:
             mix rename OldName NewName old_name NewName
           """
  end
end
