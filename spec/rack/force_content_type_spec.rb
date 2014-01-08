require 'spec_helper'

describe Infochimps::Rack::ForceContentType do
  
  let(:app){ double :app }
  let(:env){ Hash.new    }
  subject{ described_class.new(app, 'text/xml') }

  context '#call' do
    it 'overrides content send type' do
      env['CONTENT_TYPE'] = 'application/json'
      app.should_receive(:call).with(env){ |e| e['CONTENT_TYPE'].should eq('text/xml') }
      subject.call env
    end
    
    it 'overrides content accept type' do
      env['HTTP_ACCEPT'] = 'application/json'
      app.should_receive(:call).with(env){ |e| e['HTTP_ACCEPT'].should eq('text/xml') }
      subject.call env
    end
  end
end
