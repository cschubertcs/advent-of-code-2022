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

limit = 100_000
sum = 0

root.each{ |node|
    if node.content.type == 'dir' && node.content.size < limit
        puts(node)
        sum += node.content.size
    end
}

puts(sum) #1886043