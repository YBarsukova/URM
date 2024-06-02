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
  multiplication_machine = Urm::Machine.new(2)

  multiplication_instructions = [
    "1. if x3 == 0 goto 9 else goto 2",  # if x3 == 0 goto 9 else 2
    "2. x3 = x3 - 1",                    # x3 = x3 - 1
    "3. x4 = x2",                        # x4 = x2
    "4. if x4 == 0 goto 8 else goto 5",  # if x4 == 0 goto 8 else 5
    "5. x1 = x1 + 1",                    # x1 = x1 + 1
    "6. x4 = x4 - 1",                    # x4 = x4 - 1
    "7. if x4 == 0 goto 8 else goto 5",  # if x4 == 0 goto 8 else 5
    "8. if x3 == 0 goto 9 else goto 2",  # if x3 == 0 goto 9 else 2
    "9. stop"                            # stop
  ]

  # Добавляем массив строк с парсингом
  multiplication_machine.add_all(multiplication_instructions)

  MachineTester.assert_range(multiplication_machine, 0, 100, ->(x, y) { x * y })

  # Машина для деления
  division_machine = Urm::Machine.new(2)

  division_instructions = [
    Urm::Instruction.if(1, 2, 10, 2),     # 1. if x2 == 0 goto 10 else 2
    Urm::Instruction.copy(2, 4, 3),       # 2. x4 = x3
    Urm::Instruction.dec(3, 2),           # 3. x2 = x2 - 1
    Urm::Instruction.dec(4, 4),           # 4. x4 = x4 - 1
    Urm::Instruction.if(5, 2, 6, 7),      # 5. if x2 == 0 goto 6 else 7
    Urm::Instruction.if(6, 4, 8, 10),     # 6. if x4 == 0 goto 8 else 10
    Urm::Instruction.if(7, 4, 8, 3),      # 7. if x4 == 0 goto 8 else 3
    Urm::Instruction.inc(8, 1),           # 8. x1 = x1 + 1
    Urm::Instruction.if(9, 2, 10, 2),     # 9. if x2 == 0 goto 10 else 2
    Urm::Instruction.stop(10)             # 10. stop
  ]

  # Добавляем массив инструкций
  division_machine.add_all(division_instructions)

  MachineTester.assert_range(division_machine, 1, 100, ->(x, y) { x / y })
end
