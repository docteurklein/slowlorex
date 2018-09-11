defmodule SlowLorisTest do
  use ExUnit.Case
  doctest SlowLoris

  test "greets the world" do
    assert SlowLoris.hello() == :world
  end
end
