# frozen_string_literal: true

require_relative '../lib/base_solution'
require_relative '../lib/input'

class Solution < BaseSolution
  include Input

  def part1
    solve(false, %w[2 3 4 5 6 7 8 9 T J Q K A])
  end

  def part2
    solve(true, %w[J 2 3 4 5 6 7 8 9 T Q K A])
  end

  def solve(wildcard, order)
    input.map(&:split)
      .sort { |a, b| compare(a, b, wildcard, order) }
      .each_with_index.reduce(0) do |prev, ((_, bet), rank)|
      prev + (bet.to_i * (rank + 1))
    end
  end

  def compare(a, b, wildcard, order)
    a_hand = a[0]
    b_hand = b[0]
    a_score = score_hand(a_hand, wildcard: wildcard)
    b_score = score_hand(b_hand, wildcard: wildcard)

    return a_score <=> b_score if a_score != b_score

    a_hand.length.times do |i|
      return rank_card(a_hand[i], order) <=> rank_card(b_hand[i], order) if a_hand[i] != b_hand[i]
    end

    0
  end

  def rank_card(card, order)
    order.find_index(card)
  end

  def score_hand(cards, wildcard: false)
    return 6 if cards == 'JJJJJ'

    card_set = count_items(cards.chars)

    if wildcard && card_set['J'].present?
      jokers = card_set.delete('J')
      max_item = card_set.max_by { |_, v| v }[0]
      card_set[max_item] += jokers
    end

    card_counts = card_set.values.sort.reverse
    if card_counts.max == 5
      6
    elsif card_counts.max == 4
      5
    elsif card_counts[0] == 3 && card_counts[1] == 2
      4
    elsif card_counts.max == 3
      3
    elsif card_counts[0] == 2 && card_counts[1] == 2
      2
    elsif card_counts.max == 2
      1
    else
      0
    end
  end

  def count_items(items)
    dict = {}

    items.each do |item|
      if dict[item].nil?
        dict[item] = 1
      else
        dict[item] += 1
      end
    end

    dict
  end
end

Solution.new.run
