#!/usr/bin/env rake
require "bundler/gem_tasks"

desc "Set up and run tests"
task :default => [:test]

desc "Run tests"
task :test do
  sh "bacon -Itest -rubygems -a -q"
end
