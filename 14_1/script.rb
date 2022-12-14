
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

def terminal_node_reached?(terminal_nodes)
    terminal_nodes.any? {|node| node.type != 'x'}
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

width = right_most - left_most + 3
height = lower_most - upper_most + 1

grid = Grid.new(width, height, left_most-1)
defined_fields.each{|node| grid.set_node(node)}

terminal_nodes = (left_most-1..right_most+1).map{|x|
    grid.get_node(x, lower_most)
}.select{|node| 
    node.type == '.'
}
terminal_nodes.each{|node| node.type = 'x'}

puts(grid.pretty_print)

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
while !terminal_node_reached?(terminal_nodes)
    current_position = [sand_source.x, sand_source.y]

    while move = get_sand_move(grid, *current_position)
        current_position = move
    end
    if grid.get_type(*current_position) == 'x'
        puts("finished!")
        puts(grid.pretty_print)
        break
    end
    
    grid.set_type(*current_position, 'o')
    sand_counter += 1
    puts(grid.pretty_print)
end

puts(sand_counter) #793