require "fire/version"
require 'fire/request'

module FireAndForget
  def self.get(url, headers={})
    Request.new(:method => :get, :url => url, :headers => headers).execute
  end

  def self.post(url, payload, headers={})
    Request.new(:method => :post, :url => url, :payload => payload, :headers => headers).execute
  end

  def self.patch(url, payload, headers={})
    Request.new(:method => :patch, :url => url, :payload => payload, :headers => headers).execute
  end

  def self.put(url, payload, headers={})
    Request.new(:method => :put, :url => url, :payload => payload, :headers => headers).execute
  end

  def self.delete(url, headers={})
    Request.new(:method => :delete, :url => url, :headers => headers).execute
  end

  def self.head(url, headers={})
    Request.new(:method => :head, :url => url, :headers => headers).execute
  end

  def self.options(url, headers={})
    Request.new(:method => :options, :url => url, :headers => headers).execute
  end
end

FAF = FireAndForget
