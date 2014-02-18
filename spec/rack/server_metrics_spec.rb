require 'spec_helper'

describe Goliath::Chimp::Rack::ServerMetrics do

  let(:app)         { double :app }
  let(:status)      { Hash.new }
  let(:example_time){ Time.new(2014, 1, 1, 3, 15) }
  let(:env)         { { 'status' => status, endpoint: 'images', start_time: example_time.to_f } }
  subject           { described_class.new(app, env_key: 'endpoint') }

  context '#call', 'when /metrics' do
    it 'does not call the app' do
      app.should_not_receive(:call)
      env['PATH_INFO'] = '/metrics'
      subject.call env      
    end

    it 'returns the current status' do
      env['PATH_INFO'] = '/metrics'
      subject.call(env).should eq([200, {}, status])
    end
  end

  context '#call', 'when /^version' do
    it 'does nothing' do
      app.should_receive(:call)
      subject.should_receive(:post_process)
      env['PATH_INFO'] = '/foobar'
      subject.call env
    end
  end

  context '#post_process' do
    it 'does not alter the response' do
      env['REQUEST_METHOD'] = 'GET'
      subject.post_process(env, 200, {}, {}).should eq([200, {}, {}])
    end

    it 'attaches request metrics to the status' do
      env['REQUEST_METHOD'] = 'GET'
      Time.stub(:now).and_return(example_time + 30)
      subject.post_process(env, 200, {}, {})
      status.should eq(requests: { 'images' => { get: { count: 1, total_millis: 30000 } } })
    end
  end
end
