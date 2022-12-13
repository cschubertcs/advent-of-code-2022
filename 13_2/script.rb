require 'json'

def compare(left, right)
    if left.is_a?(Array) && right.is_a?(Array)
        array_result = left.zip(right).reduce(nil) { |result, (a,b)|
            if result == nil && b == nil
                result = false
            elsif result == nil
                result = compare(a, b)
            end
            result
        }
        if array_result != nil
            return array_result
        else
            return left.size == right.size ? nil : left.size < right.size
        end
    elsif left.is_a?(Integer) && right.is_a?(Integer)
        return left == right ? nil : left < right
    elsif left.is_a?(Integer) && right.is_a?(Array)
        return compare([left], right)
    elsif left.is_a?(Array) && right.is_a?(Integer)
        return compare(left, [right])
    else
        throw "Unexpected?"
    end
    return nil
end

first_key = JSON.parse('[[2]]')
second_key = JSON.parse('[[6]]')

lines_json = File.read("input").split.map { |line| JSON.parse(line)}
lines_json.push(first_key, second_key)

lines_json.sort! { |x,y|
    compare(x,y) ? -1 : 1
}

lines_json.each{|line| puts(line.inspect)}

first_index = lines_json.index(first_key)+1
second_index = lines_json.index(second_key)+1

puts("#{first_index} * #{second_index} = #{first_index*second_index}") #114 * 203 = 23142