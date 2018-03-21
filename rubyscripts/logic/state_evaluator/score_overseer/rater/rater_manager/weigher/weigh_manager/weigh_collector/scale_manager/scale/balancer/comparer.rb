# takes in two arrays of balls, compares those two arrays and, based on the comparison, labels them as heavier, lighter or balanced


 class Comparer

    def initialize
     @balanced = []
     @heavier = []
     @lighter = []
    end

    def weigh_balls(left, right)
      reset_results
      weigh_result(total_weight(right), total_weight(left))
    end

    private

    def reset_results
     @balanced = []
     @heavier = []
     @lighter = []
    end

    def weigh_result(left, right)
      if left > right
        @heavier = left
        @lighter = right
      elsif left < right
        @heavier = right
        @lighter = left
      else
        @balanced = left + right
      end
    end

    def total_weight(balls)
      count = 0
      balls.each { |b| count += b.weight }
      count
    end
end
