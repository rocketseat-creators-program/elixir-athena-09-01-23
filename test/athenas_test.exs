defmodule AthenasTest do
  use ExUnit.Case
  doctest Athenas

  test "greets the world" do
    assert Athenas.hello() == :world
  end
end
