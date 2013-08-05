
module HttpParser
    class Parser
        #
        # Returns a new request/response instance variable
        #
        def self.new_instance &block
            ::HttpParser::Instance.new &block
        end


        #
        # Initializes the Parser instance.
        #
        def initialize
            @settings = ::HttpParser::Settings.new
            yield self if block_given?
        end

        #
        # Registers an `on_message_begin` callback.
        #
        # @yield [instance]
        #   The given block will be called when the HTTP message begins.
        #
        # @yieldparam [Paceman::HttpParser::Instance] instance
        #   The state so far of the request / response being processed.
        #
        def on_message_begin(&block)
            @settings[:on_message_begin] = Callback.new(&block)
        end

        #
        # Registers an `on_url` callback.
        #
        # @yield [instance, url]
        #   The given block will be called when the Request URI is recognized
        #   within the Request-Line.
        #
        # @yieldparam [Paceman::HttpParser::Instance] instance
        #   The state so far of the request / response being processed.
        #
        # @yieldparam [String] url
        #   The recognized Request URI.
        #
        # @see http://www.w3.org/Protocols/rfc2616/rfc2616-sec5.html#sec5.1.2
        #
        def on_url(&block)
            @settings[:on_url] = DataCallback.new(&block)
        end

        #
        # Registers an `on_status_complete` callback.
        #
        # @yield [instance]
        #   The given block will be called when the status is recognized.
        #
        # @yieldparam [Paceman::HttpParser::Instance] instance
        #   The state so far of the request / response being processed.
        #
        def on_status_complete(&block)
            @settings[:on_status_complete] = Callback.new(&block)
        end

        #
        # Registers an `on_header_field` callback.
        #
        # @yield [instance, field]
        #   The given block will be called when a Header name is recognized
        #   in the Headers.
        #
        # @yieldparam [Paceman::HttpParser::Instance] instance
        #   The state so far of the request / response being processed.
        #
        # @yieldparam [String] field
        #   A recognized Header name.
        #
        # @see http://www.w3.org/Protocols/rfc2616/rfc2616-sec4.html#sec4.5
        #
        def on_header_field(&block)
            @settings[:on_header_field] = DataCallback.new(&block)
        end

        #
        # Registers an `on_header_value` callback.
        #
        # @yield [instance, value]
        #   The given block will be called when a Header value is recognized
        #   in the Headers.
        #
        # @yieldparam [Paceman::HttpParser::Instance] instance
        #   The state so far of the request / response being processed.
        #
        # @yieldparam [String] value
        #   A recognized Header value.
        #
        # @see http://www.w3.org/Protocols/rfc2616/rfc2616-sec4.html#sec4.5
        #
        def on_header_value(&block)
            @settings[:on_header_value] = DataCallback.new(&block)
        end

        #
        # Registers an `on_headers_complete` callback.
        #
        # @yield [instance]
        #   The given block will be called when the Headers stop.
        #
        # @yieldparam [Paceman::HttpParser::Instance] instance
        #   The state so far of the request / response being processed.
        #
        def on_headers_complete(&block)
            @settings[:on_headers_complete] = Callback.new(&block)
        end

        #
        # Registers an `on_body` callback.
        #
        # @yield [instance, body]
        #   The given block will be called when the body is recognized in the
        #   message body.
        #
        # @yieldparam [Paceman::HttpParser::Instance] instance
        #   The state so far of the request / response being processed.
        #
        # @yieldparam [String] body
        #   The full body or a chunk of the body from a chunked
        #   Transfer-Encoded stream.
        #
        # @see http://www.w3.org/Protocols/rfc2616/rfc2616-sec4.html#sec4.5
        #
        def on_body(&block)
            @settings[:on_body] = DataCallback.new(&block)
        end

        #
        # Registers an `on_message_begin` callback.
        #
        # @yield [instance]
        #   The given block will be called when the message completes.
        #
        # @yieldparam [Paceman::HttpParser::Instance] instance
        #   The state so far of the request / response being processed.
        #
        def on_message_complete(&block)
            @settings[:on_message_complete] = Callback.new(&block)
        end

        #
        # Parses data.
        #
        # @param [Paceman::HttpParser::Instance] inst
        #   The state so far of the request / response being processed.
        #
        # @param [String] data
        #   The data to parse against the instance specified.
        #
        # @return [Boolean]
        #   Returns true if the data was parsed successfully.
        #
        def parse(inst, data)
            ::HttpParser.http_parser_execute(inst, @settings, data, data.length)
            return !inst.error?
        end


        protected


        class Callback < Proc
            #
            # Creates a new Parser callback.
            #
            def self.new(&block)
                super do |parser|
                    begin
                        catch(:return) { yield(parser); 0 }
                    rescue
                        -1
                    end
                end
            end
        end

        class DataCallback < Proc
            def self.new(&block)
                super do |parser, buffer, length|
                    begin
                        data = buffer.get_bytes(0, length)
                        catch(:return) { yield(parser, data); 0 }
                    rescue
                        -1
                    end
                end
            end
        end
    end
end
