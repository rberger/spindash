require 'rbconfig'

module Spindash
  ##
  # Returns an array [x,y] containing the mouse coordinates
  # Be aware that the coordinate system is OS dependent.
  def getMouseLocation
    def linux
      loc_string = `xdotool getmouselocation --shell`[/X=(\d+)\nY=(\d+)/]
      loc_string.lines.map {|s| s[/.=(\d+)/, 1].to_i}
    end

    host_os = ::RbConfig::CONFIG['host_os']
    case host_os
    when /linux|solaris|bsd/
      linux
    else
      raise Exception, "unknown os: #{host_os.inspect}"
    end
  rescue Exception => e
    [nil,nil]
  end
end
