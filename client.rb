libx = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(libx) unless $LOAD_PATH.include?(libx)

require "bundler"
Bundler.require(:default)


require 'calculator_services_pb'
require 'logger'

def logger
  @logger ||= Logger.new(STDOUT)
  @logger.level = Logger::INFO

  @logger
end


def app
  logger
  @logger.info "Starting gRPC client..."

  while true do
    client = Calculator::Stub.new('server:50051', :this_channel_is_insecure)

    begin
      response = client.add(CalculatorRequest.new(x: 1, y: 2)).result
      p "This should be 3 => #{response}"
    rescue GRPC::BadStatus => e
      abort "ERROR: #{e.message}"
    end

    sleep 1000
  end
end

app