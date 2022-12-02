

def evaluate_result(choice)
    return case choice
        when 'X' then 0 # lose
        when 'Y' then 3 # draw
        when 'Z' then 6 # win
        else raise "Unknown choice: #{choice}"
    end
end

def evaluate_selection(choice)
    return case choice
        when 'A' then 1 # Rock
        when 'B' then 2 # Paper
        when 'C' then 3 # Scissors
        else raise "Unknown choice: #{choice}"
    end
end

# A Rock
# B Paper
# C Scissors
def decide_choice(opponent, result)
    if result == 'Y'
        return opponent
    elsif result == 'Z'
        return case opponent
            when 'A' then 'B'
            when 'B' then 'C'
            when 'C' then 'A'
            else raise "Unknown opponent choice: #{opponent}"
        end
    elsif result == 'X'
        return case opponent
            when 'A' then 'C'
            when 'B' then 'A'
            when 'C' then 'B'
            else raise "Unknown opponent choice: #{opponent}"
        end
    else
        raise "Unknown result: #{result}"
    end
end

def evaluateLine(line) 
    split_line = line.split
    choice = decide_choice(split_line[0], split_line[1])
    return evaluate_result(split_line[1]) + evaluate_selection(choice)
end

result = 0
File.foreach("input") { |line| 
    result = result + evaluateLine(line.strip)
}
puts(result) # 16098