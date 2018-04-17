require 'csv'

INTERSECTION_ID = '1'
REFUGE_ID       = '2'
CENTER_ID       = '3'

class CSVReader
  def initialize(file_path, type)
    @file_path = file_path
    @type      = type
  end

  def read
    raw_lines = []
    case @type
    when 'Edge'
      CSV.foreach(@file_path) do |row|
        raw_lines << row if row.size == 27
      end
    when 'Node'
      CSV.foreach(@file_path) do |row|
        raw_lines << row[0].to_i if row[1] != '3'
      end
    when 'Intersection'
      CSV.foreach(@file_path) do |row|
        raw_lines << get_nodes_with_xy(row) if row[1] == INTERSECTION_ID
      end
    when 'Refuge Node'
      CSV.foreach(@file_path) do |row|
        raw_lines << get_nodes_with_xy(row) if row[1] == REFUGE_ID
      end
    when 'Center Node'
      CSV.foreach(@file_path) do |row|
        raw_lines << get_nodes_with_xy(row) if row[1] == CENTER_ID
      end
    end
    raw_lines
  end

  def get_nodes_with_xy(row)
    [row[0].to_i, row[2].to_f, row[3].to_f]
  end
end
