# frozen_string_literal: true

# Array-based min-heap
# Each element should have the form [priority, data]
class MinHeap
  def initialize
    @heap = []
    @key_map = {}
  end

  # Add an item containing [priority, data] to the heap
  def insert(priority, data)
    @heap.push([priority, data])
    @key_map[data] = @heap.length - 1
    up_heap(@heap.length - 1)
  end

  # Pop the root of the heap (which has the smallest priority)
  def extract
    return nil if @heap.empty?

    root = @heap[0]
    @key_map.delete(root[1])

    if @heap.length > 1
      # Replace the root with the last element and down_heap to restore the heap property
      @heap[0] = @heap.pop
      @key_map[@heap[0][1]] = 0
      down_heap(0)
    else
      @heap.pop
    end

    root
  end

  # Update the priority of an element in the heap to a lower value
  def decrease_key(data, new_val)
    idx = @key_map[data]

    return if idx.nil?
    raise 'decrease_key should not set the priority to a higher value' if new_val > @heap[idx][0]

    @heap[idx] = [new_val, data]
    up_heap(idx)
  end

  def empty?
    @heap.empty?
  end

  private

  # Index of the left child of a given node in the heap
  def left(idx)
    2 * idx + 1
  end

  # Index of the right child of a given node in the heap
  def right(idx)
    2 * idx + 2
  end

  # Index of the parent of a given node in the heap
  def parent(idx)
    (idx - 1) / 2
  end

  # Swap the position of two items in the heap
  def swap(i, j)
    @heap[i], @heap[j] = @heap[j], @heap[i]
    @key_map[@heap[i][1]] = i
    @key_map[@heap[j][1]] = j
  end

  # Swap a node up if it is smaller than its parent
  def up_heap(idx)
    loop do
      # Nothing to do if its already the root
      return if idx.zero?

      parent = parent(idx)

      # If the parent is smaller than the node, the heap property is satisfied
      return if @heap[parent][0] < @heap[idx][0]

      # Otherwise, swap with the parent to restore the heap property and check again
      swap(idx, parent)
      idx = parent
    end
  end

  # Swap a node down if it is larger than its children
  def down_heap(idx)
    loop do
      left = left(idx)
      right = right(idx)
      smallest = idx

      smallest = left if left < @heap.length && @heap[left][0] < @heap[smallest][0]
      smallest = right if right < @heap.length && @heap[right][0] < @heap[smallest][0]

      # If the node is smaller than both its children, the heap property is satisfied
      return if smallest == idx

      # Otherwise, swap with the smaller child to restore the heap property and check again
      swap(idx, smallest)
      idx = smallest
    end
  end
end
