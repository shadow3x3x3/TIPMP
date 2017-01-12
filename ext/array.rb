class Array
  def aggregate(array)
    raise "Need Array not #{array.class}"    unless array.class == Array
    raise 'Two Arrays are not the same size' unless size == array.size

    aggregated_array = []
    each_with_index do |attr, index|
      aggregated_array << (attr + array[index]).round(6)
    end
    aggregated_array
  end
end