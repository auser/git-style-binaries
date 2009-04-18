require 'git-style-binary'
require 'git-style-binary/command'

module GitStyleBinary
  def self.primary(basename=nil, &block)
    basename ||= self.basename # ? 
    self.add_constraint(&block)
  end

  def self.populate_defaults
    self.primary do
      version "#{File.basename($0)} 0.0.1 (c) 2009 Nate Murray"
    #   banner <<-EOS
    # usage: #{$0} #{all_options.collect(:&to_s).join(" ")} COMMAND [ARGS]
    
    # The wordpress subcommands commands are:
    # {subcommands.pretty_print}
    
    # See 'wordpress help COMMAND' for more information on a specific command.
    # EOS
    #   opt :verbose,  "verbose", :default => false
    #   opt :dry,      "dry run", :default => false
    #   opt :test_global, "a basic global string option", :type => String
    end
  end

  # when you require primary, then it sets up a bunch of default options. 
  # 
  # who is responsible for parsing the arguments?
  # is the autorunner just a command? should they just be merged?
  # you need to know what you are running
  # the primary, just loads primary
  # the command, just loads command
  # in both cases, what gets run? the autorunner? how do we know the difference
  # between the primary and the command being run?
  #
  # what does the primary/command even specify? where do those specfications lie?
  #
  # how does the version, banner, etc get set? are the primary and commands simply trollop parsers?
  # the command needs to create a parser and then act on it. set some default options
  # but the autorunner is already creating the parser
  #
  # this needs a bit more mapping out
  class Primary < Command
    def initialize(base_name=nil)
      super
    end


# command = GitStyleBinary::primary("wordpress") do
#   version "#{$0} 0.0.1 (c) 2009 Nate Murray"
#   banner <<-EOS
# usage: #{$0} #{all_options.collect(:&to_s).join(" ")} COMMAND [ARGS]
#
# The wordpress subcommands commands are:
# {subcommands.pretty_print}
#
# See 'wordpress help COMMAND' for more information on a specific command.
# EOS
#   opt :verbose,  "verbose", :default => false
#   opt :dry,      "dry run", :default => false
#   opt :test_global, "a basic global string option", :type => String
# end
  end
end


