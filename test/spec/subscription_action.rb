require_relative './spec_init'

describe "Subscription Action" do
  specify "Is set when the subscription is started" do
    subscription = EventStore::Client::HTTP::Vertx::Subscription.new

    subscription.define_singleton_method :get do |path|
    end

    blk = Proc.new do |data|
    end

    subscription.start(&blk)

    assert(subscription.action == blk)
  end
end


