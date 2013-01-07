require 'vinz/version'

class VINZ
  DIR = File.expand_path(File.join(File.dirname(__FILE__), '..'))
end

$: << "#{VINZ::DIR}/lib" unless $:.include?("#{VINZ::DIR}/lib")

