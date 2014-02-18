require 'spec_helper'

describe Goliath::Chimp::Plugin::ActivityMonitor do

  let(:log_output)  { StringIO.new }
  let(:logger)      { Logger.new log_output }
  let(:example_time){ Time.new(2014, 1, 1, 3, 15) }
  subject(:monitor) { described_class.new('localhost', 3467, {}, {}, logger) }

  before(:each){ Time.stub(:now).and_return(example_time, example_time + 30) }

  context '#run' do
    it 'establishes a periodic latency monitor' do
      EM.synchrony do
        monitor.should_receive(:report).with(reactor: { latency: 30.0, ratio: 300.0 })
        monitor.run(window: 0.1)
        EM::Synchrony.add_timer(0.2){ EM.stop }
      end
    end
  end

  context '#latency' do
    it 'returns the latency' do
      monitor.latency.should eq(30.0)
    end

    it 'updates the previous snapshot' do
      expect{ monitor.latency }.to change{ monitor.previous }.from(example_time.to_f).to((example_time + 30).to_f)
    end
  end

  context '#report' do
    it 'logs the metric' do
      monitor.logger.should_receive(:debug).with('metrics')
      monitor.report 'metrics'
    end
  end
end
