require '../HyperTensioN/tests/hypest'

class Postulate < Test::Unit::TestCase
  include Hypest

  def test_axiom_pb1_ujshop_parsing
    parser_tests(
      # Files
      'examples/axiom/axiom.ujshop',
      'examples/axiom/pb1.ujshop',
      # Parser and extensions
      UJSHOP_Parser, [],
      # Attributes
      :domain_name => 'axiom',
      :problem_name => 'pb1',
      :operators => [
        ['add-one', ['?current'],
          # Preconditions
          ['and',
            ['empty_axiom', '?current'],
            ['at-axiom', '?current']
          ],
          # Effects
          [['at', ['call', '+', '?current', '1']]],
          [['at', '?current']],
          # Probability
          1
        ]
      ],
      :methods => [],
      :predicates => {'at' => true},
      :state => {'at' => [['0']]},
      :tasks => [true,
        ['add-one', '0'],
        ['add-one', '1'],
        ['add-one', '2']
      ],
      :axioms => [
        ['empty_axiom', ['?parameter0'],
          'negate-empty-list',
          ['not', []]
        ],
        ['at-axiom', ['?parameter0'],
          'numeric-constant',
          ['and',
            ['call', '=', '?parameter0', '0'],
            ['at', '0'],
          ],
          'double-negation',
          ['not', ['not', ['at', '?parameter0']]]
        ]
      ],
      :rewards => [],
      :attachments => []
    )
  end

  def test_axiom_pb1_ujshop_parsing_compile_to_rb
        compiler_tests(
      # Files
      'examples/axiom/axiom.ujshop',
      'examples/axiom/pb1.ujshop',
      # Parser and extensions
      UJSHOP_Parser, [], 'rb',
      # Domain
      "# Generated by Hype
require '#{File.expand_path('../../Hypertension_U', __FILE__)}'
require_relative 'external' if File.exist?(File.expand_path('../external.rb', __FILE__))

module Axiom
  include Hypertension_U
  extend self

  #-----------------------------------------------
  # Domain
  #-----------------------------------------------

  @domain = {
    # Operators
    'add_one' => 1
    # Methods
  }

  #-----------------------------------------------
  # Axioms
  #-----------------------------------------------

  def empty_axiom(parameter0)
    # negate_empty_list
    return true
  end

  def at_axiom(parameter0)
    # numeric_constant
    return true if ((parameter0.to_f == 0.0) and @state['at'].include?(['0.0']))
    # double_negation
    return true if @state['at'].include?([parameter0])
  end

  #-----------------------------------------------
  # Operators
  #-----------------------------------------------

  def add_one(current)
    return unless (empty_axiom(current) and at_axiom(current))
    @state = @state.dup
    (@state['at'] = @state['at'].dup).delete([current])
    @state['at'].unshift([(current.to_f + 1.0).to_s])
  end

  #-----------------------------------------------
  # Methods
  #-----------------------------------------------
end",
      # Problem
      "# Generated by Hype
require_relative 'axiom.ujshop'

# Objects

Axiom.problem(
  # Start
  {
    'at' => [
      ['0.0']
    ]
  },
  # Tasks
  [
    ['add_one', '0.0'],
    ['add_one', '1.0'],
    ['add_one', '2.0']
  ],
  # Debug
  ARGV.first == 'debug',
  # Maximum plans found
  ARGV[1] ? ARGV[1].to_i : -1,
  # Minimum probability for plans
  ARGV[2] ? ARGV[2].to_f : 0
) or abort"
    )
  end
end