
$x = 1
$tick = 0

$signal_strength = 0

def increment_tick 
    $tick = $tick + 1
    if [20, 60, 100, 140, 180, 220].include?($tick)
        signal_strength_update = $tick*$x
        puts("signal strength updated from #{$signal_strength} by #{signal_strength_update}")
        $signal_strength = $signal_strength + signal_strength_update
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
    puts("End of cycle #{$tick}, x has value #{$x}")
end


File.foreach("input") { |line|
    line = line.strip
    process_line(line)
}

puts($signal_strength) #15140