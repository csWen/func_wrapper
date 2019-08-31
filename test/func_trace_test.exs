defmodule FuncWrapperTest do
  use ExUnit.Case
  doctest FuncWrapper

  test "greets the world" do
    assert FuncWrapper.hello() == :world
  end
end
