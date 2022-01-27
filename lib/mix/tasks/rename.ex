defmodule Mix.Tasks.Rename do
  use Mix.Task

  def run(args \\ [])

  def run([old_name, new_name, old_otp, new_otp | options]) do
    {options, _argv, _errors} =
      options
      |> OptionParser.parse(
        strict: [
          ignore_directories: :keep,
          ignore_files: :keep,
          starting_directory: :string,
          include_extensions: :keep,
          include_files: :keep
        ]
      )

    options =
      options
      |> Enum.group_by(fn {k, _v} -> k end, fn {_k, v} -> v end)
      |> Map.to_list()
      |> maybe_put_starting_directory(Keyword.get(options, :starting_directory))

    Rename.run(
      {old_name, new_name},
      {old_otp, new_otp},
      options
    )
  end

  def run(_bad_args) do
    IO.puts("""
    Did not provide required app and otp names
    Call should look like:
      mix rename OldName NewName old_name NewName
    """)

    {:error, :bad_params}
  end

  defp maybe_put_starting_directory(options, nil), do: options

  defp maybe_put_starting_directory(options, starting_directory) do
    Keyword.put(options, :starting_directory, starting_directory)
  end
end
