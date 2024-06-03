# frozen_string_literal: true

require "minitest/autorun"
require "urm/coder"
require "urm/instruction"
require "urm/machine"

# Tests for coding integer sequences, URM instructions and URM themselves using prime numbers
class TestCoder < Minitest::Test
  def test_inc_godel_code
    numbers = [2, 3, 5]
    expected_code = (2**(2 + 1)) * (3**(3 + 1)) * (5**(5 + 1))
    assert_equal expected_code, Urm::Coder.godel_code(numbers)
  end

  def test_dec_godel_code
    numbers = [3, 2, 2]
    expected_code = (2**(3 + 1)) * (3**(2 + 1)) * (5**(2 + 1))
    assert_equal expected_code, Urm::Coder.godel_code(numbers)
  end

  def test_set_godel_code
    numbers = [1, 1, 1, 1]
    expected_code = (2**(1 + 1)) * (3**(1 + 1)) * (5**(1 + 1)) * (7**(1 + 1))
    assert_equal expected_code, Urm::Coder.godel_code(numbers)
  end

  def test_if_godel_code
    numbers = [4, 3, 2, 6, 7]
    expected_code = (2**(4 + 1)) * (3**(3 + 1)) * (5**(2 + 1)) * (7**(6 + 1)) * (11**(7 + 1))
    assert_equal expected_code, Urm::Coder.godel_code(numbers)
  end

  def test_stop_godel_code
    numbers = [5, 7]
    expected_code = (2**(5 + 1)) * (3**(7 + 1))
    assert_equal expected_code, Urm::Coder.godel_code(numbers)
  end

  def test_code_set_instruction
    instruction_set = Urm::Instruction.set(1, 1, 42)
    expected_code_set = Urm::Coder.godel_code([1, 1, 1, 42])
    assert_equal expected_code_set, Urm::Coder.code_single_instruction(instruction_set)
  end

  def test_code_inc_instruction
    instruction_inc = Urm::Instruction.inc(2, 1)
    expected_code_inc = Urm::Coder.godel_code([2, 2, 1])
    assert_equal expected_code_inc, Urm::Coder.code_single_instruction(instruction_inc)
  end

  def test_code_dec_instruction
    instruction_dec = Urm::Instruction.dec(3, 1)
    expected_code_dec = Urm::Coder.godel_code([3, 3, 1])
    assert_equal expected_code_dec, Urm::Coder.code_single_instruction(instruction_dec)
  end

  def test_code_if_instruction
    instruction_if = Urm::Instruction.if(4, 1, 5, 6)
    expected_code_if = Urm::Coder.godel_code([4, 4, 1, 5, 6])
    assert_equal expected_code_if, Urm::Coder.code_single_instruction(instruction_if)
  end

  def test_code_stop_instruction
    instruction_stop = Urm::Instruction.stop(7)
    expected_code_stop = Urm::Coder.godel_code([5, 7])
    assert_equal expected_code_stop, Urm::Coder.code_single_instruction(instruction_stop)
  end

  def test_code_machine
    machine = Urm::Machine.new(2)
    machine.add(Urm::Instruction.set(1, 1, 42))
    machine.add(Urm::Instruction.inc(2, 1))
    machine.add(Urm::Instruction.dec(3, 1))
    machine.add(Urm::Instruction.if(4, 1, 2, 5))
    # Stop instruction will be added automatically when skipped

    expected_codes = [
      Urm::Coder.godel_code([1, 1, 1, 42]),
      Urm::Coder.godel_code([2, 2, 1]),
      Urm::Coder.godel_code([3, 3, 1]),
      Urm::Coder.godel_code([4, 4, 1, 2, 5]),
      Urm::Coder.godel_code([5, 5])
    ]

    assert_equal expected_codes, Urm::Coder.code_machine(machine)
  end
end
