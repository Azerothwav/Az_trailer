fx_version 'adamant'
games { 'gta5' }

description 'Az_corejobs by Azeroth'
version '1.1'

client_scripts {
    '@az_taxi/lib/RMenu.lua',
    '@az_taxi/lib/menu/RageUI.lua',
    '@az_taxi/lib/menu/Menu.lua',
    '@az_taxi/lib/menu/MenuController.lua',
    '@az_taxi/lib/components/Audio.lua',
    '@az_taxi/lib/components/Enum.lua',
    '@az_taxi/lib/components/Keys.lua',
    '@az_taxi/lib/components/Rectangle.lua',
    '@az_taxi/lib/components/Sprite.lua',
    '@az_taxi/lib/components/Text.lua',
    '@az_taxi/lib/components/Visual.lua',
    '@az_taxi/lib/menu/items/UIButton.lua',
    '@az_taxi/lib/menu/items/UICheckBox.lua',
    '@az_taxi/lib/menu/items/UIList.lua',
    '@az_taxi/lib/menu/items/UISeparator.lua',
    '@az_taxi/lib/menu/items/UISlider.lua',
    '@az_taxi/lib/menu/items/UISliderHeritage.lua',
    '@az_taxi/lib/menu/items/UISliderProgress.lua',
    '@az_taxi/lib/menu/panels/UIColourPanel.lua',
    '@az_taxi/lib/menu/panels/UIGridPanel.lua',
    '@az_taxi/lib/menu/panels/UIPercentagePanel.lua',
    '@az_taxi/lib/menu/panels/UISliderPanel.lua',
    '@az_taxi/lib/menu/panels/UISpritPanel.lua',
    '@az_taxi/lib/menu/panels/UIStatisticsPanel.lua',
    '@az_taxi/lib/menu/windows/UIHeritage.lua',
    '@az_taxi/lib/menu/elements/ItemsBadge.lua',
    '@az_taxi/lib/menu/elements/ItemsColour.lua',
    '@az_taxi/lib/menu/elements/PanelColour.lua',


	'config.lua',
    'client/**/*.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
    'server/**/*.lua',
}