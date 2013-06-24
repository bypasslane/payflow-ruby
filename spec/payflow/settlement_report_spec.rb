require 'spec_helper'

describe Payflow::SettlementReport do
  it "sets the report id if successful" do
    report = Payflow::SettlementReport.new(OpenStruct.new(login: "username", password: "pass", partner: "Paypal"))

    response = Payflow::MockReportResponse.new("")
    report.stub(:commit).and_return(response)
    report.create_report("PROCESSOR")

    response.report_id.should eql("MOCK_ID")
  end
end