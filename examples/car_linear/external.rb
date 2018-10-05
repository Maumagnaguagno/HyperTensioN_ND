require 'forwardable'
require_relative '../../../HyperTensioN/examples/experiments/Protection'
require_relative '../../../HyperTensioN/examples/experiments/Function'
require_relative '../../../HyperTensioN/examples/experiments/Debug'

module Car_linear
  prepend Protection, Continuous, Debug

  def problem(state, *args)
    function = state[:function] = {}
    state['initial'].each {|f,v| function[f] = v.to_f}
    super(state, *args)
  end

  # (:process displacement :precondition (engine_running) :effect (increase (d) (* #t (v))) )
  def displacement(t)
    d = @state[:function]['d']
    1.upto(t) {|i| d += function('v', i).to_f}
    d
  end

  # (:process moving :precondition (engine_running) :effect (increase (v) (* #t (a))) )
  def moving(t)
    v = @state[:function]['v']
    1.upto(t) {|i| v += function('a', i).to_f}
    v
  end

  def moving_custom(t)
    v = @state[:function]['v']
    a = @state[:function][f = 'a']
    ot = 0
    @state[:event].each {|type,g,value,start|
      if f == g and start <= t
        v += a * (start - ot)
        ot = start
        case type
        when 'increase' then a += value
        when 'decrease' then a -= value
        end
      end
    }
    v + a * (t - ot)
  end
end

module External
  extend self, Forwardable

  def_delegators Car_linear, :protect, :unprotect, :function, :process, :event, :print, :print_state, :breakpoint

  def step(t, min = 0.0, max = Float::INFINITY, epsilon = 1.0)
    min.to_f.step(max.to_f, epsilon.to_f) {|i|
      t.replace(i.to_s)
      yield
    }
  end
end