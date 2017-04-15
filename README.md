## Rename
For the indecisive developer

Renames all files, modules, otp statements, etc in most standard Elixir applications


[![Build Status](https://travis-ci.org/MainShayne233/rename.svg?branch=master)](https://travis-ci.org/MainShayne233/rename)
[![Hex Version](http://img.shields.io/hexpm/v/rename.svg?style=flat)](https://hex.pm/packages/rename)

## Install
Add to your mix dependencies in `mix.exs`
```elixir
# mix.exs
defp deps do
  [
    {:rename, "~> 0.1.0", only: :dev}
  ]
end
```
and install
```bash
mix deps.get
```

## Usage
You can run it as a `mix task`
```bash
mix rename OldAppName NewAppName old_app_otp new_app_top
```
Or from Elixir
```elixir
Rename.run(
  {"OldAppName", "NewAppName"},
  {"old_app_otp", "new_app_otp"},
  ignore_files: "./lib/old_app_otp/sacred.ex" # optional options
)
```
