# frozen_string_literal: true

require "urm/instruction"

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
    # and there is exactly one stop instruction. If there is no stop instruction at the end,
    # it will be automatically added
    def validate_instructions
      labels = @instructions.select { |instr| instr.type == :if }.flat_map { |instr| [instr.label_true, instr.label_false] }
      stop_count = @instructions.count { |instr| instr.type == :stop }

      max_valid_label = @instructions.size
      labels.each do |label|
        if label <= 0 || (label > max_valid_label && label != max_valid_label + 1)
          raise InvalidLabel, "Instruction references a non-existent label: #{label}"
        end
      end

      if stop_count > 1
        raise MultipleStopsError, "There are multiple stop instructions"
      elsif stop_count.zero?
        @instructions << Urm::Instruction.stop
      end
    end

    # Runs the machine with the given input values
    #
    # @param inputs [Array<Integer>] The input values
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
          puts @registers[1]
          return
        end
        pc += 1 if instruction.type != :if # Only increment pc if it's not an if instruction
      end
    end
  end
end

