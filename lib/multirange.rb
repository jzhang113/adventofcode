# frozen_string_literal: true

# Helper for treating multiple ranges as a single, possibly disjoint range
class MultiRange
  attr_accessor :ranges

  def initialize(ranges)
    @ranges = ranges.sort_by(&:begin)
  end

  def cover?(value)
    @ranges.any? { |r| r.cover?(value) }
  end

  def count
    @ranges.sum(&:count)
  end

  # Merge all ranges, assuming that the ranges are sorted by their begin values
  # Returns a new MultiRange object
  def merge_overlapping
    current = @ranges.first
    new_ranges = []

    @ranges.drop(1).each do |range|
      new_range = current + range

      if new_range.nil?
        new_ranges << current
        current = range
      else
        current = new_range
      end
    end

    new_ranges << current
    MultiRange.new(new_ranges)
  end

  # Remove a range, potentially splitting a single range into disjoint ranges
  def difference(other)
    new_ranges = []

    @ranges.each do |range|
      if range.end < other.begin || other.end < range.begin
        new_ranges << range
      else
        new_ranges << (range.begin..other.begin) if range.begin < other.begin
        new_ranges << (other.end..range.end) if other.end < range.end
      end
    end

    MultiRange.new(new_ranges)
  end
end
