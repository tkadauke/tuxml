Gem::Specification.new do |s| 
  s.platform  =   Gem::Platform::RUBY
  s.name      =   "tuxml"
  s.version   =   "0.0.1"
  s.date      =   Date.today.strftime('%Y-%m-%d')
  s.author    =   "Thomas Kadauke"
  s.email     =   "tkadauke@imedo.de"
  s.homepage  =   "http://github.com/tkadauke/tuxml"
  s.summary   =   "JUnit XML compatible output for Ruby's Test::Unit framework"
  s.files     =   Dir.glob("{lib}/**/*")

  s.require_path = "lib"
end
