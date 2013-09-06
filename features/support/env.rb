$LOAD_PATH << File.expand_path('../../../lib/sites', __FILE__)
$PROJECT_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '../..'))
Dir["#{$PROJECT_ROOT}/lib/sites/*.rb"].each { |file| require file }
require 'rubygems'
require 'bundler/setup'
require 'rspec'
require 'taza'
require 'watir-webdriver'
require 'watir-webdriver/wait'
require 'watir-webdriver/extensions/alerts'
require 'chronic'
require 'os'
require 'active_record'
require 'factory_girl'
require 'pry'
require 'pry-nav'

$OS = ''
if OS.linux?
  $OS = 'Linux'
elsif OS.mac?
  $OS = 'macOS'
elsif OS.windows?
  $OS = 'Windows'
end
puts "OS == #{$OS} #{OS.bits} bit \n\n"

#append tools directory to the path for chromedriver
if OS.windows?
  ENV['PATH'] = File.join(File.dirname(__FILE__), '..', '..', 'tools', 'chromedriver', 'windows') + ';' + ENV['PATH']
  ENV['PATH'] = File.join(File.dirname(__FILE__), '..', '..', 'tools', 'iedriverserver') + ';' + ENV['PATH']
  ENV['PATH'] = File.join(File.dirname(__FILE__), '..', '..', 'tools', 'instant_client') + ';' + ENV['PATH']
elsif OS.mac?
  ENV['PATH'] = File.join(File.dirname(__FILE__), '..', '..', 'tools', 'chromedriver', 'mac') + ':' + ENV['PATH']
elsif OS.linux? && OS.bits == 32
  ENV['PATH'] = File.join(File.dirname(__FILE__), '..', '..', 'tools', 'chromedriver', 'linux_32') + ':' + ENV['PATH']
elsif OS.linux? && OS.bits == 64
  ENV['PATH'] = File.join(File.dirname(__FILE__), '..', '..', 'tools', 'chromedriver', 'linux_64') + ":" + ENV['PATH']
  #ENV['PATH'] = File.join(File.dirname(__FILE__), '..', '..', 'tools', 'instant_client', 'linux_64') + ":" + ENV['PATH']
  ENV["JAVA_HOME"]='/etc/alternatives/java_sdk_1.6.0' if(ENV["JAVA_HOME"].nil?)
else
  p 'unknown OS'
end

#set defaults
(ENV['TAZA_ENV'] = 'isolation')
(ENV['BROWSER'] ||= 'firefox').downcase
(ENV['DRIVER'] ||= 'watir_webdriver').downcase

#option HEADLESS=true
if ENV['HEADLESS']
  require 'headless'
  headless = Headless.new
  headless.start
  at_exit do
    headless.destroy
  end
end

Watir::always_locate = true