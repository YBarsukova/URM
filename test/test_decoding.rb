# frozen_string_literal: true

# rubocop:disable Metrics/AbcSize

require "minitest/autorun"
require "urm/coder"
require "urm/instruction"
require "urm/machine"

# Tests for decoding integer sequences, URM instructions and URM themselves
class TestDecoding < Minitest::Test
  def test_decode_set_instruction
    godel_number = Urm::Coder.godel_code([1, 1, 1, 42])
    instruction = Urm::Coder.decode_single_instruction(godel_number)
    assert_equal :set, instruction.type
    assert_equal 1, instruction.label
    assert_equal 1, instruction.register
    assert_equal 42, instruction.value
  end

  def test_decode_inc_instruction
    godel_number = Urm::Coder.godel_code([2, 2, 1])
    instruction = Urm::Coder.decode_single_instruction(godel_number)
    assert_equal :inc, instruction.type
    assert_equal 2, instruction.label
    assert_equal 1, instruction.register
  end

  def test_decode_dec_instruction
    godel_number = Urm::Coder.godel_code([3, 3, 1])
    instruction = Urm::Coder.decode_single_instruction(godel_number)
    assert_equal :dec, instruction.type
    assert_equal 3, instruction.label
    assert_equal 1, instruction.register
  end

  def test_decode_if_instruction
    godel_number = Urm::Coder.godel_code([4, 4, 1, 5, 6])
    instruction = Urm::Coder.decode_single_instruction(godel_number)
    assert_equal :if, instruction.type
    assert_equal 4, instruction.label
    assert_equal 1, instruction.register
    assert_equal 5, instruction.label_true
    assert_equal 6, instruction.label_false
  end

  def test_decode_stop_instruction
    godel_number = Urm::Coder.godel_code([5, 7])
    instruction = Urm::Coder.decode_single_instruction(godel_number)
    assert_equal :stop, instruction.type
    assert_equal 7, instruction.label
  end

  def test_decode_machine
    machine = Urm::Machine.new(2)
    machine.add(Urm::Instruction.set(1, 1, 42))
    machine.add(Urm::Instruction.inc(2, 1))
    machine.add(Urm::Instruction.dec(3, 1))
    machine.add(Urm::Instruction.if(4, 1, 2, 5))
    machine.add(Urm::Instruction.stop(7))

    encoded_machine = Urm::Coder.code_machine(machine)
    decoded_machine = Urm::Coder.decode_machine(encoded_machine)

    assert_equal 5, decoded_machine.instructions.compact.size

    instructions = decoded_machine.instructions.compact

    assert_equal :set, instructions[0].type
    assert_equal 1, instructions[0].label
    assert_equal 1, instructions[0].register
    assert_equal 42, instructions[0].value

    assert_equal :inc, instructions[1].type
    assert_equal 2, instructions[1].label
    assert_equal 1, instructions[1].register

    assert_equal :dec, instructions[2].type
    assert_equal 3, instructions[2].label
    assert_equal 1, instructions[2].register

    assert_equal :if, instructions[3].type
    assert_equal 4, instructions[3].label
    assert_equal 1, instructions[3].register
    assert_equal 2, instructions[3].label_true
    assert_equal 5, instructions[3].label_false

    assert_equal :stop, instructions[4].type
    assert_equal 7, instructions[4].label
  end

  def test_decode_machine_parsing
    instructions = [
      "1. x1 = 3",
      "2. if x2 == 0 goto 6 else goto 3",
      "3. x2 = x2 + 1",
      "4. x1 = x1 - 1",
      "5. if x1 == 0 goto 6 else goto 3",
      "6. stop"
    ]

    machine = Urm::Machine.new(1)
    machine.add_all(instructions)

    encoded_machine = Urm::Coder.code_machine(machine)
    decoded_machine = Urm::Coder.decode_machine(encoded_machine)

    assert_equal 6, decoded_machine.instructions.compact.size
    decoded_instructions = decoded_machine.instructions.compact

    assert_equal :set, decoded_instructions[0].type
    assert_equal 1, decoded_instructions[0].label
    assert_equal 1, decoded_instructions[0].register
    assert_equal 3, decoded_instructions[0].value

    assert_equal :if, decoded_instructions[1].type
    assert_equal 2, decoded_instructions[1].label
    assert_equal 2, decoded_instructions[1].register
    assert_equal 6, decoded_instructions[1].label_true
    assert_equal 3, decoded_instructions[1].label_false

    assert_equal :inc, decoded_instructions[2].type
    assert_equal 3, decoded_instructions[2].label
    assert_equal 2, decoded_instructions[2].register

    assert_equal :dec, decoded_instructions[3].type
    assert_equal 4, decoded_instructions[3].label
    assert_equal 1, decoded_instructions[3].register

    assert_equal :if, decoded_instructions[4].type
    assert_equal 5, decoded_instructions[4].label
    assert_equal 1, decoded_instructions[4].register
    assert_equal 6, decoded_instructions[4].label_true
    assert_equal 3, decoded_instructions[4].label_false

    assert_equal :stop, decoded_instructions[5].type
    assert_equal 6, decoded_instructions[5].label
  end

  def test_decoding_similar_machines
    machine1 = Urm::Machine.new(1)
    machine1.add(Urm::Instruction.if(1, 2, 2, 2))
    machine1.add(Urm::Instruction.parse("2. stop"))

    machine2 = Urm::Machine.new(1)
    machine2.add(Urm::Instruction.if(1, 2, 2, 2))

    encoded_machine1 = Urm::Coder.code_machine(machine1)
    decoded_machine1 = Urm::Coder.decode_machine(encoded_machine1)

    encoded_machine2 = Urm::Coder.code_machine(machine2)
    decoded_machine2 = Urm::Coder.decode_machine(encoded_machine2)

    assert_equal decoded_machine2.instructions.size, decoded_machine1.instructions.compact.size

    decoded_instructions1 = decoded_machine1.instructions.compact
    decoded_instructions2 = decoded_machine2.instructions.compact

    assert_equal decoded_instructions1[0].type, decoded_instructions2[0].type
    assert_equal decoded_instructions1[0].label, decoded_instructions2[0].label
    assert_equal decoded_instructions1[0].register, decoded_instructions2[0].register
    assert_equal decoded_instructions1[0].label_false, decoded_instructions2[0].label_false
    assert_equal decoded_instructions1[0].label_true, decoded_instructions2[0].label_true

    assert_equal decoded_instructions1[1].type, decoded_instructions2[1].type
    assert_equal decoded_instructions1[1].label, decoded_instructions2[1].label
  end
end

# rubocop:enable Metrics/AbcSize

