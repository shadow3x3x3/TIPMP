require 'knnball'
require 'awesome_print'

require_relative '../IO/reader'

class EvalutaionNode
  def initialize(data_path)
    @data_path = data_path
    @k_index = KnnBall.build(format_data(read(data_path)))
  end

  def read(path)
    CSVReader.new(path, 'Intersection').read
  end

  def format_data(raw)
    formated = []
    raw.each do |row|
      formated << { :id => row[0], :point=> [row[1], row[2]] }
    end
    formated
  end

  def nearest(query)
    @k_index.nearest(query)
  end

  def clac_all(type)
    result = {}
    query_data_raw = CSVReader.new(@data_path, type).read

    format_data(query_data_raw).each do |node|
      result[node[:id]] = nearest(node[:point])[:id]
    end
    result
  end
end



