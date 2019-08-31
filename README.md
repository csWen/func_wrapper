# FuncWrapper

Add function wrapper to a module. By using function_wrapperr, all functions in this module will be wrapped.

You can define you own module functions wrapper by using FuncWrapper.Helper:
```elixir
defmodule MyWrapper do
  use FuncWrapper.Helper

  defwrapper(fn fun_name, arg_list, body ->
    passed_args = arg_list |> Enum.map(&inspect/1) |> Enum.join(", ")
    IO.puts "executing #{fun_name}..."
    result = body
    IO.puts "finish #{fun_name}, result is #{result}"
    result
  end)
end

defmodule MyModule do
  use MyWrapper
  
  def sum(a, b), do: a + b
end

iex> MyModule.sum(1, 2)
executing sum...
finish sum, result is 3
3
```

Wrapper support def a function dynamically.  
There are some common wrapper, only timer wrapper for now:
```elixir
defmodule TimerTest do
  use FuncWrapper.Time

  def sum(x, y \\ 2), do: x + y

  [{:add_one, 1}, {:add_two, 2}]
  |> Enum.map(fn {name, v} ->
    def unquote(name)(x), do: x + unquote(v)
  end
end

iex> TimerTest.sum(1, 2)
Elixir.TimerTest.sum(1, 2) = 3 : 0us
```
