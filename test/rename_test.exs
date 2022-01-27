defmodule RenameTest do
  use Rename.UnitCase

  @test_copy_dir "test_copy"
  @old_app_name "Rename"
  @old_app_otp "rename"
  @new_app_name "ToDoTwitterClone"
  @new_app_otp "to_do_twitter_clone"

  setup_all do
    create_copy_of_app(@test_copy_dir)

    Rename.run(
      {@old_app_name, @new_app_name},
      {@old_app_otp, @new_app_otp},
      starting_directory: @test_copy_dir
    )

    on_exit(fn -> delete_copy_of_app(@test_copy_dir) end)
  end

  describe "run/3" do
    test "should rename mix file" do
      file = File.read!(@test_copy_dir <> "/mix.exs")

      assert String.contains?(file, @new_app_name)
      assert String.contains?(file, @old_app_name) == false
      assert String.contains?(file, @new_app_otp)
      assert String.contains?(file, @old_app_otp) == false
    end

    test "should rename main module" do
      file = File.read!(@test_copy_dir <> "/lib/" <> @new_app_otp <> ".ex")

      assert String.contains?(file, @new_app_name)
      assert String.contains?(file, @old_app_name) == false
      assert String.contains?(file, @new_app_otp)
      assert String.contains?(file, @old_app_otp) == false
    end

    test "should rename README" do
      file = File.read!(@test_copy_dir <> "/README.md")

      assert String.contains?(file, @new_app_name)
      assert String.contains?(file, @old_app_name) == false
      assert String.contains?(file, @new_app_otp)
      assert String.contains?(file, @old_app_otp) == false
    end

    test "should rename gitignore" do
      file = File.read!(@test_copy_dir <> "/.gitignore")

      assert String.contains?(file, @new_app_otp)
      assert String.contains?(file, @old_app_otp) == false
    end

    test "should rename config" do
      file = File.read!(@test_copy_dir <> "/config/test.exs")

      assert String.contains?(file, @new_app_name)
      assert String.contains?(file, @old_app_name) == false
      assert String.contains?(file, @new_app_otp)
      assert String.contains?(file, @old_app_otp) == false
    end

    test "should rename dir" do
      assert File.dir?("#{@test_copy_dir}/lib/#{@new_app_otp}")
    end

    test "should rename tests" do
      assert File.exists?("#{@test_copy_dir}/test/#{@new_app_otp}_test.exs")
    end

    test "should give proper error for invalid params" do
      assert Rename.run(
               {@old_app_name, @new_app_name},
               starting_directory: @test_copy_dir
             ) == {:error, "bad params"}
    end
  end
end
