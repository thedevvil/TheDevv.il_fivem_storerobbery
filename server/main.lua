QBCore = exports['qb-core']:GetCoreObject()


RegisterServerEvent('qb-storerobbery:server:takeMoney')
AddEventHandler('qb-storerobbery:server:takeMoney', function(register, isDone)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	-- Add some stuff if you want, this here above the if statement will trigger every 2 seconds of the animation when robbing a cash register.
    if isDone then
	local bags = math.random(1,3)
	local info = {
		worth = math.random(cashA, cashB)
	}
	Player.Functions.AddItem('markedbills', bags, false, info)
	TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['markedbills'], "add")
        if math.random(1, 100) <= 10 then
            -- Give Special Item (Safe Cracker)
            Player.Functions.AddItem("matkap", 1)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["matkap"], 'add')
        end
    end
end)

RegisterServerEvent('qb-storerobbery:server:setRegisterStatus')
AddEventHandler('qb-storerobbery:server:setRegisterStatus', function(register)
    Config.Registers[register].robbed   = true
    Config.Registers[register].time     = Config.resetTime
    TriggerClientEvent('qb-storerobbery:client:setRegisterStatus', -1, register, Config.Registers[register])
end)

RegisterServerEvent('qb-storerobbery:server:setSafeStatus')
AddEventHandler('qb-storerobbery:server:setSafeStatus', function(safe)
    TriggerClientEvent('qb-storerobbery:client:setSafeStatus', -1, safe, true)
    Config.Safes[safe].robbed = true

    SetTimeout(math.random(40, 80) * (60 * 1000), function()
        TriggerClientEvent('qb-storerobbery:client:setSafeStatus', -1, safe, false)
        Config.Safes[safe].robbed = false
    end)
end)

RegisterServerEvent('qb-storerobbery:server:SafeReward')
AddEventHandler('qb-storerobbery:server:SafeReward', function(safe)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local bags = math.random(2,5)
	local info = {
		worth = math.random(ScashA, ScashB)
	}
	Player.Functions.AddItem('markedbills', bags, false, info)
	TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['markedbills'], "add")
    local luck = math.random(1, 100)
    local odd = math.random(1, 100)
    if luck <= 10 then
            Player.Functions.AddItem("rolex", 1)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["rolex"], "add")
        if luck == odd then
            Citizen.Wait(500)
            Player.Functions.AddItem("goldbar", 1)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["goldbar"], "add")
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local toSend = {}
        for k, v in ipairs(Config.Registers) do

            if Config.Registers[k].time > 0 and (Config.Registers[k].time - Config.tickInterval) >= 0 then
                Config.Registers[k].time = Config.Registers[k].time - Config.tickInterval
            else
                if Config.Registers[k].robbed then
                    Config.Registers[k].time = 0
                    Config.Registers[k].robbed = false

                    table.insert(toSend, Config.Registers[k])
                end
            end
        end

        if #toSend > 0 then
            --The false on the end of this is redundant
            TriggerClientEvent('qb-storerobbery:client:setRegisterStatus', -1, toSend, false)
        end

        Citizen.Wait(Config.tickInterval)
    end
end)

QBCore.Functions.CreateCallback('qb-storerobbery:server:getRegisterStatus', function(source, cb)
    cb(Config.Registers)
end)

QBCore.Functions.CreateCallback('qb-storerobbery:server:getSafeStatus', function(source, cb)
    cb(Config.Safes)
end)

RegisterServerEvent('qb-storerobbery:server:CheckItem')
AddEventHandler('qb-storerobbery:server:CheckItem', function()
    local Player = QBCore.Functions.GetPlayer(source)
    local ItemData = Player.Functions.GetItemByName("security_card_01")
    local ItemData2 = Player.Functions.GetItemByName("matkap")
    if ItemData ~= nil then
        if ItemData2 ~= nil then
            TriggerClientEvent('qb-storerobbery:client:hacksafe', source)
        else
            TriggerClientEvent('QBCore:Notify', source, "Bir şeyler eksik görünüyor")
        end
    end
end)

RegisterServerEvent('qb-storerobbery:server:callCops')
AddEventHandler('qb-storerobbery:server:callCops', function(type, safe, streetLabel, coords)
    local cameraId = 4
    if type == "safe" then
        cameraId = Config.Safes[safe].camId
    else
        cameraId = Config.Registers[safe].camId
    end

    exports['ps-dispatch']:StoreRobbery(camId)

    -- // QB PHONE PD ALERT \\ --
    -- local alertData = {
    --     title = "10-90 | Shop Robbery",
    --     coords = {x = coords.x, y = coords.y, z = coords.z},
    --     description = "Someone Is Trying To Rob A Store At "..streetLabel.." (CAMERA ID: "..cameraId..")"
    -- }
    -- TriggerClientEvent("qb-phone:client:addPoliceAlert", -1, alertData)
    
end)

RegisterNetEvent('qb-marketsoygunu:kartver', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if math.random(0,100) < 35 then
        Player.Functions.AddItem('security_card_01', 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["security_card_01"], "add")
    end
end)

RegisterNetEvent('qb-marketsoygunu:paraver', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local reward = math.random(550, 600)
    if not Player then return end
    Player.Functions.AddMoney("cash", reward)
end)

RegisterNetEvent('qb-marketsoygunu:maymuncuksil', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    Player.Functions.RemoveItem('lockpick', 1)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["lockpick"], "remove")
end)

RegisterNetEvent('qb-marketsoygunu:gelismismaymuncuksil', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    Player.Functions.RemoveItem('advancedlockpick', 1)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["advancedlockpick"], "remove")
end)

RegisterNetEvent('qb-marketsoygunu:arkakasapara', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local reward2 = math.random(3800, 4400)
    if not Player then return end
    Player.Functions.AddMoney("cash", reward2)
    if math.random(0,100) < 35 then
        Player.Functions.AddItem('security_card_02', 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["security_card_02"], "add")
    end
end)

RegisterNetEvent('qb-marketsoygunu:kartsil', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    Player.Functions.RemoveItem("security_card_01", 1)
    Player.Functions.RemoveItem("matkap", 1)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["security_card_01"], "remove")
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["matkap"], "remove")
end)