#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

NUMBER_OF_COLUMNS = 3
COLUMN_MARGIN = 3
SIZE_INDENT = 2
MODE_MAP = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

FORMAT_TYPE = {
  'file' => '-',
  'directory' => 'd',
  'characterSpecial' => 'c',
  'blockSpecial' => 'b',
  'fifo' => 'p',
  'link' => 'l',
  'socket' => 's'
}.freeze

def main
  params = ARGV.getopts('a', 'r', 'l')
  files = params['a'] ? Dir.glob('*', File::FNM_DOTMATCH).sort : Dir.glob('*').sort
  files = files.reverse if params['r']
  params['l'] ? output_ls_l(files) : output_ls(files)
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

def output_ls_l(files)
  output_total_blocks(files)
  max_file_size = get_max_file_size(files)
  files.each do |file|
    file_stat = File.lstat(file)
    output_file_type(file_stat)
    output_permission(file_stat)
    print " #{file_stat.nlink}"
    print " #{Etc.getpwuid(file_stat.uid).name}"
    print "  #{Etc.getgrgid(file_stat.gid).name}"
    print file_stat.size.to_s.rjust(max_file_size + SIZE_INDENT)
    output_years_of_file_creation(file_stat)
    output_file_name(file)
    puts
  end
end

def output_total_blocks(files)
  puts "total #{files.sum { |file| File.lstat(file).blocks }}"
end

def get_max_file_size(files)
  files.map { |file| File.size(file) }.max.to_s.length
end

def output_file_type(file_stat)
  print FORMAT_TYPE[file_stat.ftype]
end

def output_permission(file_stat)
  (-3..-1).each do |index|
    print MODE_MAP[file_stat.mode.to_s(8)[index]]
  end
end

def output_years_of_file_creation(file_stat)
  if Time.now - file_stat.mtime >= (60 * 60 * 24 * (365 / 2.0)) || (Time.now - file_stat.mtime).negative?
    print "  #{file_stat.mtime.strftime('%_m %_d  %Y')}"
  else
    print "  #{file_stat.mtime.strftime('%_m %_d %H:%M')}"
  end
end

def output_file_name(file)
  if File.lstat(file).symlink?
    print " #{file} -> #{File.readlink(file)}"
  else
    print " #{file}"
  end
end

main
