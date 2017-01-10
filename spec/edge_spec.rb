require 'CSV'

require_relative '../graph/edge'

describe Edge, '#initialize' do
  context 'raw data'
    it 'matchs the correct data' do
      rows = []

      CSV.foreach('data/salu_edges.csv') do |row|
        rows << row
      end
      e = Edge.new(rows[0], mm = 200)
      e2 = Edge.new(rows[4].clone, mm = 500)
      e3 = Edge.new(rows[4].clone, mm = 500, true)

      expect(e.src).to eq 14454
      expect(e.length).to eq 38.6150017
      expect(e2.mm).to eq 0.003262
      expect(e3.mm).to eq 0.121001662
    end
end