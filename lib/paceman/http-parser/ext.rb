require 'ffi'
require 'ffi-compiler/loader'

module Paceman
  module HttpParser
    extend FFI::Library
    ffi_lib FFI::Compiler::Loader.find('http-parser-ext')
  end
end
