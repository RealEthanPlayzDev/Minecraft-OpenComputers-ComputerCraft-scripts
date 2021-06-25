--[[
File name: WebdisplayManager.lua
Author: RadiatedExodus
Created at: June 22 2021
Designed for controlling webdisplays from a OpenComputer
--]]

--// CONFIGURATION \\
local InfoServerPort = 2 --// NOTE: Do not use port 1 as the computer will use this port!!
--\\---------------//

local component, term, event, serialization = require("component"), require("term"), require("event"), require("serialization")
local clear = term.clear
local wait = os.sleep
local modem = component.modem

if modem == nil then
    error("Unable to get modem component. (ERR_UNABLE_FETCH_MODEM)")
end
if modem.isOpen(InfoServerPort) then
    error("Something else is currently opening the port: "..InfoServerPort..", please use a unused port. (ERR_PORT_ALREADY_OPENED)")
end

function interface_event(_, _, _, port, _, newDataSerialized)
    clear()
    local receivedData; print(pcall(function() receivedData = serialization.unserialize(newDataSerialized) end))
    if type(receivedData) ~= "table" or port ~= InfoServerPort then return end
    print([[
WebdisplayInfo - v1
    ]].."\nCurrent URL: "..receivedData.currentUrl.."\nCurrent display resolution: "..receivedData.disResX.." x "..receivedData.disResY.."\nCurrent display size: "..receivedData.disSizeX.." x "..receivedData.disSizeY.."\nCurrent rotation: "..receivedData.rotation)
end

event.listen("interrupted", function() modem.close(InfoServerPort) event.ignore("modem_message", interface_event) end)
modem.open(InfoServerPort)
event.listen("modem_message", interface_event)

while true do wait(1) end
