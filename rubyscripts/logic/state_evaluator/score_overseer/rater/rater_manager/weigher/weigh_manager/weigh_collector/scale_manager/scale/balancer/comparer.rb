# takes in two arrays of balls, compares those two arrays and, based on the comparison, labels them as heavier, lighter or balanced


 class Comparer

   attr_reader :balanced, :heavier, :lighter

    def initialize
      @left = []
      @right = []
      @balanced = []
      @heavier = []
      @lighter = []
    end

    def weigh_balls(left, right)
      reset_results
      @left = left
      @right = right
      weigh_result(total_weight(@left), total_weight(@right))
    end

    private

    def reset_results
     @balanced = []
     @heavier = []
     @lighter = []
    end

    def weigh_result(left, right)
      if left > right
        @heavier = @left
        @lighter = @right
      elsif left < right
        @heavier = @right
        @lighter = @left
      else
        @balanced = @left + @right
      end
    end

    def total_weight(balls)
      balls.inject(0) { |count, ball| count += ball.weight }
    end
end
