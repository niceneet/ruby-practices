#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'debug'

SIZE_INDENT = 8

def main #ファイル引数なし
	params = ARGV.getopts('lwc')
	files = ARGV 
	if files.empty?
		lines = $stdin.read
	end
	total_array = {l: 0, w: 0, c: 0}
	unless params.values.any?
		files.each do |file|
			lines = File.read(file)
			print l = count_l(lines)
			total_array[:l] += l.to_i
			print w = count_w(lines)
			total_array[:w] += w.to_i
			print c = count_c(lines)
			total_array[:c] += c.to_i
			print " #{file}"
			puts 
		end
		total_print_no_option(total_array) if files.count >= 2
	else
		files.each do |file|
			lines = File.read(file)
			print l = count_l(lines) if params['l']
			total_array[:l] += l.to_i
			print w = count_w(lines) if params['w']
			total_array[:w] += w.to_i
			print c = count_c(lines) if params['c']
			total_array[:c] += c.to_i
			print " #{file}"
			puts
		end
		total_print_option(total_array, params) if files.count >= 2
	end
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

def total_print_no_option(total_array)
	total_array.each do |each_total|
		print each_total[1].to_s.rjust(SIZE_INDENT)
	end
	print " total"
	puts
end

def total_print_option(total_array, params)
	total_array.zip(params) do |each_total, opt|
		print each_total[1].to_s.rjust(SIZE_INDENT) if opt[1] == true
	end
	print " total"
	puts
end

main
