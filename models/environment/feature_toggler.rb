class FeatureToggler

	def self.is_feature_enabled(feature_name)
		if ENV['DISABLED_FEATURES'] 
			return !ENV['DISABLED_FEATURES'].include?(feature_name)
		end
		true
	end
  
end
