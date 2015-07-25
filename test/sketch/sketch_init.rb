require_relative '../test_init'

require 'minitest/autorun'
require 'minitest-spec-context'

def assert(val, message=nil)
  logger = logger(caller[0])
  if val
    logger.pass(message || '')
  else
    logger.fail(message || '')
  end
end
