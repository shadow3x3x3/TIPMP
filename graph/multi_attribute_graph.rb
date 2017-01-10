require_relative 'edge'

class MultiAttributeGraph

  attr_reader :edges, :nodes, :connecting_table, :edges_table

  def initialize(raw_nodes, raw_edges, mm, z)
    @nodes = raw_nodes
    initialize_edges(raw_edges, mm, z)
    @connecting_table = make_connecting_table
    @edges_table      = make_edges_table
  end

  def initialize_edges(raw_edges, mm, z)
    @edges = []
    raw_edges.each { |raw_e| add_edge(raw_e, mm, z) }
  end

  def add_edge(edge, mm, z)
    @edges << Edge.new(edge, mm, z)
  end

  def make_connecting_table
    table = {}
    nodes.each { |node| table[node] = find_neighbors(node) }
    table
  end

  def make_edges_table
    table = {}
    @edges.each do |edge|
      table[[edge.src, edge.dst]] = edge
      table[[edge.dst, edge.src]] = edge
    end
    table
  end

  def find_neighbors(node)
    neighbors = []
    @edges.each do |edge|
      neighbors << retrieve_neighbor(node, edge)
    end
    neighbors.compact!
  end

  def retrieve_neighbor(node, edge)
    case node
    when edge.src
      return edge.dst
    when edge.dst
      return edge.src
    end
  end
end
