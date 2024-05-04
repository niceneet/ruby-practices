#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'debug'
# binding.break

SIZE_INDENT = 8

def main #ファイル引数なし
	params = ARGV.getopts('lwc')
	# options = parse_options
  # options = { c: true, l: true, w: true } if options.empty?
	files = ARGV
	if files.empty?
		lines = $stdin.read
	end
	total_array = [0, 0, 0]
	unless params.values.any?
		files.each do |file|
			lines = File.read(file)
			print l = count_l(lines)
			total_array[0] += l.to_i
			print w = count_w(lines)
			total_array[1] += w.to_i
			print c = count_c(lines)
			total_array[2] += c.to_i
			print " #{file}"
			puts 
		end
		total_print(total_array) if files.count >= 2
	else
		files.each do |file|
			lines = File.read(file)
			print count_l(lines) if params['l']
			print count_w(lines) if params['w']
			print count_c(lines) if params['c']
			print " #{file}"
			puts
		end
	end
end

def total_print(total_array)
	total_array.each do |each_total|
		print each_total.to_s.rjust(SIZE_INDENT)
	end
	print " total"
	puts
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

main
