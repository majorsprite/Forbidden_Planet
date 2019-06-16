-- Colors reference https://www.quackit.com/css/color/charts/css_color_names_chart.cfm
local Color = {  }

function Color.rgb(r, g, b)

  return { r = (r / 255), g = (g / 255), b = (b / 255), a = 1 }
end

function Color.rgba(r, g, b, a)
  return { r = (r / 255), g = (g / 255), b = (b / 255), a = (a / 255) }
end

--------------------
-- REDS
--------------------
function Color.indianred()
  return Color.rgb(205,92,92)
end

function Color.lightcoral()
  return Color.rgb(240,128,128)
end

function Color.salmon()
  return Color.rgb(250,128,114)
end

function Color.darksalmon()
  return Color.rgb(233,150,122)
end

function Color.lightsalmon()
  return Color.rgb(255,160,122)
end

function Color.crimson()
  return Color.rgb(220,20,60)
end

function Color.red()
  return Color.rgb(255,0,0)
end

function Color.firebrick()
  return Color.rgb(178,34,34)
end

function Color.darkred()
  return Color.rgb(139,0,0)
end

--------------------
-- Pinks
--------------------
function Color.pink()
  return Color.rgb(255,192,203)
end

function Color.lightpink()
  return Color.rgb(255,182,193)
end

function Color.hotpink()
  return Color.rgb(255,105,180)
end

function Color.deeppink()
  return Color.rgb(255,20,147)
end

function Color.mediumvioletred()
  return Color.rgb(199,21,133)
end

function Color.palevioletred()
  return Color.rgb(219,112,147)
end

--------------------
-- Oranges
--------------------
function Color.coral()
  return Color.rgb(255,127,80)
end

function Color.tomato()
  return Color.rgb(255,99,71)
end

function Color.orangered()
  return Color.rgb(255,69,0)
end

function Color.darkorange()
  return Color.rgb(255,140,0)
end

function Color.orange()
  return Color.rgb(255,165,0)
end

--------------------
-- Yellows
--------------------
function Color.gold()
  return Color.rgb(255,215,0)
end

function Color.yellow()
  return Color.rgb(255,255,0)
end

function Color.lightyellow()
  return Color.rgb(255,255,224)
end

function Color.lemonchiffon()
  return Color.rgb(255,250,205)
end

function Color.lightgoldenrodyellow()
  return Color.rgb(250,250,210)
end

function Color.papayawhip()
  return Color.rgb(255,239,213)
end

function Color.moccasin()
  return Color.rgb(255,228,181)
end

function Color.peachpuff()
  return Color.rgb(255,218,185)
end

function Color.paledoldenrod()
  return Color.rgb(238,232,170)
end

function Color.khaki()
  return Color.rgb(240,230,140)
end

function Color.darkkhaki()
  return Color.rgb(189,183,107)
end

--------------------
-- Purples
--------------------
function Color.lavender()
  return Color.rgb(230,230,250)
end

function Color.thistle()
  return Color.rgb(216,191,216)
end

function Color.plum()
  return Color.rgb(221,160,221)
end

function Color.violet()
  return Color.rgb(238,130,238)
end

function Color.orchid()
  return Color.rgb(218,112,214)
end

function Color.fuchsia()
  return Color.rgb(255,0,255)
end

function Color.magenta()
  return Color.rgb(255,0,255)
end

function Color.mediumorchid()
  return Color.rgb(186,85,211)
end

function Color.mediumpurple()
  return Color.rgb(147,112,219)
end

function Color.blueviolet()
  return Color.rgb(138,43,226)
end

function Color.darkviolet()
  return Color.rgb(148,0,211)
end

function Color.darkorchid()
  return Color.rgb(153,50,204)
end

function Color.darkmagenta()
  return Color.rgb(139,0,139)
end

function Color.purple()
  return Color.rgb(128,0,128)
end

function Color.rebeccapurple()
  return Color.rgb(102,51,153)
end

function Color.indigo()
  return Color.rgb(75,0,130)
end

function Color.mediumslateblue()
  return Color.rgb(123,104,238)
end

function Color.slateblue()
  return Color.rgb(106,90,205)
end

function Color.darkslateblue()
  return Color.rgb(72,61,139)
end

--------------------
-- Greens
--------------------
function Color.greenyellow()
  return Color.rgb(173,255,47)
end

function Color.chartreuse()
  return Color.rgb(127,255,0)
end

function Color.lawngreen()
  return Color.rgb(124,252,0)
end

function Color.lime()
  return Color.rgb(0,255,0)
end

function Color.limegreen()
  return Color.rgb(50,205,50)
end

function Color.palegreen()
  return Color.rgb(152,251,152)
end

function Color.mediumspringgreen()
  return Color.rgb(0,250,154)
end

function Color.springgreen()
  return Color.rgb(0,255,127)
end

function Color.mediumseagreen()
  return Color.rgb(60,179,113)
end

function Color.seagreen()
  return Color.rgb(46,139,87)
end

function Color.forestgreen()
  return Color.rgb(34,139,34)
end

function Color.green()
  return Color.rgb(0,128,0)
end

function Color.darkgreen()
  return Color.rgb(0,100,0)
end

function Color.yellowgreen()
  return Color.rgb(154,205,50)
end

function Color.olivedrab()
  return Color.rgb(107,142,35)
end

function Color.olive()
  return Color.rgb(128,128,0)
end

function Color.darkolivegreen()
  return Color.rgb(85,107,47)
end

function Color.mediumaquamarine()
  return Color.rgb(102,205,170)
end

function Color.darkseagreen()
  return Color.rgb(143,188,143)
end

function Color.lightseagreen()
  return Color.rgb(32,178,170)
end

function Color.darkcyan()
  return Color.rgb(0,139,139)
end

function Color.teal()
  return Color.rgb(0,128,128)
end

--------------------
-- Blues/Cyan
--------------------
function Color.aqua()
  return Color.rgb(0,255,255)
end

function Color.cyan()
  return Color.rgb(0,255,255)
end

function Color.lightcyan()
  return Color.rgb(224,255,255)
end

function Color.paleturquoise()
  return Color.rgb(175,238,238)
end

function Color.aquamarine()
  return Color.rgb(127,255,212)
end

function Color.turquoise()
  return Color.rgb(64,224,208)
end

function Color.mediumturquoise()
  return Color.rgb(72,209,204)
end

function Color.darkturquoise()
  return Color.rgb(0,206,209)
end

function Color.cadetblue()
  return Color.rgb(95,158,160)
end

function Color.steelblue()
  return Color.rgb(70,130,180)
end

function Color.lightsteelblue()
  return Color.rgb(176,196,222)
end

function Color.powderblue()
  return Color.rgb(176,224,230)
end

function Color.lightblue()
  return Color.rgb(173,216,230)
end

function Color.skyblue()
  return Color.rgb(135,206,235)
end

function Color.lightskyblue()
  return Color.rgb(135,206,250)
end

function Color.deepskyblue()
  return Color.rgb(0,191,255)
end

function Color.dodgerblue()
  return Color.rgb(30,144,255)
end

function Color.cornflowerblue()
  return Color.rgb(100,149,237)
end

function Color.royalblue()
  return Color.rgb(65,105,225)
end

function Color.blue()
  return Color.rgb(0,0,225)
end

function Color.mediumblue()
  return Color.rgb(0,0,205)
end

function Color.darkblue()
  return Color.rgb(0,0,139)
end

function Color.navy()
  return Color.rgb(0,0,128)
end

function Color.midnightblue()
  return Color.rgb(25,25,112)
end

--------------------
-- Browns
--------------------
function Color.cornsilk()
  return Color.rgb(255,248,220)
end

function Color.blanchedalmond()
  return Color.rgb(255,235,205)
end

function Color.bisque()
  return Color.rgb(255,228,196)
end

function Color.navajowhite()
  return Color.rgb(255,222,173)
end

function Color.wheat()
  return Color.rgb(245,222,179)
end

function Color.burlywood()
  return Color.rgb(222,184,135)
end

function Color.tan()
  return Color.rgb(210,180,140)
end

function Color.rosybrown()
  return Color.rgb(188,143,143)
end

function Color.sandybrown()
  return Color.rgb(244,164,96)
end

function Color.goldenrod()
  return Color.rgb(218,165,32)
end

function Color.darkgoldenrod()
  return Color.rgb(184,134,11)
end

function Color.peru()
  return Color.rgb(205,133,63)
end

function Color.chocolate()
  return Color.rgb(210,105,30)
end

function Color.saddlebrown()
  return Color.rgb(139,69,19)
end

function Color.sienna()
  return Color.rgb(160,82,45)
end

function Color.brown()
  return Color.rgb(165,42,42)
end

function Color.maroon()
  return Color.rgb(128,0,0)
end

--------------------
-- Whites
--------------------
function Color.white()
  return Color.rgb(255,255,255)
end

function Color.snow()
  return Color.rgb(255,250,250)
end

function Color.honeydew()
  return Color.rgb(240,255,240)
end

function Color.mintcream()
  return Color.rgb(245,255,250)
end

function Color.azure()
  return Color.rgb(240,255,255)
end

function Color.aliceblue()
  return Color.rgb(240,248,255)
end

function Color.ghostwhite()
  return Color.rgb(248,248,255)
end

function Color.whitesmoke()
  return Color.rgb(245,245,245)
end

function Color.seashell()
  return Color.rgb(255,245,238)
end

function Color.beige()
  return Color.rgb(245,245,220)
end

function Color.oldlace()
  return Color.rgb(253,245,230)
end

function Color.floralwhite()
  return Color.rgb(255,250,240)
end

function Color.ivory()
  return Color.rgb(255,255,240)
end

function Color.antiquewhite()
  return Color.rgb(250,235,215)
end

function Color.linen()
  return Color.rgb(250,240,230)
end

function Color.lavenderblush()
  return Color.rgb(255,240,245)
end

function Color.mistyrose()
  return Color.rgb(255,228,225)
end

--------------------
-- Greys
--------------------
function Color.gainsboro()
  return Color.rgb(220,220,220)
end

function Color.lightgray()
  return Color.rgb(211,211,211)
end

function Color.lightgrey()
  return Color.rgb(211,211,211)
end

function Color.silver()
  return Color.rgb(192,192,192)
end

function Color.darkgray()
  return Color.rgb(169,169,169)
end

function Color.darkgrey()
  return Color.rgb(169,169,169)
end

function Color.gray()
  return Color.rgb(128,128,128)
end

function Color.grey()
  return Color.rgb(128,128,128)
end

function Color.dimgray()
  return Color.rgb(105,105,105)
end

function Color.dimgrey()
  return Color.rgb(105,105,105)
end

function Color.lightslategray()
  return Color.rgb(119,136,153)
end

function Color.lightslategrey()
  return Color.rgb(119,136,153)
end

function Color.slategray()
  return Color.rgb(112,128,144)
end

function Color.slategrey()
  return Color.rgb(112,128,144)
end

function Color.darkslategray()
  return Color.rgb(47,79,79)
end

function Color.darkslategrey()
  return Color.rgb(47,79,79)
end

function Color.black()
  return Color.rgb(0,0,0)
end

return Color