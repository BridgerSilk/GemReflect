require 'json'
require 'socketry'

config_data = File.read('/own/root/gem-config.json')
config_hash = JSON.parse(config_data)
server_port = config_hash.fetch['port', '25565']

puts server_port # test

class Connection < Socketry::TCPSocket
	def initialize(socket)
		super(socket)
		# Additional initialization for the connection if needed
	end
	def on_error(err)
		return if err.is_a?(Errno::ECONNRESET) || err.is_a?(Errno::ECONNABORTED)
		puts "Socket Error: #{err}"
	end
end

server = Socketry::TCPServer.new('0.0.0.0', 25565)

server.on(:accept) do |client|
	connection = Connection.new(client)
	connection.on(:error) do |err|
		connection.on_error(err)
	end
end

begin
    server.start
    puts "Minecraft server started on port #{server_port}"
rescue StandardError => e
    puts "Error starting Minecraft server: #{e.message}"
end