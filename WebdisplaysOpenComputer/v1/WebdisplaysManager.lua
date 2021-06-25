--[[
File name: WebdisplayManager.lua
Author: RadiatedExodus
Created at: June 22 2021
Designed for controlling webdisplays from a OpenComputer
--]]

--// CONFIGURATION \\
local InfoServerEnabled = true
local InfoServerPort = 2 --// NOTE: Do not use port 1 as the computer will use this port!!
--\\---------------//

local component, term, serialization, event, thread = require("component"), require("term"), require("serialization"), require("event"), require("thread")
local modem = component.modem
local read = io.read
local clear = term.clear
local wait = os.sleep

function LocateDisplay()
    for adr, compName in component.list() do
    	if compName == "webdisplays" then
			return adr, component.proxy(adr)
		end
	end
end

local displayScrAdr, display = LocateDisplay()

if not displayScrAdr then
	error("Unable to locate any WebDisplays OpenComputer interface. (ERR_NO_INTERFACE)")
end

if not display.isLinked() then
	error("WebDisplays OpenComputer interface is not linked to any screen. (ERR_INTERFACE_NOT_LINKED)")
end

if InfoServerEnabled then
    if modem == nil then
        error("Unable to get modem component. (ERR_UNABLE_FETCH_MODEM)")
    end
    
    thread.create(function()
        while true do
            local scrResX, scrResY = display.getResolution()
    	    local scrSizeX, scrSizeY = display.getSize()
    	    local data = {
                currentUrl = display.getURL(),
                disResX = scrResX,
                disResY = scrResY,
                disSizeX = scrSizeX,
                disSizeY = scrSizeY,
                rotation = display.getRotation()
            }
            modem.broadcast(InfoServerPort, serialization.serialize(data))
            wait(1)
        end
    end)
end

function UIAction_SetUrl()
	clear()
	print("Enter the URL:")
	local url = read()
	display.setURL(tostring(url))
	print("Set the URL to"..url)
	wait(2)
	MakeGui()
end

function UIAction_SetYTEmbedUrl()
	clear()
	print("Enter the YouTube Url:")
	local url = read()
	url = string.sub(url, #"https://www.youtube.com/watch?v=" + 1)
	url = "https://www.youtube.com/embed/"..url
	display.setURL(tostring(url))
	print("Set the URL to"..url)
	wait(2)
	MakeGui()
end

function UIAction_SetYTEmbedUrlAutoplay()
    clear()
	print("Enter the YouTube Url:")
	local url = read()
	url = string.sub(url, #"https://www.youtube.com/watch?v=" + 1)
	url = "https://www.youtube.com/embed/"..url.."?autoplay=1"
	display.setURL(tostring(url))
	print("Set the URL to "..url)
	wait(2)
	MakeGui()
end
	
function UIAction_SetResolution()
	clear()
	local x, y
	print("Enter the X size of the new resolution you want to set:")
	x = read()
	if not type(tonumber(x)) == "number" then 
		repeat
			print("You did not type a number.")
			print("Enter the X size of the new resolution you want to set:")
			x = read()
		until type(tonumber(x)) == "number"
	end
	x = tonumber(x)
	print("enter the Y size of the new resolution you want to set:")
	y = read()
	if not type(tonumber(y)) == "number" then 
		repeat
		print("You did not type a number.")
			print("Enter the X size of the new resolution you want to set:")
				y = read()
		until type(tonumber(y)) == "number"
	end
	y = tonumber(y)
	display.setResolution(x, y)
	print("Set the resolution to "..tostring(x).." x "..tostring(y))
	wait(2)
	MakeGui()
end
	
function UIAction_TypeOnScreen()
	print("Enter the string you would like to type:")
	local str = read()
	display.type(str)
	print("Typed '"..str.."'")
	wait(2)
	MakeGui()
end

function MakeGui()
	clear()
	local scrResX, scrResY = display.getResolution()
	local scrSizeX, scrSizeY = display.getSize()
	print([[
Webdisplay Manager - v1
	]].."\nScreen Resolution: "..scrResX.." x "..scrResY.."\nScreen Size: "..scrSizeX.." x "..scrSizeY.."\nCurrent rotation: "..display.getRotation().."\nCurrent URL: "..display.getURL().."\n"..[[
Options:
1. Set url
2. Set url as YT embed
3. Set url as YT embed (autoplay on)
4. Set resolution
5. Type something on screen
	
Enter your desired option:
	]])
	local userinput = read()
	if userinput == "1" then
		UIAction_SetUrl()
	elseif userinput == "2" then
		UIAction_SetYTEmbedUrl()
	elseif userinput == "3" then
		UIAction_SetYTEmbedUrlAutoplay()
	elseif userinput == "4" then
		UIAction_SetResolution()
	elseif userinput == "5" then
		UIAction_TypeOnScreen()
	else
		print("Invalid option")
		wait(1)
		MakeGui()
	end
end

MakeGui()
