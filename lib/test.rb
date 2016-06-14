require 'pry'

require_relative "libui/libui"
require './lib/events.rb'

module Box
  class Horizontal
    def self.ptr(padded: 0)
      LibUI.uiNewHorizontalBox.tap { |ptr|
        LibUI.uiBoxSetPadded( ptr, padded )
      }
    end
  end
  class Vertical
    def self.ptr(padded: 0)
      LibUI.uiNewVerticalBox.tap { |ptr|
        LibUI.uiBoxSetPadded( ptr, padded )
      }
    end
  end
  def self.append(parent: nil, child: nil, stretchy: 1)
    return raise unless parent and child
    LibUI.uiBoxAppend( parent, child, stretchy )
  end
end

module Tab
  def self.append( parent: nil, title: nil, &block)
    return raise unless parent and title and block
    LibUI.uiTabAppend( parent, title, block.call )
  end
end

module Window

  PRO_CMD = "system_profiler SPDisplaysDataType"

  PRIMARY = "#{PRO_CMD} | egrep 'Resolution|Main Display\:' | awk '//{print $1}'"
  MON_RES = "#{PRO_CMD} | awk '/Resolution/{print $X}'"

  @@ptr = nil
  @@monitor_count = 1

  @@height = nil
  @@width = nil

  def self.ptr( title: nil, width: nil, height: nil, margined: 1, has_menubar: 0 )

    return @@ptr if @@ptr
    return raise unless title

    read_display_width
    read_display_height

    puts "Detected #{@@monitor_count} monitors."
    puts "Detected Monitor ID: #{read_primary_monitor} as default."
    puts "Resolution of #{@@width}W x #{@@height}h"

    width  = @@width  unless width
    height = @@height unless height

    @@ptr = LibUI.uiNewWindow(
      title, width, height, has_menubar
    ).tap { |ptr|
      LibUI.uiWindowSetMargined( ptr, margined )
    }

  end

  # Only works with two monitors right now
  def self.read_primary_monitor
    0 if `#{PRIMARY}` == "Resolution:\nMain\nResolution:\n"
    1 if `#{PRIMARY}` == "Resolution:\nResolution:\nMain\n"
  end

  def self.read_display_width
    # If we still have line break after chomp then multiple displays
    maybe_width = `#{MON_RES.gsub("X","2")}`.chomp
    if maybe_width.include?("\n")
      @@monitor_count = 2
      @@width = maybe_width.split("\n")[read_primary_monitor].to_i
    else
      @@width = maybe_width.to_i
    end
  end

  def self.read_display_height
    # If we still have line break after chomp then multiple displays
    maybe_height = `#{MON_RES.gsub("X","4")}`.chomp
    if maybe_height.include?("\n")
      @@monitor_count = 2
      @@height = maybe_height.split("\n")[read_primary_monitor].to_i
    else
      @@height = maybe_height.to_i
    end
  end

  def self.child( child )
    return raise unless child
    LibUI.uiWindowSetChild( Window::ptr(), child )
  end

  def self.close_event( event )
    return raise unless event
    LibUI.uiWindowOnClosing( Window::ptr(), event, nil )
  end

end

Window::ptr( title: "Mash GUI" )

hbox = Box::Horizontal.ptr()
vbox = Box::Vertical.ptr()

Box::append(
  parent: vbox,
  child: hbox,
  stretchy: 1
)

inner = Box::Vertical.ptr( padded: 1 )

Box::append(
  parent: hbox,
  child: inner,
  stretchy: 1
)


tabControl = LibUI.uiNewTab

Tab::append( parent: tabControl, title: "SSH Server" ) {
  Box::Horizontal.ptr( padded: 1 )
}

Tab::append( parent: tabControl, title: "Browse App" ) {
  Box::Horizontal.ptr( padded: 1 )
}

Tab::append( parent: tabControl, title: "View Help" ) {
  Box::Horizontal.ptr( padded: 1 )
}


Box::append(
  parent: inner,
  child: tabControl,
  stretchy: 1
)


Window::child( vbox )
Window::close_event( Events::should_quit )

LibUI.uiControlShow( Window::ptr() )

LibUI.uiMain
LibUI.uiQuit
