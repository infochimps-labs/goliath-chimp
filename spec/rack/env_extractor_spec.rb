require 'spec_helper'

describe Goliath::Chimp::Rack::EnvExtractor do

  subject do
    extractor_mod = described_class
    example_class = Class.new{ include extractor_mod }
    example_class.new
  end

  context '#extract_from_env' do
    context 'default' do
      let(:env){ Hash.new }
      
      it 'returns the default value when key is not found' do
        subject.extract_from_env(env, 'foo', 'default').should eq('default')
      end      
    end

    context String do
      let(:env){ { 'foo' => 'bar' } }
      
      it 'extracts the value using the string as a key' do
        subject.extract_from_env(env, 'foo').should eq('bar')
        subject.extract_from_env(env, 'bar').should be_nil
      end

      it 'extracts symbolic values' do
        env = { foo: 'bar' }
        subject.extract_from_env(env, 'foo').should eq('bar')
      end
    end

    context Symbol do
      let(:env){ { foo: 'bar' } }

      it 'extracts the value using the symbol as a key' do
        subject.extract_from_env(env, :foo).should eq('bar')
        subject.extract_from_env(env, :bar).should be_nil
      end
      
      it 'extracts string values' do
        env = { 'foo' => 'bar' }
        subject.extract_from_env(env, :foo).should eq('bar')
      end
    end

    context Array do
      let(:env){ { foo: { bar: 'baz' } } }
      
      it 'extracts the value using the array as a set of keys' do
        subject.extract_from_env(env, [:foo, :bar]).should eq('baz')
        subject.extract_from_env(env, [:bar, :foo]).should be_nil
      end
    end

    context Hash do
      let(:env){ { foo: { bar: 'baz' } } }

      it 'extracts the value using the hash as a set of keys' do
        subject.extract_from_env(env, { foo: :bar }).should eq('baz')
        subject.extract_from_env(env, { bar: :foo }).should be_nil
      end
    end

    context 'other' do
      let(:env){ Hash.new }

      it 'returns the default if given an invalid key' do
        subject.extract_from_env(env, 123, 'default').should eq('default')
      end
    end
  end
end
