require 'http-parser'

describe HttpParser::Parser, "#initialize" do
    before :each do
        @inst = HttpParser::Parser.new_instance
    end

    it "should return true when error" do
        subject.parse(@inst, "GETS / HTTP/1.1\r\n").should be_true
        @inst.error?.should be_true
    end

    it "should return false on success" do
        subject.parse(@inst, "GET / HTTP/1.1\r\n").should be_false
        @inst.error?.should be_false
    end

    it "the error should be inspectable" do
        subject.parse(@inst, "GETS / HTTP/1.1\r\n").should be_true
        @inst.error.should be_kind_of(::HttpParser::Error::INVALID_METHOD)
        @inst.error?.should be_true
    end

    it "raises different error types depending on the error" do
        subject.parse(@inst, "GET / HTTP/23\r\n").should be_true
        @inst.error.should be_kind_of(::HttpParser::Error::INVALID_VERSION)
        @inst.error?.should be_true
    end

    context "callback errors" do
        subject do
            described_class.new do |parser|
                parser.on_url { |inst, data| raise 'unhandled' }
            end
        end

        it "should handle unhandled errors gracefully" do
            subject.parse(@inst, "GET /foo?q=1 HTTP/1.1").should be_true

            @inst.error?.should be_true
            @inst.error.should be_kind_of(::HttpParser::Error::CALLBACK)
        end
    end
end

