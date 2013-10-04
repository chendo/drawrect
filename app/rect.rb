class Rect
  attr_reader :layer
  def initWithRect(bounds, label: label, colour: colour, opacity: opacity)
    @layer = CALayer.layer
    @layer.bounds = bounds
    @layer.backgroundColor = CGColorCreateHex(colour, opacity)
    @layer.position = CGRectMidPoint(bounds)
    @layer.opacity = 1.0

    @layer.layoutManager = CAConstraintLayoutManager.layoutManager

    label ||= NSStringFromRect(bounds)

    @layer.addSublayer(textLayerWithLabel(label, layer.frame))
    self
  end

  def textLayerWithLabel(label, frame)
    layer = CATextLayer.layer
    layer.string = label
    layer.font = NSFont.fontWithName("HelveticaNeue-Bold", size: 14)
    layer.fontSize = 14.0

    layer.addConstraint(CAConstraint.constraintWithAttribute(KCAConstraintMidY,
      relativeTo:"superlayer",
      attribute: KCAConstraintMidY))

    layer.addConstraint(CAConstraint.constraintWithAttribute(KCAConstraintMidX,
      relativeTo:"superlayer",
      attribute: KCAConstraintMidX))
    layer.foregroundColor = CGColorCreateGenericGray(0, 1)
    layer.frame = frame
    layer
  end
end
