class Edge

  attr_reader :id, :src, :dst, :width, :length, :mm

  Mm_table = {
    150 => 0, 200 => 1, 250 => 2,
    300 => 3, 350 => 4, 400 => 5,
    450 => 6, 500 => 7, 550 => 8,
    600 => 9
  }

  def initialize(raw, mm, z=false)
    @id = raw.shift
    @src = raw.shift
    @dst = raw.shift
    raw_attrs = z ? raw[12..23] : raw[0..11]
    set_dims(raw_attrs, mm)
  end

  private

  def set_dims(raw_attrs, mm)
    @width  = raw_attrs.shift
    @length = raw_attrs.shift
    @mm     = raw_attrs[Mm_table[mm]]
  end
end