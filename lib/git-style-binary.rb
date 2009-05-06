require 'trollop'
require 'lib/ext/core'
require 'git-style-binary/autorunner'
Dir[File.dirname(__FILE__) + "/git-style-binary/helpers/*.rb"].each {|f|  require f}

module GitStyleBinary
 
  class << self
    include Helpers::NameResolver
    attr_accessor :current_command
    attr_accessor :primary_command

    # If set to false GitStyleBinary will not automatically run at exit.
    attr_writer :run

    # Automatically run at exit?
    def run?
      @run ||= false
    end

    def parser
      @p ||= Parser.new
    end

    def load_primary
      unless @loaded_primary
        @loaded_primary = true
        primary_file = File.join(binary_directory, basename) 
        load primary_file
      end
    end

    def load_subcommand
      unless @loaded_subcommand
        @loaded_subcommand = true
        cmd_file = GitStyleBinary.binary_filename_for(GitStyleBinary.current_command_name)
        p [:loading, cmd_file]
        load cmd_file
      end
    end

  end
end

at_exit do
  unless $! || GitStyleBinary.run?
    command = GitStyleBinary::AutoRunner.run
    exit 0
  end
end
