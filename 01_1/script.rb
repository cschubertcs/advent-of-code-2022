calories_per_elf = []
current_calories = 0

File.foreach("input") { |line| 
    if line.strip.empty?
        calories_per_elf.push(current_calories)
        current_calories = 0
    else
        current_calories = current_calories + Integer(line.strip)
    end
}

puts(calories_per_elf.each_with_index.max)
# 71300
# 28