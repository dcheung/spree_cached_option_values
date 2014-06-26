require 'spec_helper'

describe Spree::Variant do

  let(:variant) { create(:variant) }
  let(:option_values) { variant.option_values }
  let(:option_value) {  option_values.first }
  let(:option_type) { option_value.option_type }

  after :each do
    Rails.cache.clear
  end

  describe "#option_value" do

    let(:cache_key) { "variant-#{variant.id}-option_value-#{option_type.name}" }

    it "should get the option value by name and return the presentation value" do
      variant.option_value(option_type.name).should == option_value.presentation
    end

    it "will use a unique cache key" do
      variant.should_receive(:option_value_cache_key)
        .with(option_type.name) { cache_key }
      variant.option_value(option_type.name)
    end

    it "will use the Rails cache to fetch the value" do
      Rails.cache.should_receive(:fetch).with(cache_key)
      variant.option_value(option_type.name)
    end

  end

  describe "#option_value_name" do

    let(:cache_key) { "variant-#{variant.id}-option_name-#{option_type.name}" }

    it "should get the option value by name and return the name value" do
      variant.option_value_name(option_type.name).should == option_value.name
    end

    it "will use a unique cache key" do
      variant.should_receive(:option_name_cache_key)
        .with(option_type.name) { cache_key }
      variant.option_value_name(option_type.name)
    end

    it "will use the Rails cache to fetch the value" do
      Rails.cache.should_receive(:fetch).with(cache_key)
      variant.option_value_name(option_type.name)
    end

  end

  describe "#clear_options_cache" do

    it "will called for each option_value twice" do
      Rails.cache.should_receive(:delete).at_least(option_values.size * 2).times
      variant.clear_options_cache
    end

  end

end