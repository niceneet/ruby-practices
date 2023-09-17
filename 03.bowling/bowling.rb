# frozen_string_literal: true
require 'debug'

score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = shots.each_slice(2).to_a

point = 0
frames.each_with_index do |frame, i|
  point += if i >= 9 || frame.sum <= 9
             frame.sum
           elsif frame[0] == 10
             if frames[i + 1] == [10, 0]
               10 + 10 + frames[i + 2][0]
             else
               10 + frames[i + 1].sum
             end
           else
             10 + frames[i + 1][0]
           end
end

puts point
