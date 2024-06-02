# frozen_string_literal: true

require "instruction"

module Urm
  class InvalidLabelError < StandardError; end
  class MultipleStopsError < StandardError; end

  # The Machine class represents an Unlimited Register Machine (URM)
  # capable of executing a series of instructions on a set of registers.
  # Machine is initialized with a specified number of input parameters.
  class Machine
    attr_reader :registers, :instructions

    # Initializes a new URM machine with n input parameters
    #
    # @param input_size [Integer] The number of input parameters
    def initialize(input_size)
      @registers = Array.new(input_size + 1, 0)
      @instructions = []
    end

    # Adds an instruction to the machine
    #
    # @param instruction [Urm::Instruction] The instruction to add
    def add(instruction)
      @instructions << instruction
    end

    # Validates the instructions to ensure there are no references to non-existent labels
    # and there is exactly one stop instruction.
    def validate_instructions
      labels = @instructions.select { |instr| instr.type == :if }.flat_map { |instr| [instr.label_true, instr.label_false] }
      stop_count = @instructions.count { |instr| instr.type == :stop }

      max_valid_label = @instructions.size
      labels.each do |label|
        if label <= 0 || (label > max_valid_label && label != max_valid_label + 1)
          raise InvalidLabelError, "Instruction references a non-existent label: #{label}"
        end
      end

      if stop_count > 1
        raise MultipleStopsError, "There are multiple stop instructions"
      elsif stop_count == 0
        @instructions << Urm::Instruction.stop
      end
    end

    # Runs the machine with the given input values and returns the value of x1
    #
    # @param inputs [Array<Integer>] The input values
    # @return [Integer] The value of x1 after execution
    def run(*inputs)
      validate_instructions

      # Initialize registers with input values
      inputs.each_with_index do |value, index|
        @registers[index + 2] = value
      end

      @registers[1] = 0 # Output register starts with 0

      pc = 0 # Program counter starts at 0

      while pc < @instructions.length
        instruction = @instructions[pc]

        case instruction.type
        when :set
          @registers[instruction.register] = instruction.value
        when :inc
          @registers[instruction.register] += 1
        when :dec
          @registers[instruction.register] -= 1 if (@registers[instruction.register]).positive?
        when :if
          pc = if (@registers[instruction.register]).zero?
                 instruction.label_true - 1
               else
                 instruction.label_false - 1
               end
        when :copy
          @registers[instruction.register] = @registers[instruction.value]
        when :stop
          return @registers[1]
        end
        pc += 1 if instruction.type != :if # Only increment pc if it's not an if instruction
      end

      @registers[1]
    end

    # Runs the machine with the given input values and prints the value of x1
    #
    # @param inputs [Array<Integer>] The input values
    def run_and_print(*inputs)
      result = run(*inputs)
      puts result
    end
  end
end
