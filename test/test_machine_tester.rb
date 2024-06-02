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

    MachineTester.assert_range(machine, 0, 100, lambda { |x2, x3| x2 * x3 })
  end
end
