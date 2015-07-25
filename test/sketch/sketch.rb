require_relative './sketch_init'

stream_name = Fixtures::EventData.write 2, 'testSliceReaderEach'

reader = EventStore::Client::HTTP::SliceReader.build stream_name, slice_size: 1

slices = []
reader.each do |slice|
  slices << slice
end

logger(__FILE__).info slices[0].links.next_uri
logger(__FILE__).info slices[1].links.next_uri

# logger(__FILE__).info slices[0].data
# logger(__FILE__).info stream_name
# logger(__FILE__).info "Slice count: #{slices.length}"
# logger(__FILE__).info "Entries in first slice: #{slices[0].entries.length}"
# logger(__FILE__).info "Entries in second slice: #{slices[1].entries.length}"
