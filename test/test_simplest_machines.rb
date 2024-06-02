# frozen_string_literal: true

require "minitest/autorun"
require "urm/machine"
require "urm/instruction"
require "urm/exceptions"
require "urm/machine_tester"

# Tests for simplest URMs executing
class TestSimplestMachines < Minitest::Test
  def test_empty
    empty_instructions = []

    machine = Urm::Machine.new(1)
    machine.add_all(empty_instructions)

    (0..100).each { |x| assert machine.run(x).zero? }
  end

  def test_only_stop
    empty_instructions = ["1. stop"]

    machine = Urm::Machine.new(0)
    machine.add_all(empty_instructions)

    (0..100).each { |_x| assert machine.run.zero? }
  end

  def test_only_set
    only_set_instructions = [
      "1. x1 = 42",
      "2. stop"
    ]

    machine = Urm::Machine.new(1)
    machine.add_all(only_set_instructions)

    (0..100).each { |x| assert_equal machine.run(x), 42 }
  end

  def test_always3
    always_3_instructions = [
      "1. x1 = x1 + 1",
      "2. if x1 == 0 goto 1 else goto 3",
      "3. x1 = 3",
      "4. stop"
    ]

    machine = Urm::Machine.new(1)
    machine.add_all(always_3_instructions)

    (0..100).each { |x| assert_equal machine.run(x), 3 }
  end

  def test_always4
    always_4_instructions = [
      "1. if x1 == 0 goto 2 else goto 4",
      "2. x1 = x1 + 1",
      "3. x1 = x1 + 1",
      "4. if x1 == 0 goto 2 else goto 5",
      "5. x1 = x1 + 1",
      "6. x1 = x1 + 1",
      "7. stop"
    ]

    machine = Urm::Machine.new(2)
    machine.add_all(always_4_instructions)

    (0..100).each { |x| assert_equal machine.run(x, x), 4 }
  end

  def test_always1
    always_1_instructions = [
      "1. x1 = x1 + 1",
      "2. x1 = x1 + 1",
      "3. if x1 == 0 goto 1 else goto 4",
      "4. x1 = x1 - 1",
      "5. stop"
    ]

    machine = Urm::Machine.new(0)
    machine.add_all(always_1_instructions)

    (0..100).each { |_x| assert_equal machine.run, 1 }
  end

  def test_identical
    identical_instructions = [
      "1. if x2 == 0 goto 5 else goto 2",
      "2. x1 = x1 + 1",
      "3. x2 = x2 - 1",
      "4. if x2 == 0 goto 5 else goto 2",
      "5. stop"
    ]

    machine = Urm::Machine.new(1)
    machine.add_all(identical_instructions)

    (0..100).each { |x| assert_equal machine.run(x), x }
  end

  def test_inc
    inc_instructions = [
      "1. if x1 == 0 goto 2 else goto 3",
      "2. x1 = 1",
      "3. if x2 == 0 goto 7 else goto 4",
      "4. x1 = x1 + 1",
      "5. x2 = x2 - 1",
      "6. if x2 == 0 goto 7 else goto 4",
      "7. stop"
    ]

    machine = Urm::Machine.new(1)
    machine.add_all(inc_instructions)

    (0..100).each { |x| assert_equal machine.run(x), x + 1 }
  end

  def test_useless_input
    useless_instructions = [
      "1. x1 = 1",
      "2. if x2 == 0 goto 3 else goto 5",
      "3. x2 = x2 + 1",
      "4. x2 = x2 - 1",
      "5. stop"
    ]

    machine = Urm::Machine.new(1)
    machine.add_all(useless_instructions)

    (0..100).each { |x| assert_equal machine.run(x), 1 }
  end

  def test_bigger_useless_input
    bigger_useless_instructions = [
      "1. if x2 == 0 goto 2 else goto 3",
      "2. if x3 == 0 goto 3 else goto 4",
      "3. x2 = x2 + 1",
      "4. x1 = 3",
      "5. stop"
    ]

    machine = Urm::Machine.new(2)
    machine.add_all(bigger_useless_instructions)

    (0..100).each { |x| (0..100).each { |y| assert_equal machine.run(x, y), 3 } }
  end
end
