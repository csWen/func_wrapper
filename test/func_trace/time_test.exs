defmodule FuncWrapper.TimeTest do
  use ExUnit.Case
  alias FuncWrapper.TestModule

  test "should no error and get correct result" do
    assert TestModule.sum(5, 6) == 11

    assert TestModule.abs(10) == 10
    assert TestModule.abs(-10) == 10

    assert TestModule.div(10, 5) == 2
    assert TestModule.div(10, 0) == 0

    assert TestModule.add_one(10) == 11
    assert TestModule.add_two(10) == 12

    assert TestModule.add_ten(10) == 20
  end
end
