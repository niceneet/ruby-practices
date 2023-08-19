require 'date'
require 'optparse'

params = ARGV.getopts("y:", "m:")
y = params["y"]
m = params["m"]

def generate_target_date(y = nil, m = nil)
  year = y.nil? ? Date.today.year : y.to_i
  month = m.nil? ? Date.today.month : m.to_i
  target_date = Date.new(year, month)
end

target_date = generate_target_date(y, m)

puts target_date.strftime("%-m月 %Y").center(21)
puts " 日 月 火 水 木 金 土"
first_date =  Date.new(target_date.year, target_date.month, 1)
first_day = first_date.day
last_day = Date.new(target_date.year, target_date.month, -1).day
first_wday = first_date.wday
print "   " * first_wday

(first_day..last_day).each do |n|
  print n.to_s.rjust(3)
  if Date.new(target_date.year, target_date.month, n).saturday?
    puts
  end
end

puts 
