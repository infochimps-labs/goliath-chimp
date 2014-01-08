require 'spec_helper'

describe Infochimps::Rack::Handler do
  subject{ Object.new.extend described_class }

  context '#valid_response' do
    it 'returns a templated response' do
      subject.valid_response('OK').should eq([200, {}, 'OK'])
    end
  end
  
  context '#invalid_operation' do
    before do
      subject.define_singleton_method(:create){ }
      subject.define_singleton_method(:retrieve){ }
    end

    it 'returns a validation error listing available operations' do
      message = 'Operation not allowed for Object. Valid operations are ["create", "retrieve"]'
      subject.invalid_operation(:update).should eq([405, {}, { error: message }])
    end
  end

  context '#method_missing', 'when crud method' do
    it 'returns an http error' do
      subject.update.should eq([405, {}, { error: 'Operation not allowed for Object. Valid operations are []' }])
    end
  end

  context '#method_missing', 'when other method' do
    it 'raises a NoMethodError normally' do
      expect{ subject.foobar }.to raise_error(NoMethodError)
    end
  end
end
