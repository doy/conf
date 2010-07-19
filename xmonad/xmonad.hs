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
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.Reflect
import XMonad.Layout.WindowNavigation
import XMonad.Prompt
import XMonad.Prompt.AppLauncher
import XMonad.Prompt.Input
import XMonad.Prompt.Shell
import XMonad.Prompt.XMonad
import XMonad.Util.Font(stringToPixel)
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeysP)
import qualified XMonad.StackSet as W
import System.IO
import Data.List
import System.Directory
import Char

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
                 logHook            = myFadeInactiveLogHook >>
                                      (myXmobarLogHook xmproc)
             } `additionalKeysP` [("C-M1-o", spawn "urxvtc")
                                 ,("C-M1-b", spawn "firefox")
                                 ,("C-S-l", spawn "xscreensaver-command -lock")
                                 ,("C-M1-r", shellPrompt defaultXPConfig)
                                 ,("C-M1-x", xmonadPrompt defaultXPConfig)
                                 ,("C-M1-f", launchApp defaultXPConfig "feh")
                                 ,("C-M1-m", launchApp defaultXPConfig "mplayer")
                                 ,("C-M1-p", launchApp defaultXPConfig "xpdf")
                                 ,("C-M1-s", launchApp defaultXPConfig "soffice")
                                 ,("C-M1-q", killAllPrompt)
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
        ratio   = 0.662
        delta   = 0.0005

myFadeInactiveLogHook =
    fadeInactiveLogHook 0xbbbbbbbb

myXmobarLogHook xmproc =
    dynamicLogWithPP $ xmobarPP
    { ppOutput = hPutStrLn xmproc
    , ppTitle  = xmobarColor "green" "" . shorten 100
    , ppUrgent = xmobarColor "yellow" "red" . xmobarStrip
    }

data BorderUrgencyHook = BorderUrgencyHook deriving (Read, Show)

instance UrgencyHook BorderUrgencyHook where
    urgencyHook _ win =
        do color <- withDisplay (\display -> io (stringToPixel display "#ff0000")); withDisplay (\display -> io (setWindowBorder display win color))

myManageHook = composeAll [ resource =? "xmessage"    --> doFloat
                          , resource =? "qemu"        --> doFloat
                          , resource =? "qemu-system-x86_64" --> doFloat
                          , resource =? "firefox-bin" --> doF (W.shift "browser")
                          , resource =? "win"         --> doF (W.shift "docs") -- xpdf
                          , resource =? "feh"         --> doF (W.shift "docs")
                          ]

killAllPrompt = inputPromptWithCompl defaultXPConfig "killall" runningProcessesCompl ?+ killAll
killAll procName = spawn ("killall " ++ procName)
runningProcessesCompl str = runningProcesses >>= (\procs -> return $ filter (\proc -> str `isPrefixOf` proc) procs)
runningProcesses = getDirectoryContents "/proc" >>= (\dir -> return $ map (\pid -> "/proc/" ++ pid ++ "/comm") $ filter (\dir -> all isDigit dir) $ dir) >>= (\filenames -> sequence $ map (\filename -> openFile filename ReadMode >>= hGetContents) filenames) >>= (\procs -> return $ sort $ nub $ map (\proc -> init proc) procs)
