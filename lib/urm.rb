# frozen_string_literal: true

require "urm/version"
require "urm/instruction"
require "urm/machine"

# The Urm module provides functionality to create and manipulate instructions
# for the Unbounded Register Machine (URM). The URM is a theoretical model used
# in computer science to study the principles of computation and algorithms.
#
# This module includes classes for different types of instructions such as setting
# a register, incrementing a register, decrementing a register, conditional jumps,
# and stopping the machine. It also provides methods to parse instructions from
# strings and convert them back to their string representations.
module Urm
  class Error < StandardError; end

  machine = Urm::Machine.new(2)

  # Добавляем инструкции
  machine.add(Urm::Instruction.set(1, 5))              # x1 = 5
  machine.add(Urm::Instruction.if(2, 6, 3))            # if x2 == 0 goto 6 else 3
  machine.add(Urm::Instruction.dec(1))                 # x1 = x1 - 1
  machine.add(Urm::Instruction.dec(2))                 # x2 = x2 - 1
  machine.add(Urm::Instruction.if(2, 6, 3))            # if x2 == 0 goto 6 else 3
  machine.add(Urm::Instruction.stop)                   # stop

  (1..100).each do |i|
    expected_output = [5 - i, 0].max
    machine.run(i)
    output = machine.registers[1]
    puts "Test failed for input #{i}: expected #{expected_output}, got #{output}" if output != expected_output
  end
end