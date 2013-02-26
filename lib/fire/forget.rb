require "fire/version"
require 'fire/request'

module FireAndForget
  def self.get(url, headers={}, &block)
    Request.new(:method => :get, :url => url, :headers => headers, :callback => block).execute
  end

  def self.post(url, payload, headers={}, &block)
    Request.new(:method => :post, :url => url, :payload => payload, :headers => headers, :callback => block).execute
  end

  def self.patch(url, payload, headers={}, &block)
    Request.new(:method => :patch, :url => url, :payload => payload, :headers => headers, :callback => block).execute
  end

  def self.put(url, payload, headers={}, &block)
    Request.new(:method => :put, :url => url, :payload => payload, :headers => headers, :callback => block).execute
  end

  def self.delete(url, headers={}, &block)
    Request.new(:method => :delete, :url => url, :headers => headers, :callback => block).execute
  end

  def self.head(url, headers={}, &block)
    Request.new(:method => :head, :url => url, :headers => headers, :callback => block).execute
  end

  def self.options(url, headers={}, &block)
    Request.new(:method => :options, :url => url, :headers => headers, :callback => block).execute
  end
end

FAF = FireAndForget
