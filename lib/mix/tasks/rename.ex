defmodule Mix.Tasks.Rename do
  use Mix.Task

  def run(args \\ [])
  def run([old_name, new_name, old_otp, new_otp | extra_options]) do
    Rename.run(
      {old_name, new_name}, 
      {old_otp, new_otp}, 
      run_options(extra_options)
    )
  end
  def run(_bad_args) do
    IO.puts """
    Did not provide required app and otp names
    Call should look like:
      mix rename OldName NewName old_name NewName
    """
    {:error, :bad_params}
  end

  def run_options(extra_options, options \\ [])
  def run_options([], options) do
    ignore_files = options[:ignore_files] || []
    options
    |> Enum.reject(fn {key, _val} -> key == :ignore_files end)
    |> Enum.concat([ignore_files: ignore_files])
  end
  def run_options([key, val | rest], options) do
    rest
    |> run_options(
      options
      |> Enum.concat([{parsed_key(key), val}])
    )
  end

  def parsed_key(key) do
    key
    |> String.slice(2..-1)
    |> String.replace("-", "_")
    |> String.to_atom
  end

end
