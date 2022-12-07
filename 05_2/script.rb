def process_initial_stack(stack_lines)
    result = []
    index_line = stack_lines[0]
    max_index = Integer(index_line.split(//).max)
    (1..max_index).each{|index|
        column = index_line.index(String(index))
        row_result = []
        stack_lines[1..-1].each{ |line|
            entry = line[column]
            row_result.push(entry) if !entry.strip.empty?
        }
        result.push(row_result.reverse)
    }
    return result
end

def full_move_operation(working_stacks, times, from, to)
    move = working_stacks[from-1].shift(times)
    working_stacks[to-1].unshift(*move)
end

initial_stack = true
initial_stack_lines = []
working_stacks = []
File.foreach("input") { |line| 
    if line.strip.empty?
        working_stacks = process_initial_stack(initial_stack_lines)
        initial_stack = false
    end

    if initial_stack
        initial_stack_lines.unshift(line)
    elsif !line.strip.empty?
        line.match(/move (\d+) from (\d+) to (\d+)/) { |match|
            full_move_operation(working_stacks, Integer(match[1]), Integer(match[2]), Integer(match[3]))
        }
    end
}
puts(working_stacks.map{|entry| entry[0]}.join) #TPFFBDRJD