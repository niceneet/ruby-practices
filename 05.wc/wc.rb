#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

SIZE_INDENT = 8

def main
  files = ARGV
  if files.empty?
    standard_input = [$stdin.read.to_s]
    file_specification = false
    output_section(standard_input, file_specification)
  else
    file_specification = true
    output_section(files, file_specification)
  end
end

def output_section(files, file_specification)
  params = ARGV.getopts('lwc')
  total_hash = { l: 0, w: 0, c: 0 }
  files.each do |file|
    lines = file_specification ? File.read(file) : file
    print_section(lines, total_hash, params)
    print " #{file}" if file_specification
    puts
  end
  total_print_option(total_hash, params) if files.count >= 2
end

def print_section(lines, total_hash, params)
  print l = count_l(lines) if params['l'] || params.values.none?
  print w = count_w(lines) if params['w'] || params.values.none?
  print c = count_c(lines) if params['c'] || params.values.none?
  total_hash[:l] += l.to_i
  total_hash[:w] += w.to_i
  total_hash[:c] += c.to_i
end

def count_l(file)
  file.lines.count.to_s.rjust(SIZE_INDENT)
end

def count_w(file)
  file.scan(/\s+/).size.to_s.rjust(SIZE_INDENT)
end

def count_c(file)
  file.bytesize.to_s.rjust(SIZE_INDENT)
end

def total_print_option(total_hash, params)
  total_hash.zip(params) do |each_total, opt|
    print each_total[1].to_s.rjust(SIZE_INDENT) if opt[1] || params.values.none?
  end
  print ' total'
  puts
end

main
