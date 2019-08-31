defmodule FuncWrapper.Time do
  use FuncWrapper.Helper

  defwrapper(fn fun_name, arg_list, body ->
    passed_args = arg_list |> Enum.map(&inspect/1) |> Enum.join(", ")
    {time, result} = :timer.tc(fn -> body end)
    IO.puts("#{__MODULE__}.#{fun_name}(#{passed_args}) = #{result} : #{time}us")
    result
  end)
end
