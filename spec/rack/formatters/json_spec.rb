require 'spec_helper'

describe Infochimps::Rack::Formatters::JSON do

  let(:app)    { double :app }
  let(:env)    { { 'params' => {} } }
  let(:status) { 200 }
  let(:headers){ Hash.new }
  subject      { described_class.new app }

  context '#post_process', 'when the content-type is set to JSON' do
    it 'serializes the body as JSON' do
      headers['Content-Type'] = 'application/json'
      subject.post_process(env, status, headers, { foo: 'bar' }).should eq([status, headers, '{"foo":"bar"}'])
    end
  end

  context '#post_process', 'when the content-type is not set to JSON' do
    it 'does not serializes the body' do
      headers['Content-Type'] = 'application/xml'
      subject.post_process(env, status, headers, { foo: 'bar' }).should eq([status, headers, { foo: 'bar' }])
    end
  end

  context '#post_process', 'when the content-type is set to JSON and pretty is a param' do
    it 'serializes the body as pretty-printed JSON' do
      headers['Content-Type'] = 'application/json'
      env['params']['pretty'] = true
      MultiJson.should_receive(:dump).with({ foo: { bar: 'baz' } }, pretty: true).and_return('{\n  "foo":{\n    "bar":"baz"\n  }\n}')
      subject.post_process(env, status, headers, { foo: { bar: 'baz' } }).should eq([status, headers, '{\n  "foo":{\n    "bar":"baz"\n  }\n}'])
    end
  end
end
