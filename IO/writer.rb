module Writer
  def self.output_to_txt(skyline_paths, sp, src, dst)
    @sp = sp
    filter_skyline_path = if skyline_paths.size > 5
                              split_path_ids(filter_skyline(skyline_paths))
                            else
                              split_path_ids(skyline_paths)
                            end

    sum_best_skyline_path = sum_best_path(filter_skyline_path)

    write(src, dst, filter_skyline_path,   'top_5')
    write(src, dst, sum_best_skyline_path, 'sum_best')
  end

  def self.write(src, dst, content, type)
    File.open("output/#{type}_#{src}to#{dst}_result.txt", "w") do |f|
      if type == 'sum_best'
        sp_id_array = path_to_id(content)

        sp_id_array.each_with_index do |id, index|
          f.write("\"id\" = #{id}")
          index == sp_id_array.size - 1 ? f.write("\n") : f.write(' OR ')
        end
      else
        content.each do |sp|
          sp_id_array = path_to_id(sp)

          sp_id_array.each_with_index do |id, index|
            f.write("\"id\" = #{id}")
            index == sp_id_array.size - 1 ? f.write("\n") : f.write(' OR ')
          end
        end
      end
    end
  end

  def self.path_to_id(path)
    path_id = []

    path.each_with_index do |v, i|
      next if i == path.size - 1
      next_v = path[i + 1]
      @sp.graph.edges.each do |edge|
        path_id << edge.id if edge.src == v && edge.dst == next_v
        path_id << edge.id if edge.src == next_v && edge.dst == v
      end
    end
    path_id
  end

  def self.filter_skyline(skyline_path)
    sort_result = sort_by_dim(skyline_path)

    skyline_path_set = get_skyline_path_ids(sort_result)
    reslut = filter_array_top_k(skyline_path_set, 5) # Top 5 skyline paths
    reslut
  end

  def self.sort_by_dim(ori_hash)
    result_array = []
    index = 0
    @sp.dim.times do
      result_array << ori_hash.sort_by { |_, value| value[index] }
      index += 1
    end
    result_array
  end

  def self.get_skyline_path_ids(skyline_array)
    skyline_path_set = []
    skyline_array.each do |skyline_set|
      temp_set = []
      skyline_set.each do |skyline|
        temp_set << skyline[0].to_s
      end
      skyline_path_set << temp_set
    end
    skyline_path_set
  end

  def self.filter_array_top_k(target_array, top_k)
    result_array = []
    search_range = 0
    find_k       = 0
    until (find_k >= top_k) # || (search_range == @skyline_path.size)
      search_range += 1
      result_array = target_array.inject { |top_k, next_array| top_k & next_array[0..search_range] }
      find_k = result_array.size
    end
    result_array
  end

  def self.split_path_ids(target_paths)
    skyline_paths = target_paths.map {|path_ids, _path_values| path_ids.to_s.split("_")}
    skyline_paths.map! do |skyline_path|
      skyline_path.shift # shift the "path"
      skyline_path.map(&:to_i)
    end
  end

  def self.sum_best_path(paths)
    result_path = []
    paths.each do |path|
      result_path << @sp.attrs_in(path).inject(&:+)
    end

    paths[result_path.index(result_path.min)]
  end

end
