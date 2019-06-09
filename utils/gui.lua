local Color = require "utils.color"
local Gui = {}

function Gui.header(parent, caption, alignment)
  
  alignment = alignment or "left"
  color = color or Color.white()

  local flow = parent.add{ type = "flow" }
  local label = flow.add{ type = "label", caption = caption }

  flow.style.horizontal_align = alignment
  flow.style.horizontally_stretchable = true

  label.style.font = "heading-2"
  label.style.font_color = color
  
  return label
end


function Gui.bar(parent, color)
  local bar = parent.add { type = 'progressbar', value = 1 }
  bar.style.color = color or Color.white()
  bar.style.horizontally_stretchable = true
  return bar
end

function Gui.line(parent)
  local line = parent.add{ type = "frame", style = 'image_frame' }
  line.style.horizontally_stretchable = true
  return line
end

function Gui.label(parent, caption, alignment, color)
  
  alignment = alignment or "left"
  color = color or Color.white()

  local flow = parent.add{ type = "flow" }
  local label = flow.add{ type = "label", caption = caption }

  flow.style.horizontal_align = alignment
  flow.style.horizontally_stretchable = true

  label.style.font_color = color

  return label
end

function Gui.spacer(parent, height)
  local flow = parent.add{type = "flow" }
  flow.style.horizontally_stretchable = true
  flow.style.height = height or 5

end


return Gui