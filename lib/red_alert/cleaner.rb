module RedAlert
  class Cleaner
    FILTERED_TEXT = '[REMOVED]'
    RECURSIVE_TEXT = '[RECURSIVE STRUCTURE]'

    attr_reader :filter_keys

    def initialize(filter_keys)
      @filter_keys = filter_keys.to_set
    end

    def scrub(params)
      formatted = format(params)
      formatted.each do |key, value|
        if filter_keys.include? key
          formatted[key] = FILTERED_TEXT
        elsif value.respond_to? :to_hash
          formatted[key] = scrub value
        end
      end
    end

    def format(value, stack = Set.new)
      return RECURSIVE_TEXT if stack.include? value.object_id

      if value.respond_to? :to_ary
        value.map{|v| format v, stack + [value.object_id]}
      elsif value.respond_to? :to_hash
        value.each_with_object({}){|(k,v), memo| memo[k] = format v, stack + [value.object_id]}
      else
        value.nil? ? nil : value.to_s
      end
    end
  end
end
