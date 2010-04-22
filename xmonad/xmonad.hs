--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import XMonad
import XMonad.Actions.CycleWS
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.Reflect
import XMonad.Layout.WindowNavigation
import XMonad.Util.Font(stringToPixel)
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeysP)
import qualified XMonad.StackSet as W
import System.IO
import Data.List

main = do
    xmproc <- spawnPipe "xmobar"
    xmonad $ withUrgencyHookC BorderUrgencyHook urgencyConfig { suppressWhen = Never } $ defaultConfig {
                 terminal           = "urxvtc",
                 modMask            = mod4Mask,
                 normalBorderColor  = "#000000",
                 focusedBorderColor = "#aaaaaa",
                 workspaces         = ["term", "browser", "docs", "4",
                                       "5", "6", "7", "8", "9"],
                 layoutHook         = avoidStruts myLayout,
                 manageHook         = myManageHook <+>
                                      manageDocks <+>
                                      manageHook defaultConfig,
                 logHook            = dynamicLogWithPP $ xmobarPP
                                         { ppOutput = hPutStrLn xmproc
                                         , ppTitle  = xmobarColor "green" "" . shorten 100
                                         , ppUrgent = xmobarColor "yellow" "red" . xmobarStrip
                                         }
             } `additionalKeysP` [("C-M1-o", spawn "urxvtc")
                                 ,("C-M1-b", spawn "firefox")
                                 ,("C-S-l", spawn "xscreensaver-command -lock")
                                 ,("C-M1-r", spawn "gmrun")
                                 ,("C-M1-c", restart "xmonad" True)
                                 ,("C-M1-<Left>", prevWS)
                                 ,("C-M1-<Right>", nextWS)
                                 ,("C-M1-<Up>", focusUrgent)
                                 ,("C-S-M1-<Left>", shiftToPrev)
                                 ,("C-S-M1-<Right>", shiftToNext)
                                 ,("M1-<Tab>", windows W.focusDown)
                                 ,("M1-S-<Tab>", windows W.focusUp)
                                 ,("C-M1-h", sendMessage $ Go L)
                                 ,("C-M1-j", sendMessage $ Go D)
                                 ,("C-M1-k", sendMessage $ Go U)
                                 ,("C-M1-l", sendMessage $ Go R)
                                 ]

myLayout = configurableNavigation noNavigateBorders (tiled ||| Mirror tiled ||| Full)
    where
        tiled   = reflectHoriz $ Tall nmaster delta ratio
        nmaster = 2
        ratio   = 0.5955
        delta   = 0.0005

data BorderUrgencyHook = BorderUrgencyHook deriving (Read, Show)

instance UrgencyHook BorderUrgencyHook where
    urgencyHook _ win =
        do color <- withDisplay (\display -> io (stringToPixel display "#ff0000")); withDisplay (\display -> io (setWindowBorder display win color))

myManageHook = composeAll [ resource =? "xmessage"    --> doFloat
                          , resource =? "firefox-bin" --> doF (W.shift "browser")
                          , resource =? "win"         --> doF (W.shift "docs") -- xpdf
                          , resource =? "feh"         --> doF (W.shift "docs")
                          ]
