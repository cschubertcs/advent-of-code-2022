require 'set'

sum = 0
File.foreach("input") { |line| 
    sections = line.strip.split(",")
    combination = Set.new
    max_length = 0
    sections.each{ |section|
        range = section.split("-")
        start = Integer(range[0])
        finish = Integer(range[1])
        length = finish-start+1
        sequence = (start..finish)
        combination += sequence
        max_length = [max_length, sequence.size].max
    }
    sum += 1 if combination.size == max_length
}
puts(sum) #450