require 'spec_helper'

describe Spree::OptionValue do

  let(:variant) { create(:variant) }
  let(:option_values) { variant.option_values }
  let(:option_value) {  option_values.first }
  let(:option_type) { option_value.option_type }

  describe "#bust_cache_for_all_variants" do

    it "will be called on touch of the option_value" do
      option_value.should_receive(:bust_cache_for_all_variants)
      option_value.touch
    end

    it "will clear the variants name and value cache for each variant" do
      Rails.cache.should_receive(:delete).at_least(2).times
      option_value.touch
    end

  end

end