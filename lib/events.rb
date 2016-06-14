module Events
  def self.should_quit
    Proc.new do |ptr|
      puts "QUITTING!"
      LibUI.uiControlDestroy( Window::ptr() )
      LibUI.uiQuit
      0
    end
  end
end
