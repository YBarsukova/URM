# frozen_string_literal: true

require "urm/exceptions"

module Urm
  # This class represents an instruction for the Unbounded Register Machine (URM).
  # It includes various types of instructions such as setting a register,
  # incrementing a register, decrementing a register, conditional jumps, stop, and copy.
  class Instruction
    attr_reader :type, :register, :value, :label_true, :label_false

    def initialize(type, register: nil, value: nil, label_true: nil, label_false: nil)
      @type = type
      @register = register
      @value = value
      @label_true = label_true
      @label_false = label_false
    end

    def self.set(register, value)
      raise Urm::InvalidRegisterInitialization, "Value cannot be negative" if value.negative?
      raise Urm::InvalidRegisterIndex, "Register index must be positive" if register <= 0

      new(:set, register: register, value: value)
    end

    def self.inc(register)
      raise Urm::InvalidRegisterIndex, "Register index must be positive" if register <= 0

      new(:inc, register: register)
    end

    def self.dec(register)
      raise Urm::InvalidRegisterIndex, "Register index must be positive" if register <= 0

      new(:dec, register: register)
    end

    def self.if(register, label_true, label_false)
      raise Urm::InvalidRegisterIndex, "Register index must be positive" if register <= 0
      raise Urm::InvalidLabel, "Label must be positive" if label_true <= 0 || label_false <= 0

      new(:if, register: register, label_true: label_true, label_false: label_false)
    end

    def self.stop
      new(:stop)
    end

    # For copy instructions index of source register is stored in value field
    def self.copy(register, source_register)
      raise Urm::InvalidRegisterIndex, "Register index must be positive" if register <= 0 || source_register <= 0

      new(:copy, register: register, value: source_register)
    end

    def to_s
      case @type
      when :set
        "x#{@register} = #{@value}"
      when :inc
        "x#{@register} = x#{@register} + 1"
      when :dec
        "x#{@register} = x#{@register} - 1"
      when :if
        "if x#{@register} == 0 goto #{@label_true} else goto #{@label_false}"
      when :stop
        "stop"
      when :copy
        "x#{@register} = x#{@value}"
      else
        raise "Unknown instruction type: #{@type}"
      end
    end

    def self.parse(instruction_str)
      if (match = instruction_str.match(/^x(\d+) = (-?\d+)$/))
        parse_set(match)
      elsif (match = instruction_str.match(/^x(\d+) = x\1 \+ 1$/))
        parse_inc(match)
      elsif (match = instruction_str.match(/^x(\d+) = x\1 - 1$/))
        parse_dec(match)
      elsif (match = instruction_str.match(/^if x(\d+) == 0 goto (\d+) else goto (\d+)$/))
        parse_if(match)
      elsif (match = instruction_str.match(/^x(\d+) = x(\d+)$/))
        parse_copy(match)
      elsif instruction_str == "stop"
        parse_stop
      else
        raise "Unknown instruction format: #{instruction_str}"
      end
    end

    class << self
      private

      def parse_set(match)
        set(match[1].to_i, match[2].to_i)
      end

      def parse_inc(match)
        inc(match[1].to_i)
      end

      def parse_dec(match)
        dec(match[1].to_i)
      end

      def parse_if(match)
        self.if(match[1].to_i, match[2].to_i, match[3].to_i)
      end

      def parse_copy(match)
        copy(match[1].to_i, match[2].to_i)
      end

      def parse_stop
        stop
      end
    end
  end
end
