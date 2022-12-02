

def evaluate_selection(choice)
    return case choice
        when 'A','X' then 1 # Rock
        when 'B','Y' then 2 # Paper
        when 'C','Z' then 3 # Scissors
        else raise "Unknown choice: #{choice}"
    end
end

# A X Rock
# B Y Paper
# C Z Scissors
def evaluate_win(opponent, player)
    opponent_value = evaluate_selection(opponent)
    player_value = evaluate_selection(player)
    
    if player_value == opponent_value
        return 3 # draw
    elsif (player_value == 1 and opponent_value == 3) or (player_value == 2 and opponent_value == 1) or (player_value == 3 and opponent_value == 2)
        return 6 # win
    else 
        return 0 # loss
    end
end

def evaluateLine(line) 
    split_line = line.split
    return evaluate_selection(split_line[1]) + evaluate_win(split_line[0], split_line[1])
end

result = 0
File.foreach("input") { |line| 
    result = result + evaluateLine(line.strip)
}
puts(result) # 15572