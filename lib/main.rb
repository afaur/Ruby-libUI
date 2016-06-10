require_relative "libui/libui"

options =  LibUI::InitOptions.new
init    =  LibUI.uiInit(options)

if init != nil
  puts "error"
  puts LibUI.uiFreeInitError(init)
end

should_quit = Proc.new do |ptr|
  puts "QUITTING!"
  LibUI.uiControlDestroy(MAIN_WINDOW)
  LibUI.uiQuit
  0
end

checkbox_toggle = Proc.new do |ptr|
  checked = LibUI.uiCheckboxChecked(ptr) == 1
  LibUI.uiWindowSetTitle(MAIN_WINDOW, "Checkbox is #{checked}")
  LibUI.uiCheckboxSetText(ptr, "I am the checkbox (#{checked})")
end

open_menu_item_clicked = Proc.new do |ptr|
  puts "Clicked 'Open'"
end

save_menu_item_clicked = Proc.new do |ptr|
  puts "Clicked 'Save'"
end

# Create 'File' menu with a few items and callbacks
# when the items are clicked
menu = LibUI.uiNewMenu("File")
open_menu_item = LibUI.uiMenuAppendItem(menu, "Open")
LibUI.uiMenuItemOnClicked(open_menu_item, open_menu_item_clicked, nil)
save_menu_item = LibUI.uiMenuAppendItem(menu, "Save")
LibUI.uiMenuItemOnClicked(save_menu_item, save_menu_item_clicked, nil)
LibUI.uiMenuAppendQuitItem(menu)
LibUI.uiOnShouldQuit(should_quit, nil)

# Create 'Edit' menu
edit_menu = LibUI.uiNewMenu("Edit")
LibUI.uiMenuAppendCheckItem(edit_menu, "Checkable Item")
LibUI.uiMenuAppendSeparator(edit_menu)
disabled_item = LibUI.uiMenuAppendItem(edit_menu, "Disabled Item");
LibUI.uiMenuItemDisable(disabled_item);

preferences = LibUI.uiMenuAppendPreferencesItem(menu)

help_menu = LibUI.uiNewMenu("Help")
LibUI.uiMenuAppendItem(help_menu, "Help")
LibUI.uiMenuAppendAboutItem(help_menu)


vbox = LibUI.uiNewVerticalBox
hbox = LibUI.uiNewHorizontalBox
LibUI.uiBoxSetPadded(vbox, 1)
LibUI.uiBoxSetPadded(hbox, 1)

LibUI.uiBoxAppend(vbox, hbox , 1)

group = LibUI.uiNewGroup("Basic Controls")
LibUI.uiGroupSetMargined(group, 1)
LibUI.uiBoxAppend(hbox, group, 0)

inner = LibUI.uiNewVerticalBox
LibUI.uiBoxSetPadded(inner, 1)
LibUI.uiGroupSetChild(group, inner)

button = LibUI.uiNewButton("Button")
button_clicked_callback = Proc.new do |ptr|
  LibUI.uiMsgBox(MAIN_WINDOW, "Information", "You clicked the button")
end

LibUI.uiButtonOnClicked(button, button_clicked_callback, nil)
LibUI.uiBoxAppend(inner, button, 0)
LibUI.uiBoxAppend(inner, LibUI.uiNewCheckbox("Checkbox"), 0)
LibUI.uiBoxAppend(inner, LibUI.uiNewLabel("Label"), 0)
LibUI.uiBoxAppend(inner, LibUI.uiNewHorizontalSeparator, 0)
LibUI.uiBoxAppend(inner, LibUI.uiNewDatePicker, 0)
LibUI.uiBoxAppend(inner, LibUI.uiNewTimePicker, 0)
LibUI.uiBoxAppend(inner, LibUI.uiNewDateTimePicker, 0)
LibUI.uiBoxAppend(inner, LibUI.uiNewFontButton, 0)
LibUI.uiBoxAppend(inner, LibUI.uiNewColorButton, 0)

inner2 = LibUI.uiNewVerticalBox
LibUI.uiBoxSetPadded(inner2, 1)
LibUI.uiBoxAppend(hbox, inner2, 1)

group = LibUI.uiNewGroup("Numbers")
LibUI.uiGroupSetMargined(group, 1)
LibUI.uiBoxAppend(inner2, group, 0)

inner = LibUI.uiNewVerticalBox
LibUI.uiBoxSetPadded(inner, 1)
LibUI.uiGroupSetChild(group, inner)

spinbox = LibUI.uiNewSpinbox(0, 100)
spinbox_changed_callback = Proc.new do |ptr|
  puts "New Spinbox value: #{LibUI.uiSpinboxValue(ptr)}"
end
LibUI.uiSpinboxSetValue(spinbox,42)
LibUI.uiSpinboxOnChanged(spinbox, spinbox_changed_callback, nil)
LibUI.uiBoxAppend(inner, spinbox, 0);

slider = LibUI.uiNewSlider(0, 100)
slider_changed_callback = Proc.new do |ptr|
  puts "New Slider value: #{LibUI.uiSliderValue(ptr)}"
end
LibUI.uiSliderOnChanged(slider, slider_changed_callback, nil)
LibUI.uiBoxAppend(inner, slider, 0)

progressbar = LibUI.uiNewProgressBar
LibUI.uiBoxAppend(inner, progressbar, 0)

group = LibUI.uiNewGroup("Lists")
LibUI.uiGroupSetMargined(group, 1)
LibUI.uiBoxAppend(inner2, group, 0)

inner = LibUI.uiNewVerticalBox
LibUI.uiBoxSetPadded(inner, 1)
LibUI.uiGroupSetChild(group, inner)

combobox_selected_callback = Proc.new do |ptr|
  puts "New combobox selection: #{LibUI.uiComboboxSelected(ptr)}"
end
cbox = LibUI.uiNewCombobox
LibUI.uiComboboxAppend(cbox, "Combobox Item 1")
LibUI.uiComboboxAppend(cbox, "Combobox Item 2")
LibUI.uiComboboxAppend(cbox, "Combobox Item 3")
LibUI.uiBoxAppend(inner, cbox, 0)
LibUI.uiComboboxOnSelected(cbox, combobox_selected_callback, nil)

#cbox = LibUI.uiNewEditableCombobox
#LibUI.uiComboboxAppend(cbox, "Editable Item 1")
#LibUI.uiComboboxAppend(cbox, "Editable Item 2")
#LibUI.uiComboboxAppend(cbox, "Editable Item 3")
#LibUI.uiBoxAppend(inner, cbox, 0)

rb = LibUI.uiNewRadioButtons
LibUI.uiRadioButtonsAppend(rb, "Radio Button 1")
LibUI.uiRadioButtonsAppend(rb, "Radio Button 2")
LibUI.uiRadioButtonsAppend(rb, "Radio Button 3")
LibUI.uiBoxAppend(inner, rb, 1)

tab = LibUI.uiNewTab
hbox1 = LibUI.uiNewHorizontalBox
LibUI.uiTabAppend(tab, "Page 1", hbox1)
LibUI.uiTabAppend(tab, "Page 2", LibUI.uiNewHorizontalBox)
LibUI.uiTabAppend(tab, "Page 3", LibUI.uiNewHorizontalBox)
LibUI.uiBoxAppend(inner2, tab, 1)

text_changed_callback = Proc.new do |ptr|
  puts "Current textbox data: '#{LibUI.uiEntryText(ptr)}'"
end

text_entry = LibUI.uiNewEntry
LibUI.uiEntrySetText text_entry, "Please enter your feelings"
LibUI.uiEntryOnChanged(text_entry, text_changed_callback, nil)
LibUI.uiBoxAppend(hbox1, text_entry, 1)

MAIN_WINDOW = LibUI.uiNewWindow("hello world", 600, 600, 1)
LibUI.uiWindowSetMargined(MAIN_WINDOW, 1)
LibUI.uiWindowSetChild(MAIN_WINDOW, vbox)

LibUI.uiWindowOnClosing(MAIN_WINDOW,should_quit, nil)
LibUI.uiControlShow(MAIN_WINDOW)

LibUI.uiMain
LibUI.uiQuit
