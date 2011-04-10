def with_warnings(flag)
  old_verbose, $VERBOSE = $VERBOSE, flag
  yield
ensure
  $VERBOSE = old_verbose
end

def silence_warnings
  with_warnings(nil) { yield }
end

if EM.reactor_running?
  # EM-Synchrony patches for mongo
  silence_warnings do
    class Mongo::Connection
      TCPSocket = ::EventMachine::Synchrony::TCPSocket
      Mutex = ::EventMachine::Synchrony::Thread::Mutex
      ConditionVariable = ::EventMachine::Synchrony::Thread::ConditionVariable
    end
  end
end

silence_warnings do
  # this may cause errors! doublecheck!!!
  module BSON
    class ObjectId
      def as_json(options ={})
        to_s
      end
      def to_json
        to_s
      end
    end
  end
end