defmodule FuncWrapper.TestModule do
  use FuncWrapper.Time

  def sum(x, y \\ 2), do: x + y

  def abs(x) when x < 0, do: 0 - x
  def abs(x), do: x

  def div(_x, y) when y == 0, do: 0
  def div(x, y), do: x / y

  [{:add_one, 1}, {:add_two, 2}]
  |> Enum.map(fn {name, v} ->
    def unquote(name)(x), do: x + unquote(v)
  end)

  def add_ten(x), do: sum(x, 10)
end
