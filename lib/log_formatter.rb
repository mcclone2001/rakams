class LogFormatter < ::Logger::Formatter
    attr_accessor :flat_json

    def call(severity, timestamp, progname, raw_msg)
      track_info = ElasticAPM.log_ids do |transaction_id, span_id, trace_id|
        { :'transaction.id' => transaction_id,
          :'span.id' => span_id,
          :'trace.id' => trace_id }
      end

      # hack para obtener el request_id
      # https://github.com/roidrage/lograge/issues/255#issuecomment-657328032
      tagged = Rails.application.config.log_tags.zip(current_tags).to_h
      track_info.merge!(tagged)

      msg = normalize_message(raw_msg)
      payload = { 
          level: severity, 
          timestamp: timestamp.strftime("%Y-%m-%dT%H:%M:%S%:z"), 
          environment: ::Rails.env, 
          track: track_info
      }

      if flat_json && msg.is_a?(Hash)
        payload.merge!(msg)
      else
        payload.merge!(message: msg)
      end

      payload.to_json << "\n"
    end

    private

    def normalize_message(raw_msg)
      return raw_msg unless raw_msg.is_a?(String)

      JSON.parse(raw_msg)
    rescue JSON::ParserError
      raw_msg
    end
end