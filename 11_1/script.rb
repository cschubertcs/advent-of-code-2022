
class Monkey
    attr_reader :items, :evaluations
    def initialize(id, items, operation, test, success_monkey, failure_monkey)
        @id = id
        @items = items
        @operation = operation
        @test = test
        @success_monkey = success_monkey
        @failure_monkey = failure_monkey
        @evaluations = 0
    end

    def inspect_items
        @items = @items.map(&@operation)
        @evaluations = @evaluations + @items.size
    end

    def reduce_worry_level
        @items = @items.map {|item|
            item / 3
        }
    end

    def throw_items(monkeys)
        @items.each{|item|
            if @test.call(item)
                monkeys[@success_monkey].items.push(item)
            else
                monkeys[@failure_monkey].items.push(item)
            end
        }
        @items = []
    end
end

monkeys = []
current_id = -1
current_items = []
operation = nil
test = nil
success = nil
failure = nil

File.foreach("input") { |line|
    line = line.strip
    if match = line.match(/Monkey (?<monkey>\d+)/)
        current_id = Integer(match[:monkey])
    elsif match = line.match(/Starting items: (?<items>[\d, ]+)/)
        current_items = match[:items].split(', ').map{|item| Integer(item)}
    elsif match = line.match(/Operation: new = old (?<operation>[\+\*]) (?<operand>(\d+|old))/)
        case match[:operation]
        when '*' 
            operation = lambda {|current_value|
                if match[:operand] == 'old'
                    return current_value * current_value
                else
                    return current_value * Integer(match[:operand])
                end
            }
        when '+' 
            operation = lambda {|current_value| 
                if match[:operand] == 'old'
                    return current_value + current_value
                else
                    return current_value + Integer(match[:operand])
                end
            }
        else
            throw "Unexpected operation"
        end
    elsif match = line.match(/Test: divisible by (?<number>\d+)/)
        test = lambda {|current_value| current_value % Integer(match[:number]) == 0}
    elsif match = line.match(/If (?<bool>(true|false)): throw to monkey (?<monkey>\d+)/)
        case match[:bool]
        when 'true'
            success = Integer(match[:monkey])
        when 'false'
            failure = Integer(match[:monkey])

            monkeys.push(Monkey.new(current_id, current_items, operation, test, success, failure))
        end
    end

}

(1..20).each{
    monkeys.each{|monkey| 
        monkey.inspect_items
        monkey.reduce_worry_level
        monkey.throw_items(monkeys)
    }
}

puts(monkeys.map(&:evaluations).sort.reverse[0,2].reduce(:*))
#90294



