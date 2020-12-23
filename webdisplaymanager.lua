--// WebDisplays Screen Manager
--// Only compatible with 1 screen
--// Make sure "webdisplays:interface" is OpenComputers and linked to the screen you want to control.

print("Initializing")

--// System flags
local sysFlags = {}
--// Display screen owner name and UUID
sysFlags.displayOwnerInfo = true
--// [DEBUG/Screen] Display screen address field
sysFlags.displayAddress = true

--// Initialize variables
local openComputerSystem = {}
local screen
local screenAddress
local screenData = {}
openComputerSystem.component = require("component")

--// Get screen address
for addr, name in openComputerSystem.component.list() do
    if name == "webdisplays" then
        screenAddress = addr
        break
    end
end

--// If theres no screen then there should be no screen address
if not screenAddress then
    error("WebDisplays Screen Manager - Fatal Error DisplayNotFoundException")
end

screen = openComputerSystem.component.proxy(screenAddress)

--// Get screen data and stuff
screenData.ownerName, screenData.ownerUUID = screen.getOwner()

screen = openComputerSystem.component.proxy(screenAddress)
print("WebDisplays Screen Manager - By RealEthanPlayzDev")

if sysFlags.displayAddress then
   print("Screen address: "..screenAddress) 
end

if sysFlags.displayOwnerInfo then
    print("Screen owned by: "..screenData.ownerName)
    print("Owner UUID: "..screenData.ownerUUID)
end
