defmodule CanaryPocTest do
  use ExUnit.Case
  doctest CanaryPoc

  test "greets the world" do
    assert CanaryPoc.hello() == :world
  end
end
