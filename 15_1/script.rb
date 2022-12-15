
class Node
    attr_reader :x, :y
    def initialize(x, y)
        @x = x
        @y = y
    end

    def ==(other)
        @x == other.x && @y == other.y
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

left_most_coordinate = sensors.map{|sensor|
    result = sensor.center.x - sensor.radius
    result
}.min
right_most_coordinate = sensors.map{|sensor|
    result = sensor.center.x + sensor.radius
    result
}.max

puts(left_most_coordinate)
puts(right_most_coordinate)

count = (left_most_coordinate..right_most_coordinate).map{|x|
    check_node = Node.new(x, 2_000_000)
    sensors.any?{|sensor|
        sensor.include?(check_node)
    } && !sensor_nodes.include?(check_node) && !beacons.include?(check_node)
}.count(true)

puts(count) #4985193