# frozen_string_literal: true

require "minitest/autorun"
require "instruction"
require "exceptions"

class TestInstructionParse < Minitest::Test
  def test_parse_set_instruction
    inst = Urm::Instruction.parse("x2 = 3")
    assert_equal :set, inst.type
    assert_equal 2, inst.register
    assert_equal 3, inst.value
  end

  def test_parse_inc_instruction
    inst = Urm::Instruction.parse("x2 = x2 + 1")
    assert_equal :inc, inst.type
    assert_equal 2, inst.register
  end

  def test_parse_dec_instruction
    inst = Urm::Instruction.parse("x3 = x3 - 1")
    assert_equal :dec, inst.type
    assert_equal 3, inst.register
  end

  def test_parse_if_instruction
    inst = Urm::Instruction.parse("if x2 == 0 goto 3 else goto 4")
    assert_equal :if, inst.type
    assert_equal 2, inst.register
    assert_equal 3, inst.label_true
    assert_equal 4, inst.label_false
  end

  def test_parse_stop_instruction
    inst = Urm::Instruction.parse("stop")
    assert_equal :stop, inst.type
    assert_nil inst.value
  end

  def test_parse_copy_instruction
    inst = Urm::Instruction.parse("x2 = x3")
    assert_equal :copy, inst.type
    assert_equal 2, inst.register
    assert_equal 3, inst.value
  end

  # Тесты для проверки выброса исключений
  def test_parse_set_instruction_invalid_value
    assert_raises(Urm::InvalidRegisterInitialization) do
      Urm::Instruction.parse("x2 = -1")
    end
  end

  def test_parse_set_instruction_invalid_register
    assert_raises(Urm::InvalidRegisterIndex) do
      Urm::Instruction.parse("x0 = 3")
    end
  end

  def test_parse_inc_instruction_invalid_register
    assert_raises(Urm::InvalidRegisterIndex) do
      Urm::Instruction.parse("x0 = x0 + 1")
    end
  end

  def test_parse_dec_instruction_invalid_register
    assert_raises(Urm::InvalidRegisterIndex) do
      Urm::Instruction.parse("x0 = x0 - 1")
    end
  end

  def test_parse_if_instruction_invalid_register
    assert_raises(Urm::InvalidRegisterIndex) do
      Urm::Instruction.parse("if x0 == 0 goto 3 else goto 4")
    end
  end

  def test_parse_if_instruction_invalid_label
    assert_raises(Urm::InvalidLabel) do
      Urm::Instruction.parse("if x2 == 0 goto 0 else goto 4")
    end
    assert_raises(Urm::InvalidLabel) do
      Urm::Instruction.parse("if x2 == 0 goto 3 else goto 0")
    end
  end

  def test_parse_copy_instruction_invalid_register
    assert_raises(Urm::InvalidRegisterIndex) do
      Urm::Instruction.parse("x0 = x3")
    end
    assert_raises(Urm::InvalidRegisterIndex) do
      Urm::Instruction.parse("x2 = x0")
    end
  end

  # Тесты метода to_s
  def test_to_s_set_instruction
    inst = Urm::Instruction.set(2, 3)
    assert_equal "x2 = 3", inst.to_s
  end

  def test_to_s_inc_instruction
    inst = Urm::Instruction.inc(2)
    assert_equal "x2 = x2 + 1", inst.to_s
  end

  def test_to_s_dec_instruction
    inst = Urm::Instruction.dec(3)
    assert_equal "x3 = x3 - 1", inst.to_s
  end

  def test_to_s_if_instruction
    inst = Urm::Instruction.if(2, 3, 4)
    assert_equal "if x2 == 0 goto 3 else goto 4", inst.to_s
  end

  def test_to_s_stop_instruction
    inst = Urm::Instruction.stop
    assert_equal "stop", inst.to_s
  end

  def test_to_s_copy_instruction
    inst = Urm::Instruction.copy(2, 3)
    assert_equal "x2 = x3", inst.to_s
  end
end
