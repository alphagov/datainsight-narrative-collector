require 'bunny'
require_relative '../src/leader'
require_relative 'spec_helper'

describe "a leader collector" do
  before(:each) do
    @collector = Collectors::LeaderCollector.new
  end

  it "when printed should contains a valid JSON document" do
    JSON.parse(@collector.print).keys.should == ["envelope", "payload"]
  end

  it "when printed should return the correct message" do
    @collector.stubs(:response).returns(@collector.create_message("message", "bob"))

    payload = JSON.parse(@collector.print)["payload"]

    payload["content"].should == "message"
    payload["author"].should == "bob"
  end

  it "when broadcast should connect to the exchange correctly" do
    @collector.stubs(:response)

    exchange= mock('exchange')
    exchange.expects(:publish).with("null", :key => 'googledrive.leader')

    rabbit = mock('bunny')
    rabbit.expects(:start)
    rabbit.expects(:stop)
    rabbit.expects(:exchange).with('datainsight', :type => :topic).returns exchange
    Bunny.expects(:new).returns rabbit

    @collector.broadcast
  end

end
