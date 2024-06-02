# frozen_string_literal: true

require "urm/instruction"
require "urm/exceptions"

module Urm
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
    # @param instruction [Urm::Instruction, String] The instruction to add
    def add(instruction)
      instruction =
        case instruction
        when String
          Urm::Instruction.parse(instruction)
        else
          instruction
        end
      @instructions[instruction.label - 1] = instruction
    end

    # Adds an array of instructions to the machine
    #
    # @param instructions [Array<Urm::Instruction, String>] The array of instructions to add
    def add_all(instructions)
      instructions.each do |instruction|
        add(instruction)
      end
    end

    # Validates the instructions to ensure there are no references to non-existent labels
    # and there is exactly one stop instruction.
    def validate_instructions
      labels = collect_labels
      validate_labels(labels)
      validate_stop_instructions
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

        if instruction.nil?
          pc += 1
          next
        end

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
    class << self
      private

      def collect_labels
        @instructions.compact.select { |instr| instr.type == :if }
                     .flat_map { |instr| [instr.label_true, instr.label_false] }
      end

      def validate_labels(labels)
        max_valid_label = @instructions.compact.size
        labels.each do |label|
          next if label.positive? && (label <= max_valid_label || label == max_valid_label + 1)

          raise InvalidLabel, "Instruction references a non-existent label: #{label}"
        end
      end

      def validate_stop_instructions
        stop_count = @instructions.compact.count { |instr| instr.type == :stop }

        raise MultipleStopsError, "There are multiple stop instructions" if stop_count > 1

        return unless stop_count.zero?

        @instructions[@instructions.compact.size] = Urm::Instruction.stop(@instructions.compact.size + 1)
      end
    end
  end
end
