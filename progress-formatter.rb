require 'spec/runner/formatter/base_text_formatter'
require 'progressbar'

class Progress < Spec::Runner::Formatter::BaseTextFormatter
  attr_reader :example_count, :finished_count
  
  def initialize(options, where)
    super
    @example_times = []
  end

  def start(count)
    @example_count = count
    @fail_count = 0
    @finished_count = 0
    @progress_bar = ProgressBar.new("  #{count} examples", count, output)
    @progress_bar.instance_variable_set("@bar_mark", "=")
  end

  def example_started(example)
    @time = Time.now
  end

  def example_failed(example, counter, failure)
    super
    @example_times << [ 
      example_group.description,
      example.description,
      Time.now - @time,
      'red'
    ]
    @state = :red
    output.print "\e[K"
    fail_list(failure)
    increment
  end

  def example_passed(example)
    super
    @example_times << [ 
      example_group.description, 
      example.description, 
      Time.now - @time, 
      'green'
    ]
    @state = :green
    increment
  end

  def example_pending(example, message, deprecated_pending_location=nil)
    super
    increment
  end

  def start_dump(times = true)
    super()
    if times
      count = @example_times.size < 20 ? @example_times.size : 20
      @output.puts "\n\nTop #{count} slowest examples:\n"

      @example_times = @example_times.sort_by do |description, example, time, color|
        time
      end.reverse

      @example_times[0..20].each do |description, example, time, color|
        case color
        when 'red'
          @output.print red(sprintf("%.3f", time) + "sec")
        when 'green'
          @output.print green(sprintf("%.3f", time) + "sec")
        end
        @output.puts " #{description} #{example}"
      end
      @output.flush
    end
  end

  def dump_pending
  end

  def dump_failure(counter, failure)
  end

  def state
    @state ||= :green
  end

  def colors
    { :red => 31, :green => 32, :yellow => 33 }
  end

  def increment
    with_color do
      @finished_count += 1
      @progress_bar.instance_variable_set("@title", "  #{finished_count}/#{example_count}")
      @progress_bar.inc
    end
  end

  def with_color
    output.print "\e[#{colors[state]}m"
    yield
    output.print "\e[0m"
  end

  def fail_list(failure)
    @fail_count += 1
    puts red(@fail_count.to_s + ")" + failure.header)
    puts red(" " + failure.exception.message)
    puts " "
  end
end

class Onlytime < Progress
  def fail_list(failure)
  end
end

class OnlyFail < Progress
  def start_dump
    super(false)
  end
end
