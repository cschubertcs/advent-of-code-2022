
class Node
    attr_reader :x, :y
    attr_accessor :type
    def initialize(x, y, type)
        @x = Integer(x)
        @y = Integer(y)
        @type = type
    end

    def to_s
        "(#{@x}, #{@y}, #{@type})"
    end
end

class Grid
    def initialize(width, height, left_offset)
        @grid = Array.new(height){ |y|
            Array.new(width) {|x| 
                Node.new(x, y, '.')
            }
        }
        puts("Created grid with max x value: #{@grid[0].size} and offset #{left_offset}")
        @left_offset = left_offset
    end

    def get_node(x, y)
        if 0 <= y && y < @grid.size && 0 <= 0 && @grid[y].size
            @grid[y][x-@left_offset]
        else
            nil
        end
    end

    def set_node(node)
        @grid[node.y][node.x-@left_offset] = node
    end

    def get_type(x, y)
        get_node(x,y)&.type
    end

    def set_type(x, y, type)
        @grid[y][x-@left_offset].type = type
    end

    def pretty_print
        @grid.map{|line|
            line.map{|node|
                #"(#{node.x},#{node.y})"
                node.type
            }.join
        }.join("\n")
    end
end

def sand_node_blocked?(sand_source)
    sand_source.type == 'o'
end

def connect(start_node, end_node)
    if start_node.x != end_node.x && start_node.y != end_node.y || start_node.type != end_node.type
        throw "Nodes not combinable: #{start_node} #{end_node}"
    end
    start_x = [start_node.x, end_node.x].min
    end_x = [start_node.x, end_node.x].max
    start_y = [start_node.y, end_node.y].min
    end_y = [start_node.y, end_node.y].max

    result = []
    (start_x..end_x).each{|new_x|
        (start_y..end_y).each{|new_y|
            result.push(Node.new(new_x, new_y, start_node.type))
        }
    }
    result
end

defined_fields = []
File.read("input").split(/\n/){ |line|
    line.split(/ -> /).map{|pair| 
        pair = pair.split(',')
        Node.new(pair[0], pair[1], '#')
    }.each_cons(2){ |start_node, end_node|
        defined_fields.push(*connect(start_node, end_node))
    }
}

sand_source = Node.new(500, 0, '+')
defined_fields.push(sand_source)

left_most = defined_fields.map{|stone| stone.x}.min
right_most = defined_fields.map{|stone| stone.x}.max
upper_most = defined_fields.map{|stone| stone.y}.min
lower_most = defined_fields.map{|stone| stone.y}.max

puts("#{left_most} #{right_most} #{upper_most} #{lower_most}")

padding = 10000

width = right_most - left_most + padding
height = lower_most - upper_most + 3

grid = Grid.new(width, height, left_most-1+padding/2)
defined_fields.each{|node| grid.set_node(node)}

terminal_nodes = (left_most-padding/2..right_most+padding/2).map{|x|
    grid.get_node(x, lower_most + 2)
}.select{|node| 
    node.type == '.'
}
terminal_nodes.each{|node| node.type = '#'}

def get_sand_move(grid, x, y)
    targets = ['x', '.']
    if targets.include?(grid.get_type(x,y+1))
        return [x, y+1]
    elsif targets.include?(grid.get_type(x-1, y+1))
        return  [x-1, y+1]
    elsif targets.include?(grid.get_type(x+1, y+1))
        return [x+1, y+1]
    else 
        return nil
    end
end

sand_counter = 0
while !sand_node_blocked?(sand_source)
    current_position = [sand_source.x, sand_source.y]

    while move = get_sand_move(grid, *current_position)
        current_position = move
    end
    
    grid.set_type(*current_position, 'o')
    sand_counter += 1
    print('.')
end

puts(sand_counter) #