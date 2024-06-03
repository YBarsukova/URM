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

    def self.decode_single_instruction(godel_number)
      exponents = extract_exponents(godel_number)

      type = exponents[0]
      label = exponents[1]

      case type
      when 1
        decode_set(label, exponents)
      when 2
        decode_inc(label, exponents)
      when 3
        decode_dec(label, exponents)
      when 4
        decode_if(label, exponents)
      when 5
        decode_stop(label)
      else
        raise "Unknown instruction type: #{type}"
      end
    end

    def self.decode_machine(godel_numbers)
      instructions = godel_numbers.map { |number| decode_single_instruction(number) }
      machine = Machine.new(0) # Создаем машину с 0 входными регистрами
      instructions.each { |instruction| machine.add(instruction) }
      machine
    end

    def self.extract_exponents(godel_number)
      exponents = []
      prime_enum = Prime.each

      loop do
        prime = prime_enum.next
        exponent = 0

        while (godel_number % prime).zero?
          godel_number /= prime
          exponent += 1
        end

        exponents << (exponent - 1)
        break if godel_number == 1
      end

      exponents
    end

    def self.decode_set(label, exponents)
      Instruction.set(label, exponents[2], exponents[3])
    end

    def self.decode_inc(label, exponents)
      Instruction.inc(label, exponents[2])
    end

    def self.decode_dec(label, exponents)
      Instruction.dec(label, exponents[2])
    end

    def self.decode_if(label, exponents)
      Instruction.if(label, exponents[2], exponents[3], exponents[4])
    end

    def self.decode_stop(label)
      Instruction.stop(label)
    end
  end
end
