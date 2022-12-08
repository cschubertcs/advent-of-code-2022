require 'tree'

class NodeContent
    def initialize(type, size)
        @type = type
        @size = size
    end
    attr_accessor :size
    attr_reader :type
end

root = Tree::TreeNode.new("/", NodeContent.new('dir', 0))
current_node = root

File.foreach("input") { |line|
    line = line.strip
    puts(line)
    if line == '$ cd /'
        current_node = root
        next
    end
    if line == '$ cd ..'
        current_node = current_node.parent
        next
    end
    if matches = line.match(/\$ cd (?<dir>\S+)/)
        current_node = current_node.add( Tree::TreeNode.new(matches[:dir], NodeContent.new('dir', 0)) )
        next
    end
    if matches = line.match(/(?<size>\d+) (?<name>\S+)/)
        current_node.add( Tree::TreeNode.new(matches[:name], NodeContent.new('file', Integer(matches[:size]))) )
        next
    end
}

root.postordered_each{ |node|
    puts(node)
    if node.parent
        node.parent.content.size += node.content.size
    end
}

root.print_tree(root.node_depth, nil, lambda { |node, prefix|
    puts("#{prefix} #{node.name} (#{node.content.size})")
})

total_space = 70_000_000
required_space = 30_000_000
used_space = root.content.size

unused_space = total_space-used_space
space_to_delete = required_space-unused_space

min_dir_space = used_space
root.each{|node|
    if node.content.type == 'dir' && node.content.size > space_to_delete
        min_dir_space = [min_dir_space, node.content.size].min
    end
}

puts(min_dir_space) #3842121