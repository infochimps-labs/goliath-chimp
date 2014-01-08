require 'spec_helper'

describe Infochimps::Rack::Handler do
  subject{ Object.new.extend described_class }
  
  context '#invalid_operation' do
    before do
      subject.define_singleton_method(:create){ }
      subject.define_singleton_method(:retrieve){ }
    end

    it 'returns a validation error listing available operations' do
      message = 'Operation not allowed for Object. Valid operations are ["create", "retrieve"]'
      subject.invalid_operation(:update).should             be_a(Goliath::Validation::MethodNotAllowedError)
      subject.invalid_operation(:update).message.should     eq(message)
      subject.invalid_operation(:update).status_code.should eq('405')
    end
  end

  context '#method_missing', 'when crud method' do
    it 'raises a goliath http error' do
      message = 'Operation not allowed for Object. Valid operations are []'
      expect{ subject.update }.to raise_error(Goliath::Validation::MethodNotAllowedError, message)
    end
  end

  context '#method_missing', 'when other method' do
    it 'raises a NoMethodError normally' do
      expect{ subject.foobar }.to raise_error(NoMethodError)
    end
  end
end
