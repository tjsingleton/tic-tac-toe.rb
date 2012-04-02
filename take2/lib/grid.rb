require_relative "./point"

class Grid
  EMPTY_POSITION = Class.new
  class PositionAlreadyTaken < StandardError; end
  class PositionOutOfBounds < StandardError; end

  # @param max_point [Point]
  def initialize(max_point)
    @columns = max_point.x + 1
    @rows    = max_point.y + 1

    build_grid
  end

  # @param point [Point]
  # @return [true,false]
  def empty_at?(point)
    get(point) == EMPTY_POSITION
  end

  # @param point [Point]
  def get(point)
    @hash.fetch(point)
  rescue KeyError
    raise PositionOutOfBounds, "#{point} is out of bounds"
  end

  # @param point [Point]
  # @param value [Object]
  def set(point, value)
    @hash.store(point, value)
  end

  # @return [Integer]
  def size
    @hash.length
  end

  def each(&block)
    @hash.each &block
  end

  def each_row(&block)
    @hash.each_slice(@columns, &block)
  end

  def each_column(&block)
    @hash.each_slice(@columns).to_a.transpose.each(&block)
  end

  def each_diagonal(&block)
    a = @columns.times.map do |x|
      point = Point[x,x]
      [point, @hash.fetch(point)]
    end

    b = @columns.times.map do |x|
      point = Point[x, @columns - 1 - x]
      [point, @hash.fetch(point)]
    end

    [a,b].each(&block)
  end

  private
  def build_grid
    @hash = {}
    @columns.times &method(:build_row)
  end

  # @param x [Integer]
  def build_row(x)
    @rows.times do |y|
      point = Point[x, y]
      @hash.store point, Grid::EMPTY_POSITION
    end
  end
end

class Grid::WriteOnce < Grid
  def set(point, value)
    raise PositionAlreadyTaken unless empty_at?(point)
    super
  end
end
