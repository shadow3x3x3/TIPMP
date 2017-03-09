require_relative 'nearest_dijkstra'
require_relative '../IO/reader'

require_relative 'evaluation_node'

class NearestStronghold
  include NearestDijkstra

  def initialize(graph)
    @graph = graph
  end

  def query(node, zone)
    @targets = case zone
               when 'salu'
                 salu_en = EvalutaionNode.new('data/salu_nodes_xy.csv')
                 salu_en.clac_all('Refuge Node')
               when 'longjing'
                 salu_en = EvalutaionNode.new('data/longjing_nodes_xy.csv')
                 salu_en.clac_all('Refuge Node')
               end
    shorest_path_query(node)
  end
end