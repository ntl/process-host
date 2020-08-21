ProcessHost - supervisor
  Isolate::Process
    * Inputs: thread, start_mutex
    * `.assure_transferrable(*args)`
      - TrueClass, FalseClas, NilClass, Integer, Float, Symbol, String, Array, Hash, Mutex, Queue
    * `.build(*args, &block)`
      - Constructs a locked mutex
      - Ensures all arguments are transferrable
      - Starts a thread, passing the locked mutex as first arg, then other args
      - Instantiates
    * `#start` - releases start_mutex
    * `.start` - `.build` then `#start`
  Isolate - isolates a process within a thread (someday, RbActor)
    * Inputs: process
    * `#start` - starts process
    * `#terminate` - kills the process abruptly
    * `#stop(timeout=nil)` - graceful shutdown (terminates when timeout exceeded)
    * `#status` - `ready`, `active`, `failed`, `finished`, `stopping`, `stopped`, `terminated`
      - Based on internal state and whether thread is active/alive/dead
    * `.build() do … end`
      - The block is what gets started
  Process - framework module
    * Implements: `#start`
    * Template method: `#next`
  Process::Build - constructs a process (assuring arguments are primitives; `#new` or `#build`)
  Start - starts one or more processes
    * multiple processes get assigned to different isolates

# Blocks execution
some_process = SomeProcess.build("someStream-123", batch_size: 111)
some_process.start

# If there is no supervisor running, build and start
# If there is a supervisor running, start in an isolated process
some_process = SomeProcess.start("someStream-123", batch_size: 111)

# All arguments to a process must be primitive, i.e. one of the
# following classes:
#
#   TrueClass
#   FalseClass
#   NilClass
#   Integer
#   Float
#   Symbol
#   String
#   Array (of primitives)
#   Hash (of primitives)
#   Mutex / Queue (/ SizedQueue)

assert_raises(ProcessHost::Error) do
  SomeProcess.start(SomeClass.new)
end
