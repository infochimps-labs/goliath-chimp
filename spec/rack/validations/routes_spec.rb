require 'spec_helper'

describe Infochimps::Rack::Validation::Routes do
  
  let(:app)  { double :app }
  let(:env)  { Hash.new }
  let(:regex){ Regexp.new(/^\/final\/fantasy\/(?<version>.*)$/) }
  subject    { described_class.new(app, regex, '/final/fantasy/<version>') }

  context '#call', 'with an invalid path' do
    it 'returns a validation error' do
      env['REQUEST_PATH'] = '/foo/bar/baz'
      subject.call(env).should eq([400, {}, { error: 'Invalid route. Must match /final/fantasy/<version>' }])
    end    
  end

  context '#call', 'with a valid path' do
    it 'extracts all match groups as params' do
      env['REQUEST_PATH'] = '/final/fantasy/vii'
      app.should_receive(:call).with(env) do |e|
        e['routes'].should be_a(Hash)
        e['routes'][:version].should eq('vii')
      end
      subject.call env
    end
  end  
end
