# Dijkstra's algorithm for searching shorest path
module NearestDijkstra
  def shorest_path_query(src_id)
    dijkstra_init(src_id)
    until @vertices.empty?
      nearest_node = check_shortest
      break unless @distances[nearest_node]
      check_nearest(@graph.find_neighbors(nearest_node), nearest_node)
      nn = get_nn_node
      return nn unless nn.nil?
    end
  end

  def dijkstra_init(src_id)
    @distances  = {}
    @previouses = {}
    @graph.nodes.each do |n|
      @distances[n]  = nil
      @previouses[n] = nil
    end
    @distances[src_id] = 0
    @vertices = @graph.nodes.clone
  end

  def check_shortest
    @vertices.inject do |f, n|
      next n unless @distances[f]
      next f unless @distances[n]
      next f if @distances[f] < @distances[n]
      n
    end
  end

  def check_nearest(neighbors, nn)
    neighbors.each do |n|
      alt = @distances[nn] + length_between(nn, n)
      if @distances[n].nil? || alt < @distances[n]
        @distances[n] = alt
        @previouses[n] = nn
      end
    end
    @vertices.delete(nn)
  end

  def get_nn_node
    @targets.each do |k, v|
      return [k, v] unless @distances[v].nil?
    end
    nil
  end

  # def get_path(src_id, dst_id)
  #   path = get_path_recursively(src_id, dst_id)
  #   path.is_a?(Array) ? path.reverse : path
  # end

  # def get_path_recursively(src, dest)
  #   return src if src == dest
  #   [dest, get_path_recursively(src, @previouses[dest])].flatten
  # end

  def length_between(src, dst)
    @graph.edges_table[[src, dst]].length
  end
end
