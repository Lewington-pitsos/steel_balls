require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.test_files = FileList['rubyscripts/testing/**/*_test.rb']
end

Rake::TestTask.new(:db_test) do |t|
  t.test_files = FileList['rubyscripts/testing/**/database/**/*_test.rb']
end

task default: :test
