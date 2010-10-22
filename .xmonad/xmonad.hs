import XMonad

import XMonad.Config.Gnome

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.ManageHelpers

import XMonad.Layout.Tabbed 
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.Reflect
import XMonad.Layout.Grid
import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Layout.IM

import XMonad.Util.EZConfig
import XMonad.Util.Scratchpad

import qualified XMonad.Actions.FlexibleManipulate as FM
import qualified XMonad.Actions.FlexibleResize as FR
import XMonad.Actions.GridSelect
import XMonad.Actions.UpdatePointer
import XMonad.Actions.WindowBringer
import XMonad.Actions.WindowGo

import XMonad.Prompt
import XMonad.Prompt.Window
import XMonad.Prompt.RunOrRaise
import XMonad.Prompt.Ssh

import XMonad.Util.NamedWindows
import XMonad.Util.Paste

import qualified XMonad.StackSet as W

import qualified Data.Map as M
import qualified Data.List as L
import System.IO

import Data.Ratio ((%))

myKeysAdd =
    [
        ("M-s",        scratchpadSpawnActionTerminal "urxvt"),
        ("M-C-l",      spawn "gnome-screensaver; gnome-screensaver-command --lock"),
        ("M-b",        sendMessage ToggleStruts),
        ("M-/",        displayCurrentWorkspace)
    ]

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
    [
        ((modMask, button1), (\w -> focus w >> FM.mouseWindow FM.discrete w)),
        ((modMask, button3), (\w -> focus w >> FR.mouseResizeWindow w))
    ]

myXPConfig = defaultXPConfig 
    {
        font = "-*-Terminus-medium-r-normal-*-14-*-*-*-*-*-*-*",
        height = 20
    }

myGSConfig = defaultGSConfig
    { 
        gs_cellheight = 35, 
        gs_cellwidth = 200, 
        gs_font = "-*-Terminus-medium-r-normal-*-14-*-*-*-*-*-*-*"
    }  

myKeys (XConfig { XMonad.modMask = modMask, XMonad.workspaces = workspaces }) = M.fromList $
    (map 
        (\(key, screen, workspace) -> 
            ((modMask, key),
                ((screenWorkspace screen)
                    >>= flip whenJust (windows . W.view)) 
                        >> (windows $ W.greedyView (workspaces !! workspace))))
        $ 
        zip3 ([xK_1..xK_9] ++ [xK_0])
             ((take 5 $ repeat 0) ++ (take 5 $ repeat 1))
             ([1..9] ++ [0]))
    ++
    (map
        (\(key, workspace) ->
            ((shiftMask .|. modMask, key), 
                windows $ W.shift (workspaces !! workspace)))
        $
        zip ([xK_1..xK_9] ++ [xK_0])
            ([1..9] ++ [0]))
    ++
    [
        ((modMask, xK_g), goToSelectedFromCurrent myGSConfig),
        ((modMask .|. shiftMask, xK_g), goToSelected myGSConfig),
        ((modMask, xK_f), gotoMenu),

        --((modMask, xK_p), runOrRaisePrompt myXPConfig),
        --((modMask, xK_g), windowPromptGoto myXPConfig { autoComplete = Just 500000 } ),
        ((modMask, xK_o), sshPrompt myXPConfig),
        ((modMask, xK_u), focusUrgent),
        ((modMask, xK_r), refreshFirefox),
        ((modMask, xK_d), spawn "xdotool click 1" >> spawn "xdotool key r" )
    ]

refreshFirefox :: X ()
refreshFirefox = do
    ws <- gets windowset
    let stack = (W.stack . W.workspace . W.current) ws
    case stack of
        Nothing -> 
            ifWindows (className =? "Firefox") focusAndRerfresh (return ())
        Just w -> do
            ifWindows (className =? "Firefox") focusAndRerfresh (return ())
            ((windows . W.focusWindow . W.focus) w)

focusAndRerfresh :: [Window] -> X ()
focusAndRerfresh w = do
    (windows . W.focusWindow . head) w
    spawn "xdotool key 'ctrl+r'"

--    ifWindows (className =? "Firefox") (windows . W.focusWindow . head) (return ())
--    XMonad.Util.Paste.pasteString "asd"
--    ifWindows (className =? "Firefox") ((sendKeyWindow shiftMask xK_o) . head) (return ())
--    --ifWindows (className =? "Gajim.py") (windows . W.focusWindow . head) (return ())
--    ifWindows (className =? "Gajim.py") ((sendKeyWindow shiftMask xK_o) . head) (return ())

currentWsName :: W.StackSet i l a s sd -> i
currentWsName = W.tag . W.workspace . W.current

currentScreenId :: W.StackSet i l a s sd -> s
currentScreenId = W.screen . W.current

displayCurrentWorkspace :: X ()
displayCurrentWorkspace = do
    ws <- gets windowset
    let horizOffset = if currentScreenId ws > 0 then " -i $(((1200+1600)/2))" else ""
    spawn $ "echo " ++ (currentWsName ws) ++ " | /usr/bin/osd_cat --font -*-terminus-*-*-*-*-120-*-*-*-*-*-*-* -p top -o 120 -A center " ++ horizOffset

decorateName' :: Window -> X String
decorateName' w = do fmap show $ getName w

onCurrentWindows :: Eq a => W.StackSet i l a s sd -> [a]
onCurrentWindows = L.nub . W.integrate' . W.stack . W.workspace . W.current

windowOnCurrentMap :: X [(String,Window)]
windowOnCurrentMap = do
    ws <- gets windowset
    wins <- mapM keyValuePair (onCurrentWindows ws)
    return wins
    where keyValuePair w = flip (,) w `fmap` decorateName' w

gridselectWindowFromCurrent :: GSConfig Window -> X (Maybe Window)
gridselectWindowFromCurrent gsconf = windowOnCurrentMap >>= gridselect gsconf

withSelectedWindowFromCurrent :: (Window -> X ()) -> GSConfig Window -> X ()
withSelectedWindowFromCurrent 
    callback conf = (gridselectWindowFromCurrent conf) >>= flip whenJust callback

goToSelectedFromCurrent :: GSConfig Window -> X ()
goToSelectedFromCurrent = withSelectedWindowFromCurrent $ windows . W.focusWindow

myTabConfig = defaultTheme 
    { 
        fontName = "-*-Terminus-medium-r-normal-*-14-*-*-*-*-*-*-*",
        inactiveColor = "grey22",
        inactiveTextColor = "grey80",
        activeTextColor = "black"
    }
myTabbed = tabbed shrinkText myTabConfig

myWorkspaces = ["0:web", "1", "2", "3", "4", "5", "6", "7:home", "8:mail", "9:im"]

imLayout = avoidStruts $ smartBorders $ withIM ratio gajimRoster myTabbed where
    ratio = (1%6)
    gajimRoster = (And (ClassName "Gajim.py") (Role "roster"))

myManageHook = composeAll 
    [
        isFullscreen                 --> doFullFloat,
        className =? "stalonetray"   --> doIgnore,
        className =? "Gajim.py"      --> doShift "9:im",
        className =? "Firefox"       --> doShift "0:web",
        className =?  "Xmessage"     --> doCenterFloat,
        className =? "feh"           --> doCenterFloat 
    ]

main = do
    xmonad $ withUrgencyHook NoUrgencyHook $ gnomeConfig
        {
          terminal   = "urxvt",
          modMask    = mod4Mask,

          workspaces = myWorkspaces,

          keys       = \c -> myKeys c `M.union` keys gnomeConfig c,
          mouseBindings = \c -> myMouseBindings c `M.union` mouseBindings gnomeConfig c,

          logHook    = updatePointer (TowardsCentre 0.5 0.5),
          manageHook = manageHook gnomeConfig <+> manageDocks <+> scratchpadManageHookDefault <+> myManageHook,
          layoutHook = onWorkspace "9:im" imLayout $ smartBorders $ avoidStruts $ (myTabbed ||| (Tall 1 (3/100) (1/2)))
        }
        `additionalKeysP` myKeysAdd
