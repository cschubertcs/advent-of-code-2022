require 'set'

Coordinate = Struct.new(:x, :y)

head = Coordinate.new(0,0)
tail = Coordinate.new(0,0)

history = Set.new
history.add(tail)

def move(direction, coordinate)
    return case direction
        when 'U' then Coordinate.new(coordinate.x, coordinate.y+1)
        when 'D' then Coordinate.new(coordinate.x, coordinate.y-1)
        when 'L' then Coordinate.new(coordinate.x-1, coordinate.y)
        when 'R' then Coordinate.new(coordinate.x+1, coordinate.y)
    end
end

def get_closer(head, tail)
    #puts("#{head} #{tail} max_distance:#{max_distance(head, tail)} ")
    max_dist = max_distance(head, tail)
    if max_dist <= 1
        return tail
    end

    if head.x == tail.x && head.y > tail.y
        return move('U', tail)
    elsif head.x == tail.x && head.y < tail.y
        return move('D', tail)
    elsif head.y == tail.y && head.x > tail.x
        return move('R', tail)
    elsif head.y == tail.y && head.x < tail.x
        return move('L', tail)
    elsif head.x < tail.x && head.y < tail.y
        return move('D', move('L', tail))
    elsif head.x > tail.x && head.y > tail.y
        return move('U', move('R', tail))
    elsif head.x < tail.x && head.y > tail.y
        return move('U', move('L', tail))
    elsif head.x > tail.x && head.y < tail.y
        return move('D', move('R', tail))
    end
    raise "Unexpected case o.O"
end

def max_distance(coordinate_1, coordinate_2)
    return [(coordinate_1.x-coordinate_2.x).abs, (coordinate_1.y-coordinate_2.y).abs].max
end

File.foreach("input") { |line|
    line = line.strip
    direction = line.split(' ')[0]
    steps = Integer(line.split(' ')[1])
    (1..steps).each{|iteration|
        head = move(direction, head)
        tail = get_closer(head, tail)
        history.add(tail)
        puts("head: #{head}")
        puts("tail: #{tail}")
    }
}

puts(history.size)