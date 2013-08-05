require 'http-parser'

describe ::HttpParser::Instance, "#initialize" do
    context "when initialized from a pointer" do
        it "should not call http_parser_init" do
            ptr = described_class.new.to_ptr

            ::HttpParser.should_not_receive(:http_parser_init)

            described_class.new(ptr)
        end
    end

    context "when given a block" do
        it "should yield the new Instance" do
            expected = nil

            described_class.new { |inst| expected = inst }

            expected.should be_kind_of(described_class)
        end

        it "should allow changing the parser type" do
            inst = described_class.new do |inst|
                inst.type = :request
            end

            inst.type.should == :request
        end
    end

    describe "#type" do
        it "should default to :both" do
            subject.type.should == :both
        end

        it "should convert the type to a Symbol" do
            subject[:type_flags] = ::HttpParser::TYPES[:request]

            subject.type.should == :request
        end

        it "should extract the type from the type_flags field" do
            subject[:type_flags] = ((0xff & ~0x3) | ::HttpParser::TYPES[:response])

            subject.type.should == :response
        end
    end

    describe "#type=" do
        it "should set the type" do
            subject.type = :response

            subject.type.should == :response
        end

        it "should not change flags" do
            flags = (0xff & ~0x3)
            subject[:type_flags] = flags

            subject.type = :request

            subject[:type_flags].should == (flags | ::HttpParser::TYPES[:request])
        end
    end

    describe "#stop!" do
        it "should throw :return, 1" do
            lambda { subject.stop! }.should throw_symbol(:return,1)
        end
    end

    describe "#error!" do
        it "should throw :return, -1" do
            lambda { subject.error! }.should throw_symbol(:return,-1)
        end
    end

    describe "#reset!" do
        it "should call http_parser_init" do
            inst = described_class.new

            ::HttpParser.should_receive(:http_parser_init)

            inst.reset!
        end
    end

    it "should not change the type" do
        inst = described_class.new do |inst|
            inst.type = :request
        end

        inst.reset!
        inst.type.should == :request
    end
end

