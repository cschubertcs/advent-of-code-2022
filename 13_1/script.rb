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

correct_indices = []
File.read("input").split.each_slice(2).with_index { |(left, right), index|
    left_json = JSON.parse(left)
    right_json = JSON.parse(right)

    if compare(left_json, right_json)
        correct_indices.append(index+1)
    end
}

puts(correct_indices.sum) #6240