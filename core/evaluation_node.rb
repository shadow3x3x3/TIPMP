require 'knnball'
require 'awesome_print'

require_relative '../IO/reader'

class EvalutaionNode
  def initialize(ori_path)
    @k_index = KnnBall.build(format_data(read(ori_path)))
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

  def clac_all
    result = {}

    query_data_path = 'data/nearest_data/query_nodes.csv'
    query_data_raw = CSVReader.new(query_data_path, 'Center Node').read
    query_data = format_data(query_data_raw)

    query_data.each do |node|
      result[node[:id]] = nearest(node[:point])[:id]
    end
    result
  end
end



