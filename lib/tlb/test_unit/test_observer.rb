require 'run_data'

module Tlb::TestObserver
  def self.included base
    base.send(:alias_method, :run_suite_without_test_observers, :run_suite)
    base.send(:remove_method, :run_suite)
    base.send(:include, InstanceMethods)
  end

  class TestUnitRunData
    include Tlb::RunData

    def suite_failed(failure)
      update_suite_failed(suite_name_for(failure.test_name))
    end

    def suite_name_for(test_name)
      test_name.scan(/\((.+)\)$/).flatten.first
    end
  end

  module InstanceMethods
    def run_suite
      run_data = TestUnitRunData.new
      
      add_listener(Test::Unit::TestResult::FAULT) do |fault|
        run_data.suite_failed(fault)
      end

      add_listener(Test::Unit::UI::TestRunnerMediator::FINISHED) do |*elapsed_time|
        run_data.report_all_suite_data
      end

      add_listener(Test::Unit::TestSuite::STARTED) do |suite_name|
        run_data.suite_started(suite_name)
      end


      add_listener(Test::Unit::TestSuite::FINISHED) do |suite_name|
          run_data.update_suite_data(suite_name)
      end

      run_suite_without_test_observers
    end
  end
end
