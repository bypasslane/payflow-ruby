require 'spec_helper'

describe Payflow::Request do
  describe "initializing" do
    it "should build a sale request on action capture" do
      request = Payflow::Request.new(:sale, 100, "CREDITCARDREF")
      request.pairs.trxtype.should eql('S')
    end

    it "should build a capture request on action capture" do
      request = Payflow::Request.new(:capture, 100, "CREDITCARDREF")
      request.pairs.trxtype.should eql('D')
    end

    describe "with an encrypted credit_card" do
      it "should add ENCTRACK2 to the request pairs" do
        credit_card = Payflow::CreditCard.new(encrypted_track_data: "SUPERENCRYPTEDTRACKDATA", track2: "Heya")
        request = Payflow::Request.new(:sale, 100, credit_card)
        request.pairs.enctrack2.present?.should be(true)
      end
    end
  end

  it "should be in test? if asked" do
    request = Payflow::Request.new(:sale, 100, "CREDITCARDREF", {test: true})
    request.test?.should be(true)
  end

  describe "commiting" do
    it "should call connection post" do
      request = Payflow::Request.new(:sale, 100, "CREDITCARDREF", {test: true})
      connection = stub
      connection.should_receive(:post).and_return(OpenStruct.new(status: 200, body: "<ResponseData><TransactionResult><AMount>12</AMount></TransactionResult></ResponseData>"))
      request.stub(:connection).and_return(connection)
      request.commit
    end

    it "should return a Payflow::Response" do
      request = Payflow::Request.new(:sale, 100, "CREDITCARDREF", {test: true})
      connection = stub
      connection.should_receive(:post).and_return(OpenStruct.new(status: 200, body: "<ResponseData><TransactionResult><AMount>12</AMount></TransactionResult></ResponseData>"))
      request.stub(:connection).and_return(connection)
      request.commit.should be_a(Payflow::Response)
    end
  end

end