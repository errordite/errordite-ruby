require 'spec_helper'

describe Errordite::Client do
  let(:logger) { double(:logger) }
  let(:connection) { double(:connection) }
  let(:response) { double(:response, code: '201', message: 'Created') }

  before :each do
    Errordite::Client::Connection.stub(:new).and_return(connection)
    connection.stub(:post).and_return(response)
  end

  it 'records errors by posting them to /receiveerror' do
    error = double(:error)
    context = double(:context)
    serializer = double(:serializer, to_json: 'json-representation')
    Errordite::Serializer.stub(:new).with(error, context).and_return(serializer)
    subject.should_receive(:post_json).with('/receiveerror', 'json-representation')
    subject.record(error, context)
  end

  it 'sends json to the server by posting through a new connection' do
    path = '/receiveerror'
    body = '{}'
    connection.should_receive(:post).with(
      '/receiveerror', '{}', 'Content-Type' => 'application/json; charset=utf-8', 'Content-Length' => '2'
    ).and_return(response)
    Errordite::Client.new.post_json(path, body)
  end

  it 'logs response if code != 201' do
    client = Errordite::Client.new('server.example.com', 443, logger)
    response.stub(:code).and_return('500')
    response.stub(:message).and_return('Server Error')
    logger.should_receive(:warn)
    client.post_json '/receiveerror', ''
  end

  it 'logs response if log level is debug' do
    client = Errordite::Client.new('server.example.com', 443, logger)
    response.stub(:code).and_return('500')
    response.stub(:message).and_return('Server Error')
    logger.should_receive(:warn)
    client.post_json '/receiveerror', ''
  end
end

describe Errordite::Client::Connection do
  let(:http) { double(:http).as_null_object }

  it 'creates a new verified https connection to the given server and port' do
    Net::HTTP.stub(:new).with('one.example.com', 443).and_return(http)
    http.should_receive(:use_ssl=).with(true)
    http.should_receive(:verify_mode=).with(OpenSSL::SSL::VERIFY_PEER)
    Errordite::Client::Connection.new('one.example.com', 443)
  end

  it 'posts data through the https connection' do
    Net::HTTP.stub(:new).and_return(http)
    arguments = double('arguments')
    http.should_receive(:post).with(arguments)
    Errordite::Client::Connection.new('one.example.com', 443).post(arguments)
  end
end
