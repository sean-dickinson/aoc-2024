# Advent of Code 2024

All solutions are in Ruby with tests in the spec folder.

Many thanks to the [Ruby AOC CLI](https://github.com/egiurleo/advent_of_code_cli).

## Differences from the Ruby AOC CLI
- Rather than an "examples" concept, I am generating rspec tests for each day. 
- Inside the spec folder there is a test_inputs directory where you can place the "example" input to reference in your test to do TDD via the example.

# Commands

## Scaffold
The scaffold command will create a spec file, test input file, solution file, and input file for the day specified.
```
bin/aoc_cli scaffold 1
```

## Download
The download command will download the input for the day specified.
```
bin/aoc_cli download 1
```

## Solve
The solve command will run the solution for the day specified using the input file.
```
bin/aoc_cli solve 1
```



