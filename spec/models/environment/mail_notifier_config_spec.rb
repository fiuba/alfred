require 'spec_helper'

describe "MailNotifierConfig" do

  describe "set of values" do
    describe "with empty content" do
      it "should response an empty array" do
        MailNotifierConfig.stored_values('').should == []
      end
    end

    describe "with nil content" do
      it "should response an empty array" do
        MailNotifierConfig.stored_values(nil).should == []
      end
    end

    describe "with content" do
      it "should response a collection of symbols" do
        MailNotifierConfig.stored_values('value01,value02').should ==
                [ :value01, :value02 ]
      end
    end

  end

  describe "has_to_send_notification_of_test_result" do
    describe "environment variable is not set" do
      it { MailNotifierConfig
            .has_to_prevent_notification_for(:test_result).should == false }
    end

    describe "environment variable is set" do
      before do 
        ENV['MAIL_PREVENT_NOTIFICATION_FOR'] = 'test_result'
      end

      it { MailNotifierConfig
            .has_to_prevent_notification_for( :test_result ).should == true }
    end
  end
end

