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

sum = 0
File.foreach("input") { |line| 
    halfs = split_in_halfs(line.strip)
    first_set = Set.new(halfs[0].split(//))
    second_set = Set.new(halfs[1].split(//))
    diff = first_set & second_set

    diff.each { |char|
        puts("#{char} -> #{convert_to_priority(char)}")
        sum += convert_to_priority(char)
    }
}
puts(sum) #7845