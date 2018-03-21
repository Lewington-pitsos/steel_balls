module ScaleHelper

  def agglomorate(category_hash)
    # returns an vversion of the array hash compounded into a single array
    category_hash.map { |_, array| array }.flatten
  end

end
