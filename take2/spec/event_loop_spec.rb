require_relative "../lib/event_loop"

describe EventLoop do
  it "fires it's callbacks until it is stopped" do
    event_loop = EventLoop.new

    i = 10
    event_loop.each_tick do
      i -= 1
      event_loop.stop if i == 0
    end

    i.should == 10
    event_loop.start
    i.should == 0
  end
end
