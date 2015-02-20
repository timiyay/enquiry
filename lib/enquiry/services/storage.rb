require 'redis'

module Enquiry
  # StorageService
  #
  # Provides a proxy to data persistence services - in this case, Redis.
  class StorageService
    attr_reader :store

    def initialize(store: nil)
      @store ||= store || init_store
    end

    def get(key)
      @store.get key
    end

    def set(key, value)
      @store.set key, value
    end

    private

    def init_store
      Redis.new url: ENV['ENQUIRY_REDIS_URL']
    end
  end
end
