require 'spec_helper'

describe Errordite::Serializer do
  describe '(in general)' do
    let(:context) { Hash.new }
    let(:exception) { Exception.new }
    let(:serializer) { Errordite::Serializer.new(exception, context) }

    it 'includes Token taken from Errordite.api_token' do
      Errordite.stub(:api_token).and_return("AnApiToken")
      expect(serializer.as_json['Token']).to eql('AnApiToken')
    end

    it 'takes TimestampUtc from the current time' do
      Time.stub(:now).and_return(Time.utc(2013, 3, 4, 12, 34, 56))
      expect(serializer.as_json['TimestampUtc']).to eql('2013-03-04 12:34:56')
    end

    it 'takes Source from backtrace file' do
      exception.stub(:backtrace).and_return(["/path/to/file/example.rb:80:in `hello'"])
      expect(serializer.as_json['ExceptionInfo']['Source']).to eql('/path/to/file/example.rb')
    end

    it 'takes MethodName from backtrace method' do
      exception.stub(:backtrace).and_return(["/path/to/file/example.rb:80:in `hello'"])
      expect(serializer.as_json['ExceptionInfo']['MethodName']).to eql('hello')
    end

    it 'takes ExceptionType from exception class' do
      exception.stub(:class).and_return(FloatDomainError)
      expect(serializer.as_json['ExceptionInfo']['ExceptionType']).to eql('FloatDomainError')
    end

    it 'takes Message from exception message' do
      exception.stub(:message).and_return("My message is this")
      expect(serializer.as_json['ExceptionInfo']['Message']).to eql('My message is this')
    end

    ['MachineName', 'Url', 'UserAgent', 'Version'].each do |special_attribute|
      it "adds #{special_attribute} to top level if included in context" do
        context[special_attribute] = "special-attribute-value"
        expect(serializer.as_json[special_attribute]).to eql("special-attribute-value")
      end
    end

    it "adds other unknown attributes to exception data when included in context" do
      context["Anything"] = "anything-value"
      context["Something"] = "something-value"
      expect(serializer.as_json["ExceptionInfo"]["Data"]).to eql({
        "Anything" => "anything-value",
        "Something" => "something-value"
      })
    end

    it 'forms StackTrace using backtrace joined with newlines' do
      exception.stub(:backtrace).and_return(["first-line", "second-line"])
      expect(serializer.as_json['ExceptionInfo']['StackTrace']).to eql("first-line\nsecond-line")
    end

    it 'is serializable as JSON' do
      serializer.stub(:as_json).and_return(:as_json_result)
      JSON.should_receive(:dump).with(:as_json_result).and_return(:serialized_json)
      expect(serializer.to_json).to eql(:serialized_json)
    end
  end
end