# frozen_string_literal: true

require "urm/exceptions"
require "urm/instruction"
require "prime"

module Urm
  # The Coder class provides methods for encoding and decoding URM instructions
  # and entire machines using Godel numbering. This class is useful for converting instructions and machines
  # into unique numerical representations and back. The primary methods available in this class are:
  #
  # - `self.code_single_instruction`: Encodes a single URM instruction into a Godel number.
  # - `self.code_machine`: Encodes an entire URM machine (a sequence of instructions) into an array of Godel numbers.
  # - `self.godel_code`: Encodes an array of integers into a single Godel number.
  #
  # TODO add about decoding
  class Coder
    def self.code_single_instruction(instruction)
      code = case instruction.type
             when :set
               [1, instruction.label, instruction.register, instruction.value]
             when :inc
               [2, instruction.label, instruction.register]
             when :dec
               [3, instruction.label, instruction.register]
             when :if
               [4, instruction.label, instruction.register, instruction.label_true, instruction.label_false]
             when :stop
               [5, instruction.label]
             else
               raise "Unknown instruction type: #{instruction.type}"
             end
      godel_code(code)
    end

    def self.code_machine(machine)
      machine.validate_instructions
      machine.instructions.compact.map do |instruction|
        code_single_instruction(instruction)
      end
    end

    def self.godel_code(numbers)
      primes = Prime.first(numbers.size)
      godel_number = 1

      numbers.each_with_index do |num, index|
        godel_number *= primes[index]**(num + 1)
      end

      godel_number
    end
  end
end
