require 'spec_helper'

describe Infochimps::Rack::ApiVersion do
  
  let(:app)    { double :app }
  let(:env)    { Hash.new }
  let(:version){ '1.2' }
  subject      { described_class.new(app, version, api: 'Jumanji') }

  context '#call', 'when /version' do
    it 'does not call the app' do
      app.should_not_receive(:call)
      env['PATH_INFO'] = '/version'
      subject.call env
    end
    
    it 'returns the version' do
      env['PATH_INFO'] = '/version'
      subject.call(env).should eq([200, { 'X-Jumanji-Version' => version }, version])
    end
  end

  context '#call', 'when /^version' do
    it 'does nothing' do
      app.should_receive(:call)
      env['PATH_INFO'] = '/foobar'
      subject.call env
    end
  end

  context '#post_process' do
    it 'add a server version header to all responses' do
      subject.post_process(env, 200, {}, 'OK').should eq([200, { 'X-Jumanji-Version' => version }, 'OK'])
    end
  end
end
