require 'prime'

class Item
    attr_accessor :actual_value
    def initialize(value)
        @actual_value = recalculate_relevant_value(value)
    end

    def recalculate_relevant_value(value)
        return value % (2*7*11*19*3*5*17*13)
    end

    def actual_value=(new_value)
        @actual_value = recalculate_relevant_value(new_value)
    end

    def test_divisible(divisor)
        return @actual_value % divisor == 0
    end
end

class Monkey
    attr_reader :items, :evaluations
    def initialize(id, items, operation, test_divisor, success_monkey, failure_monkey)
        @id = id
        @items = items.map{|item| Item.new(item)}
        @operation = operation
        @test_divisor = test_divisor
        @success_monkey = success_monkey
        @failure_monkey = failure_monkey
        @evaluations = 0
    end

    def inspect_items
        @items = @items.each(&@operation)
        @evaluations = @evaluations + @items.size
    end

    def throw_items(monkeys)
        @items.each{|item|
            if item.test_divisible(@test_divisor)
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
test_divisor = nil
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
                    current_value.actual_value = current_value.actual_value * current_value.actual_value
                else
                    current_value.actual_value = current_value.actual_value * Integer(match[:operand])
                end
            }
        when '+' 
            operation = lambda {|current_value| 
                if match[:operand] == 'old'
                    current_value.actual_value = current_value.actual_value + current_value.actual_value
                else
                    current_value.actual_value = current_value.actual_value + Integer(match[:operand])
                end
            }
        else
            throw "Unexpected operation"
        end
    elsif match = line.match(/Test: divisible by (?<number>\d+)/)
        test_divisor = Integer(match[:number])
    elsif match = line.match(/If (?<bool>(true|false)): throw to monkey (?<monkey>\d+)/)
        case match[:bool]
        when 'true'
            success = Integer(match[:monkey])
        when 'false'
            failure = Integer(match[:monkey])

            monkeys.push(Monkey.new(current_id, current_items, operation, test_divisor, success, failure))
        end
    end

}

(1..10_000).each{|iteration|
    monkeys.each{|monkey| 
        puts("Before inspect")
        monkey.inspect_items
        puts("Before throw")
        monkey.throw_items(monkeys)
    }
    puts("Finished #{iteration}")
}

puts(monkeys.map(&:evaluations).sort.reverse[0,2].reduce(:*))
#18170818354



