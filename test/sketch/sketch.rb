require_relative './sketch_init'

stream_name = Fixtures::EventData.write 2, 'testSliceReaderEach'

logger(__FILE__).info stream_name
