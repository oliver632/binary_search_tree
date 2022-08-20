class Node
  include Comparable

  attr_accessor :data, :left, :right

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end

  # making Comparable work based on data value
  def <=>(other_node)
    @data <=> other_node.data
  end
end

class Tree

  attr_accessor :root

  def initialize(array)
    @array = array
    @root = build_tree(array, 0, @array.length - 1)
  end

  def build_tree(array, start_pos, end_pos)
    # sort and remove duplicates from array
    array = @array.sort.uniq

    # checks if no children
    return nil if start_pos > end_pos

    # find middle position rounded down
    mid_pos = ((start_pos + end_pos) / 2).floor

    root = Node.new(array[mid_pos])
    # recursively make the rest of the tree
    root.left = build_tree(array, start_pos, mid_pos - 1)
    root.right = build_tree(array, mid_pos + 1, end_pos)

    # return 0-level node
    root
  end
end

node1 = Node.new(5)
node2 = Node.new(3)

tree = Tree.new([-50, 1, 2, 3, 4, 5, 7])
p tree.root
