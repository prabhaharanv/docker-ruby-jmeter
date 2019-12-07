require 'ruby-jmeter'
require 'slop'

opts = Slop.parse do |o|
  o.string '-u', '--url', 'target url'
  o.float '-t', '--throughput', 'requests per minute'
  o.integer '-d', '--duration', 'duration in seconds'
  o.integer '-r', '--rampup', 'rampup in seconds'
  o.bool '-g', '--gui', 'use gui'
end
# default to Dockerfile jmeter location
jmeter_path = ENV['JMETER_BIN'] ? ENV['JMETER_BIN'] : '/opt/jmeter/bin/'
json_path = File.dirname(__FILE__) + '/payload.json'
gui = opts.gui? # only true for non docker testing
url = opts[:url]
throughput = opts[:throughput]
duration = opts[:duration]
rampup = opts[:rampup]
threads = (throughput / 120).to_i + 1 # enough threads, as long as latency is < 500ms

puts opts.to_hash
puts threads
$stdout.sync = true

testplan = test do
  threads count: threads, duration: duration, rampup: rampup do
    constant_throughput_timer throughput: throughput / threads
    if gui
      view_results_tree
      aggregate_report
    end

    default_headers = [
      { name: 'Content-Type', value: 'application/json' },
    ]
    post(name: 'restful POST', url: url, raw_body: IO.read(json_path)) do
        header(default_headers)
    end
  end
end

if __FILE__ == $0
  testplan.run(
    path: jmeter_path,
    gui: gui,
    debug: true
  )
end