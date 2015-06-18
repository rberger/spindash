module Spindash
  class Spin

    def initialize(args)
      puts "args: #{args.inspect}"
      @verbose = args[:verbose]
      @dry_run = args[:dry_run]
      @time = args[:time].to_i
      @x_spaces = args[:x_spaces].to_i
      @y_spaces = args[:y_spaces].to_i
      @space_width = args[:width].to_i
      @space_hieght = args[:hieght].to_i

      @viewport = {x: 0, y: 0}
      @current_space = 0
    end
    
    def mouse_state
      return if @dry_run
      current_viewport_string = `xdotool get_desktop_viewport --shell`[/X=(\d+)\nY=(\d+)/]
      current_viewport = current_viewport_string.lines.map {|s| s[/.=(\d+)/, 1].to_i}
      lower_right = [(current_viewport[0] + @space_width -1), (current_viewport[1] + @space_hieght -1)]
      loc = getMouseLocation
      case loc
      when current_viewport
        :stop
      when lower_right
        :end
      else
        nil
      end
    end
    
    def run
      loop do
        puts "Spin#run: About to sleep for #{@time.inspect} seconds" if @verbose
        sleep @time

        puts "About to call mouse_state"
        case mouse_state()
        when :end
          break 
        when :stop
          next
        end
        spin
      end
    end

    def calc_viewport
      space_x = @current_space % @x_spaces
      space_y = @current_space / @x_spaces
      @viewport[:x] = space_x * @space_width
      @viewport[:y] = space_y * @space_hieght
      puts "Spin#calc_viewport: @current_space: #{@current_space.inspect} space_x: #{space_x} space_y: #{space_y} @viewport: #{@viewport.inspect}"  if @verbose
      @current_space = @current_space + 1
      @current_space = 0 if @current_space >= @x_spaces * @y_spaces
      @viewport
    end
    
    def spin
      calc_viewport
      puts "Spin#spin: wmctrl -o #{@viewport[:x]}, #{@viewport[:y]}"
#      system("wmctrl -o #{@viewport[:x]}, #{@viewport[:y]}") unless @dry_run
    end
  end
end
