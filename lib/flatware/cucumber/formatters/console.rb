require 'flatware/cucumber/formatters/console/summary'
require 'cucumber/formatter/console'

module Flatware::Cucumber::Formatters
  class Console
    #for format_string
    include ::Cucumber::Formatter::Console

    FORMATS = {
      passed:    '.',
      failed:    'F',
      undefined: 'U',
      pending:   'P',
      skipped:   '-'
    }

    STATUSES = FORMATS.keys

    attr_reader :out, :err

    def initialize(stdout, stderr)
      @out, @err = stdout, stderr
    end

    def progress(result)
      out.print format result.progress
    end

    def summarize(checkpoints)
      steps = checkpoints.flat_map(&:steps)
      scenarios = checkpoints.flat_map(&:scenarios)
      Summary.new(steps, scenarios, out).summarize
    end

    def summarize_remaining(remaining_jobs)
      out.puts
      out.puts "The following features have not been run:"
      for job in remaining_jobs
        out.puts job.id
      end
    end

    private
    def format(status)
      format_string FORMATS[status], status
    end
  end
end
