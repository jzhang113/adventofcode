# frozen_string_literal: true

require 'open-uri'

# Helpers for getting puzzle input and making it available as `input`
module Input
  BASE_DIR = '../input'
  USER_AGENT = 'custom downloader - jzhang113 - jiahuaz01@gmail.com'
  AOC_SESSION = ENV.fetch('AOC_SESSION')

  def self.included(obj)
    path, = caller[0].partition(':')
    day_num = File.basename(path, '.rb').to_i
    year = File.realpath(File.dirname(path)).split('/').last

    obj.class_eval <<-RUBY, __FILE__, __LINE__ + 1
      def input
        @input ||= #{get_input(day_num, year)}
      end
    RUBY
  end

  module_function

  def get_input(day, year, delimiter: "\n")
    input = load_and_read(day, year)

    return input if delimiter.nil?

    input.split(delimiter)
  end

  def load_and_read(day, year)
    input_file_path = File.join(File.dirname(__FILE__), BASE_DIR, "#{year}_#{format('%02d', day)}.txt")
    download_url = "https://adventofcode.com/#{year}/day/#{day}/input"

    if File.file?(input_file_path)
      puts "The file #{input_file_path} already exists; reading local copy"
      return File.read(input_file_path)
    end

    URI.parse(download_url).open('User-Agent' => USER_AGENT, 'Cookie' => AOC_SESSION) do |blob|
      File.open(input_file_path, 'w+') do |file|
        file.write(blob.read)
        puts "Wrote file #{input_file_path}"

        file.rewind
        return file.read
      end
    end
  end
end
