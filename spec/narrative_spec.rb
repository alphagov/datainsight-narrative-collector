require 'bunny'
require_relative '../lib/narrative'
require_relative 'spec_helper'

describe "a narrative collector" do
  before(:each) do
    @collector = Collectors::NarrativeCollector.new
  end

  it "when printed should contains a valid JSON document" do
    @collector.stub(:response).and_return(@collector.create_message("message", "bob"))

    JSON.parse(@collector.print).keys.should == ["envelope", "payload"]
  end

  it "when printed should return the correct message" do
    @collector.stub(:response).and_return(@collector.create_message("message", "bob"))

    payload = JSON.parse(@collector.print)["payload"]

    payload["content"].should == "message"
    payload["author"].should == "bob"
  end

  it "should log an error, if message cannot be created" do
    @collector.stub(:response).and_raise("Error!")
    Logging.logger[@collector].should_receive(:error)

    @collector.print
  end

  it "when broadcast should connect to the exchange correctly" do
    @collector.stub(:response)

    exchange= mock('exchange')
    exchange.should_receive(:publish).with("null", :key => 'googledrive.narrative')

    rabbit = mock('bunny')
    rabbit.should_receive(:start)
    rabbit.should_receive(:stop)
    rabbit.should_receive(:exchange).with('datainsight', :type => :topic).and_return exchange
    Bunny.should_receive(:new).and_return rabbit

    @collector.broadcast
  end

end
