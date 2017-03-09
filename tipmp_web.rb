require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erb'
require 'pry'
require 'awesome_print'

require_relative 'IO/reader'
require_relative 'IO/writer'
require_relative 'graph/multi_attribute_graph'
require_relative 'path/sky_path'
require_relative 'core/evaluation_node'


before do
  # for preprocess reading
  en = EvalutaionNode.new('data/nearest_data/salu_nodes_xy.csv')
  @center_nodes = en.clac_all

  # for Skyline path reading
  salu_node_csv = CSVReader.new('data/salu_nodes.csv', 'Node')
  salu_edge_csv = CSVReader.new('data/salu_edges.csv', 'Edge')
  @SALU_NODES = salu_node_csv.read
  @SALU_EDGES = salu_edge_csv.read

  longjing_node_csv = CSVReader.new('data/longjing_nodes.csv', 'Node')
  longjing_edge_csv = CSVReader.new('data/longjing_edges.csv', 'Edge')
  @LONGJING_NODES = longjing_node_csv.read
  @LONGJING_EDGES = longjing_edge_csv.read
end

get '/' do
  @title = '沙鹿地區淹水逃生路線模擬'

  erb :index
end

post '/SkylinePathResult' do
  ap get_params(params)

  case params['z_radio']
  when 'true'
    z = true
  when 'false'
    z = false
  end

  src = if @center_nodes[params['source'].to_i]
          @center_nodes[params['source'].to_i]
        else
          params['source'].to_i
        end
  dst  = params['destination'].to_i
  rain = params['rain'].to_i

  dim_multiple = [
    params['dim_input_1'].to_f,
    params['dim_input_2'].to_f,
    params['dim_input_3'].to_f
  ]

  case params['data_set']
  when 'salu'
    mag = MultiAttributeGraph.new(@SALU_NODES, @SALU_EDGES, rain, z, dim_multiple)
  when 'longjing'
    mag = MultiAttributeGraph.new(@LONGJING_NODES, @LONGJING_EDGES, rain, z, dim_multiple)
  end
  sp = SkyPath.new(mag)
  @result = sp.query_skyline_path(
    src_id: src,
    dst_id: dst,
    limit: 1.3,
    evaluate: false
  )

  Writer.output_to_txt(@result, sp, src, dst)
  @filename_5   = "top_5_#{src}to#{dst}_result.txt"
  @filename_sum = "sum_best_#{src}to#{dst}_result.txt"
  erb :result
end

get '/:filename' do |f|
  send_file "output/#{f}", filename: f, type: 'Application/octet-stream'
end


## Functions ##
def get_params(params)
  {
    :data => params['data_set'],
    :src  => params['source'],
    :dst  => params['destination'],
    :rain => params['rain'],
    :dim1 => params['dim_input_1'],
    :dim2 => params['dim_input_2'],
    :dim3 => params['dim_input_3'],
    :z    => params['z_radio']
  }
end
