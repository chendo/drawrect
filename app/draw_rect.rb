class DrawRect
  attr_reader :overlay

  AUTO_SHUTDOWN_AFTER = 3600 # 1 hour
  def initialize
    setupOverlay
  end

  def setupOverlay
    @overlay = OverlayWindow.alloc.initWithContentRect(NSScreen.mergedScreenBounds,
      styleMask: NSBorderlessWindowMask,
      backing: NSBackingStoreBuffered,
      defer: true)
  end

  def addRect(rect, label, colour, opacity)
    overlay.addRect(Rect.alloc.initWithRect(rect, label: label, colour: colour, opacity: opacity))
    nil
  end

  def listen
    connection = NSConnection.defaultConnection
    connection.rootObject = self

    if !connection.registerName("drawrect.server")
      $stderr.puts "Could not register mach port name, quitting"
      exit
    end

    resetAutoQuit
  end

  def handleCommand(commandArray)
    command, *args = commandArray[1..-1]
    case command
    when 'rect', 'flipped_rect'
      rectString, label, colour, opacity = args

      rect = NSRectFromString(rectString)
      rect = CGRectFlip(rect) if command == 'flipped_rect'
      colour ||= randomColour
      opacity ||= 0.7

      if rect == CGRectZero
        return "Could not parse a rect from '#{rectString}'"
      end

      addRect(rect, label, colour, opacity)
      resetAutoQuit
      true
    when 'clear'
      resetAutoQuit
      overlay.clear
    when 'quit'
      quit
    else
      "Invalid command: #{command}"
    end
  end

  private

  def quit
    Dispatch::Queue.main.after(0) do
      exit 0
    end
  end

  def resetAutoQuit
    self.class.cancelPreviousPerformRequestsWithTarget(self)
    performSelector(:quit, withObject: nil, afterDelay:AUTO_SHUTDOWN_AFTER)
  end

  COLOURS = [
    '113F8C',
    '01A4A4',
    '00A1CB',
    '61AE24',
    'D0D102',
    '32742C',
    'D70060',
    'E54028',
    'F18D05',
    '616161',
  ].freeze

  def randomColour
    if !@colours || @colours.empty?
      @colours = COLOURS.dup.shuffle
    end
    @colours.shift
  end
end
