set old to get (path to frontmost application as text)
activate application "Google Chrome"
delay 0.2
tell application "System Events"
	keystroke space
end tell

activate application old