Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(5000)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)


local List = {
    Actions = {
        "Déposer",
        "Prendre"
    },
    ActionIndex = 1,
    ActionButton = 1
}

local List2 = {
    Actions = {
        "Déposer",
        "Prendre"
    },
    ActionIndex = 1,
    ActionButton = 1
}
-- SOCIETYMENU

function OpenSocietyPlayerInventoryMenu(society, position)
    local menu = RageUI.CreateMenu("Déposer", "Contenu de vos poches :")

    RageUI.Visible(menu, not RageUI.Visible(menu))

    while menu do
        Wait(0)
        RageUI.IsVisible(menu, function()

            RageUI.Separator("~b~Que voulez-vous déposer ?")
            ESX.PlayerData = ESX.GetPlayerData()
            for i = 1, #ESX.PlayerData.inventory do
                if ESX.PlayerData.inventory[i].count > 0 then
                    RageUI.Button("• "..ESX.PlayerData.inventory[i].label, nil, { RightLabel = "Quantité(s) : ~r~x"..ESX.PlayerData.inventory[i].count }, true, {
                        onSelected = function()
                            if UpdateOnscreenKeyboard() == 0 then return end
                            local string = KeyboardInput('Combien voulez vous déposer ?', '', '', 100)
                            if string ~= "" then
                                deposit = tonumber(string)
                                if ESX.PlayerData.inventory[i].count >= deposit then
                                    TriggerServerEvent("Core:AddInventoryToSocietyCache", position, society.name, ESX.PlayerData.inventory[i].name, ESX.PlayerData.inventory[i].label, deposit)
                                else
                                    print('t')
                                    ESX.ShowNotification('~r~Erreur ~w~~n~Tu n\'as pas assez d\'objets sur toi')
                                end
                            end
                        end
                    })
                end
            end

        end, function()
        end)

        if not RageUI.Visible(menu) then
            menu = RMenu:DeleteType('menu', true)
            OpenSocietyMenu({label = ESX.PlayerData.job.label, name = ESX.PlayerData.job.name }, position)
        end
    end
end

function OpenSocietyInventoryMenu(society, position, data)
    local menu = RageUI.CreateMenu("Prendre", "Contenu du coffre :")

    RageUI.Visible(menu, not RageUI.Visible(menu))

    while menu do
        Wait(0)
        RageUI.IsVisible(menu, function()
            RageUI.Separator("~b~Que voulez-vous prendre ?")
            for k,v in pairs(data) do
                RageUI.Button(v.label, nil, {RightLabel = "Quantité(s) : ~r~x"..v.count}, true, {
                    onSelected = function()
                        if UpdateOnscreenKeyboard() == 0 then return end
                        local string = KeyboardInput('Combien voulez vous prendre ?', '', '', 100)
                        if string ~= "" then
                            deposit = tonumber(string) 
                            if v.count >= deposit then
                                TriggerServerEvent("Core:RemoveInventoryToSocietyCache", position, society.name, v.item, v.label, deposit)
                                OpenSocietyMenu({label = ESX.PlayerData.job.label, name = ESX.PlayerData.job.name }, position)
                            else
                                ESX.ShowNotification('~r~Erreur ~w~~n~Il n\'y a pas assez d\'objets dans le coffre')
                            end
                        end
                    end
                })
            end

        end, function()
        end)

        if not RageUI.Visible(menu) then
            menu = RMenu:DeleteType('menu', true)
            OpenSocietyMenu({label = ESX.PlayerData.job.label, name = ESX.PlayerData.job.name }, position)
        end
    end
end