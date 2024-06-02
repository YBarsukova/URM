# frozen_string_literal: true

require "minitest/autorun"
require "urm/machine"
require "urm/instruction"
require "urm/exceptions"

# Tests for exceptions that should be thrown out after trying to run incorrectly set up URM
class TestInvalidMachines < Minitest::Test
  def test_two_stops_only
    instructions = [
      "1. stop",
      "2. stop"
    ]

    machine = Urm::Machine.new(0)
    machine.add_all(instructions)

    assert_raises(Urm::MultipleStopsError) { machine.run }
  end

  def test_two_stops
    instructions = [
      "1. x1 = 1",
      "2. x1 = x1 + 1",
      "3. stop",
      "4. x1 = x1 + 1",
      "5. stop"
    ]

    machine = Urm::Machine.new(1)
    machine.add_all(instructions)

    assert_raises(Urm::MultipleStopsError) { machine.run }
  end

  def test_nonexistent_labels
    instructions = [
      "1. x1 = 1",
      "2. if x1 == 0 goto 5 else goto 3",
      "3. x1 = x1 + 1",
      "4. stop"
    ]

    machine = Urm::Machine.new(1)
    machine.add_all(instructions)

    assert_raises(Urm::InvalidLabel) { machine.run }
  end

  def test_nonexistent_labels2
    instructions = [
      "1. x1 = 1",
      "2. if x1 == 0 goto 3 else goto 5", # Метка 5 не существует
      "3. x1 = x1 + 1",
      "4. stop"
    ]

    machine = Urm::Machine.new(1)
    machine.add_all(instructions)

    assert_raises(Urm::InvalidLabel) { machine.run }
  end

  def test_nonexistent_labels3
    instructions = [
      "1. x1 = 1",
      "2. if x1 == 0 goto 3 else goto 4",
      "3. x1 = x1 + 1",
      "4. if x1 == 0 goto 6 else goto 2", # Метка 6 не существует
      "5. stop"
    ]

    machine = Urm::Machine.new(1)
    machine.add_all(instructions)

    assert_raises(Urm::InvalidLabel) { machine.run }
  end

  def test_nonexistent_labels4
    instructions = [
      "1. x1 = 1",
      "2. x1 = x1 + 1",
      "3. if x1 == 0 goto 4 else goto 6",
      "4. stop"
    ]

    machine = Urm::Machine.new(1)
    machine.add_all(instructions)

    assert_raises(Urm::InvalidLabel) { machine.run }
  end
end
