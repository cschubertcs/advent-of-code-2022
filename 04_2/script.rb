require 'set'

sum = 0
File.foreach("input") { |line| 
    sections = line.strip.split(",")
    combination = Set.new
    total_length = 0
    sections.each{ |section|
        range = section.split("-")
        start = Integer(range[0])
        finish = Integer(range[1])
        length = finish-start+1
        sequence = (start..finish)
        combination += sequence
        total_length += sequence.size
    }
    sum += 1 if combination.size != total_length
}
puts(sum) #837