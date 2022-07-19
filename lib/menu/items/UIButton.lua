---@type table
local SettingsButton = {
    Rectangle = { Y = 0, Width = 431, Height = 38 },
    Text = { X = 8, Y = 3, Scale = 0.33 },
    LeftBadge = { Y = -2, Width = 40, Height = 40 },
    RightBadge = { X = 385, Y = -2, Width = 40, Height = 40 },
    RightText = { X = 420, Y = 4, Scale = 0.35 },
    SelectedSprite = { Dictionary = "commonmenu", Texture = "gradient_nav", Y = 0, Width = 431, Height = 38 },
}

---ButtonWithStyle
---@param Label string
---@param Description string
---@param Style table
---@param Enabled boolean
---@param Callback function
---@param Submenu table
---@return nil
---@public
function RageUI.Button(Label, Description, Style, Enabled, Action, Submenu)
    local CurrentMenu = RageUI.CurrentMenu
    if CurrentMenu ~= nil and CurrentMenu() then
        ---@type number
        local Option = RageUI.Options + 1

        if CurrentMenu.Pagination.Minimum <= Option and CurrentMenu.Pagination.Maximum >= Option then
            ---@type boolean
            local Active = CurrentMenu.Index == Option

            RageUI.ItemsSafeZone(CurrentMenu)

            local haveLeftBadge = Style.LeftBadge and Style.LeftBadge ~= RageUI.BadgeStyle.None
            local haveRightBadge = (Style.RightBadge and Style.RightBadge ~= RageUI.BadgeStyle.None) or (not Enabled and Style.LockBadge ~= RageUI.BadgeStyle.None)
            local LeftBadgeOffset = haveLeftBadge and 27 or 0
            local RightBadgeOffset = haveRightBadge and 32 or 0
            if Style.Color and Style.Color.BackgroundColor then
                RenderRectangle(CurrentMenu.X, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset, SettingsButton.SelectedSprite.Height, Style.Color.BackgroundColor[1], Style.Color.BackgroundColor[2], Style.Color.BackgroundColor[3], Style.Color.BackgroundColor[4])
            end
            if Active then
                if Style.Color and Style.Color.HightLightColor then
                    RenderRectangle(CurrentMenu.X, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset, SettingsButton.SelectedSprite.Height, Style.Color.HightLightColor[1], Style.Color.HightLightColor[2], Style.Color.HightLightColor[3], Style.Color.HightLightColor[4])
                else
                    RenderSprite(SettingsButton.SelectedSprite.Dictionary, SettingsButton.SelectedSprite.Texture, CurrentMenu.X, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset, SettingsButton.SelectedSprite.Height)
                end
            end
            if Enabled then
                if haveLeftBadge then
                    if (Style.LeftBadge ~= nil) then
                        local LeftBadge = Style.LeftBadge(Active)
                        RenderSprite(LeftBadge.BadgeDictionary or "commonmenu", LeftBadge.BadgeTexture or "", CurrentMenu.X, CurrentMenu.Y + SettingsButton.LeftBadge.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsButton.LeftBadge.Width, SettingsButton.LeftBadge.Height, 0, LeftBadge.BadgeColour and LeftBadge.BadgeColour.R or 255, LeftBadge.BadgeColour and LeftBadge.BadgeColour.G or 255, LeftBadge.BadgeColour and LeftBadge.BadgeColour.B or 255, LeftBadge.BadgeColour and LeftBadge.BadgeColour.A or 255)
                    end
                end
                if haveRightBadge then
                    if (Style.RightBadge ~= nil) then
                        local RightBadge = Style.RightBadge(Active)
                        RenderSprite(RightBadge.BadgeDictionary or "commonmenu", RightBadge.BadgeTexture or "", CurrentMenu.X + SettingsButton.RightBadge.X + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightBadge.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsButton.RightBadge.Width, SettingsButton.RightBadge.Height, 0, RightBadge.BadgeColour and RightBadge.BadgeColour.R or 255, RightBadge.BadgeColour and RightBadge.BadgeColour.G or 255, RightBadge.BadgeColour and RightBadge.BadgeColour.B or 255, RightBadge.BadgeColour and RightBadge.BadgeColour.A or 255)
                    end
                end
                if Style.RightLabel then
                    RenderText(Style.RightLabel, CurrentMenu.X + SettingsButton.RightText.X - RightBadgeOffset + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightText.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, SettingsButton.RightText.Scale, Active and 0 or 245, Active and 0 or 245, Active and 0 or 245, 255, 2)
                end
                RenderText(Label, CurrentMenu.X + SettingsButton.Text.X + LeftBadgeOffset, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, SettingsButton.Text.Scale, Active and 0 or 245, Active and 0 or 245, Active and 0 or 245, 255)
            else
                if haveRightBadge then
                    local RightBadge = RageUI.BadgeStyle.Lock(Active)
                    RenderSprite(RightBadge.BadgeDictionary or "commonmenu", RightBadge.BadgeTexture or "", CurrentMenu.X + SettingsButton.RightBadge.X + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightBadge.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsButton.RightBadge.Width, SettingsButton.RightBadge.Height, 0, RightBadge.BadgeColour and RightBadge.BadgeColour.R or 255, RightBadge.BadgeColour and RightBadge.BadgeColour.G or 255, RightBadge.BadgeColour and RightBadge.BadgeColour.B or 255, RightBadge.BadgeColour and RightBadge.BadgeColour.A or 255)
                end

                RenderText(Label, CurrentMenu.X + SettingsButton.Text.X + LeftBadgeOffset, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, SettingsButton.Text.Scale, 163, 159, 148, 255)
            end
            RageUI.ItemOffset = RageUI.ItemOffset + SettingsButton.Rectangle.Height
            RageUI.ItemsDescription(CurrentMenu, Description, Active);
            if Enabled then
                local Hovered = CurrentMenu.EnableMouse and (CurrentMenu.CursorStyle == 0 or CurrentMenu.CursorStyle == 1) and RageUI.ItemsMouseBounds(CurrentMenu, Active, Option + 1, SettingsButton);
                local Selected = (CurrentMenu.Controls.Select.Active or (Hovered and CurrentMenu.Controls.Click.Active)) and Active
                if (Action.onHovered ~= nil) and Hovered then
                    Action.onHovered();
                end
                if (Action.onActive ~= nil) and Active then
                    Action.onActive();
                end
                if Selected then
                    local Audio = RageUI.Settings.Audio
                    RageUI.PlaySound(Audio[Audio.Use].Select.audioName, Audio[Audio.Use].Select.audioRef)
                    if (Action.onSelected ~= nil) then
                        Citizen.CreateThread(function()
                            Action.onSelected();
                        end)
                    end
                    if Submenu and Submenu() then
                        RageUI.NextMenu = Submenu
                    end
                end
            end
        end
        RageUI.Options = RageUI.Options + 1
    end
end

