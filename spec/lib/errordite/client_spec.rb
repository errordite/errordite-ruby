require 'spec_helper'

describe Errordite::Client do
  let(:connection) { double(:connection) }

  it 'sends json to the server by posting through a new connection' do
    Errordite::Client::Connection.stub(:new).and_return(connection)
    path = '/receiveerror'
    body = '{}'
    connection.should_receive(:post).with(
      '/receiveerror', '{}', 'Content-Type' => 'application/json; charset=utf-8', 'Content-Length' => '2'
    )
    Errordite::Client.new.send_json(path, body)
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