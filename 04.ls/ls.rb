#!/usr/bin/env ruby
# frozen_string_literal: true

NUMBER_OF_COLUMNS = 3
COLUMN_MARGIN = 3

def main
  files = Dir.glob('*').sort

  number_of_row = (files.size / NUMBER_OF_COLUMNS.to_f).ceil
  files_array = files.each_slice(number_of_row).to_a

  max_length_array = make_max_length_array(files_array)
  output_ls(files, number_of_row, max_length_array)
end

def make_max_length_array(files_array)
  files_array.map do |elements|
    elements.map(&:length).max
  end
end

def output_ls(files, number_of_row, max_length_array)
  (0...number_of_row).each do |row|
    NUMBER_OF_COLUMNS.times do |column|
      index = row + column * number_of_row
      print files[index].ljust(max_length_array[column] + COLUMN_MARGIN) if files[index]
    end
    puts
  end
end

main
