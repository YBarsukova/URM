# frozen_string_literal: true

require_relative "urm/version"
require_relative "urm/instruction"

module Urm
  class Error < StandardError; end
  # Создание инструкций
  inst1 = Urm::Instruction.set(2, 3)
  inst2 = Urm::Instruction.inc(2)
  inst3 = Urm::Instruction.dec(3)
  inst4 = Urm::Instruction.if(2, 3, 4)
  inst5 = Urm::Instruction.stop

  # Преобразование инструкций в строки
  puts inst1.to_s  # => "x2 ← 3"
  puts inst2.to_s  # => "x2 ← x2 + 1"
  puts inst3.to_s  # => "x3 ← x3 - 1"
  puts inst4.to_s  # => "if x2 = 0 goto 3 else goto 4"
  puts inst5.to_s  # => "stop"

end
