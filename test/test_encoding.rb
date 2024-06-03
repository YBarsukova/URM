# frozen_string_literal: true

require "minitest/autorun"
require "coder"
require "urm/instruction"
require "urm/machine"

class TestCoder < Minitest::Test
  def test_godel_code
    numbers = [2, 3, 5]
    expected_code = 2**(2+1) * 3**(3+1) * 5**(5+1)
    assert_equal expected_code, Coder.godel_code(numbers)

    numbers = [0, 0, 0]
    expected_code = 2**(0+1) * 3**(0+1) * 5**(0+1)
    assert_equal expected_code, Coder.godel_code(numbers)

    numbers = [1, 1, 1]
    expected_code = 2**(1+1) * 3**(1+1) * 5**(1+1)
    assert_equal expected_code, Coder.godel_code(numbers)

    numbers = [4, 3, 2, 6, 7]
    expected_code = 2**(4+1) * 3**(3+1) * 5**(2+1) * 7**(6+1) * 11**(7+1)
    assert_equal expected_code, Coder.godel_code(numbers)

    numbers = [5, 7]
    expected_code = 2**(5+1) * 3**(7+1)
    assert_equal expected_code, Coder.godel_code(numbers)
  end

  def test_code_single_instruction
    instruction_set = Instruction.set(1, 1, 42)
    expected_code_set = Coder.godel_code([1, 1, 1, 42])
    assert_equal expected_code_set, Coder.code_single_instruction(instruction_set)

    instruction_inc = Instruction.inc(2, 1)
    expected_code_inc = Coder.godel_code([2, 2, 1])
    assert_equal expected_code_inc, Coder.code_single_instruction(instruction_inc)

    instruction_dec = Instruction.dec(3, 1)
    expected_code_dec = Coder.godel_code([3, 3, 1])
    assert_equal expected_code_dec, Coder.code_single_instruction(instruction_dec)

    instruction_if = Instruction.if(4, 1, 5, 6)
    expected_code_if = Coder.godel_code([4, 4, 1, 5, 6])
    assert_equal expected_code_if, Coder.code_single_instruction(instruction_if)

    instruction_stop = Instruction.stop(7)
    expected_code_stop = Coder.godel_code([5, 7])
    assert_equal expected_code_stop, Coder.code_single_instruction(instruction_stop)
  end

  def test_code_machine
    machine = Machine.new(2)
    machine.add(Instruction.set(1, 1, 42))
    machine.add(Instruction.inc(2, 1))
    machine.add(Instruction.dec(3, 1))
    machine.add(Instruction.if(4, 1, 5, 6))
    machine.add(Instruction.stop(7))

    expected_codes = [
      Coder.godel_code([1, 1, 1, 42]),
      Coder.godel_code([2, 2, 1]),
      Coder.godel_code([3, 3, 1]),
      Coder.godel_code([4, 4, 1, 5, 6]),
      Coder.godel_code([5, 7])
    ]

    assert_equal expected_codes, Coder.code_machine(machine)
  end
end
