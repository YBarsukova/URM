# frozen_string_literal: true

module Urm
  class Instruction
    attr_reader :type, :register, :value , :label_true, :label_false

    def initialize(type, register: nil, value: nil, label_true: nil, label_false: nil)
      @type = type
      @register = register
      @value = value
      @label_true = label_true
      @label_false = label_false
    end

    def self.set(register, value)
      new(:set, register: register, value: value)
    end

    def self.inc(register)
      new(:inc, register: register)
    end

    def self.dec(register)
      new(:dec, register: register)
    end

    def self.if(register, label_true, label_false)
      new(:if, register: register, label_true: label_true, label_false: label_false)
    end

    def self.stop
      new(:stop)
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
      else
        raise "Unknown instruction type: #{@type}"
      end
    end

    def self.parse(instruction_str)
      case instruction_str
      when /^x(\d+) ← (\d+)$/
        set($1.to_i, $2.to_i)
      when /^x(\d+) ← x\1 \+ 1$/
        inc($1.to_i)
      when /^x(\d+) ← x\1 - 1$/
        dec($1.to_i)
      when /^if x(\d+) = 0 goto (\d+) else goto (\d+)$/
        self.if($1.to_i, $2.to_i, $3.to_i)
      when /^stop$/
        stop
      else
        raise "Unknown instruction format: #{instruction_str}"
      end
    end

  end
end
