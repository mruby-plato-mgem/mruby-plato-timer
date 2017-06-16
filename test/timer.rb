# Plato::Timer class

assert('Timer', 'class') do
  assert_equal(Plato::Timer.class, Class)
end

assert('Timer', 'superclass') do
  assert_equal(Plato::Timer.superclass, Object)
end

assert('Timer', 'add') do
  ts = Plato::Timer.class_variable_get(:@@timer)
  ts.clear
  assert_equal(Plato::Timer.add(100, Proc.new {}), 1)
  assert_equal(Plato::Timer.add(200, Proc.new {}, 'test'), 2)
  assert_equal(ts.size, 2)
  assert_nil(ts[0].instance_variable_get(:@target))
  assert_nil(ts[1].instance_variable_get(:@target))
end

assert('Timer', 'delete') do
  ts = Plato::Timer.class_variable_get(:@@timer)
  ts.clear
  id0 = Plato::Timer.add(100, Proc.new {})
  id1 = Plato::Timer.add(200, Proc.new {}, 'test')
  Plato::Timer.delete(id0)
  id2 = Plato::Timer.add(300, Proc.new {})
  assert_equal(id2, 3)
  assert_nil(ts[0])
  assert_true(ts[1] && ts[2])
end

assert('Timer', 'start') do
  ts = Plato::Timer.class_variable_get(:@@timer)
  ts.clear
  id0 = Plato::Timer.add(100, Proc.new {})
  id1 = Plato::Timer.add(200, Proc.new {})
  t = Plato::Machine.millis
  Plato::Timer.start(id0)
  assert_equal(ts[0].instance_variable_get(:@target), t + 100)
  assert_nil(ts[1].instance_variable_get(:@target))
  t = Plato::Machine.millis
  Plato::Timer.start
  assert_equal(ts[0].instance_variable_get(:@target), t + 100)
  assert_equal(ts[1].instance_variable_get(:@target), t + 200)
end

assert('Timer', 'stop') do
  ts = Plato::Timer.class_variable_get(:@@timer)
  ts.clear
  id0 = Plato::Timer.add(100, Proc.new {})
  id1 = Plato::Timer.add(200, Proc.new {})
  t = Plato::Machine.millis
  Plato::Timer.start
  Plato::Timer.stop(id0)
  assert_nil(ts[0].instance_variable_get(:@target))
  assert_equal(ts[1].instance_variable_get(:@target), t + 200)
  Plato::Timer.stop
  assert_nil(ts[0].instance_variable_get(:@target))
  assert_nil(ts[1].instance_variable_get(:@target))
end

assert('Timer', 'refresh') do
  ts = Plato::Timer.class_variable_get(:@@timer)
  ts.clear
  ary = []
  id0 = Plato::Timer.add(100, Proc.new {|a| a << 0}, ary)
  id1 = Plato::Timer.add(200, Proc.new {|a| a << 1}, ary)
  id2 = Plato::Timer.add(300, Proc.new {|a| a << 2}, ary)
  id3 = Plato::Timer.add(400, Proc.new {|a| a << 3}, ary)
  t = Plato::Machine.millis
  Plato::Timer.start
  Plato::Timer.refresh
  assert_equal(ary, [])
  Plato::Machine.delay(100)
  Plato::Timer.refresh    # id0
  assert_equal(ary, [0])
  Plato::Machine.delay(100)
  Plato::Timer.refresh    # id0, id1
  assert_equal(ary, [0, 0, 1])
  Plato::Timer.stop(id2)
  Plato::Machine.delay(100)
  Plato::Timer.refresh    # id0 (id2 stopped)
  assert_equal(ary, [0, 0, 1, 0])
  Plato::Machine.delay(100)
  Plato::Timer.refresh    # id0, id1, id3
  assert_equal(ary, [0, 0, 1, 0, 0, 1, 3])
end
