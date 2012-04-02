require_relative "../lib/grid"

describe Grid do
  let(:max)  { Point[2,2] }
  let(:grid) { described_class.new(max) }
  let(:all_points) { 3.times.map {|x| 3.times.map {|y| Point[x, y] }}.flatten }

  def empty_point(x, y)
    [Point[x,y], Grid::EMPTY_POSITION]
  end

  it "can retrieve a set value" do
    grid.set(max, 1)
    grid.get(max).should == 1
  end

  it "is empty by default" do
    grid.each do |point, _|
      grid.should be_empty_at(point)
    end
  end

  it "iterates over the grid: (0,0), (0,1), ..., (2,2)" do
    grid.each do |point, _|
      point.should == all_points.shift
    end
  end

  it "is the correct size" do
    grid.size.should == 9
  end

  it "iterates over the rows: [(0,0), (0,1), (0,2)], [(1,0), ..." do
    grid.each_row.to_a.should == [
        [empty_point(0,0), empty_point(0,1), empty_point(0,2)],
        [empty_point(1,0), empty_point(1,1), empty_point(1,2)],
        [empty_point(2,0), empty_point(2,1), empty_point(2,2)],
    ]
  end

  it "iterates over the columns: [(0,0), (1,0), (2,0)], [(0,1), ..." do
    grid.each_column.to_a.should == [
        [empty_point(0,0), empty_point(1,0), empty_point(2,0)],
        [empty_point(0,1), empty_point(1,1), empty_point(2,1)],
        [empty_point(0,2), empty_point(1,2), empty_point(2,2)],
    ]
  end

  it "iterates over the diagnals: [(0,0), (1,1), (2,2)], [(0,2), (1,1), (2,0)]" do
    grid.each_diagonal.to_a.should == [
        [empty_point(0,0), empty_point(1,1), empty_point(2,2)],
        [empty_point(0,2), empty_point(1,1), empty_point(2,0)]
    ]
  end
end

describe Grid::WriteOnce do
  let(:max)  { Point[2,2] }
  let(:grid) { described_class.new(max) }

  it "does not allow a position to be set twice" do
    grid.set(max, 1)
    expect { grid.set(max, 1) }.to raise_error(Grid::PositionAlreadyTaken)
    grid.get(max).should == 1
  end
end
