# frozen_string_literal: true

require "minitest/autorun"
require "urm/machine"
require "urm/instruction"
require "urm/exceptions"

# Tests for automatic adding a stop instruction if it wasn't added manually
class TestAutoStopMachines < Minitest::Test
  def test_auto_stop
    instructions = [
      "1. x1 = 1"
    ]

    machine = Urm::Machine.new(0)
    machine.add_all(instructions)

    (0..100).each { |_x| assert_equal machine.run, 1 }
  end

  def test_auto_stop_with_if
    instructions = [
      "1. x1 = 1",
      "2. if x1 == 0 goto 3 else goto 4",
      "3. x1 = x1 + 1"
    ]

    machine = Urm::Machine.new(0)
    machine.add_all(instructions)

    (0..100).each { |_x| assert_equal machine.run, 1 }
  end

  def test_auto_stop_with_loop
    instructions = [
      "1. x1 = 1",
      "2. if x1 == 0 goto 3 else goto 4",
      "3. x1 = x1 + 1",
      "4. if x1 == 0 goto 2 else goto 5"
    ]

    machine = Urm::Machine.new(0)
    machine.add_all(instructions)

    (0..100).each { |_x| assert_equal machine.run, 1 }
  end
end
