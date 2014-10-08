require 'base64'
require 'uri'

class ApacheLog
  FORMATS = {
    :combined => %r{^(\S+) - - \[(\S+ \+\d{4})\] "(\S+ \S+ [^"]+)" (\d{3}) (\d+|-) "(.*?)" "([^"]+)"$}
  }

  class << self
    def each_line(str, log_format = FORMATS[:combined])
      str.each_line do|line|
        data = line.scan(log_format).flatten
        if data.empty?
          p "Line didn't match pattern: #{line}"
          next
        end
        yield data
      end
    end
  end
end

class Log
  attr_accessor :ip, :urls, :refs, :date, :keywords
  def initialize(ip: ip = "0.0.0.0", date: date = "")
    @ip = ip
    @date = date
    @urls = []
    @refs = []
    @keywords = []
  end

  def add_accessed_url(url)
    @urls << url
  end

  def add_keyword(k)
    @keywords << k
  end

  def add_referrer(ref)
    @refs << ref
  end
end


file = ARGV[0]
logs = []
ips = {}

str = `cat #{file} | grep "GET /s" | grep "http" | grep -v "kooleye.com"`
ApacheLog.each_line(str) do |data|
  host, date, url_with_method, status, size, referrer, agent = data
  next if referrer == "-"
  if ips[host].nil?
    ips[host] = true
    log = Log.new(ip: host, date: date)
    logs << log
  else
    log = logs.select {|log| log.ip == host}[0]
  end
  log.add_referrer(URI.unescape referrer) if referrer != "-"
end

logs.each do |log|
  str = `cat #{file} | grep #{log.ip}`
  ApacheLog.each_line(str) do |data|
    host, date, url_with_method, status, size, referrer, agent = data
    if url_with_method.include? "/redirect?u="
      base64 = url_with_method.split(" ")[1].gsub("/redirect?u=", "")
      url = Base64.urlsafe_decode64 base64
      url = "vc_url=" + url.split("vc_url=")[1] if url.include? "vc_url="
      log.add_accessed_url("redirect?u=#{url}")
    elsif url_with_method.include? "buys"
      url = url_with_method.split(" ")[1]
      log.add_keyword(url)
    elsif url_with_method.include? "/s"
      url = url_with_method.split(" ")[1]
      kewword = url.split("?")[1]
      log.add_keyword(URI.unescape kewword) if kewword
    end
  end
end

n_clicked = 0
grid_n_clicked = 0
grid_n = 0
image_n_clicked = 0
image_n = 0
logs.each_with_index do |log, i|
  n_clicked += 1 if log.urls.length > 0

  grid = false
  log.keywords.each {|k| grid = true if k.include?("grid")}
  if grid
    grid_n_clicked += 1 if log.urls.length > 0
    grid_n += 1
  else
    image_n_clicked += 1 if log.urls.length > 0
    image_n += 1
  end

  puts i + 1
  puts "date: #{log.date}"
  puts "ip: #{log.ip}"
  puts "refs: #{log.refs}"
  puts "keywords: #{log.keywords}"
  puts "n: #{n_clicked}  urls: #{log.urls}"
  puts "\n"
end

puts "grid: #{grid_n}:#{grid_n_clicked} #{100.0 * grid_n_clicked / grid_n}%"
puts "imag: #{image_n}:#{image_n_clicked} #{100.0 * image_n_clicked / image_n}%"

puts "\n"
