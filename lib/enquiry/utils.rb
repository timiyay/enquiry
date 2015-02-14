module Enquiry
  module Utils
    module_function

    def symbolize_keys(hash)
      # adaption from Avdi Grimm's Virtuous Code blog,
      # using #each_with_object instead of #inject
      # http://devblog.avdi.org/2009/07/14/recursively-symbolize-keys/
      hash.each_with_object({}) do |(key, value), result|
        new_key = case key
                  when String then key.to_sym
                  else key
                  end
        new_value = case value
                    when Hash then symbolize_keys(value)
                    else value
                    end
        result[new_key] = new_value
        result
      end
    end
  end
end
