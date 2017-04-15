defmodule Mix.Tasks.Rename do
  use Mix.Task

  def run(args \\ [])
  def run([old_name, new_name, old_otp, new_otp | options]) do
    Rename.run({old_name, new_name}, {old_otp, new_otp}, options)
  end
  def run(_bad_args) do
    IO.puts """
    Did not provide required app and otp names
    Call should look like:
      mix rename OldName NewName old_name NewName 
    """
  end
end
