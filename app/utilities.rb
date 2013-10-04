def CGRectMidPoint(bounds)
  CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
end

def CGRectFlip(rect)
  screenHeight = NSMaxY(NSScreen.screens.first.frame)
  CGRectMake(rect.origin.x,
    screenHeight - NSMaxY(rect),
    rect.size.width,
    rect.size.height
  )
end

def CGColorCreateHex(hex, alpha = 1.0)
  # yolo
  CGColorCreateGenericRGB(*hex.scan(/[a-f0-9]{2}/i).map do |hex|
    hex.to_i(16) / 255.0
  end, alpha)
end

class NSScreen
  def self.mergedScreenBounds
    NSScreen.screens.inject(CGRectZero) do |rect, screen|
      rect = NSUnionRect(rect, screen.frame)
    end
  end
end
