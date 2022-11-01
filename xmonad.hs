import XMonad
import XMonad.Util.SpawnOnce
import System.Exit
import XMonad.Util.Run
import XMonad.Layout.MultiColumns
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Layout.Spiral
import Data.Monoid
import XMonad.Util.EZConfig
import Data.Map
eth_present = do
	xmproc <- spawnPipe "/usr/bin/ip a s eth0 | /usr/bin/grep 'state UP' > /tmp/wificheck.txt;/usr/bin/ip a s usb0 2>&1 >>/tmp/wificheck.txt | /usr/bin/grep 'state UP' >> /tmp/wificheck.txt"
	present <- readFile "/tmp/wificheck.txt"
	return $ present == ""
main::IO ()
main = do
	has_eth <- eth_present
	xmproc <- spawnPipe (if has_eth then "/usr/bin/xmobar /home/carlo/.config/xmonad/xmobarrc" else "/usr/bin/xmobar /home/carlo/.config/xmonad/xmobarrc_wired")
	xmonad $ docks def {
	terminal = "alacritty",
	focusFollowsMouse = True,
	modMask = mod4Mask,
	borderWidth = 4,
	workspaces = ["prgm","scol","3","4","5","6"],
	focusedBorderColor = "#7919e8",
	normalBorderColor = "#000000",
	manageHook = manageDocks <+> manageHook def,
	layoutHook = avoidStruts $ layoutHook def ||| spiral (1.618),
	logHook = dynamicLogWithPP $ xmobarPP
		{ ppOutput = hPutStrLn xmproc,
		  ppTitle = shorten 50
		}
	} `additionalKeysP` [("M-0", spawn "amixer -q sset Master 2%+"),("M-9", spawn "amixer -q sset Master 2%-"),("M-8", spawn "amixer set Master toggle"), ("M-s", spawn "slock")]
