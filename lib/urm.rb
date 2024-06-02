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
  machine.add(Urm::Instruction.if(3, 9, 2))
  machine.add(Urm::Instruction.dec(3))
  machine.add(Urm::Instruction.copy(4, 2))
  machine.add(Urm::Instruction.if(4, 8, 5))
  machine.add(Urm::Instruction.inc(1))
  machine.add(Urm::Instruction.dec(4))
  machine.add(Urm::Instruction.if(4, 8, 5))
  machine.add(Urm::Instruction.if(3, 9, 2))
  machine.add(Urm::Instruction.stop)

  (0..100).each do |i|
    (0..100).each do |j|
      expected_output = i * j
      output = machine.run(i, j)
      puts "Test failed for input #{i}: expected #{expected_output}, got #{output}" if output != expected_output
    end
  end

  machine = Urm::Machine.new(2)

  machine.add(Urm::Instruction.if(2, 10, 2))
  machine.add(Urm::Instruction.copy(4, 3))
  machine.add(Urm::Instruction.dec(2))
  machine.add(Urm::Instruction.dec(4))
  machine.add(Urm::Instruction.if(2, 6, 7))
  machine.add(Urm::Instruction.if(4, 8, 10))
  machine.add(Urm::Instruction.if(4, 8, 3))
  machine.add(Urm::Instruction.inc(1))
  machine.add(Urm::Instruction.if(2, 10, 2))
  # machine.add(Urm::Instruction.stop)

  (1..100).each do |i|
    (1..100).each do |j|
      expected_output = i / j
      output = machine.run(i, j)
      puts "Test failed for input #{i}: expected #{expected_output}, got #{output}" if output != expected_output
    end
  end
end
