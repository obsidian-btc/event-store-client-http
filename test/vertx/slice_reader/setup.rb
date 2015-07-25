require_relative './slice_reader_init'

stream_name = Fixtures::EventData.write 3000, 'testSliceReaderEach'

logger(__FILE__).info "Stream name:\n#{stream_name}"
