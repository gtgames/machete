# EM-Synchrony patches for mongo

def with_warnings(flag)
  old_verbose, $VERBOSE = $VERBOSE, flag
  yield
ensure
  $VERBOSE = old_verbose
end

def silence_warnings
  with_warnings(nil) { yield }
end

silence_warnings do
  class Mongo::Connection
    TCPSocket = ::EventMachine::Synchrony::TCPSocket
    Mutex = ::EventMachine::Synchrony::Thread::Mutex
    ConditionVariable = ::EventMachine::Synchrony::Thread::ConditionVariable
  end
end
