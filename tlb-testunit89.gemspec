$module_name="testunit"
$framework='test::unit'
$name="tlb-testunit89"
require File.join(File.dirname(__FILE__), 'gem_common')

Gem::Specification.new do |s|
  configure_tlb(s)
  depends_on_core s
  s.platform = 'java' 
  s.version = '0.3.4'
  s.add_runtime_dependency 'test-unit', '> 0',  '< 2.4'
end
