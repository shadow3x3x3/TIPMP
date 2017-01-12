require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erb'
require 'pry'

require_relative 'IO/reader'
require_relative 'graph/multi_attribute_graph'
require_relative 'path/sky_path'

nodes = CSVReader.new('data/salu_nodes.csv', 'Node')
edges = CSVReader.new('data/salu_edges.csv', 'Edge')

get '/' do
  @title = '沙鹿地區淹水逃生路線模擬'

  erb :index
end
