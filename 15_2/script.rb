require 'set'
class Node
    attr_reader :x, :y
    def initialize(x, y)
        @x = x
        @y = y
    end

    def ==(other)
        @x == other.x && @y == other.y
    end

    def eql?(other)
        return self == other
    end

    def hash
        [@x, @y].hash
    end
      
    def to_s
        "(#{x},#{y})"
    end
end

class Sensor
    attr_reader :center, :radius
    def initialize(center, radius)
        @center = center
        @radius = radius
    end

    def include?(test_node)
        determine_distance(center, test_node) <= radius
    end

    def to_s
        "(#{center},#{radius})"
    end
end

def connect(start_node, end_node)
    if (start_node.x - end_node.x).abs != (start_node.y - end_node.y).abs
        throw "Nodes not combinable: #{start_node} #{end_node}"
    end
    x_direction = (end_node.x - start_node.x) <=> 0
    y_direction = (end_node.y - start_node.y) <=> 0
    
    current_node = start_node
    nodes = [current_node]
    while current_node != end_node
        current_node = Node.new(current_node.x + x_direction, current_node.y + y_direction)
        nodes.push(current_node)
    end
    nodes
end

def determine_distance(node_1, node_2)
    (node_1.x-node_2.x).abs + (node_1.y-node_2.y).abs
end

sensors = []
beacons = []
sensor_nodes = []
File.read("input").split(/\n/){ |line|
    match = line.match(/Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/)
    center = Node.new(Integer(match[1]), Integer(match[2]))
    beacon = Node.new(Integer(match[3]), Integer(match[4]))

    sensors.push(Sensor.new(center, determine_distance(center, beacon)))
    sensor_nodes.push(center)
    beacons.push(beacon)
}

puts("Found #{sensors.size} sensors")

candidates = Set.new
sensors.each_with_index{|sensor, index|
    top = Node.new(sensor.center.x, sensor.center.y - sensor.radius-1)
    right = Node.new(sensor.center.x + sensor.radius+1, sensor.center.y)
    bottom = Node.new(sensor.center.x, sensor.center.y + sensor.radius+1)
    left = Node.new(sensor.center.x - sensor.radius-1, sensor.center.y)

    top_right = connect(top, right)
    right_bottom = connect(right, bottom)
    bottom_left = connect(bottom, left)
    left_top = connect(left, top)
    
    candidates.merge(top_right)
    candidates.merge(right_bottom)
    candidates.merge(bottom_left)
    candidates.merge(left_top)
    
    puts("#{index+1}/#{sensors.size} (radius: #{sensor.radius}) #{candidates.size}")
}

max_index = 4_000_000
candidates = candidates.select{|node| 0 <= node.x && node.x <= max_index && 0 <= node.y && node.y <= max_index}

free_nodes = []
puts("Checking #{candidates.size} candidates")
candidates.each_with_index{|candidate, index|
    puts("#{index+1}/#{candidates.size}: #{candidate} (#{free_nodes.size})")
    if !sensor_nodes.include?(candidate) && !beacons.include?(candidate) && !sensors.any?{|sensor| sensor.include?(candidate)}
        free_nodes.push(candidate)
    end
}

puts("Node:")
puts(free_nodes) #2895970*4000000 + 2601918 = 11583882601918