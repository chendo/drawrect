# drawrect

`drawrect` is a simple command line OS X app that draws rectangles on the screen.

It was originally designed to aid debugging [Shortcat](http://shortcatapp.com/) by visualising `CGRect`s or `NSRect`s from within `lldb`.

## Screenshot

![Screenshot](http://cl.ly/image/3a3f2s0k2a06/drawrect.png)

## Usage

`drawrect` was designed to be used from within `lldb`

* `dr object.bounds`  - draws a rect at object.bounds using bottom-left origin
* `drf object.bounds` - draws a rect at object.bounds using top-left origin
* `drc`               - clears all rects

You can use it from the command line as well.

```bash
Usage:
drawrect rect <rect> [label] [colour] [opacity] - draws a rect with bottom left origin
drawrect flipped_rect <rect> [label] [colour] [opacity] - draws a rect with top left origin
drawrect clear - clears all rects
drawrect quit - quits server
```

## Installation

* Download the [binary](https://github.com/chendo/drawrect/releases/download/v1.0/drawrect) or [build it yourself](#building-from-source)
  * `curl https://github.com/chendo/drawrect/releases/download/v1.0/drawrect > /usr/local/bin/drawrect`
* **Optional:** Grab `lldb` script:
  * `mkdir -p ~/Library/lldb; curl https://github.com/chendo/drawrect/raw/master/drawrect.py > ~/Library/lldb/drawrect.py`
  * `echo "command script import ~/Library/lldb/drawrect.py" >> ~/.lldbinit`

## Notes

* Only tested on 10.8
* The backgrounded `drawrect` server will exit after an hour of inactivity.
* The rects will stay on the screen after `lldb` quits. I couldn't seem to find hooks for process termination or resuming execution.

## Building from source

`drawrect` is written in RubyMotion, so you'll need that to compile it.

```bash
$ rake build:development  # binary will get built at `build/MacOSX*/drawrect.app/MacOS/drawrect`
```

## License

See [LICENSE](https://github.com/chendo/drawrect/blob/master/LICENSE) for details.
