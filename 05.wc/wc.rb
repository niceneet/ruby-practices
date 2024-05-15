#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

SIZE_INDENT = 8

def main
  options = ARGV.getopts('lwc')
  files = ARGV
  if files.empty?
    standard_input = [$stdin.read.to_s]
    file_specification = false
    output_section(standard_input, options, file_specification)
  else
    file_specification = true
    output_section(files, options, file_specification)
  end
end

def output_section(files, options, file_specification)
  total_hash = { l: 0, w: 0, c: 0 }
  files.each do |file|
    lines = file_specification ? File.read(file) : file
    print_section(lines, total_hash, options)
    print " #{file}" if file_specification
    puts
  end
  total_print_option(total_hash, options) if files.count >= 2
end

def print_section(lines, total_hash, options)
  print l = count_l(lines) if options['l'] || options.values.none?
  print w = count_w(lines) if options['w'] || options.values.none?
  print c = count_c(lines) if options['c'] || options.values.none?
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

def total_print_option(total_hash, options)
  total_hash.zip(options) do |each_total, opt|
    print each_total[1].to_s.rjust(SIZE_INDENT) if opt[1] || options.values.none?
  end
  print ' total'
  puts
end

main
