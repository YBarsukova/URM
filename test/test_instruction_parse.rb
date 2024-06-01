# frozen_string_literal: true

require "minitest/autorun"
require "urm/instruction"

class TestInstructionParse < Minitest::Test
  def test_parse_set_instruction
    inst = Urm::Instruction.parse("x2 ← 3")
    assert_equal :set, inst.type
    assert_equal 2, inst.register
    assert_equal 3, inst.value
  end

  def test_parse_inc_instruction
    inst = Urm::Instruction.parse("x2 ← x2 + 1")
    assert_equal :inc, inst.type
    assert_equal 2, inst.register
  end

  def test_parse_dec_instruction
    inst = Urm::Instruction.parse("x3 ← x3 - 1")
    assert_equal :dec, inst.type
    assert_equal 3, inst.register
  end

  def test_parse_if_instruction
    inst = Urm::Instruction.parse("if x2 = 0 goto 3 else goto 4")
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
end
