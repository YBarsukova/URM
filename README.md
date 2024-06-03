# About URM Gem

This gem is designed for convenient and fast construction and verification of URM - Unbounded Register Machines. It will be especially useful for students studying algorithm theory.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add mmcs_urm

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install mmcs_urm

## Usage

### Instructions

You can instantiate URM instructions of 5 primitive types and 1 advanced type. It is possible to create them manually or using string parsing.

Please note that `<-` and `=` from common URM syntax are replaced with `=` and `==` for better code readability.

```ruby
require "urm/instruction"

set_instruction = Urm::Instruction.set(1, 1, 42)    # 1. x1 = 42
inc_instruction = Urm::Instruction.inc(2, 1)        # 2. x1 = x1 + 1
dec_instruction = Urm::Instruction.dec(3, 2)        # 3. x2 = x2 - 1
if_instruction = Urm::Instruction.if(4, 2, 2, 5)    # 4. if x2 == 0 goto 2 else goto 5
stop_instruction = Urm::Instruction.stop(5)         # 5. stop

copy_instruction = Urm::Instruction.copy(6, 2, 3)    # 6. x2 = x3.
# Note that this instruction is not basic and thus cannot be coded or decoded via our Coder class methods
```

Alternatively, you can use string parsing:

```ruby
require "urm/instruction"

set_instruction = Urm::Instruction.parse("1. x1 = 42")
inc_instruction = Urm::Instruction.parse("2. x1 = x1 + 1")
dec_instruction = Urm::Instruction.parse("3. x2 = x2 - 1")
if_instruction = Urm::Instruction.parse("4. if x2 == 0 goto 2 else goto 5")
stop_instruction = Urm::Instruction.parse("5. stop")
```

Instructions can also be converted into strings using the `.to_s` method:

```ruby
inst = Urm::Instruction.if(1, 2, 3, 4)         # inst.to_s => "1. if x2 == 0 goto 3 else goto 4"
```

There are some strict rules about initializing an instruction. If not followed, errors can occur:
* Register indexes must be positive integers (note that `x1` is always the only output register)
* Instruction labels must be positive integers
* URM only works with non-negative integers, so keep that in mind when using the `set` instruction
* You can only check if a register equals zero in the `if` instruction, not any other integer or another register

Here are some examples of incorrect instruction instantiations:

```ruby
inst = Urm::Instruction.parse("1. if x0 == 0 goto 3 else goto 4")  # Invalid: x0 is not a valid register
inst = Urm::Instruction.parse("0. x3 = x3 - 1")                    # Invalid: Label 0 is not allowed
inst = Urm::Instruction.parse("2. if x1 == 1 goto 3 else goto 4")  # Invalid: Checking if x1 == 1 is not allowed
```


### Machines

You can instantiate a URM machine by specifying the number of input registers it will have:

```ruby
multiplication_machine = Urm::Machine.new(2)  # Creating a machine for evaluating the binary function f(x, y) = x * y
```

Initially, the machine is empty, and running it will do nothing. Next, you need to add a series of URM instructions to your machine. You can do this in multiple ways:

```ruby
require "urm/machine"
require "urm/instruction"

simple_machine = Urm::Machine.new(2)

# You can instantiate each instruction (via parsing or manually) and add it to the machine's instruction pool using the .add method

set_instruction =  Urm::Instruction.parse("1. x1 = 42")
inc_instruction =  Urm::Instruction.parse("2. x1 = x1 + 1")
dec_instruction =  Urm::Instruction.parse("3. x2 = x2 - 1")
if_instruction =   Urm::Instruction.parse("4. if x2 == 0 goto 2 else goto 5")
stop_instruction = Urm::Instruction.parse("5. stop")

simple_machine.add(set_instruction)
simple_machine.add(inc_instruction)
simple_machine.add(dec_instruction)
simple_machine.add(if_instruction)
simple_machine.add(stop_instruction)  # Note: If you forget to add the stop instruction, it will be automatically added before running.
```

Alternatively, you can use the `.add_all()` method to pass an array of instructions or strings (which will be parsed into instructions as shown above):

```ruby
require "urm/machine"

simple_machine = Urm::Machine.new(2)

instructions = [
  "1. x1 = 42",
  "2. x1 = x1 + 1",
  "3. x2 = x2 - 1",
  "4. if x2 == 0 goto 2 else goto 5",
  "5. stop"
]

simple_machine.add_all(instructions)
```

Now, if you've done everything correctly, you are ready to run your URM and see the results.

### Running

The example below demonstrates the creation of a URM that evaluates the binary function f(x, y) = x * y. The URM is normalized so that `x` will be stored in `x2`, `y` in `x3`, and the result will be stored in `x1`.

```ruby
require "urm/machine"

multiplication_machine = Urm::Machine.new(2)

multiplication_instructions = [
  "1. if x3 == 0 goto 9 else goto 2",
  "2. x3 = x3 - 1",
  "3. x4 = x2",
  "4. if x4 == 0 goto 8 else goto 5",
  "5. x1 = x1 + 1",
  "6. x4 = x4 - 1",
  "7. if x4 == 0 goto 8 else goto 5",
  "8. if x3 == 0 goto 9 else goto 2",
  "9. stop"
]

multiplication_machine.add_all(multiplication_instructions)
```

You can run the machine in two different ways. The `.run()` method takes input values for `x2` and `x3`, starts the computation, and returns the result (which will be stored in `x1`):

```ruby
result = multiplication_machine.run(2, 3)    # result = 2 * 3
```

Or, you can print the result to the console using the `run_and_print()` method:

```ruby
multiplication_machine.run_and_print(2, 3)   # prints result
```

### Auto-testing

There are situations where you want to check whether your URM computes the function correctly on multiple inputs. You can use the `MachineTester` class for that purpose. It has two useful methods that allow you to ensure your URM works as intended. Imagine we have the following machine prepared for testing. It evaluates `f(x, y) = floor(x / y)` for any positive `x` and `y`.

```ruby
require "urm/machine"

division_machine = Urm::Machine.new(2)

division_instructions = [
  "1. if x2 == 0 goto 10 else goto 2",
  "2. x4 = x3",
  "3. x2 = x2 - 1",
  "4. x4 = x4 - 1",
  "5. if x2 == 0 goto 6 else goto 7",
  "6. if x4 == 0 goto 8 else goto 10",
  "7. if x4 == 0 goto 8 else goto 3",
  "8. x1 = x1 + 1",
  "9. if x2 == 0 goto 10 else goto 2",
  "10. stop"
]

division_machine.add_all(division_instructions)
```

You can test how it works on a single input or a range of inputs using the `assert()` and `assert_range()` methods of the `MachineTester` class. \
`assert()` accepts the machine, expected output, and input values. \
`assert_range()` accepts a machine, the bottom and top range for input variable borders, and a lambda function for comparing the results.

Here is an example:

```ruby
require "urm/machine_tester"

does_it_work = MachineTester.assert(division_machine, 2, 7, 3) 
# returns true if division_machine.run(7, 3) == 2

does_it_work = MachineTester.assert_range(division_machine, 1, 100, ->(x, y) { x / y }) 
# returns true if run(x, y) == floor(x / y) for all combinations of x and y in the 1..100 range (1 and 100 are included)
```


### Encoding and Decoding

The `Coder` class allows you to encode and decode URM instructions and entire machines using Gödel numbering. This is useful for converting instructions and machines into unique numerical representations and back.

Here’s how you can use it:

#### Encoding

You can encode an integer sequence, a single instruction or an entire machine using the `Coder` class.

```ruby
require "urm/coder"
require "urm/instruction"
require "urm/machine"

# Encode an integer sequence
code = Urm::Coder.godel_code([4, 4, 2, 2, 5])    #code = 2^(5) * 3^(5) * 5^(3) * 7^(3) * 11^(6)

# Encode a single instruction
instruction = Urm::Instruction.parse("1. x1 = 4")
code = Urm::Coder.code_single_instruction(instruction)    #code = 2^(2) * 3^(2) * 5^(2) * 7^(5)

# Encode an entire machine
machine = Urm::Machine.new(2)
instructions = [
  "1. x1 = 4",
  "2. x1 = x1 + 1",
  "3. x2 = x2 - 1",
  "4. if x2 == 0 goto 2 else goto 5",
  "5. stop"
]
machine.add_all(instructions)
encoded_machine = Urm::Coder.code_machine(machine)    #encoded_machine = [code1, code2, ... code5]
```

#### Decoding

Similarly, you can decode an encoded instruction back into itself or an array of encoded instructions back into a machine.

```ruby
require "urm/coder"
require "urm/instruction"
require "urm/machine"

# Decode a single instruction
encoded_instruction = 10147085071200
instruction = Urm::Coder.decode_single_instruction(encoded_instruction)
puts instruction.to_s  # Outputs the string representation of the instruction

# Decode an entire machine
encoded_machine = [308700, 26575698996000, 16200, 15552]
decoded_machine = Urm::Coder.decode_machine(encoded_machine)
decoded_machine.instructions.each do |instr|
  puts instr.to_s if instr  # Outputs the string representation of each instruction
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/YBarsukova/URM. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/YBarsukova/URM/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the DemoGem project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/YBarsukova/URM/blob/master/CODE_OF_CONDUCT.md).
