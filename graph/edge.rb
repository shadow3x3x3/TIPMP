class Edge

  attr_reader :id, :src, :dst, :width, :length, :mm

  Mm_table = {
    150 => 0, 200 => 1, 250 => 2,
    300 => 3, 350 => 4, 400 => 5,
    450 => 6, 500 => 7, 550 => 8,
    600 => 9
  }

  def initialize(raw, mm, z, dim_multiple)
    @id = raw.shift.to_i
    @src = raw.shift.to_i
    @dst = raw.shift.to_i
    raw_attrs = (z ? raw[12..23] : raw[0..11]).map(&:to_f)
    set_dims(raw_attrs, mm, dim_multiple)
  end

  def attrs
    [@width, @length, @mm]
  end

  private

  def set_dims(raw_attrs, mm, dim_multiple)
    @width  = raw_attrs.shift * dim_multiple[0]
    @length = raw_attrs.shift * dim_multiple[1]
    @mm     = raw_attrs[Mm_table[mm]] * dim_multiple[2]
  end
end