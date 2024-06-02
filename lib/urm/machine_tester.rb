# frozen_string_literal: true

require "urm/machine"
require "urm/exceptions"

# The MachineTester class provides methods for testing the functionality of an
# Unbounded Register Machine (URM). It includes methods to assert that the machine
# produces expected outputs for given inputs and to validate the machine's outputs
# over a range of input values using a provided lambda function.
#
# Methods:
#
# - self.assert(machine, expected_output, *inputs):
#   Checks that for the given input values, the machine produces the expected output.
#   If the output does not match the expected value, it prints an error message.
#   Returns true if the output matches, false otherwise.
#
# - self.assertRange(machine, a, b, func):
#   Validates that for all combinations of input values within the range [a, b],
#   the machine's output matches the output of the provided lambda function.
#   It handles any number of input parameters for the machine.
#   Returns true if all outputs match, false otherwise.
#
# Example usage:
#
#   machine = Urm::Machine.new(2)
#   multiplication_lambda = ->(x, y) { x * y }
#   MachineTester.assert(machine, 6, 2, 3)  # Asserts that machine.run(2, 3) == 6
#   MachineTester.assertRange(machine, 0, 10, multiplication_lambda)  # Validates for range [0, 10]
#
class MachineTester
  # Проверяет, что на входе х2... х(n+1) машина дает х1
  #
  # @param machine [Urm::Machine] The machine to test
  # @param inputs [Array<Integer>] The input values
  # @param expected_output [Integer] The expected output
  # @return [Boolean] true if the machine's output matches the expected output
  def self.assert(machine, expected_output, *inputs)
    output = machine.run(*inputs)
    if output == expected_output
      true
    else
      puts "Test failed for input #{inputs}: expected #{expected_output}, got #{output}"
      false
    end
  end

  # Проверяет, что на всех наборах входных в диапазоне [a,b] machine.run(эти наборы) = lambda(эти наборы)
  #
  # @param machine [Urm::Machine] The machine to test
  # @param lower_bound [Integer] The start of the range
  # @param upper_bound [Integer] The end of the range
  # @param func [Proc] The lambda function to test against
  # @return [Boolean] true if all outputs match the lambda's outputs
  def self.assert_range(machine, lower_bound, upper_bound, func)
    input_size = machine.registers.size - 1 # учитываем x1, который не является входным

    ranges = Array.new(input_size) { (lower_bound..upper_bound).to_a }
    inputs_list = ranges.first.product(*ranges[1..])

    inputs_list.each do |inputs|
      expected_output = func.call(*inputs)
      return false unless assert(machine, expected_output, *inputs)
    end

    true
  end
end
