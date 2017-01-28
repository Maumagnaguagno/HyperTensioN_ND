# Generated by Hype
require_relative 'disjunction.ujshop'

# Objects
t1 = 't1'
t2 = 't2'
t1000 = 't1000'
t4 = 't4'

Disjunction.problem(
  # Start
  {
    'p' => [
      [t1, t2]
    ],
    'q' => [
      [t1000]
    ],
    'r' => [],
    's' => [
      [t4]
    ],
    'pred' => [
      [t1]
    ],
    'axiom1' => []
  },
  # Tasks
  [
    ['unify', t1]
  ],
  # Debug
  ARGV.first == '-d',
  # Maximum plans found
  ARGV[1] ? ARGV[1].to_i : -1,
  # Minimum probability for plans
  ARGV[2] ? ARGV[2].to_f : 0
)