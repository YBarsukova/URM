# frozen_string_literal: true

require "minitest/autorun"
require "urm/instruction"
require "urm/exceptions"

# Tests for URM instructions initializing and exceptions throwing
class TestInstruction < Minitest::Test
  def test_set_instruction
    inst = Urm::Instruction.set(1, 2, 3)
    assert_equal 1, inst.label
    assert_equal :set, inst.type
    assert_equal 2, inst.register
    assert_equal 3, inst.value
  end

  def test_set_invalid_value
    assert_raises(Urm::InvalidRegisterInitialization) do
      Urm::Instruction.set(1, 2, -1)
    end
  end

  def test_set_invalid_register
    assert_raises(Urm::InvalidRegisterIndex) do
      Urm::Instruction.set(1, 0, 3)
    end
  end

  def test_set_invalid_label
    assert_raises(Urm::InvalidLabel) do
      Urm::Instruction.set(0, 2, 3)
    end
    assert_raises(Urm::InvalidLabel) do
      Urm::Instruction.set(-1, 2, 3)
    end
  end

  def test_inc_instruction
    inst = Urm::Instruction.inc(1, 2)
    assert_equal 1, inst.label
    assert_equal :inc, inst.type
    assert_equal 2, inst.register
  end

  def test_inc_invalid_register
    assert_raises(Urm::InvalidRegisterIndex) do
      Urm::Instruction.inc(1, 0)
    end
  end

  def test_inc_invalid_label
    assert_raises(Urm::InvalidLabel) do
      Urm::Instruction.inc(0, 2)
    end
    assert_raises(Urm::InvalidLabel) do
      Urm::Instruction.inc(-1, 2)
    end
  end

  def test_dec_instruction
    inst = Urm::Instruction.dec(1, 2)
    assert_equal 1, inst.label
    assert_equal :dec, inst.type
    assert_equal 2, inst.register
  end

  def test_dec_invalid_register
    assert_raises(Urm::InvalidRegisterIndex) do
      Urm::Instruction.dec(1, 0)
    end
  end

  def test_dec_invalid_label
    assert_raises(Urm::InvalidLabel) do
      Urm::Instruction.dec(0, 2)
    end
    assert_raises(Urm::InvalidLabel) do
      Urm::Instruction.dec(-1, 2)
    end
  end

  def test_if_instruction
    inst = Urm::Instruction.if(1, 2, 3, 4)
    assert_equal 1, inst.label
    assert_equal :if, inst.type
    assert_equal 2, inst.register
    assert_equal 3, inst.label_true
    assert_equal 4, inst.label_false
  end

  def test_if_invalid_register
    assert_raises(Urm::InvalidRegisterIndex) do
      Urm::Instruction.if(1, 0, 3, 4)
    end
  end

  def test_if_invalid_label
    assert_raises(Urm::InvalidLabel) do
      Urm::Instruction.if(0, 2, 3, 4)
    end
    assert_raises(Urm::InvalidLabel) do
      Urm::Instruction.if(-1, 2, 3, 4)
    end
    assert_raises(Urm::InvalidLabel) do
      Urm::Instruction.if(1, 2, 0, 4)
    end
    assert_raises(Urm::InvalidLabel) do
      Urm::Instruction.if(1, 2, 3, 0)
    end
  end

  def test_stop_instruction
    inst = Urm::Instruction.stop(1)
    assert_equal 1, inst.label
    assert_equal :stop, inst.type
  end

  def test_stop_invalid_label
    assert_raises(Urm::InvalidLabel) do
      Urm::Instruction.stop(0)
    end
    assert_raises(Urm::InvalidLabel) do
      Urm::Instruction.stop(-1)
    end
  end

  def test_copy_instruction
    inst = Urm::Instruction.copy(1, 2, 3)
    assert_equal 1, inst.label
    assert_equal :copy, inst.type
    assert_equal 2, inst.register
    assert_equal 3, inst.value
  end

  def test_copy_invalid_register
    assert_raises(Urm::InvalidRegisterIndex) do
      Urm::Instruction.copy(1, 0, 3)
    end
    assert_raises(Urm::InvalidRegisterIndex) do
      Urm::Instruction.copy(1, 2, 0)
    end
  end

  def test_copy_invalid_label
    assert_raises(Urm::InvalidLabel) do
      Urm::Instruction.copy(0, 2, 3)
    end
    assert_raises(Urm::InvalidLabel) do
      Urm::Instruction.copy(-1, 2, 3)
    end
  end
end
