class EventLoop
  class NOT_RUNNING; end
  class RUNNING; end

  def initialize
    @callbacks = []
  end

  def each_tick(&block)
    @callbacks << block
  end

  def start
    @state = RUNNING
    while @state == RUNNING
      @callbacks.each &:call
    end
  end

  def stop
    @state = NOT_RUNNING
  end
end
