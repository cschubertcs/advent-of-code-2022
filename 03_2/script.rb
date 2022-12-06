require 'set'

def split_in_halfs(line)
    if line.size % 2 != 0
        raise "Given line cannot be split into two equal parts #{line}"
    end
    middle_index = (line.size / 2)-1
    [line[0..middle_index], line[middle_index+1..-1]]
end

def convert_to_priority(char)
    lower_case_value = char.ord - 96
    return lower_case_value if lower_case_value > 0 
    return lower_case_value+58
end

current_common_chars = Set.new
sum = 0
File.foreach("input").with_index { |line, line_no| 
    if line_no % 3 == 0
        current_common_chars = Set.new(line.strip.split(//))
    else
        current_common_chars &= Set.new(line.strip.split(//))
    end

    if line_no % 3 == 2
        current_common_chars.each { |char|
            puts("#{char} -> #{convert_to_priority(char)}")
            sum += convert_to_priority(char)
        }
    end
}
puts(sum) #2790