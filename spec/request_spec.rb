require 'spec_helper'

describe FireAndForget::Request do
  describe "#initialize" do

    def new_req(args)
      FireAndForget::Request.new(args)
    end

    def min_valid_args
      {:method => :get, :url => "http://matt.aimonetti.net/"}
    end

    it "requires a method argument" do
     lambda{ new_req({}) }.should raise_error(ArgumentError, "must pass :method")
    end

    it "requires a url argument" do
     lambda{ new_req(:method => :get) }.should raise_error(ArgumentError, "must pass :url")
    end

    it "requires both a method and url" do
      lambda{ new_req(:method => :get, :url => "http://google.com") }.should_not raise_error
    end

    it "takes custom headers" do
      req = new_req(min_valid_args.merge({:headers => {"X-Request-Id" => 42}}))
      req.headers["X-Request-Id"].should eq(42)
    end

    it "has default headers" do
      req = new_req(min_valid_args)
      req.headers.should_not be_nil
      req.headers.should_not be_empty
    end

    describe "content type" do

      it "defaults to json" do
        req = new_req(min_valid_args)
        req.headers['Content-Type'].should eq("application/json")
      end

       it "can be set via argument" do
        req = new_req(min_valid_args.merge(:content_type => 'text/xml'))
        req.content_type.should eq('text/xml')
        req.headers['Content-Type'].should eq('text/xml')
       end

       it "can be set via headers" do
        req = new_req(min_valid_args.merge(:headers => {'Content-Type' => 'text/xml'}))
        req.content_type.should eq('text/xml')
        req.headers['Content-Type'].should eq('text/xml')
      end

    end

    describe "body" do

      it "is extracted from the payload as-is, if passed as a string" do
        text = "this is a test"
        req = new_req(min_valid_args.merge(:payload => text))
        req.body.should eq(text)
      end

      it "becomes an empty string if passed as nil" do
        req = new_req(min_valid_args)
        req.body.should eq("")
      end

      it "is converted to json if it's not a string or nil" do
        payload = {:foo => :bar}
        req = new_req(min_valid_args.merge(:payload => payload))
        req.body.should eq(payload.to_json)
      end
    end

    describe "converted headers" do
      it "are represented as an array of strings" do
        req = new_req(min_valid_args)
        req.processed_headers.each do |header_line|
          header_line.is_a?(String).should eq(true)
          header_line.should match(/.*?:\s.+/)
        end
      end
    end

  end
end
