require 'paceman'

describe Paceman::Parser, "#initialize" do
    before :each do
        @inst = Paceman::Parser.new_instance
    end

    it "should return true when no error" do
        subject.parse(@inst, "GET / HTTP/1.1\r\n").should be_true
        @inst.error?.should be_false
    end

    it "should return false on error" do
        subject.parse(@inst, "GETS / HTTP/1.1\r\n").should be_false
        @inst.error?.should be_true
    end

    it "the error should be inspectable" do
        subject.parse(@inst, "GETS / HTTP/1.1\r\n").should be_false
        @inst.error.should be_kind_of(::Paceman::HttpParser::Error::INVALID_METHOD)
        @inst.error?.should be_true
    end

    it "raises different error types depending on the error" do
        subject.parse(@inst, "GET / HTTP/23\r\n").should be_false
        @inst.error.should be_kind_of(::Paceman::HttpParser::Error::INVALID_VERSION)
        @inst.error?.should be_true
    end
end

