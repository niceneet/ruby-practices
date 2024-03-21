# frozen_string_literal: true

require 'pathname'

dir_path = Dir.pwd
files = Dir.glob("#{dir_path}/*").sort

max_length = 0

files.each do |file|
  file_name = File.basename(file)
  file_length = file_name.length
  max_length = file_length if file_length > max_length
end

Files_column = 3
files_row = (files.size / Files_column.to_f).ceil

(0...files_row).each do |i|
  Files_column.times do |j|
    index = i + j * files_row
    print File.basename(files[index]).ljust(max_length + 3) if files[index]
  end
  puts
end
