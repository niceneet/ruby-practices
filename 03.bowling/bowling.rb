# frozen_string_literal: true

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

frames = []
shots.each_slice(2) do |s|
  frames << s
end

point = 0
frames.each_with_index do |frame, i|
  point += if i >= 9
             frame.sum
           elsif frame.sum <= 9
             frame.sum
           elsif frames[i] == [10, 0]
             if frames[i + 1] == [10, 0]
               10 + 10 + frames[i + 2][0]
             else
               10 + frames[i + 1].sum
             end
           # elsif frame.sum == 10 スペアの時条件の書き方はelseとどちらがよろしいですか？
           else
             frames[i].sum + frames[i + 1][0]
           end
end

puts point
