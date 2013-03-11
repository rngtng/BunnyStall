require 'open-uri'
require 'openssl'
require 'json'

module GraphiteStats
  URL  = "https://graphite.s-cloud.net/render/?rawData=true&format=json&%s&from=%s"
  KEY  = "sumSeries(payments.stats.plans.creator-pro*)"
  USER = "admin"

  def get_stats(keys, password, time='-10minutes')
    keys = Array(keys).map { |key| "target=#{key}" }.join("&")
    open(URL % [keys, time], {
      :http_basic_authentication => [USER, password],
      :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE
    }).read
  end

  def datapoints(stats)
    JSON.parse(stats).map do |data|
      dp1, dp2 = Array(data["datapoints"])
      (dp2[0].to_i - dp1[0].to_i) > 0 ? dp2[1] : nil
    end.flatten.compact
  end

  def get_last_datapoint(key, password)
    if stats = get_stats(key, password)
      (datapoints(stats) - done_datapoints).pop
    end
  end

  def done_datapoints
    @@done_datapoints ||= []
  end

  def payment(key, password, sn = nil)
    if password && pt = get_last_datapoint(key, password)
      done_datapoints << pt
    end
  end
end
