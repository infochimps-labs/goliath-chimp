require 'spec_helper'

describe Goliath::Chimp::Validation::RequiredRoutes do

  let(:app)     { double :app }
  let(:env)     { Hash.new.merge routes }
  let(:required){ { /^foo$/ => :id, 'bar' => :id } }
  subject       { described_class.new(app, :endpoint, required) }

  context '#call', 'with selected route' do
    let(:routes){ { 'routes' => { endpoint: 'foo' } } }

    it 'raises a validation error if required route is missing' do
      subject.call(env).should eq([400, {}, { error: 'A id route is required for foo' }])
    end

    it 'does not raise an error if required route is present' do
      routes.merge!('routes' => { id: '123' })
      app.should_receive(:call).with(env)
      subject.call env
    end
  end

  context '#call', 'with unselected route' do
    let(:routes){ { 'routes' => { endpoint: 'baz' } } }

    it 'does not raise an error when selected route does not match' do
      app.should_receive(:call).with(env)
      subject.call env
    end
  end

end
