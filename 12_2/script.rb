require 'set'

class Node 
    attr_reader :value, :name
    attr_accessor :distance, :previous_node, :top, :right, :bottom, :left, :x, :y
    def initialize(name, value)
        @name = name
        @value = value
        @x = 0
        @y = 0
        @top = nil
        @right = nil
        @bottom = nil
        @left = nil
        @distance = Float::INFINITY
        @previous_node = nil
    end

    def reachable_neighbours
        [@top, @right, @bottom, @left].compact.filter {|entry| entry.value <= @value+1}
    end

    def to_s
        "Node(#{name},#{@x},#{@y})"
    end
end


terrain = File.read("input").split.map {|line| line.split(//).map{|name|
    value = case name
    when 'S' then 0
    when 'E' then 'z'.ord - 'a'.ord
    else name.ord - 'a'.ord
    end
    Node.new(name, value)
}}
to_visit = []
terrain.each_with_index { |row, row_index|
    row.each_with_index { |node, column_index|
        node = terrain[row_index][column_index]
        node.x = row_index
        node.y = column_index
        if row_index > 0
            node.top = terrain[row_index-1][column_index]
        end
        if row_index < terrain.size - 1
            node.bottom = terrain[row_index+1][column_index]
        end
        if column_index > 0
            node.left = terrain[row_index][column_index-1]
        end
        if column_index < row.size
            node.right = terrain[row_index][column_index+1]
        end
        if node.name == 'S' || node.name == 'a'
            to_visit.push(node)
            node.distance = 0
        end
    }
}

visited = Set.new()


while !to_visit.empty?
    visiting_node = to_visit.shift
    if visiting_node.name == 'E'
        iteration_node = visiting_node
        loop do
            puts("#{iteration_node}")
            if iteration_node.previous_node == nil
                break
            end
            iteration_node = iteration_node.previous_node
        end
        puts(visiting_node.distance) #459
        break
    end

    neighbours = visiting_node.reachable_neighbours
    neighbours.each{|node|
        if node.distance > visiting_node.distance + 1
            node.previous_node = visiting_node
            node.distance = visiting_node.distance + 1
            to_visit.push(node)
        end
    }
end
