require 'csv'

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
        raw_lines << row[0].to_i
      end
    when 'Intersection'
      CSV.foreach(@file_path) do |row|
        line = []
        if row[1] == '1'
          line << row[0].to_i
          line << row[2].to_f
          line << row[3].to_f
          raw_lines << line
        end
      end
    end
    raw_lines
  end
end
