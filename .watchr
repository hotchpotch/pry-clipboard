
watch( 'test/test_.*\.rb' )  {|md| system("bundle exec rake test") }
watch( 'lib/(.*)\.rb' )      {|md| system("bundle exec rake test") }
