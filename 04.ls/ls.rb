#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

NUMBER_OF_COLUMNS = 3
COLUMN_MARGIN = 3
SIZE_INDENT = 2

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
  blocks = files.map do |file|
    File::Stat.new(file).blocks
  end
  puts "total #{blocks.sum}"
end

def get_max_file_size(files)
  files.map { |file| File.size(file) }.max.to_s.length
end

def output_file_type(file_stat)
  case file_stat.ftype
  when 'file'
    print '-'
  when 'directory'
    print 'd'
  when 'characterSpecial'
    print 'c'
  when 'blockSpecial'
    print 'b'
  when 'fifo'
    print 'p'
  when 'link'
    print 'l'
  when 'socket'
    print 's'
  end
end

def output_permission(file_stat)
  (-3..-1).each do |index|
    case file_stat.mode.to_s(8)[index]
    when '0' then print '---'
    when '1' then print '--x'
    when '2' then print '-w-'
    when '3' then print '-wx'
    when '4' then print 'r--'
    when '5' then print 'r-x'
    when '6' then print 'rw-'
    when '7' then print 'rwx'
    end
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
