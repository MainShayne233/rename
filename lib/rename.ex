defmodule Rename do

  @moduledoc """
  The single module that does all the renaming
  Talk about pressure
  At least there are tests
  Well there's "a" test
  But it does like one thing
  So it's fine
  If you're mad about it, submit a PR.
  """

  @default_extensions [
    "ex",
    "exs",
    "eex",
    "md",
  ]

  @default_ignore_directories [
    "_build",
    "deps",
    "assets",
  ]

  @default_starting_directory "."

  @default_ignore_files []

  @doc """
  The public function you use to rename your app.
  Call looks like: run({"OldName", "NewName"}, {"old_otp", "new_otp"}, options)
  """

  def run(names, opts, options \\ [])
  def run(names = {_old_name, _new_name}, otps = {_old_otp, _new_otp}, options) do
    names
    |> rename_in_directory(
      otps,
      options[:starting_directory] || @default_starting_directory,
      options
    )
  end

  def run(_names, _otp, _options), do: {:error, "bad params"}

  defp rename_in_directory(names = {old_name, new_name}, otps = {old_otp, new_otp}, cwd, options) do
    cwd
    |> File.ls!
    |> Enum.each(fn path ->
      file_or_dir = cwd <> "/" <> path
      cond do
        is_valid_directory?(file_or_dir, options) ->
          rename_in_directory(names, otps, file_or_dir, options)
          true
        is_valid_file?(file_or_dir, options) ->
          file_or_dir
          |> File.read
          |> case do
            {:ok, file} -> 
              updated_file = file
              |> String.replace(old_name, new_name)
              |> String.replace(old_otp, new_otp)
              File.write(file_or_dir, updated_file)
              true
            _ ->
              false
          end
        true -> 
          false
      end
      |> case do
        true -> 
          file_or_dir
          |> File.rename(String.replace(file_or_dir, old_otp, new_otp))
        _ -> :nothing
      end
    end)
  end

  defp is_valid_directory?(dir, options) do
    File.dir?(dir) and
    dir in (options[:ignore_directories] || @default_ignore_directories) == false
  end

  defp is_valid_file?(file, options) do
    File.exists?(file) and
    file in (options[:ignore_files] || @default_ignore_files) == false and
    has_valid_extension?(file, options)
  end

  defp has_valid_extension?(file, options) do
    extension = file
    |> String.split(".")
    |> List.last
    extension in (options[:valid_extensions] || @default_extensions)
  end

end
