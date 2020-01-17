defmodule HandymanTest do
  use ExUnit.Case
  doctest Handyman

  test "greets the world" do
    assert Handyman.hello() == :world
  end
end
