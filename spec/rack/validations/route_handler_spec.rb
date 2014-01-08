require 'spec_helper'

describe Infochimps::Rack::Validation::RouteHandler do

  let(:app)     { double :app }
  let(:env)     { Hash.new.merge routes }
  let(:handlers){ { /^foo$/ => 'FooHandler', 'bar' => 'BarHandler' } }
  subject       { described_class.new(app, :endpoint, handlers) }

  context '#call', 'handler regex' do
    let(:routes){ { 'routes' => { endpoint: 'foo' } } }
    
    it 'assigns a handler if selected route matches' do
      app.should_receive(:call).with(env){ |e| e['handler'].should eq('FooHandler') }
      subject.call env
    end
  end

  context '#call', 'handler string' do
    let(:routes){ { 'routes' => { endpoint: 'bar' } } }
    
    it 'assigns a handler if selected route matches' do
      app.should_receive(:call).with(env){ |e| e['handler'].should eq('BarHandler') }
      subject.call env
    end
  end

  context '#call', 'no handler' do
    let(:routes){ { 'routes' => { endpoint: 'baz' } } }

    it 'raises a validation error' do
      subject.call(env).should eq([400, {}, { error: "No handler found for endpoint <baz>" }])
    end
  end
end
