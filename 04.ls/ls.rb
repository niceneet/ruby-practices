#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

NUMBER_OF_COLUMNS = 3
COLUMN_MARGIN = 3

def main
  params = ARGV.getopts('a')
  files = params['a'] ? Dir.glob('*', File::FNM_DOTMATCH).sort : Dir.glob('*').sort
  output_ls(files)
end

def output_ls(files)
  number_of_row = (files.size / NUMBER_OF_COLUMNS.to_f).ceil
  max_lengths = make_max_lengths(files, number_of_row)

  (0...number_of_row).each do |row|
    NUMBER_OF_COLUMNS.times do |column|
      index = row + column * number_of_row
      print files[index].ljust(max_lengths[column] + COLUMN_MARGIN) if files[index]
    end
    puts
  end
end

def make_max_lengths(files, number_of_row)
  files.each_slice(number_of_row).to_a.map { _1.map(&:length).max }
end

main
