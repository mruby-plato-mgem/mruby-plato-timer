#
# Plato::Timer class
#
module Plato
  class Timer
    include Machine

    @@timer = []

    def self.add(ms, proc, arg=nil)
      @@timer << self.new(ms, proc, arg)
      @@timer.size # Timer ID
    end

    def self.delete(id)
      @@timer[id-1] = nil
    end

    def self.start(id=nil)
      tick = Machine.millis
      if id.nil?
        @@timer.each {|t| t.start(tick) if t}
      else
        t = @@timer[id-1]
        t.start(tick) if t
      end
    end

    def self.stop(id=nil)
      if id.nil?
        @@timer.each {|t| t.stop if t}
      else
        t = @@timer[id-1]
        t.stop if t
      end
    end

    def self.refresh
      tick = Machine.millis
      @@timer.each {|t| t.refresh(tick) if t}
    end

    def initialize(tmo, handler, arg)
      @tmo = tmo
      @handler = handler
      @arg = arg
      @target = nil
    end

    def start(tick)
      @target = tick + @tmo
    end

    def stop
      @target = nil
    end

    def refresh(tick)
      if @target && @target <= tick
        @handler.call(@arg)
        start(@target)
      end
    end
  end
end
