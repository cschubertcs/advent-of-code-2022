require 'tree'

forrest = []
File.foreach("input") { |line|
    line = line.strip
    forrest.push(line.split(//).map{|s| Integer(s)})   
}
transposed_forrest = forrest.transpose
width = forrest[0].size
height = forrest.size

visibility = Array.new(height) {Array.new(width, 1)}

def scenic_score_left(line, index)
    if index == 0
        #puts("visible_from_left(#{line}, #{index}) -> 0")
        return 0
    end
    value = line[index]
    result = 1
    line[1..index-1].reverse.each{ |item_left|
        #puts("Comparing #{item_left} >= #{value}")
        if item_left >= value
            break
        end
        result = result+1
    }
    #puts("visible_from_left(#{line}, #{index}) -> #{result}")
    return result
end

#forrest.each{ |row| puts(row.inspect)}

(0..height-1).each{ |row_index|
    row = forrest[row_index]
    (0..width-1).each { |column_index|
        #puts("#{row_index} #{column_index} #{width-1-column_index}")
        row_visibility = scenic_score_left(row, column_index) * scenic_score_left(row.reverse, width-1-column_index)
        visibility[row_index][column_index] = row_visibility
    }
}

#transposed_forrest.each{ |row| puts(row.inspect)}

(0..width-1).each{ |row_index|
    transposed_row = transposed_forrest[row_index]
    (0..height-1).each { |column_index|
        #puts("#{row_index} #{column_index} #{height-1-column_index}")
        row_visibility = scenic_score_left(transposed_row, column_index) * scenic_score_left(transposed_row.reverse, height-1-column_index)
        visibility[column_index][row_index] *= row_visibility
    }
}

#visibility.each{|line| puts(line.inspect)}

puts(visibility.map {|line| line.max}.max) #574080