require 'spec_helper'

describe Goliath::Chimp::Rack::ControlMethods do

  let(:app)    { double :app }
  let(:env)    { Hash.new }
  let(:methods){ { 'GET' => :grab, 'PUT' => :shelve } }
  subject      { described_class.new(app, methods) }

  context '#call', 'with matching http method' do
    it 'assigns a control method' do
      env['REQUEST_METHOD'] = 'GET'
      app.should_receive(:call).with(env){ |e| e['control_method'].should eq(:grab) }
      subject.call env
    end

    it 'uses HTTP_X over REQUEST' do
      env['REQUEST_METHOD'] = 'GET'
      env['HTTP_X_METHOD']  = 'PUT'
      app.should_receive(:call).with(env){ |e| e['control_method'].should eq(:shelve) }
      subject.call env
    end
  end

  context '#call', 'without a matching http method' do
    it 'does not assign a control method' do
      env['REQUEST_METHOD'] = 'HEAD'
      app.should_receive(:call).with(env){ |e| e['control_method'].should be_nil }
      subject.call env
    end
  end
end
