class AppDelegate
  def main
    args = NSProcessInfo.processInfo.arguments

    case args[1]
    when 'server'
      bootServer!
      return
    when 'help', nil
      showHelp
      exit 0
    end

    if !daemonRunning?
      bootServerInBackground!(args[0])
    end

    ret = server.handleCommand(args)
    if ret.is_a?(String)
      $stderr.puts(ret)
      showHelp
      exit 1
    end

    exit
  end

  def showHelp
    $stderr.puts <<-HELP.gsub(/^\s+/, "")
      drawrect draws a rect on the screen. Useful for debugging.
      See https://github.com/chendo/drawrect for more details.

      Usage:
      drawrect rect <rect> [label] [colour] [opacity] - draws a rect with bottom left origin
      drawrect flipped_rect <rect> [label] [colour] [opacity] - draws a rect with top left origin
      drawrect clear - clears all rects
      drawrect quit - quits server
    HELP
  end

  def daemonRunning?
    !server.nil?
  end

  def bootServerInBackground!(path)
    NSTask.launchedTaskWithLaunchPath(path, arguments:["server"])

    secondsLeft = 5
    while !daemonRunning? && secondsLeft > 0
      sleep 0.1
      secondsLeft -= 0.1
    end

    if !daemonRunning?
      $stderr.puts "Couldn't boot server :("
      exit
    end
  end

  def bootServer!
    # We need to run NSApplicationMain to be able to make windows
    app = NSApplication.sharedApplication
    app.delegate = self

    NSApp.run
  end

  def applicationDidFinishLaunching(notification)
    DrawRect.new.listen
  end

  def server
    @server ||= NSConnection.rootProxyForConnectionWithRegisteredName("drawrect.server", host: nil)
  end
end
