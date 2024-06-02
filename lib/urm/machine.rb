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

    # Runs the machine with the given input values and returns the value of x1
    #
    # @param inputs [Array<Integer>] The input values
    # @return [Integer] The value of x1 after execution
    def run(*inputs)
      validate_instructions
      initialize_registers(inputs)
      execute_instructions
    end

    # Runs the machine with the given input values and prints the value of x1
    #
    # @param inputs [Array<Integer>] The input values
    def run_and_print(*inputs)
      result = run(*inputs)
      puts result
    end

    private

    # Initialize the registers with input values
    #
    # @param inputs [Array<Integer>] The input values
    def initialize_registers(inputs)
      inputs.each_with_index do |value, index|
        @registers[index + 2] = value
      end
      @registers[1] = 0 # Output register starts with 0
    end

    # Execute the instructions loaded into the machine
    #
    # @return [Integer] The value of x1 after execution
    def execute_instructions
      pc = 0 # Program counter starts at 0
      while pc < @instructions.length
        instruction = @instructions[pc]
        if instruction.nil?
          pc += 1
          next
        end
        new_pc = execute_instruction(instruction, pc)
        pc = new_pc.nil? ? pc + 1 : new_pc
      end
      @registers[1]
    end

    # Execute a single instruction
    #
    # @param instruction [Urm::Instruction] The instruction to execute
    # @param counter [Integer] The current program counter
    # @return [Integer, nil] The updated program counter or nil if the pc should just increment
    def execute_instruction(instruction, counter)
      case instruction.type
      when :set
        execute_set(instruction)
      when :inc
        execute_inc(instruction)
      when :dec
        execute_dec(instruction)
      when :if
        return execute_if(instruction)
      when :copy
        execute_copy(instruction)
      when :stop
        return counter + 1 # Stop execution by setting pc beyond the last instruction
      else
        raise "Unknown instruction type: #{instruction.type}"
      end
      nil
    end

    def execute_set(instruction)
      @registers[instruction.register] = instruction.value
    end

    def execute_inc(instruction)
      @registers[instruction.register] += 1
    end

    def execute_dec(instruction)
      @registers[instruction.register] -= 1 if @registers[instruction.register].positive?
    end

    def execute_if(instruction)
      if @registers[instruction.register].zero?
        instruction.label_true - 1
      else
        instruction.label_false - 1
      end
    end

    def execute_copy(instruction)
      @registers[instruction.register] = @registers[instruction.value]
    end

    # Validates the instructions to ensure there are no references to non-existent labels
    # and there is exactly one stop instruction.
    def validate_instructions
      labels = collect_labels
      validate_labels(labels)
      validate_stop_instructions
    end

    # Collects all labels referenced by if instructions
    #
    # @return [Array<Integer>] An array of labels
    def collect_labels
      @instructions.compact.select { |instr| instr.type == :if }
                   .flat_map { |instr| [instr.label_true, instr.label_false] }
    end

    # Validates that all referenced labels exist
    #
    # @param labels [Array<Integer>] An array of labels to validate
    # @return [void]
    def validate_labels(labels)
      max_valid_label = @instructions.compact.size
      labels.each do |label|
        next if label.positive? && (label <= max_valid_label || (label == max_valid_label + 1 && !stop_exists?))

        raise InvalidLabel, "Instruction references a non-existent label: #{label}"
      end
    end

    # Validates that there is exactly one stop instruction
    #
    # @return [void]
    def validate_stop_instructions
      stop_count = @instructions.compact.count { |instr| instr.type == :stop }

      raise MultipleStopsError, "There are multiple stop instructions" if stop_count > 1

      return unless stop_count.zero?

      @instructions[@instructions.compact.size] = Urm::Instruction.stop(@instructions.compact.size + 1)
    end

    def stop_exists?
      @instructions.compact.any? { |instr| instr.type == :stop }
    end
  end
end
