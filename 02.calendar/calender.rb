require 'date'
require 'optparse'

params = ARGV.getopts("y:", "m:")
y = params["y"]
m = params["m"]

target_date = if y.nil? && m.nil?
              Date.today
            elsif y.nil?
              Date.new(Date.today.year, m.to_i)
            else
              Date.new(y.to_i, m.to_i)
            end

puts target_date.strftime("%-m月 %Y").center(21)
puts " 日 月 火 水 木 金 土"
last_date = Date.new(target_date.year, target_date.month, -1).day
first_date =  Date.new(target_date.year, target_date.month,)
first_wday = first_date.wday

first_wday.times do
  print " " * 3
end

(1..last_date).each do |n|
  print n.to_s.rjust(3)
  if Date.new(target_date.year, target_date.month, n).saturday?
    puts
  end
end

puts 
