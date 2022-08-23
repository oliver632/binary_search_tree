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
    @root = build_tree(array.sort.uniq, 0, @array.length - 1)
  end

  def build_tree(array, start_pos, end_pos)
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

  def insert(data, root = @root)
    return Node.new(data) if root.nil?

    if root.data == data
      return root
    elsif root.data < data
      root.right = insert(data, root.right)
    else
      root.left = insert(data, root.left)
    end

    root
  end

  # deletes a node
  def delete(data, root = @root)
    if root.data == data
      if root.left.nil? && root.right.nil?
        return nil
      elsif root.left.nil? && !root.right.nil?
        return root.right
      elsif !root.left.nil? && root.right.nil?
        return root.left
      elsif !root.left.nil? && !root.right.nil?
        right = root.right
        root = root.left
        root.right = right
        return root
      end
    end

    if root.data < data
      root.right = delete(data, root.right)
    else
      root.left = delete(data, root.left)
    end

    root
  end

  def level_order(&block)
    queue = []
    return if @root.nil?

    queue.append(@root)
    until queue.empty?

      current = queue[0]
      queue.append(current.left) unless current.left.nil?
      queue.append(current.right) unless current.right.nil?
      yield(queue.shift)
    end
  end

  def find(data)
    current = @root
    until data == current.data
      if data > current.data
        current = current.right
      else
        current = current.left
      end
      return nil if current.nil?
    end

    current
  end

  def preorder(root = @root, &block)
    return if root.nil?
    
    yield root
    preorder(root.left, &block)
    preorder(root.right, &block)
  end

  def inorder(root = @root, &block)
    return if root.nil?
    
    inorder(root.left, &block)
    yield root
    inorder(root.right, &block)
  end

  def postorder(root = @root, &block)
    return if root.nil?

    postorder(root.left, &block)
    postorder(root.right, &block)
    yield root
  end

  # returns the height until a leaf node from a given node.
  def height(node, height = 0)
    return height - 1 if node.nil?

    height_left = height(node.left, height + 1)
    height_right = height(node.right, height + 1)

    height_left > height_right ? height_left : height_right
  end

  # returns the depth from the tree root to a given node.
  def depth(node)
    height(@root) - height(node)
  end

  def balanced?(node = @root, height = 0)
    return height - 1 if node.nil?

    height_left = balanced?(node.left, height + 1)
    height_right = balanced?(node.right, height + 1)
    return false if height_left == false || height_right == false
    return false if height_left - height_right > 1
    return false if height_right - height_left > 1

    return true if node == @root
    height_left > height_right ? height_left : height_right
  end

  def rebalance
    all_nodes = []
    inorder{ |node| all_nodes.append(node.data)}
    @root = build_tree(all_nodes.sort.uniq, 0, all_nodes.length-1)
  end
end

node1 = Node.new(5)
node2 = Node.new(3)


array = Array.new(15) {rand(1..100)}.sort.uniq
tree = Tree.new(array)

p tree.balanced?

all_nodes = []
tree.level_order {|node| all_nodes.append(node.data)}
p all_nodes

all_nodes = []
tree.preorder {|node| all_nodes.append(node.data)}
p all_nodes

all_nodes = [] 
tree.postorder {|node| all_nodes.append(node.data)}
p all_nodes

all_nodes = []
tree.inorder {|node| all_nodes.append(node.data)}
p all_nodes

p "Inserting"
tree.insert(101)
tree.insert(102)
tree.insert(103)

p tree.balanced?

tree.rebalance

p tree.balanced?

all_nodes = []
tree.level_order {|node| all_nodes.append(node.data)}
p all_nodes

all_nodes = []
tree.preorder {|node| all_nodes.append(node.data)}
p all_nodes

all_nodes = []
tree.postorder {|node| all_nodes.append(node.data)}
p all_nodes

all_nodes = []
tree.inorder {|node| all_nodes.append(node.data)}
p all_nodes