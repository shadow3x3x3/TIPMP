require 'CSV'
require 'pp'

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
    end
    raw_lines
  end
end
