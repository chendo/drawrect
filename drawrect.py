# LLDB script that lets you easily use drawrect
# Usage: (while at a breakpoint)
#  dr element.bounds      - draws the the rect at element.bounds
#  drc                    - clears rects

import lldb
import shlex
from subprocess import call

drawRectPath = '/usr/local/bin/drawrect'

def rectDescription(frame, expr):
    return frame.EvaluateExpression("(NSString *)NSStringFromRect({0})".format(expr)).GetObjectDescription()

def callDrawRect(args):
    call([drawRectPath] + args)

def drawrect(debugger, user_input, result, unused):
    args = shlex.split(user_input)

    target = debugger.GetSelectedTarget()
    frame = target.GetProcess().GetSelectedThread().GetFrameAtIndex(0)

    expr = args.pop(0)
    rectString = rectDescription(frame, expr)

    callDrawRect(['rect', rectString, expr])

    return None

def drawrectFlipped(debugger, user_input, result, unused):
    args = shlex.split(user_input)

    target = debugger.GetSelectedTarget()
    frame = target.GetProcess().GetSelectedThread().GetFrameAtIndex(0)

    expr = args.pop(0)
    rectString = rectDescription(frame, expr)

    callDrawRect(['flipped_rect', rectString, expr])

    return None

def clear(debugger, user_input, result, unused):
    callDrawRect(['clear'])

def __lldb_init_module(debugger, unused):
    debugger.HandleCommand('command script add --function drawrect.drawrect dr')
    debugger.HandleCommand('command script add --function drawrect.drawrectFlipped drf')

    debugger.HandleCommand('command script add --function drawrect.clear drc')
    debugger.HandleCommand('drc')
