module UJSHOP_Parser
  extend self

  attr_reader :domain_name, :problem_name, :operators, :methods, :predicates, :state, :tasks, :goal_pos, :goal_not, :axioms, :reward

  NOT = 'not'
  NIL = 'nil'

  #-----------------------------------------------
  # Scan tokens
  #-----------------------------------------------

  def scan_tokens(filename)
    (str = IO.read(filename)).gsub!(/;.*$/,'')
    str.downcase!
    stack = []
    list = []
    str.scan(/[()]|[^\s()]+/) {|t|
      case t
      when '('
        stack << list
        list = []
      when ')'
        stack.empty? ? raise('Missing open parentheses') : list = stack.pop << list
      else list << t
      end
    }
    raise 'Missing close parentheses' unless stack.empty?
    raise 'Malformed expression' if list.size != 1
    list.first
  end

  #-----------------------------------------------
  # Define effects
  #-----------------------------------------------

  def define_effects(name, group)
    raise "Error with #{name} effects" unless group.instance_of?(Array)
    group.each {|pre|
      raise 'Unexpected not in effects' if pre.first == NOT
      @predicates[pre.first.freeze] = true
    }
  end

  #-----------------------------------------------
  # Define expression
  #-----------------------------------------------

  def define_expression(name, group)
    raise "Error with #{name}" unless group.instance_of?(Array)
    group.unshift(first = 'and') if (first = group.first).instance_of?(Array)
    if first == 'and' or first == 'or'
      if group.size == 1
        raise "Unexpected zero arguments for #{first} in #{name}"
      elsif group.size == 2
        define_expression(name, group.replace(group.last))
      else group.drop(1).each {|g| define_expression(name, g)}
      end
    elsif first == 'not'
      raise "Unexpected multiple arguments for not in #{name}" if group.size != 2
      define_expression(name, group.last)
    else @predicates[first.freeze] ||= false
    end
  end

  #-----------------------------------------------
  # Parse operator
  #-----------------------------------------------

  def parse_operator(op)
    op.shift
    raise 'Action without name definition' unless (name = op.first.shift).instance_of?(String)
    name.sub!(/^!!/,'invisible_') or name.sub!(/^!/,'')
    raise "Action #{name} redefined" if @operators.assoc(name)
    raise "Operator #{name} have #{op.size} groups instead of 4 or more" if op.size < 4
    @operators << operator = [name, op.shift, []]
    # Preconditions
    if (group = op.shift) != NIL
      define_expression("#{name} preconditions", operator[2] = group)
    end
    # Effects
    if op.size < 2
      raise "Error with #{name} effects"
    elsif op.size <= 3
      operator[4] = (group = op.shift) != NIL ? define_effects(name, group) : []
      operator[3] = (group = op.shift) != NIL ? define_effects(name, group) : []
      operator << (op.empty? ? 1 : op.shift.to_f)
    else
      i = 0
      until op.empty?
        operator << (op.first.instance_of?(String) ? op.shift : "#{name}_#{i}")
        del = (group = op.shift) != NIL ? define_effects(name, group) : []
        add = (group = op.shift) != NIL ? define_effects(name, group) : []
        operator.push(add, del, op.shift.to_f)
        i += 1
      end
    end
  end

  #-----------------------------------------------
  # Parse method
  #-----------------------------------------------

  def parse_method(met)
    met.shift
    # Method may already have decompositions associated
    name = (group = met.first).shift
    @methods << method = [name, group] unless method = @methods.assoc(name)
    met.shift
    until met.empty?
      # Optional label, add index for the unlabeled cases
      method << [met.first.instance_of?(String) ? met.shift : "#{name}_#{method.size - 2}", free_variables = [], pos = [], neg = []]
      # Preconditions
      if (group = met.shift) != NIL
        raise "Error with #{name} preconditions" unless group.instance_of?(Array)
        group.each {|pre|
          pre.first != NOT ? pos << pre : pre.size == 2 ? neg << (pre = pre.last) : raise("Error with #{name} negative precondition group")
          @predicates[pre.first.freeze] ||= false
          free_variables.concat(pre.select {|i| i.start_with?('?') and not method[1].include?(i)})
        }
        free_variables.uniq!
      end
      # Subtasks
      if (group = met.shift) != NIL
        raise "Error with #{name} subtasks" unless group.instance_of?(Array)
        group.each {|pre| pre.first.sub!(/^!!/,'invisible_') or pre.first.sub!(/^!/,'')}
        method.last << group
      else method.last << []
      end
    end
  end

  #-----------------------------------------------
  # Parse domain
  #-----------------------------------------------

  def parse_domain(domain_filename)
    if (tokens = scan_tokens(domain_filename)).instance_of?(Array) and tokens.shift == 'defdomain'
      @operators = []
      @methods = []
      @axioms = []
      @reward = []
      raise 'Found group instead of domain name' if tokens.first.instance_of?(Array)
      @domain_name = tokens.shift
      @predicates = {}
      raise 'More than one group to define domain content' if tokens.size != 1
      tokens = tokens.shift
      while group = tokens.shift
        case group.first
        when ':operator' then parse_operator(group)
        when ':method' then parse_method(group)
        when ':-'
          group.shift
          name = (params = group.shift).shift
          @axioms << axiom = [name, params] unless axiom = @axioms.assoc(name)
          group.each {|exp| define_expression("axiom #{name}", exp)}
          axiom.concat(group)
        when ':reward'
          group.shift
          @reward = group
        else puts "#{group.first} is not recognized in domain"
        end
      end
    else raise "File #{domain_filename} does not match domain pattern"
    end
  end

  #-----------------------------------------------
  # Parse problem
  #-----------------------------------------------

  def parse_problem(problem_filename)
    if (tokens = scan_tokens(problem_filename)).instance_of?(Array) and tokens.size.between?(5,6) and tokens.shift == 'defproblem'
      @problem_name = tokens.shift
      raise 'Different domain specified in problem file' if @domain_name != tokens.shift
      @state = tokens.shift
      @tasks = tokens.shift
      # Tasks may be ordered or unordered
      @tasks.shift unless order = (@tasks.first != ':unordered')
      @tasks.each {|pre| pre.first.sub!(/^!!/,'invisible_') or pre.first.sub!(/^!/,'')}
      @tasks.unshift(order)
      @goal_pos = []
      @goal_not = []
    else raise "File #{problem_filename} does not match problem pattern"
    end
  end
end