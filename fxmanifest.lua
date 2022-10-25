fx_version 'adamant'
games { 'gta5' }

description 'Az_trailer by Azeroth'
version '2.0'

client_scripts {
    'lib/RMenu.lua',
    'lib/menu/RageUI.lua',
    'lib/menu/Menu.lua',
    'lib/menu/MenuController.lua',
    'lib/components/Audio.lua',
    'lib/components/Enum.lua',
    'lib/components/Keys.lua',
    'lib/components/Rectangle.lua',
    'lib/components/Sprite.lua',
    'lib/components/Text.lua',
    'lib/components/Visual.lua',
    'lib/menu/items/UIButton.lua',
    'lib/menu/items/UICheckBox.lua',
    'lib/menu/items/UIList.lua',
    'lib/menu/items/UISeparator.lua',
    'lib/menu/items/UISlider.lua',
    'lib/menu/items/UISliderHeritage.lua',
    'lib/menu/items/UISliderProgress.lua',
    'lib/menu/panels/UIColourPanel.lua',
    'lib/menu/panels/UIGridPanel.lua',
    'lib/menu/panels/UIPercentagePanel.lua',
    'lib/menu/panels/UISliderPanel.lua',
    'lib/menu/panels/UISpritPanel.lua',
    'lib/menu/panels/UIStatisticsPanel.lua',
    'lib/menu/windows/UIHeritage.lua',
    'lib/menu/elements/ItemsBadge.lua',
    'lib/menu/elements/ItemsColour.lua',
    'lib/menu/elements/PanelColour.lua',

	'config.lua',
    'client/**/*.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
    'server/**/*.lua',
}
