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

class CalculatorService < Calculator::Service
  def add(request, _unused_call)
    CalculatorResponse.new(result: request.x + request.y)
  end
end

def app
  logger

  @logger.info "Starting gRPC server..."
  s = GRPC::RpcServer.new
  @logger.info s
  s.add_http2_port('0.0.0.0:50051', :this_port_is_insecure)
  @logger.info "Running server..."
  s.handle(CalculatorService)
  s.run_till_terminated_or_interrupted([1, 'int', 'SIGINT', 'SIGQUIT', 'SIGTERM'])
  @logger.info "Server stopped."
end

app
