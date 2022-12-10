
$x = 1
$tick = 0

def increment_tick 
    
    #print("tick: #{$tick}, x: #{$x}, drawing: ")
    if [$x-1, $x, $x+1].include?($tick % 40)
        print('#')
    else
        print('.')
    end
    #puts
    $tick = $tick + 1
    
    if $tick % 40 == 0
        puts
    end
end

def process_line(line) 
    if line == 'noop'
        increment_tick
    elsif match = line.match(/addx (?<number>-?\d+)/)
        increment_tick
        increment_tick
        $x = $x + Integer(match[:number])
    end
    #puts("End of cycle #{$tick}, x has value #{$x}")
end


File.foreach("input") { |line|
    line = line.strip
    process_line(line)
}

###..###....##..##..####..##...##..###..
#..#.#..#....#.#..#....#.#..#.#..#.#..#.
###..#..#....#.#..#...#..#....#..#.#..#.
#..#.###.....#.####..#...#.##.####.###..
#..#.#....#..#.#..#.#....#..#.#..#.#....
###..#.....##..#..#.####..###.#..#.#....