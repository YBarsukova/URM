# frozen_string_literal: true
require "minitest/autorun"
require "urm/instruction"
require "urm/exceptions"

class TestInstruction < Minitest::Test
  def test_set_instruction
    inst = Urm::Instruction.set(2, 3)
    assert_equal :set, inst.type
    assert_equal 2, inst.register
    assert_equal 3, inst.value
  end

  def test_set_instruction_invalid_value
    assert_raises(Urm::InvalidRegisterInitialization) do
      Urm::Instruction.set(2, -1)
    end
  end

  def test_set_instruction_invalid_register
    assert_raises(Urm::InvalidRegisterIndex) do
      Urm::Instruction.set(0, 3)
    end
  end

  def test_inc_instruction
    inst = Urm::Instruction.inc(2)
    assert_equal :inc, inst.type
    assert_equal 2, inst.register
  end

  def test_inc_instruction_invalid_register
    assert_raises(Urm::InvalidRegisterIndex) do
      Urm::Instruction.inc(0)
    end
  end

  def test_dec_instruction
    inst = Urm::Instruction.dec(2)
    assert_equal :dec, inst.type
    assert_equal 2, inst.register
  end

  def test_dec_instruction_invalid_register
    assert_raises(Urm::InvalidRegisterIndex) do
      Urm::Instruction.dec(0)
    end
  end

  def test_if_instruction
    inst = Urm::Instruction.if(2, 3, 4)
    assert_equal :if, inst.type
    assert_equal 2, inst.register
    assert_equal 3, inst.label_true
    assert_equal 4, inst.label_false
  end

  def test_if_instruction_invalid_register
    assert_raises(Urm::InvalidRegisterIndex) do
      Urm::Instruction.if(0, 3, 4)
    end
  end

  def test_if_instruction_invalid_label
    assert_raises(Urm::InvalidLabel) do
      Urm::Instruction.if(2, 0, 4)
    end
    assert_raises(Urm::InvalidLabel) do
      Urm::Instruction.if(2, 3, 0)
    end
  end

  def test_stop_instruction
    inst = Urm::Instruction.stop
    assert_equal :stop, inst.type
  end
end
