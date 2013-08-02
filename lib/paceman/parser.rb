
module Paceman
    class Parser
        #
        # Initializes the Parser instance.
        #
        # @param [Paceman::HttpParser::HttpParser] ptr
        #   Optional pointer to an existing `http_parser` struct.
        #
        def initialize
            @settings = HttpParser::Settings.new
            yield self if block_given?
        end

        #
        # Registers an `on_message_begin` callback.
        #
        # @yield []
        #   The given block will be called when the HTTP message begins.
        #
        def on_message_begin(&block)
            assert_block(block)
            assert_arity(1, block)
            @settings[:on_message_begin] = Callback.new(&block)
        end

        #
        # Registers an `on_url` callback.
        #
        # @yield [url]
        #   The given block will be called when the Request URI is recognized
        #   within the Request-Line.
        #
        # @yieldparam [String] url
        #   The recognized Request URI.
        #
        # @see http://www.w3.org/Protocols/rfc2616/rfc2616-sec5.html#sec5.1.2
        #
        def on_url(&block)
            assert_block(block)
            assert_arity(2, block)
            @settings[:on_url] = DataCallback.new(&block)
        end

        #
        # Registers an `on_status_complete` callback.
        #
        # @yield []
        #   The given block will be called when the status is recognized.
        #
        def on_status_complete(&block)
            assert_block(block)
            assert_arity(1, block)
            @settings[:on_status_complete] = Callback.new(&block)
        end

        #
        # Registers an `on_header_field` callback.
        #
        # @yield [field]
        #   The given block will be called when a Header name is recognized
        #   in the Headers.
        #
        # @yieldparam [String] field
        #   A recognized Header name.
        #
        # @see http://www.w3.org/Protocols/rfc2616/rfc2616-sec4.html#sec4.5
        #
        def on_header_field(&block)
            assert_block(block)
            assert_arity(2, block)
            @settings[:on_header_field] = DataCallback.new(&block)
        end

        #
        # Registers an `on_header_value` callback.
        #
        # @yield [value]
        #   The given block will be called when a Header value is recognized
        #   in the Headers.
        #
        # @yieldparam [String] value
        #   A recognized Header value.
        #
        # @see http://www.w3.org/Protocols/rfc2616/rfc2616-sec4.html#sec4.5
        #
        def on_header_value(&block)
            assert_block(block)
            assert_arity(2, block)
            @settings[:on_header_value] = DataCallback.new(&block)
        end

        #
        # Registers an `on_headers_complete` callback.
        #
        # @yield []
        #   The given block will be called when the Headers stop.
        #
        def on_headers_complete(&block)
            assert_block(block)
            assert_arity(1, block)
            @settings[:on_headers_complete] = Callback.new(&block)
        end

        #
        # Registers an `on_body` callback.
        #
        # @yield [body]
        #   The given block will be called when the body is recognized in the
        #   message body.
        #
        # @yieldparam [String] body
        #   The full body or a chunk of the body from a chunked
        #   Transfer-Encoded stream.
        #
        # @see http://www.w3.org/Protocols/rfc2616/rfc2616-sec4.html#sec4.5
        #
        def on_body(&block)
            assert_block(block)
            assert_arity(2, block)
            @settings[:on_body] = DataCallback.new(&block)
        end

        #
        # Registers an `on_message_begin` callback.
        #
        # @yield []
        #   The given block will be called when the message completes.
        #
        def on_message_complete(&block)
            assert_block(block)
            assert_arity(1, block)
            @settings[:on_message_complete] = Callback.new(&block)
        end

        #
        # Parses data.
        #
        # @param [String] data
        #   The data to parse.
        #
        # @return [Integer]
        #   The number of bytes parsed. `0` will be returned if the parser
        #   encountered an error.
        #
        def parse(parser, data)
            HttpParser.http_parser_execute(parser, @settings, data, data.length)
            return !parser.error?
        end


        protected


        class Callback < Proc
            #
            # Creates a new Parser callback.
            #
            def self.new(&block)
                super do |parser|
                    catch(:return) { yield(parser); 0 }
                end
            end
        end

        class DataCallback < Proc
            def self.new(&block)
                super do |parser, buffer, length|
                    data = buffer.get_bytes(0, length)
                    catch(:return) { yield(parser, data); 0 }
                end
            end
        end
    end
end
