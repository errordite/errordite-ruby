require 'spec_helper'

describe Errordite::Config do
  subject { Errordite::Config.new }
  let(:client) { double('client') }

  it 'uses www.errordite.com as default server' do
    expect(subject.server).to eql('www.errordite.com')
  end

  it 'allows server to be set' do
    subject.server = 'errordite.example.com'
    expect(subject.server).to eql('errordite.example.com')
  end

  it 'uses 443 as default port' do
    expect(subject.port).to eql(443)
  end

  it 'allows port to be set' do
    subject.port = 80
    expect(subject.port).to eql(80)
  end

  it 'uses ERRORDITE_TOKEN environment variable as default api token' do
    ENV['ERRORDITE_TOKEN'] = 'token-from-environment'
    expect(subject.api_token).to eql('token-from-environment')
  end

  it 'allows api token to be set' do
    ENV['ERRORDITE_TOKEN'] = 'token-from-environment'
    subject.api_token = 'overidden-token'
    expect(subject.api_token).to eql('overidden-token')
  end

  it 'builds client with server and port' do
    subject.server = 'errordite.example.com'
    subject.port = 123
    Errordite::Client.should_receive(:new).with('errordite.example.com', 123).and_return(client)
    expect(subject.client).to eql(client)
  end

  it 'memoizes client' do
    Errordite::Client.stub(:new).and_return(client)
    expect(subject.client).to eql(client)
    expect(subject.client).to eql(client)
  end

  it 'allows custom client to be set' do
    custom_client = double('custom-client')
    subject.client = custom_client
    expect(subject.client).to eql(custom_client)
  end
end