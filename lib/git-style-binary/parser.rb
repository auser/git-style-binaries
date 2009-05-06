module GitStyleBinary
class Parser < Trollop::Parser
  attr_reader :runs
  attr_reader :short

  def initialize *a, &b
    super
    @runs = []
  end

  # def banner s=nil; @banner = lambda{s} if s; @banner end
  def banner      s=nil; @banner     = s if s; @banner     end
  def short_desc  s=nil; @short_desc = s if s; @short_desc end

  ## Adds text to the help display.
  def text s; @order << [:text, s] end

  def spec_names
    @specs.collect{|name, spec| spec[:long]}
  end

  ## Print the help message to 'stream'.
  def educate stream=$stdout
    width # just calculate it now; otherwise we have to be careful not to
          # call this unless the cursor's at the beginning of a line.

    left = {}
    @specs.each do |name, spec| 
      left[name] = "--#{spec[:long]}" +
        (spec[:short] ? ", -#{spec[:short]}" : "") +
        case spec[:type]
        when :flag; ""
        when :int; " <i>"
        when :ints; " <i+>"
        when :string; " <s>"
        when :strings; " <s+>"
        when :float; " <f>"
        when :floats; " <f+>"
        end
    end

    leftcol_width = left.values.map { |s| s.length }.max || 0
    rightcol_start = leftcol_width + 6 # spaces

    unless @order.size > 0 && @order.first.first == :text
      stream.puts "#@version\n" if @version
      stream.puts eval(%Q["#{@banner}"]) + "\n" if @banner # lazy banner
      stream.puts "Options:"
    else
      stream.puts "#@banner\n" if @banner
    end

    @order.each do |what, opt|
      if what == :text
        stream.puts wrap(opt)
        next
      end

      spec = @specs[opt]
      stream.printf "  %#{leftcol_width}s:   ", left[opt]
      desc = spec[:desc] + 
        if spec[:default]
          if spec[:desc] =~ /\.$/
            " (Default: #{spec[:default]})"
          else
            " (default: #{spec[:default]})"
          end
        else
          ""
        end
      stream.puts wrap(desc, :width => width - rightcol_start - 1, :prefix => rightcol_start)
    end
  end

  def consume(&block)
    cloaker(&block).bind(self).call
  end

  def consume_all(blocks)
    blocks.each {|b| consume(&b)}
  end

  def bin_name
    GitStyleBinary.full_current_command_name
  end

  def all_options_string
    '#{spec_names.collect(&:to_s).collect{|name| "[--" + name + "]"}.join(" ")} COMMAND [ARGS]'
  end

  # id like to put all runs in a hash and run whichever one matches the command
  # name. the problem is the cmd loading. that is to say, how do we get the
  # name 'wordpress' when we load the global block, and wordpress-post, or
  # simply 'post' when we load the local block?  if you can do do that, then
  # you can have the right run here
  def run(&block)
    @runs << block
  end
 
end
end