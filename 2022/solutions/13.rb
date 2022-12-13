# frozen_string_literal: true

require_relative './base_solution'
require_relative '../input'

class ArrNum
  attr_accessor :parts

  def initialize(parts = [])
    @parts = parts
  end

  def in_order(other)
    @parts.each_with_index do |part, idx|
      case part
      in Integer => left_int
        case other.parts[idx]
        in nil
          return 1
        in Integer => right_int
          res = left_int <=> right_int
          return res unless res.zero?
        in right_arr
          left = ArrNum.new
          left.parts << left_int
          res = left.in_order(right_arr)
          return res unless res.nil?
        end
      in left_arr
        case other.parts[idx]
        in nil
          return 1
        in Integer => right_int
          right = ArrNum.new
          right.parts << right_int
          res = left_arr.in_order(right)
          return res unless res.nil?
        in right_arr
          res = left_arr.in_order(right_arr)
          return res unless res.nil?
        end
      end
    end

    res = parts.length <=> other.parts.length
    return res unless res.zero?

    nil
  end

  def inspect
    @parts.inspect
  end
end

class Solution < BaseSolution
  include Input

  def parse(str)
    num_stack = []

    str.split('').each_with_index do |char, idx|
      case char
      in '['
        new_top = ArrNum.new
        num_stack.last.parts << new_top unless num_stack.empty?
        num_stack.push(new_top)
      in ']'
        num_stack.pop if num_stack.count > 1
      in ','
      in '0'
        if str[idx - 1] != '1'
          num_stack.last.parts << 0
        else
          num_stack.last.parts << 10
        end
      in '1'
        num_stack.last.parts << 1 if str[idx + 1] != '0'
      in d
        num_stack.last.parts << d.to_i
      end
    end

    num_stack.pop
  end

  def part1
    sum = 0

    input.split('').each_with_index do |pair, idx|
      left = parse(pair[0])
      right = parse(pair[1])
      res = left.in_order right
      sum += (idx + 1) if res == -1
    end

    sum
  end

  def part2
    packets = input.split('').flatten.map { |str| parse(str) }

    placeholder1 = ArrNum.new([ArrNum.new([2])])
    placeholder2 = ArrNum.new([ArrNum.new([6])])

    packets.append(placeholder1, placeholder2)

    sorted = packets.sort { |a, b| a.in_order b }

    prod = []
    sorted.each_with_index do |ln, idx|
      prod << idx + 1 if ln == placeholder1 || ln == placeholder2
    end

    prod.reduce(:*)
  end
end

Solution.new.run
