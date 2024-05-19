local rewardData = 0
local typeshit = ""

RegisterNetEvent("vd:startPlayerReward", function()
    SendNUIMessage({type="openUi"})
    SetNuiFocus(true, true)
end)

RegisterNUICallback("givereward", function()
    TriggerServerEvent("vd:giveRewardToPlayer")
    SetNuiFocus(false, false)
end)

RegisterNUICallback("exit", function()
    SetNuiFocus(false, false)
end)

RegisterNetEvent("vd:setPlayerHud", function(type, hours)
    SendNUIMessage({type = type, hours=hours})
    typeshit = type
    if hours then
        rewardData = hours
    end
end)

local function hours()
    if typeshit == "Invalid" then
        rewardData = rewardData - 1
        TriggerServerEvent("vd:updateTime", rewardData)
    end

    Citizen.SetTimeout(3600 * 1000, hours)
end
hours()
