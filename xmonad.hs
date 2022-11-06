import XMonad
import XMonad.Util.SpawnOnce
import System.Exit
import XMonad.Util.Run
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import Data.Monoid
import XMonad.Util.EZConfig
import Data.Map

--Cspell:disable
--  check if ethernet connected, so xmobar can change depending on ethernet:
eth_present = do
	xmproc <- spawnPipe "/usr/bin/ip a s eth0 | /usr/bin/grep 'state UP' > /tmp/wificheck.txt;/usr/bin/ip a s usb0 2>&1 >>/tmp/wificheck.txt | /usr/bin/grep 'state UP' >> /tmp/wificheck.txt"
	present <- readFile "/tmp/wificheck.txt"
	return $ present == ""

main::IO ()
main = do
	has_eth <- eth_present
	-- depending on ethernet will use different xmobar file, so that with ethernet connected, ethernet data is displayed:
	xmproc <- spawnPipe (if has_eth then "/usr/bin/xmobar /home/carlo/.config/xmonad/xmobarrc" else "/usr/bin/xmobar /home/carlo/.config/xmonad/xmobarrc_wired")
	xmonad $ docks def {
	terminal = "alacritty -o font.size=16",
	focusFollowsMouse = True,
	-- sets mod key to super/windows key:
	modMask = mod4Mask,
	borderWidth = 4,
	workspaces = ["prgm","scol","3","4","5","6"],
	focusedBorderColor = "#7919e8",
	normalBorderColor = "#000000",
	-- uses default layouts:
	manageHook = manageDocks <+> manageHook def,
	layoutHook = avoidStruts $ layoutHook def,
	logHook = dynamicLogWithPP $ xmobarPP
		{ ppOutput = hPutStrLn xmproc,
		  ppTitle = shorten 50
		}
	} `additionalKeysP` [("M-<XF86AudioRaiseVolume>", spawn "amixer -q sset Master 2%+"),("M-<XF86AudioLowerVolume>", spawn "amixer -q sset Master 2%-"),("M-<XF86AudioMute>", spawn "amixer set Master toggle"), ("M-s", spawn "slock"), ("M-b", spawn "xdotool type $(grep '^' /home/carlo/.config/xmonad/bmarks|dmenu -i -sb '#5900d8')")]
