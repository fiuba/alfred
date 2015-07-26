require 'spec_helper'

describe "FeatureToggler" do

  describe "is_feature_enable" do

    it "should return true when feature is not disabled" do
      ENV['DISABLED_FEATURES'] = 'f1'
      expect(FeatureToggler.is_feature_enabled('f2')).to be true
    end

    it "should return false when feature is disabled" do
      ENV['DISABLED_FEATURES'] = 'f1'
      expect(FeatureToggler.is_feature_enabled('f1')).to be false
    end
  end
end

