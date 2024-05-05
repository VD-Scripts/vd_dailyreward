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

RegisterNetEvent("vd:setPlayerHud", function(type)
    SendNUIMessage({type = type})
end)