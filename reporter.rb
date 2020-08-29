
require 'json'
require 'terminal-table'

# Prints a pretty ascii/md table showing summary results. This takes
# as argument, the path to the standard jmeter statistic.json file
# (found in hmtl/ dir after generating a full jmeter report)
# i.e. /opt/jmeter/bin/jmeter -g jmeter.jtl -o html
# outputs a simple ascii/markdown table
def table_summary(summary_hash)
    header = [
        'Transaction', 'Samples', 'Error %', 'Rps', 'Avg (ms)', '90th', '95th', '99th', 'BytesRx/s', 'BytesSent/s'
    ]
    keys = [
        'transaction', 'sampleCount', 'errorPct', 'throughput', 'meanResTime', 'pct1ResTime', 'pct2ResTime', 'pct3ResTime', 'receivedKBytesPerSec', 'sentKBytesPerSec'
    ]
    data_rows = []
    labels = summary_hash.keys
    labels.each do |label|
        row = []
        keys.each do |key|
            val = summary_hash[label][key]
            if key == 'errorPct'
                val = val.round(4)
            elsif key == 'transaction'
                # pass
            else
                val = val.round(2)
            end
            row << val
        end
        data_rows << row
    end
    table = Terminal::Table.new
    table.headings = header
    table.rows = data_rows
    table.style = { :border_top => false, :border_bottom => false }
    # make it markdown
    return table.to_s.gsub('+', '|')
end

file = File.read(ARGV[0])
puts table_summary(JSON.parse(file))



