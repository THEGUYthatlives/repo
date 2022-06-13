local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/discord%20lib.txt"))()
local Window = Library:Window(game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)
if game.PlaceId == 286090429 then
    local Misc_Server = Window:Server("Misc", "")
    local Subtitles_Channel = Misc_Server:Channel("Subtitles")
    local Subtitle_Text = "Label"
    local Subtitle_Duration = 2.5
    local Subtitle_Color = Color3.new(1, 1, 1)
    local Subtitle_Color_RGB = Color3.new(1, 1, 1)
    Subtitles_Channel:Textbox("Text", "Type Here!", false, function(i)
        Subtitle_Text = i
    end)
    Subtitles_Channel:Textbox("Duration", "Seconds", false, function(i)
        if tonumber(i) then
            Subtitle_Duration = tonumber(i)
        else
            Library:Notification("Your input was not a valid number.", "Duration has been set to 2.5 seconds.", "Ok")
        end
    end)
    local Subtitle_Dropdowns = Subtitles_Channel:Dropdown("Color", {"Team Color", "RGB"}, function(option)
        if option == "Team Color" then
            Subtitle_Color = "Team Color"
        elseif option == "RGB" then
            Subtitle_Color = "RGB"
        else
            Subtitle_Color = require(game.ReplicatedStorage.Modules.Teams).colors[option][3]
        end
    end)
    for TeamName,_ in pairs(require(game.ReplicatedStorage.Modules.Teams).colors) do
        Subtitle_Dropdowns:Add(TeamName)
    end
    Subtitles_Channel:Colorpicker("Color (RGB)", Color3.new(1, 1, 1), function(c)
        Subtitle_Color_RGB = c
    end)
    Subtitles_Channel:Button("Create", function()
        local Color = Subtitle_Color
        if Color == "Team Color" then
            Color = require(game.ReplicatedStorage.Modules.Teams).colors[game.Players.LocalPlayer.Status.Team.Value][3]
        elseif Color == "RGB" then
            Color = Subtitle_Color_RGB
        end
        require(game.ReplicatedStorage.Modules.Subtitles).NewSubtitle(Subtitle_Text, Subtitle_Duration, Color)
    end)
end
