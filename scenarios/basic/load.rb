# and example load test that take CLI args and does POST requests
require 'ruby-jmeter'
require 'slop'

opts = Slop.parse do |o|
  o.string '-u', '--url', 'target url', required: true
  o.float '-t', '--throughput', 'requests per second', required: true
  o.integer '-d', '--duration', 'duration in seconds', required: true
  o.integer '-r', '--rampup', 'rampup in seconds', required: true
  o.integer '-h', '--threads', 'threads, if you want to be specific'
  o.bool '-g', '--gui', 'use gui (local only) be sure to export JMETER_BIN'
end
# default to Dockerfile jmeter location
jmeter_path = ENV['JMETER_BIN'] ? ENV['JMETER_BIN'] : '/opt/jmeter/bin/'
json_path = File.dirname(__FILE__) + '/payload.json'
gui = opts.gui? # only true for non docker testing
url = opts[:url]
rpm = opts[:throughput] * 60
duration = opts[:duration]
rampup = opts[:rampup]
# a good default thread count is half the desired requests/s
threads = opts[:threads] ? opts[:threads] : (rpm / 120).to_i + 1

$stdout.sync = true # make sure jmeter stdout is flowing

# LOAD TEST
testplan = test do
  threads count: threads, duration: duration, rampup: rampup do
    constant_throughput_timer throughput: rpm / threads
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