require 'thor'

module Scratch
  class CLI < Thor

    desc "task A","do task A things"

    def taska(*args)
      puts args
      if options[:option_a]
        puts "option a"
      end
    end

    desc "task B","task b things"
    method_option :option_a, :desc => "task a option task_a"

    def supertask *args
      puts " i am the supertask"
      puts "opt a" if options[:option_a]
    end

    default_task :supertask

  end
end

Scratch::CLI.start(ARGV)