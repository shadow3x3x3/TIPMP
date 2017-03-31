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
require_relative 'core/nearest_stronghold'

before do
  # for preprocess reading
  salu_en     = EvalutaionNode.new('data/salu_nodes_xy.csv')
  longjing_en = EvalutaionNode.new('data/longjing_nodes_xy.csv')
  @salu_center_nodes = salu_en.clac_all('Center Node')
  @longjing_center_nodes = longjing_en.clac_all('Center Node')

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
  @title = '台中地區淹水逃生路線模擬'

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

  rain = params['rain'].to_i

  dim_multiple = [
    params['dim_input_1'].to_f,
    params['dim_input_2'].to_f,
    params['dim_input_3'].to_f
  ]

  case params['data_set']
  when 'salu'
    mag = MultiAttributeGraph.new(@SALU_NODES, @SALU_EDGES, rain, z, dim_multiple)
    case params['query']
    when 'center'
      center_node = params['center'].to_i
      src_id = if @salu_center_nodes[center_node]
                @salu_center_nodes[center_node]
              else
                center_node
              end
      ns = NearestStronghold.new(mag)
      refuge_node, dst_id = ns.query(src_id, params['data_set'])
      @title = "#{params['center']} 到 #{refuge_node}計算結果 - (節點#{src_id} to #{dst_id})"
    when 'srcDest'
      src_id = params['source'].to_i
      dst_id = params['dest'].to_i
      @title = "節點#{src_id} to #{dst_id}計算結果"
    end
  when 'longjing'
    mag = MultiAttributeGraph.new(@LONGJING_NODES, @LONGJING_EDGES, rain, z, dim_multiple)
    case params['query']
    when 'center'
      center_node = params['center'].to_i
      src_id = if @longjing_center_nodes[center_node]
                @longjing_center_nodes[center_node]
              else
                center_node
              end
      ns = NearestStronghold.new(mag)
      refuge_node, dst_id = ns.query(src_id, params['data_set'])
      @title = "#{params['center']} 到 #{refuge_node}計算結果 - (節點#{src_id} to #{dst_id})"
    when 'srcDest'
      src_id = params['source'].to_i
      dst_id = params['dest'].to_i
      @title = "節點#{src_id} to #{dst_id}計算結果"
    end
  end

  sp = SkyPath.new(mag)
  query_data = { 'src_id' => src_id, 'dst_id' => dst_id, 'limit' => 1.3, 'evaluate' => 1 }
  ap query_data
  @result = sp.query_skyline_path(
    src_id: src_id,
    dst_id: dst_id,
    limit: 1.3,
    evaluate: false
  )

  Writer.output_to_txt(@result, sp, src_id, dst_id)

  @filename_5   = "top_5_#{src_id}to#{dst_id}_result.txt"
  @filename_sum = "sum_best_#{src_id}to#{dst_id}_result.txt"
  erb :result
end

get '/:filename' do |f|
  send_file "output/#{f}", filename: f, type: 'Application/octet-stream'
end


## Functions ##
def get_params(params)
  {
    :data   => params['data_set'],
    :query  => params['query'],
    :center => params['center'],
    :src    => params['source'],
    :dst    => params['dest'],
    :rain   => params['rain'],
    :dim1   => params['dim_input_1'],
    :dim2   => params['dim_input_2'],
    :dim3   => params['dim_input_3'],
    :z      => params['z_radio']
  }
end
