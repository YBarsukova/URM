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

  # Создание инструкций
  inst1 = Urm::Instruction.set(2, 3)
  inst2 = Urm::Instruction.inc(2)
  inst3 = Urm::Instruction.dec(3)
  inst4 = Urm::Instruction.if(2, 3, 4)
  inst5 = Urm::Instruction.stop

  # Преобразование инструкций в строки
  puts inst1  # => "x2 = 3"
  puts inst2  # => "x2 = x2 + 1"
  puts inst3  # => "x3 = x3 - 1"
  puts inst4  # => "if x2 == 0 goto 3 else goto 4"
  puts inst5  # => "stop"

  # Создание машины с 2 входными параметрами
  machine = Urm::Machine.new(2)
  machine.add(Urm::Instruction.set(3, 15))      # x3 = 15
  machine.add(Urm::Instruction.inc(3))          # x3 = x3 + 1
  machine.add(Urm::Instruction.dec(3))     # x3 = x3 - 1
  machine.add(Urm::Instruction.if(3, 4, 5))     # if x3 = 0 goto 4 else goto 5
  machine.add(Urm::Instruction.stop)            # stop

  # Печатаем текущие состояния регистров и инструкции
  puts "Registers: #{machine.registers.inspect}"
  puts "Instructions: "
  machine.instructions.each_with_index do |instr, index|
    puts "#{index + 1}: #{instr}"
  end
end
