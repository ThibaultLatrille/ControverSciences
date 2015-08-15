if PeekBar.available?
  Peek.into Peek::Views::GC
  Peek.into Peek::Views::PerformanceBar
  Peek.into Peek::Views::PG
end