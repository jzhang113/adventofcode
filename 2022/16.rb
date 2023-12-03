# frozen_string_literal: true

require_relative '../lib/base_solution'
require_relative '../lib/input'

class Solution < BaseSolution
  include Input

  EXCLUDED_INSTANCE_VARS << 'memo'

  def parse_input
    valves = {}

    input.each do |lines|
      parts = lines.split
      flow = parts[4][5..-2].to_i
      exits = parts[9..].map { |label| label.gsub(',', '') }

      valves[parts[1]] = { flow: flow, exits: exits }
    end

    valves
  end

  def dfs(node, graph, steps, opened, &block)
    cur_time = steps.reduce(0) { |sum, v| sum + v[1] + 1 }
    return 0 if cur_time > 30

    @memo[cur_time][node] = {} if @memo[cur_time][node].nil?

    return @memo[cur_time][node][opened] if @memo[cur_time][node][opened].present?

    exits = graph[node][:exits]
    max_cost = 0
    exits.each do |e, v|
      new_steps = [*steps, [node, v]]
      new_opened = opened.dup.add(e)

      cost = block.call(steps) + dfs(e, graph, new_steps, new_opened, &block)
      max_cost = cost if cost > max_cost
    end

    @memo[cur_time][node][opened] = max_cost
  end

  def dfs2(node, node2, graph, steps, steps2, opened, &block)
    cur_time = steps.reduce(0) { |sum, v| sum + v[1] + 1 }
    ele_cur_time = steps2.reduce(0) { |sum, v| sum + v[1] + 1 }
    return 0 if cur_time > 26 || ele_cur_time > 26

    @memo[cur_time][node] = {} if @memo[cur_time][node].nil?

    @memo[cur_time][node][node2] = {} if @memo[cur_time][node][node2].nil?

    return @memo[cur_time][node][node2][opened] if @memo[cur_time][node][node2][opened].present?

    exits = graph[node][:exits]
    exits2 = graph[node2][:exits]
    max_cost = 0

    exits.each do |e, v|
      new_steps = [*steps, [node, v]]
      new_opened = opened.dup.add(e)

      cost = block.call(steps) + dfs(e, graph, new_steps, new_opened, &block) + dfs2()
      max_cost = cost if cost > max_cost
    end

    @memo[cur_time][node][opened] = max_cost
  end

  def path_length(from, to, graph)
    queue = [[from, 0]]
    visited = graph.to_h { |k, _| [k, false] }

    until queue.empty?
      current, len = queue.shift
      # p "#{current} #{len}"
      return len if current == to
      next if visited[current]

      visited[current] = true

      graph[current][:exits].each { |node| queue.push([node, len + 1]) }
    end
  end

  def before_block
    @graph = parse_input
    significant = @graph.filter { |_, node| node[:flow] != 0 }.keys
    @sig_graph = significant.to_h { |lbl| [lbl, { flow: @graph[lbl][:flow], :exits => {} }] }

    combos = significant.combination(2).to_a
    combos.each do |from, to|
      @sig_graph[from][:exits][to] = path_length(from, to, @graph)
      @sig_graph[to][:exits][from] = path_length(to, from, @graph)
    end
  end

  def part1
    @count = 0
    max_flow = 0
    left_over = 0

    @memo = Array.new(50) { {} }

    dfs 'PL', @sig_graph, ['PL', 0], Set.new do |nodes|
      @count += 1
      # p nodes
      flow = 0
      time = 30

      nodes.each do |node, cost|
        break if time < cost

        time -= cost + 1
        flow += @graph[node][:flow] * time

        if flow > max_flow
          max_flow = flow
          left_over = time
        end
      end

      flow
    end

    @memo[0]
  end

  def part2
    max_flow = 0

    # @memo = Array.new(50) { {} }

    dfs 'PL', @sig_graph, [['PL', 0]], Set.new do |nodes|
      flow = 0
      time = 30
      time2 = 30

      nodes.each do |node, cost|
        break if time < cost

        time -= cost + 1
        flow += @graph[node][:flow] * time

        if flow > max_flow
          max_flow = flow
          left_over = time
        end
      end

      flow
    end

    max_flow
  end
end

Solution.new.run
