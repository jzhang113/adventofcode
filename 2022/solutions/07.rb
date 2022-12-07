# frozen_string_literal: true

require_relative './base_solution'
require_relative '../input'

class FileNode
  include Enumerable

  DIR_TYPE = 'dir'
  FILE_TYPE = 'file'

  attr_accessor :type, :name, :size, :parent, :children

  def initialize(type, name, size, parent = nil)
    @type = type
    @name = name
    @size = size
    @parent = parent
    @children = []
  end

  def each(&block)
    block.call(self)
    children.each { |node| node.each(&block) }
  end
end

class Solution < BaseSolution
  include Input

  def build_file_structure
    # assume first command is cd /
    @root = FileNode.new(FileNode::DIR_TYPE, '/', 0)
    current = @root

    input.drop(1).each do |line|
      parts = line.split

      if parts[0] == '$'
        # commands
        case parts[1]
        when 'cd'
          # puts "cd to #{parts[2]}"
          current =
            if parts[2] == '..'
              current.parent
            else
              current.children.find { |node| node.name == parts[2] }
            end
        end
      else
        # output, assumed to be ls
        current.children <<
          if parts[0] == FileNode::DIR_TYPE
            FileNode.new(FileNode::DIR_TYPE, parts[1], 0, current)
          else
            FileNode.new(FileNode::FILE_TYPE, parts[1], parts[0].to_i, current)
          end
      end
    end
  end

  def calc_dir_size(root)
    return root.size if root.type == FileNode::FILE_TYPE

    total_size = 0

    root.children.each do |node|
      total_size +=
        if node.type == FileNode::FILE_TYPE
          node.size
        else
          calc_dir_size(node)
        end
    end

    root.size = total_size
  end

  def before_block
    EXCLUDED_INSTANCE_VARS << 'root'

    build_file_structure
    calc_dir_size(@root)
  end

  def part1
    @root
      .filter { |node| node.type == FileNode::DIR_TYPE && node.size < 100_000 }
      .map(&:size)
      .sum
  end

  def part2
    system_size = 70_000_000
    min_size = 30_000_000
    remaining_size = system_size - @root.size
    free_size = min_size - remaining_size

    @root
      .filter { |node| node.size >= free_size }
      .map(&:size)
      .min
  end
end

Solution.new.run
