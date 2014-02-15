module Goliath::Chimp
  module Plugin
    class ActivityMonitor

      def initialize(address, port, config, status, logger)
        @status   = status
        @logger   = logger
        @previous = Time.now.to_f
      end

      def run(options = {})
        interval = options[:window] || 60
        EM::Synchrony.add_periodic_timer(interval) do
          current = latency
          @status[:reactor] = {
            latency: current,
            ratio:   (current / interval).round(6),
          }
          report @status
        end
      end
      
      def latency
        snapshot = Time.now.to_f
        laten = snapshot - @previous
        @previous = snapshot
        laten
      end
      
      def report metric
        @logger.debug metric
      end
    end
  end
end
