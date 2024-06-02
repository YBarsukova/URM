# frozen_string_literal: true

require "urm/version"
require "urm/instruction"
require "urm/machine"
require "urm/machine_tester"

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

  # Машина для умножения
  machine = Urm::Machine.new(2)

  multiplication_instructions = [
    "if x3 == 0 goto 9 else goto 2",  # if x3 == 0 goto 9 else 2
    "x3 = x3 - 1",                    # x3 = x3 - 1
    "x4 = x2",                        # x4 = x2
    "if x4 == 0 goto 8 else goto 5",  # if x4 == 0 goto 8 else 5
    "x1 = x1 + 1",                    # x1 = x1 + 1
    "x4 = x4 - 1",                    # x4 = x4 - 1
    "if x4 == 0 goto 8 else goto 5",  # if x4 == 0 goto 8 else 5
    "if x3 == 0 goto 9 else goto 2",  # if x3 == 0 goto 9 else 2
    "stop"                            # stop
  ]

  # Добавляем массив строк с парсингом
  machine.add_all(multiplication_instructions)

  MachineTester.assert_range(machine, 0, 100, ->(x,y){x*y})

  # (0..100).each do |i|
  #   (0..100).each do |j|
  #     expected_output = i * j
  #     output = machine.run(i, j)
  #     puts "Test failed for input #{i}, #{j}: expected #{expected_output}, got #{output}" if output != expected_output
  #   end
  # end

  # Машина для деления
  machine = Urm::Machine.new(2)

  division_instructions = [
    Urm::Instruction.if(2, 10, 2),     # if x2 == 0 goto 10 else 2
    Urm::Instruction.copy(4, 3),       # x4 = x3
    Urm::Instruction.dec(2),           # x2 = x2 - 1
    Urm::Instruction.dec(4),           # x4 = x4 - 1
    Urm::Instruction.if(2, 6, 7),      # if x2 == 0 goto 6 else 7
    Urm::Instruction.if(4, 8, 10),     # if x4 == 0 goto 8 else 10
    Urm::Instruction.if(4, 8, 3),      # if x4 == 0 goto 8 else 3
    Urm::Instruction.inc(1),           # x1 = x1 + 1
    Urm::Instruction.if(2, 10, 2),     # if x2 == 0 goto 10 else 2
    Urm::Instruction.stop              # stop
  ]


  # Добавляем массив инструкций
  machine.add_all(division_instructions)

  MachineTester.assert_range(machine, 1, 100, ->(x,y){x/y})


  # (1..100).each do |i|
  #   (1..100).each do |j|
  #     expected_output = i / j
  #     output = machine.run(i, j)
  #     puts "Test failed for input #{i}, #{j}: expected #{expected_output}, got #{output}" if output != expected_output
  #   end
  # end
end



