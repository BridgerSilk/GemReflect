require 'socket'

class Connection
    attr_reader :socket
  
    def initialize(socket)
        @socket = socket
    end
end