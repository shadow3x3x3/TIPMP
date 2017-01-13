require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erb'
require 'pry'

require_relative 'IO/reader'
require_relative 'IO/writer'
require_relative 'graph/multi_attribute_graph'
require_relative 'path/sky_path'

raw_nodes = CSVReader.new('data/salu_nodes.csv', 'Node')
raw_edges = CSVReader.new('data/salu_edges.csv', 'Edge')
nodes = raw_nodes.read
edges = raw_edges.read

get '/' do
  @title = '沙鹿地區淹水逃生路線模擬'

  erb :index
end

post '/SkylinePathResult' do
  case params['z_radio']
  when 'true'
    z = true
  when 'false'
    z = false
  end

  src = params['source'].to_i
  dst = params['destination'].to_i
  rain = params['rain'].to_i

  dim_multiple = [
    params['dim_input_1'].to_f,
    params['dim_input_2'].to_f,
    params['dim_input_3'].to_f
  ]
  mag = MultiAttributeGraph.new(nodes, edges, rain, z, dim_multiple)
  sp = SkyPath.new(mag)
  @result = sp.query_skyline_path(
    src_id: src,
    dst_id: dst,
    limit: 2,
    evaluate: false
  )

  @filename_5   = "top_5_#{src}to#{dst}_result.txt"
  @filename_sum = "sum_best_#{src}to#{dst}_result.txt"

  Writer.output_to_txt(@result, sp, 9993, 11291)
  erb :result
end
