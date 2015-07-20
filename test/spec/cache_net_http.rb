require 'net/http'

uri = URI('http://localhost:2113/streams/testSliceReaderEachfdd7d8b0d59046f0bafa40293096c644-69327a66-6789-41ca-843b-9920824492b8/0/forward/20')

request = Net::HTTP::Get.new(uri.path, initheader = {'Accept' => 'application/vnd.eventstore.atom+json'})
response = Net::HTTP.new(uri.host, uri.port).start {|http| http.request(request) }
