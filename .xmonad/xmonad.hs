
import XMonad
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Util.Run

import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.LayoutHints
import XMonad.Layout.Tabbed

myDzenStatusBar = "dzen2 -ta 'l' -w 150 -fn monospace:size=10 -dock"
myDzenTopBar = "conky -c $HOME/.xmonad/conky_dzen.lua | " ++
	       "dzen2 -ta 'r' -x 150 -fn monospace:size=10"
myDzenFGColor = "#555555"
myDzenBGColor = "#222222"
myNormalFGColor = "#ffffff"
myNormalBGColor = "#0f0f0f"
myFocusedFGColor = "#f0f0f0"
myFocusedBGColor = "#333333"

main = do
  dzenXmonad <- spawnPipe myDzenStatusBar
  dzenTop    <- spawnPipe myDzenTopBar
  xmonad $ ewmh desktopConfig {
	 terminal = "st"
	, modMask = mod4Mask
        , layoutHook = myLayoutHook
        , logHook = dynamicLogWithPP $ myDzenPP dzenXmonad
        , manageHook = manageDocks <+> myManageHook
	}

myDzenPP h = def
  { ppSep = "^p(10)^r(3x3)^p(10)"
  , ppVisible = dzenColor myNormalFGColor myDzenBGColor . pad
  , ppCurrent = dzenColor myNormalBGColor myDzenFGColor . pad
  , ppOutput = hPutStrLn h
  , ppTitle = const ""
  , ppHiddenNoWindows = const ""
  }

myTabbedConfig = def
  { fontName = "monospace" }

myManageHook = composeAll
  [ className =? "MPlayer"        --> doFloat
  , className =? "Gimp"           --> doFloat
  , resource  =? "desktop_window" --> doIgnore
  , resource  =? "kdesktop"       --> doIgnore
  --, isFullscreen --> doFullFloat
  ]

myLayoutHook = avoidStruts . smartBorders $
                 ((tiled ||| Mirror tiled ||| tabbed shrinkText myTabbedConfig ) ||| Full)
  where
    tiled   = Tall nmaster delta ratio
    nmaster = 1
    ratio   = 1/2
    delta   = 3/100
