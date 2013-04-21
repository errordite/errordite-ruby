require 'spec_helper'

describe Errordite do
  let(:config) { double('config') }

  before :each do
    Errordite.config = nil
    Errordite::Config.stub(:new).and_return(config)
  end

  it 'builds a new Config instance if none set' do
    Errordite::Config.should_receive(:new).and_return(config)
    expect(Errordite.config).to eql(config)
  end

  it 'returns same Config instance if asked multiple times' do
    expect(Errordite.config).to equal(Errordite.config)
  end

  [:api_token].each do |method|
    it "delegates getting #{method} to config instance" do
      result = double('result')
      config.should_receive(method).and_return(result)
      expect(Errordite.__send__(method)).to equal(result)
    end

    it "delegates setting #{method} to config instance" do
      argument = double('argument')
      result = double('result')
      config.should_receive("#{method}=").with(argument).and_return(result)
      expect(Errordite.__send__("#{method}=", argument)).to equal(result)
    end
  end
end