#Generated at 2013-09-05 13:34:38 -0500

require 'rubygems'
require 'bundler/setup'
require 'taza/tasks'

Taza::Rake::Tasks.new do |t|
  file_hole = FileUtils.mkdir_p "artifacts/#{Time.now.to_i}"
  t.spec_opts = ["--require taza",
                "--format html --out #{file_hole}/index.html",
                "--format p" ,
                "--format FailingExamplesFormatter --out #{file_hole}/failing_examples.txt"]
end
