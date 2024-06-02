# frozen_string_literal: true

require "minitest/autorun"
require "urm/machine"
require "urm/instruction"
require "urm/exceptions"
require "machine_tester"

class TestMachineOperations < Minitest::Test
  def test_multiplication
    multiplication_instructions = [
      "1. if x3 == 0 goto 9 else goto 2",
      "2. x3 = x3 - 1",
      "3. x4 = x2",
      "4. if x4 == 0 goto 8 else goto 5",
      "5. x1 = x1 + 1",
      "6. x4 = x4 - 1",
      "7. if x4 == 0 goto 8 else goto 5",
      "8. if x3 == 0 goto 9 else goto 2",
      "9. stop"
    ]

    machine = Urm::Machine.new(2)
    machine.add_all(multiplication_instructions)

    MachineTester.assert_range(machine, 0, 10, lambda { |x2, x3| x2 * x3 })
  end

  def test_division
    division_instructions = [
      "1. if x2 == 0 goto 10 else goto 2",
      "2. x4 = x3",
      "3. x2 = x2 - 1",
      "4. x4 = x4 - 1",
      "5. if x2 == 0 goto 6 else goto 7",
      "6. if x4 == 0 goto 8 else goto 10",
      "7. if x4 == 0 goto 8 else goto 3",
      "8. x1 = x1 + 1",
      "9. if x2 == 0 goto 10 else goto 2",
      "10. stop"
    ]
    machine = Urm::Machine.new(2)
    machine.add_all(division_instructions)

    MachineTester.assert_range(machine, 1, 10, lambda { |x2, x3| x2 / x3 })
  end

  def test_subtraction
    subtraction_instructions = [
      "1. if x2 == 0 goto 7 else goto 2",
      "2. if x3 == 0 goto 6 else goto 3",
      "3. x2 = x2 - 1",
      "4. x3 = x3 - 1",
      "5. if x2 == 0 goto 7 else goto 2",
      "6. x1 = x2",
      "7. stop"
    ]

    machine = Urm::Machine.new(2)
    machine.add_all(subtraction_instructions)

    MachineTester.assert_range(machine, 0, 100, lambda { |x2, x3| [x2 - x3, 0].max })
  end

  def test_addition
    addition_instructions = [
      "1. if x2 == 0 goto 5 else goto 2",
      "2. x2 = x2 - 1",
      "3. x1 = x1 + 1",
      "4. if x2 == 0 goto 5 else goto 2",
      "5. stop",
    ]

    machine = Urm::Machine.new(2)
    machine.add_all(addition_instructions)

    MachineTester.assert_range(machine, 0, 100, lambda { |x2, x3| x2 + x3 })
  end

end