# frozen_string_literal: true

require "minitest/autorun"
require "urm/instruction"
require "urm/exceptions"

# Tests for parsing strings <-> machine instructions
class TestInstructionParse < Minitest::Test
  def test_parse_set_instruction
    inst = Urm::Instruction.parse("1. x2 = 3")
    assert_equal 1, inst.label
    assert_equal :set, inst.type
    assert_equal 2, inst.register
    assert_equal 3, inst.value
  end

  def test_parse_inc_instruction
    inst = Urm::Instruction.parse("1. x2 = x2 + 1")
    assert_equal 1, inst.label
    assert_equal :inc, inst.type
    assert_equal 2, inst.register
  end

  def test_parse_dec_instruction
    inst = Urm::Instruction.parse("1. x3 = x3 - 1")
    assert_equal 1, inst.label
    assert_equal :dec, inst.type
    assert_equal 3, inst.register
  end

  def test_parse_if_instruction
    inst = Urm::Instruction.parse("1. if x2 == 0 goto 3 else goto 4")
    assert_equal 1, inst.label
    assert_equal :if, inst.type
    assert_equal 2, inst.register
    assert_equal 3, inst.label_true
    assert_equal 4, inst.label_false
  end

  def test_parse_stop_instruction
    inst = Urm::Instruction.parse("1. stop")
    assert_equal 1, inst.label
    assert_equal :stop, inst.type
    assert_nil inst.value
  end

  def test_parse_copy_instruction
    inst = Urm::Instruction.parse("1. x2 = x3")
    assert_equal 1, inst.label
    assert_equal :copy, inst.type
    assert_equal 2, inst.register
    assert_equal 3, inst.value
  end

  def test_parse_set_instruction_invalid_value
    assert_raises(Urm::InvalidRegisterInitialization) do
      Urm::Instruction.parse("1. x2 = -1")
    end
  end

  def test_parse_set_instruction_invalid_register
    assert_raises(Urm::InvalidRegisterIndex) do
      Urm::Instruction.parse("1. x0 = 3")
    end
  end

  def test_parse_set_instruction_invalid_label
    assert_raises(Urm::InvalidLabel) do
      Urm::Instruction.parse("0. x2 = 3")
    end
    assert_raises(Urm::InvalidLabel) do
      Urm::Instruction.parse("-1. x2 = 3")
    end
  end

  def test_parse_inc_instruction_invalid_register
    assert_raises(Urm::InvalidRegisterIndex) do
      Urm::Instruction.parse("1. x0 = x0 + 1")
    end
  end

  def test_parse_inc_instruction_invalid_label
    assert_raises(Urm::InvalidLabel) do
      Urm::Instruction.parse("0. x2 = x2 + 1")
    end
    assert_raises(Urm::InvalidLabel) do
      Urm::Instruction.parse("-1. x2 = x2 + 1")
    end
  end

  def test_parse_dec_instruction_invalid_register
    assert_raises(Urm::InvalidRegisterIndex) do
      Urm::Instruction.parse("1. x0 = x0 - 1")
    end
  end

  def test_parse_dec_instruction_invalid_label
    assert_raises(Urm::InvalidLabel) do
      Urm::Instruction.parse("0. x3 = x3 - 1")
    end
  end

  def test_parse_if_instruction_invalid_register
    assert_raises(Urm::InvalidRegisterIndex) do
      Urm::Instruction.parse("1. if x0 == 0 goto 3 else goto 4")
    end
  end

  def test_parse_if_instruction_invalid_label
    assert_raises(Urm::InvalidLabel) do
      Urm::Instruction.parse("0. if x2 == 0 goto 3 else goto 4")
    end
    assert_raises(Urm::InvalidLabel) do
      Urm::Instruction.parse("-1. if x2 == 0 goto 3 else goto 4")
    end
    assert_raises(Urm::InvalidLabel) do
      Urm::Instruction.parse("1. if x2 == 0 goto 0 else goto 4")
    end
    assert_raises(Urm::InvalidLabel) do
      Urm::Instruction.parse("1. if x2 == 0 goto 3 else goto 0")
    end
  end

  def test_parse_stop_instruction_invalid_label
    assert_raises(Urm::InvalidLabel) do
      Urm::Instruction.parse("0. stop")
    end
    assert_raises(Urm::InvalidLabel) do
      Urm::Instruction.parse("-1. stop")
    end
  end

  def test_parse_copy_instruction_invalid_register
    assert_raises(Urm::InvalidRegisterIndex) do
      Urm::Instruction.parse("1. x0 = x3")
    end
    assert_raises(Urm::InvalidRegisterIndex) do
      Urm::Instruction.parse("1. x2 = x0")
    end
  end

  def test_parse_copy_instruction_invalid_label
    assert_raises(Urm::InvalidLabel) do
      Urm::Instruction.parse("0. x2 = x3")
    end
    assert_raises(Urm::InvalidLabel) do
      Urm::Instruction.parse("-1. x2 = x3")
    end
  end

  def test_to_s_set_instruction
    inst = Urm::Instruction.set(1, 2, 3)
    assert_equal "1. x2 = 3", inst.to_s
  end

  def test_to_s_inc_instruction
    inst = Urm::Instruction.inc(1, 2)
    assert_equal "1. x2 = x2 + 1", inst.to_s
  end

  def test_to_s_dec_instruction
    inst = Urm::Instruction.dec(1, 3)
    assert_equal "1. x3 = x3 - 1", inst.to_s
  end

  def test_to_s_if_instruction
    inst = Urm::Instruction.if(1, 2, 3, 4)
    assert_equal "1. if x2 == 0 goto 3 else goto 4", inst.to_s
  end

  def test_to_s_stop_instruction
    inst = Urm::Instruction.stop(1)
    assert_equal "1. stop", inst.to_s
  end

  def test_to_s_copy_instruction
    inst = Urm::Instruction.copy(1, 2, 3)
    assert_equal "1. x2 = x3", inst.to_s
  end
end
