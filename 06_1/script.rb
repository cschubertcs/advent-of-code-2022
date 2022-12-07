require 'set'

File.foreach("input") { |line|
    work_line = line.rstrip
    sequence_length = 4
    left_end = 0
    right_end = left_end + sequence_length -1

    while right_end < work_line.size
        entries = Set.new(work_line[left_end..right_end].split(//))
        if entries.size == sequence_length
            puts(right_end+1) #1953
            break
        end
        left_end = left_end+1
        right_end = right_end+1
    end
}