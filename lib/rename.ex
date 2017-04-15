defmodule Rename do

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

  def run(names, options \\ [])
  def run(names = {{_old_name, _new_name}, {_old_otp, _new_otp}}, options) do
    names
    |> rename_in_directory(
      options[:starting_directory] || @default_starting_directory,
      options
    )
  end

  def run(_names, _options) do
    IO.puts """
    Invalid names parameters.
    Call should look like:
      run({"old_name", "new_name"}, options) or
      run([{"old_name", "new_name"}, {"OldName", "NewName"}], options)
    Can pass as many name pairs as you'd like, and options are optional
    """
  end


  def rename_in_directory(names = {{old_name, new_name}, {old_otp, new_otp}}, cwd, options) do
    cwd
    |> File.ls!
    |> Enum.each(fn path ->
      file_or_dir = cwd <> "/" <> path
      cond do
        is_valid_directory?(file_or_dir, options) ->
          rename_in_directory(names, file_or_dir, options)
        is_valid_file?(file_or_dir, options) ->
          with {:ok, file} <- File.read(file_or_dir) do
            updated_file = file
            |> String.replace(old_name, new_name)
            |> String.replace(old_otp, new_otp)
            File.write(file_or_dir, updated_file)
          end
        true -> :nothing
      end
      unless options[:rename_files] == false do
        file_or_dir
        |> File.rename(String.replace(file_or_dir, old_otp, new_otp))
      end
    end)
  end

  def is_valid_directory?(dir, options) do
    File.dir?(dir) and
    dir in (options[:ignore_directories] || @default_ignore_directories) == false
  end

  def is_valid_file?(file, options) do
    File.exists?(file) and
    file in (options[:ignore_files] || @default_ignore_files) == false and
    has_valid_extension?(file, options)
  end

  def has_valid_extension?(file, options) do
    extension = file
    |> String.split(".")
    |> List.last
    extension in (options[:valid_extensions] || @default_extensions)
  end

end
