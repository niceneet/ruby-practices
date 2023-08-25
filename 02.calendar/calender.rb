require 'date'
require 'optparse'

params = ARGV.getopts("y:", "m:")
y = params["y"]
m = params["m"]

year = y.nil? ? Date.today.year : y.to_i
month = m.nil? ? Date.today.month : m.to_i
target_date = Date.new(year, month)

puts target_date.strftime("%m月 %Y").center(21)
puts "日 月 火 水 木 金 土"
first_date =  Date.new(target_date.year, target_date.month, 1)
last_date = Date.new(target_date.year, target_date.month, -1)
first_wday = first_date.wday
print "   " * first_wday

(first_date..last_date).each do |date|
  print date.day.to_s.rjust(2) + " "
  puts if date.saturday?
end

puts 
