module Spree
  Variant.class_eval do

    def option_value(name)
      Rails.cache.fetch(option_value_cache_key(name)) do
        option_value_by_name(name).try(:presentation)
      end
    end

    def option_value_name(name)
      Rails.cache.fetch(option_name_cache_key(name)) do
        option_value_by_name(name).try(:name)
      end
    end

    def option_value_cache_key(name)
      "variant-#{id}-option_value-#{name}"
    end

    def option_name_cache_key(name)
      "variant-#{id}-option_name-#{name}"
    end

    def clear_options_cache
      option_values.joins(:option_type).each do |ov|
        name = ov.option_type.name
        Rails.cache.delete(option_value_cache_key(name))
        Rails.cache.delete(option_name_cache_key(name))
      end
    end

  private

    def option_value_by_name(name)
      option_values.joins(:option_type)
        .where('spree_option_types.name = ?', name).first
    end

  end
end