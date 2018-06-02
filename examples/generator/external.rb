require 'forwardable'
require_relative '../../../HyperTensioN/examples/experiments/Protection'
require_relative '../../../HyperTensioN/examples/experiments/Function'

module Generator
  prepend Protection
  include Continuous

  def problem(state, *args)
    state[:function] = {
      ['fuellevel', 'gen'] => 1000 - state['available'].size * 20,
      ['capacity', 'gen'] => 1000
    }
    state[:continuous] = []
    super(state, *args)
  end

  def identity(t)
    t
  end

  def double(t)
    t * 2
  end
end

module External
  extend self
  extend Forwardable

  def_delegators Generator, :protect, :unprotect, :function, :assign, :increase, :decrease, :scale_up, :scale_down, :activate

  def time(t, min = 0, max = Float::INFINITY, epsilon = 1)
    min.step(max, epsilon) {|i|
      t.replace(i.to_s)
      yield
    }
  end
end