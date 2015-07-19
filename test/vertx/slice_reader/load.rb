require_relative './slice_reader_init'

stream_name = 'testSliceReaderEache02a7c1d811b4d3b942d854e2e0f8a0e-0645c0e2-7386-4424-88ac-0e8a012d0fd7'

logger(__FILE__).info stream_name

reader = EventStore::Client::HTTP::Vertx::Reader.build stream_name

slice_number = 0

reader.each do |slice|
  slice_number += 1
  logger(__FILE__).info "== BEGIN SLICE =="

  logger(__FILE__).info "Slice number: #{slice_number}"

  first_entry_id = slice.data['entries'][0]['id'] rescue "(none)"
  logger(__FILE__).info "First entry ID: #{first_entry_id}"

  number_of_entries = slice.data['entries'].length
  logger(__FILE__).info "Slice entries: #{number_of_entries}"

  logger(__FILE__).info "== END SLICE =="
end
