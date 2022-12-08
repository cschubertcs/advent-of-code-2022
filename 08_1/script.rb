require 'tree'

forrest = []
File.foreach("input") { |line|
    line = line.strip
    forrest.push(line.split(//).map{|s| Integer(s)})   
}
transposed_forrest = forrest.transpose
width = forrest[0].size
height = forrest.size

if width != height
    raise "forrest needs to be quadratic"
end

visibility = Array.new(height) {Array.new(width, false)}

#(0..height-1).each {|index|
#    visibility[index][0] = true
#    visibility[index][-1] = true
#}
#(0..width-1).each {|index|
#    visibility[0][index] = true
#    visibility[-1][index] = true
#}

def visible_from_left(line, index)
    if index == 0
        #puts("visible_from_left(#{line}, #{index}) -> true")
        return true
    end
    value = line[index]
    result = true
    line[0..index-1].each{ |item_left|
        if item_left >= value
            result = false
            break
        end
    }
    #puts("visible_from_left(#{line}, #{index}) -> #{result}")
    return result
end

forrest.each{ |row| puts(row.inspect)}

(0..height-1).each{ |row_index|
    row = forrest[row_index]
    (0..width-1).each { |column_index|
        #puts("#{row_index} #{column_index} #{width-1-column_index}")
        row_visibility = visible_from_left(row, column_index) | visible_from_left(row.reverse, width-1-column_index)
        visibility[row_index][column_index] = row_visibility
    }
}

#transposed_forrest.each{ |row| puts(row.inspect)}

(0..width-1).each{ |row_index|
    transposed_row = transposed_forrest[row_index]
    (0..height-1).each { |column_index|
        #puts("#{row_index} #{column_index} #{height-1-column_index}")
        row_visibility = visible_from_left(transposed_row, column_index) || visible_from_left(transposed_row.reverse, height-1-column_index)
        visibility[column_index][row_index] |= row_visibility
    }
}

visibility.each{|line| puts(line.inspect)}

puts(visibility.map {|line| line.count(true)}.sum) #1851