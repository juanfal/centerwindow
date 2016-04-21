#!/usr/bin/osascript
-- juanfc 2016-04-21
-- centers frontmost window in the main screen.
-- Takes care of the special syntax for Sublime Text
--  and for that case uses WP and HP, width and height % of free screen we want
-- DEPENDS on cscreen binary app installed inside ~/bin/
-- it is easy to change anything here, but we need a Foundation app to tell us
-- the geometry of the main window
-- cscreen seems to be the most robust one


-- http://www.pyehouse.com/cscreen/
--  set screenSize to bounds of window of desktop
set sr to do shell script "~/bin/cscreen"
set screenWidth to word 4 of paragraph 2 of sr
set screenHeight to word 5 of paragraph 2 of sr

property WP : 0.1  -- prop of w free screen we want
property HP : 0.02 -- prop of w free screen we want

tell application "System Events"
    --  set screenHeight to (screenHeight - dockHeight)
    set myFrontMost to name of first item of ¬
        (processes whose frontmost is true)
end tell


if myFrontMost is "Sublime Text" then
    tell application "System Events" to tell application process myFrontMost
        set stprops to get the properties of window 1
        set windowXl to item 1 of (position of stprops)
        set windowYt to item 2 of (position of stprops)
        set windowWidth to item 1 of (size of stprops)
        set windowHeight to item 2 of (size of stprops)
    end tell
else
    tell application myFrontMost
        set windowSize to bounds of window 1
    end tell
    set windowXl to item 1 of windowSize
    set windowYt to item 2 of windowSize
    set windowXr to item 3 of windowSize
    set windowYb to item 4 of windowSize

    set windowWidth to windowXr - windowXl
    set windowHeight to windowYb - windowYt
end if

if myFrontMost is "Sublime Text" then
    tell application "System Events" to tell application process myFrontMost
        set position of window 1 to {¬
            round (screenWidth * WP), ¬
            round (screenHeight * HP) ¬
        }

        set size of window 1 to {¬
            round (screenWidth * (1 - 2 * WP)), ¬
            round (screenHeight * (1 - 2 * HP)) ¬
        }
    end tell
else
    tell application myFrontMost
        set bounds of window 1 to {¬
            round ((screenWidth - windowWidth) / 2) rounding as taught in school, ¬
            round ((screenHeight - windowHeight) / 2) rounding as taught in school, ¬
            round ((screenWidth + windowWidth) / 2) rounding as taught in school, ¬
            round ((screenHeight + windowHeight) / 2) rounding as taught in school ¬
                }
    end tell
end if
