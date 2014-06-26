module Spree
  OptionValue.class_eval do
    after_touch :bust_cache_for_all_variants

  private

    def bust_cache_for_all_variants
      name = option_type.name
      variants.each do |v|
        Rails.cache.delete(v.option_value_cache_key(name))
        Rails.cache.delete(v.option_name_cache_key(name))
      end
    end

  end
end