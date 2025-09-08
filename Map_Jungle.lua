local player = game.Players.LocalPlayer
local char = player.Character
local hrp = char.HumanoidRootPart
local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remote = ReplicatedStorage.RemoteFunctions
_G.AutoFarm =  true
-- Map List

local function PressKey(key)
    VirtualInputManager:SendKeyEvent(true, key, false, game)
    task.wait(0.3)
    VirtualInputManager:SendKeyEvent(false, key, false, game)
end

local function clickMouse()
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        task.wait(0.05)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end

local function PlaceUnit(x,y,z)
    local args = {
        [1] = "unit_farmer_npc",
        [2] = {
            ["Valid"] = true,
            ["Position"] = Vector3.new(-338.291015625+x, 61.68030548095703+y, -85.99600219726562+z),
            ["CF"] = CFrame.new(-338.291015625+x, 61.68030548095703+y, -85.99600219726562+z, -1, 0, -8.742277657347586e-08, 0, 1, 0, 8.742277657347586e-08, 0, -1),
            ["Rotation"] = 180}}
        Remote.PlaceUnit:InvokeServer(unpack(args))
end

local function UpgradeUnit(ID)
    local args = {
       [1] = ID
    }
    game:GetService("ReplicatedStorage").RemoteFunctions.UpgradeUnit:InvokeServer(unpack(args))
end

local function StartPlay()
    wait(1)
     -- หาตัวละคร
    local Entities = workspace.Map.Entities
    local EntitiesID = {}
    local Backpack1 = game:GetService('Players').LocalPlayer.Backpack
    local UnitPlaced = 0
    local UnitMax = 20
    local UnitList = {}
    local PriceList = {}
    local x,y,z = 0,0,0
    local Restarted = false

    for _, v in ipairs(Backpack1:GetChildren()) do
        for _, unit in ipairs(v:GetChildren()) do
            if unit.Name ~= "Handle" then
               table.insert(UnitList,unit)
            end
        end
    end

    for _, v in ipairs(Backpack1:GetChildren()) do
        table.insert(PriceList, tonumber(v:GetAttribute('Description'):sub(2)))
    end
    
    
    wait(5)
    -- เวลาเข้าเกมครั้งแรก
    local args = {
       [1] = "dif_insane"
    }
    Remote.PlaceDifficultyVote:InvokeServer(unpack(args))
    local AutoskipButton = game:GetService("Players").LocalPlayer.PlayerGui.GameGuiNoInset.Screen.Top.WaveControls.AutoSkip
    local AutoskipButtonText = game:GetService("Players").LocalPlayer.PlayerGui.GameGuiNoInset.Screen.Top.WaveControls.AutoSkip.Title.Text
    if AutoskipButtonText == "Auto Skip: Off" then 
        GuiService.SelectedObject = AutoskipButton
        wait(0.5)
        GuiService.SelectedObject = AutoskipButton
        PressKey(Enum.KeyCode.Return) end
    wait(0.3)
    local SpeedGame = 2
    local args = {
        [1] = SpeedGame
    }
    Remote.ChangeTickSpeed:InvokeServer(unpack(args))

    local RestartButton = game:GetService("Players").LocalPlayer.PlayerGui.GameGui.Screen.Middle.GameEnd.Items.Frame.Actions.Items.Again
    RestartButton:GetPropertyChangedSignal("Visible"):Connect(function()
        if RestartButton.Visible == true then
            game:GetService("ReplicatedStorage").RemoteFunctions.RestartGame:InvokeServer() end
        wait(1.5)
        local args = {[1] = "dif_insane"}
        Remote.PlaceDifficultyVote:InvokeServer(unpack(args))
        Restarted = true
    end)

    --เริ่มทำฟาร์ม วางตัว
    while _G.AutoFarm == true do
        wait(1)
        local Cash = tonumber(player:GetAttribute("Cash"))
        print(Cash)
        print(x,y,z)
        if Restarted == true then  
            x = 0
            y = 0
            z = 0
            UnitPlaced = 0
            Restarted = false
        end
        --วางตัว
        if Cash >= 250 and UnitPlaced < 10 then
            PlaceUnit(x,y,z)
            z = z-3
            UnitPlaced = UnitPlaced+1 
        elseif Cash >= 250 and UnitPlaced < 20 then
            if UnitPlaced == 10 then
                x = x-7
                z = z+3
            end
            PlaceUnit(x,y,z)
            z = z+3
            UnitPlaced = UnitPlaced+1 
        end

    end


end
wait(5)
StartPlay()
