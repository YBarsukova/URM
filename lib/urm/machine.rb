# frozen_string_literal: true

require "instruction"

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
    # @param instruction [Urm::Instruction] The instruction to add
    def add(instruction)
      @instructions << instruction
    end

    # Sets the input values for the machine
    #
    # @param inputs [Array<Integer>] The input values

  end
end
