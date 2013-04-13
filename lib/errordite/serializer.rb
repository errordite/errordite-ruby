require 'errordite'
require 'json'

class Errordite::Serializer
  SPECIAL_CONTEXT_ATTRIBUTES = ['MachineName', 'Url', 'UserAgent', 'Version']

  attr_reader :exception, :context

  def initialize(exception, context = {})
    @exception = exception
    @context = context
  end

  def as_json
    special_attributes.merge(
      "Token" => Errordite.api_token,
      "TimestampUtc" => Time.now.strftime("%Y-%m-%d %H:%M:%S"),
      "ExceptionInfo" => {
        "Source" => source,
        "MethodName" => method_name,
        "ExceptionType" => exception.class.name,
        "StackTrace" => stack_trace,
        "Data" => exception_data
      }
    )
  end

  def to_json
    JSON.dump(as_json)
  end

  private

  def special_attributes
    context.select {|k, v| SPECIAL_CONTEXT_ATTRIBUTES.include?(k) }
  end

  def exception_data
    context.reject {|k, v| SPECIAL_CONTEXT_ATTRIBUTES.include?(k) }
  end

  def timestamp
    Time.now.strftime("%Y-%m-%d %H:%M:%S")
  end

  def stack_trace
    exception.backtrace && exception.backtrace.join("\n")
  end

  def source
    split_first_line && split_first_line[1]
  end

  def method_name
    split_first_line && split_first_line[3]
  end

  def split_first_line
    @split_first_line ||= exception.backtrace && exception.backtrace[0] && exception.backtrace[0].match(/^(.*?)(?:\:(\d+))(?:\:in `(.*)')?$/)
  end
end