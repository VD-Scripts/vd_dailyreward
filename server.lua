local tunnel = module("lib/Tunnel")
local proxy = module("lib/Proxy")

vRP = proxy.getInterface("vRP")
vRPclient = tunnel.getInterface("vRP", "vd_dailyreward")

local server = {}
server.rewards = {
    "money",
    "pp"
}
server.CashRewardMin = 1
server.CashRewardMax = 10000

server.givePPFunction = vRP.givePremiumPoints
server.ppMin = 1
server.ppMax = 2

local rewardData = {} -- cooldown

AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        exports.oxmysql:query("SELECT dailyReward FROM vrp_users WHERE id=@user_id", {user_id = user_id}, function(i)
            rewardData[user_id] = i[1].dailyReward
            if rewardData[user_id] == 0 then
                TriggerClientEvent("vd:setPlayerHud", source,"Available")
            else
                TriggerClientEvent("vd:setPlayerHud", source, "Invalid", rewardData[user_id])
            end
        end)
    end
end)

RegisterServerEvent("vd:updateTime", function(hours)
    if (hours + 1) ~= rewardData[user_id] then return DropPlayer(source, "Mars") end
    rewardData[user_id] = hours
    if rewardData[user_id] == 0 then
        TriggerClientEvent("vd:setPlayerHud", source,"Available")
    else
        TriggerClientEvent("vd:setPlayerHud", source, "Invalid", rewardData[user_id])
    end
end)

AddEventHandler("vRP:playerLeave", function(user_id, source)
    exports.oxmysql:query("UPDATE vrp_users SET dailyReward = @daily WHERE id=@user_id", {user_id=user_id, daily=rewardData[user_id]})
end)

RegisterCommand("dailyreward", function(player, args)
    local user_id = vRP.getUserId{player}

    if rewardData == 0 then
        TriggerClientEvent("vd:startPlayerReward", player)
    end
end)

RegisterServerEvent("vd:giveRewardToPlayer", function()
    local user_id = vRP.getUserId({source})

    if rewardData[user_id] ~= 0 then return vRPclient.notify(source, {"Pacatos"}) end

    rewardData[user_id] = 24
    exports.oxmysql:query("UPDATE vrp_users SET dailyReward = 24 WHERE id=@user_id", {user_id = user_id})
    TriggerClientEvent("vd:setPlayerHud", source, "Invalid", rewardData[user_id])

    local chance = math.random(1, #server.rewards)
    for k,v in pairs(server.rewards) do
        if k == chance then
            if v == "money" then
                local cashReward = math.random(server.CashRewardMin, server.CashRewardMax)
                vRP.giveMoney({user_id, cashReward})
                vRPclient.notify(source, {"[Daily Reward]: Ai primit "..cashReward.."$ de la bunicuta ta."})
            elseif v == "pp" then
                local ppReward = math.random(server.ppMin, server.ppMax)
                server.givePPFunction({user_id, ppReward})
                vRPclient.notify(source, {"[Daily Reward]: Ai primit "..ppReward.." Premium Points de la bunicuta ta."})
            end
        end
    end
end)
