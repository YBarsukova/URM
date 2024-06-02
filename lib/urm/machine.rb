# frozen_string_literal: true

require "urm/instruction"

module Urm
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
