require 'date'
require 'optparse'

params = ARGV.getopts("y:", "m:")
y = params["y"]
m = params["m"]

year = y.nil? ? Date.today.year : y.to_i
month = m.nil? ? Date.today.month : m.to_i

first_date =  Date.new(year, month, 1)
last_date = Date.new(year, month, -1)

puts first_date.strftime("%-m月 %Y").center(20)
puts "日 月 火 水 木 金 土"
print "   " * first_date.wday

(first_date..last_date).each do |date|
  print date.day.to_s.rjust(2) + " "
  puts if date.saturday?
end

puts 
