require 'spec_helper'

class MockLogger
  def error(message)
    puts message
  end
end

class Rails
  @logger = MockLogger.new
  class << self
    attr_accessor :logger    
  end
end

class MockStdout
  attr_reader :results

  def initialize
    @results = []
  end

  def write(msg)
    @results << msg
  end
end

describe RailsErrHandler do
  before do
    mock_out = MockStdout.new
    $stdout = mock_out
    begin
      raise StandardError, "error test"
    rescue => err
      @err = err
      @return_err = RailsErrHandler.handle(err)
      @results = mock_out.results
    ensure
      $stdout = STDOUT
    end
  end
  
  it 'has a version number' do
    expect(RailsErrHandler::VERSION).not_to be nil
  end

  it 'output the error message' do
    expect(@results[0]).to eq "error test"
  end

  it 'output the error back trace' do
    expect(@results[2]).to eq @err.backtrace.join("\n")
  end

  it 'returns original error' do
    expect(@return_err).to eq(@err)
  end
end
