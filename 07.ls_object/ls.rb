# frozen_string_literal: true

require 'pathname'

dir_path = Dir.pwd
files = Dir.glob("#{dir_path}/*").sort

max_length = 0

files.each do |file|
  file_name = File.basename(file)
  file_length = Pathname.new(file_name).basename.to_s.length
  max_length = file_length if file_length > max_length
end

files_row = 3
files_puts = (files.size / files_row.to_f).ceil

(0...files_puts).each do |i|
  files_row.times do |j|
    index = i + j * files_puts
    print File.basename(files[index]).ljust(max_length + 3) if files[index]
  end
  puts
end
