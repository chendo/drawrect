class OverlayWindow < NSWindow
  def initWithContentRect(bounds, styleMask: styleMask, backing:backing, defer:defer)
    super

    self.opaque = false
    self.alphaValue = 1.0
    self.backgroundColor = NSColor.clearColor
    self.level = NSScreenSaverWindowLevel + 1
    self.ignoresMouseEvents = true

    self.contentView.tap do |view|
      view.alphaValue = 0
      view.wantsLayer = true
      view.needsDisplay = true
    end

    @rootLayer = CALayer.layer
    @rootLayer.delegate = self
    @rootLayer.bounds = self.contentView.frame
    self.contentView.layer = @rootLayer

    orderFrontRegardless
  end

  def addRect(rect)
    @rootLayer.addSublayer(rect.layer)
  end

  def clear
    @rootLayer.sublayers = nil
  end
end
