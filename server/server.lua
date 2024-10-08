local LUXRCore = exports['luxr-core']:GetCoreObject()

-- Get All Players
LUXRCore.Functions.CreateCallback('luxr-bountyhunter:server:getplayers', function(source, cb)
    MySQL.query('SELECT * FROM players', {}, function(result)
        cb(result or {})
    end)
end)

-- Add Bounty to Player
RegisterNetEvent('luxr-bountyhunter:server:addplayerbounty', function(amount, newreward, data)
    local src = source
    local Player = LUXRCore.Functions.GetPlayer(src)
    if Player.PlayerData.job.type ~= Config.BountyJobType then
        TriggerClientEvent('ox_lib:notify', src, { title = Config.Messages.NotAuthorized, type = 'error', duration = Config.NotificationDuration })
        return
    end

    if newreward <= Config.MaxBounty then
        MySQL.update('UPDATE players SET outlawstatus = ? WHERE citizenid = ?', { newreward, data.citizenid })
        TriggerClientEvent('ox_lib:notify', src, { title = Config.Messages.AdditionalBountyAdded, type = 'success', duration = Config.NotificationDuration })
        if Config.Logs.Enabled then
            TriggerEvent('luxr-log:server:CreateLog', 'outlaw', Config.Logs.BountyRaisedTitle, Config.Logs.Color, '💰 WANTED dead or alive '..data.firstname..' '..data.lastname..' reward $'..newreward)
        end
    else
        TriggerClientEvent('ox_lib:notify', src, { title = Config.Messages.MaxBountyReached, type = 'info', duration = Config.NotificationDuration })
    end
end)

-- Get Players for Reward
LUXRCore.Functions.CreateCallback('luxr-bountyhunter:server:getrewardplayers', function(source, cb)
    local players = {}
    for _, v in pairs(LUXRCore.Functions.GetPlayers()) do
        local ped = LUXRCore.Functions.GetPlayer(v)
        if ped then
            players[#players + 1] = {
                name = ped.PlayerData.charinfo.firstname .. ' ' .. ped.PlayerData.charinfo.lastname .. ' | (' .. GetPlayerName(v) .. ')',
                id = v,
                citizenid = ped.PlayerData.citizenid,
            }
        end
    end
    table.sort(players, function(a, b) return a.id < b.id end)
    cb(players)
end)

-- Pay Bounty Amount to Player
RegisterNetEvent('luxr-bountyhunter:server:payplayer', function(data)
    local src = source
    local Player = LUXRCore.Functions.GetPlayer(src)
    if Player.PlayerData.job.type ~= Config.BountyJobType then
        TriggerClientEvent('ox_lib:notify', src, { title = Config.Messages.NotAuthorized, type = 'error', duration = Config.NotificationDuration })
        return
    end

    local RewardPlayer = LUXRCore.Functions.GetPlayer(tonumber(data.rewardplayer))
    if RewardPlayer then
        RewardPlayer.Functions.AddMoney('cash', tonumber(data.rewardamount))
        MySQL.update('UPDATE players SET outlawstatus = ? WHERE citizenid = ?', { 0, data.bountycitizenid })
        TriggerClientEvent('ox_lib:notify', src, { title = Config.Messages.BountyPaid, type = 'success', duration = Config.NotificationDuration })
        TriggerClientEvent('ox_lib:notify', RewardPlayer.PlayerData.source, { title = Lang:t('client.received_bounty_reward', { amount = data.rewardamount }), type = 'success', duration = Config.NotificationDuration })
        if Config.Logs.Enabled then
            TriggerEvent('luxr-log:server:CreateLog', 'outlaw', Config.Logs.OutlawCapturedTitle, Config.Logs.Color, '🔒 '..data.bountyfirstname..' '..data.bountylastname..' has been captured and reward $'..data.rewardamount..' paid')
        end
    else
        TriggerClientEvent('ox_lib:notify', src, { title = Config.Messages.PlayerNotFound, type = 'error', duration = Config.NotificationDuration })
    end
end)

-- Create a New Bounty
RegisterNetEvent('luxr-bountyhunter:server:createnewbounty', function(data, bountyamount, amount)
    local src = source
    local Player = LUXRCore.Functions.GetPlayer(src)
    local jobtype = Player.PlayerData.job.type

    if jobtype == Config.BountyJobType then
        MySQL.update('UPDATE players SET outlawstatus = ? WHERE citizenid = ?', { bountyamount, data.citizenid })
        TriggerClientEvent('ox_lib:notify', src, { title = Config.Messages.BountyAdded, type = 'success', duration = Config.NotificationDuration })
        if Config.Logs.Enabled then
            TriggerEvent('luxr-log:server:CreateLog', 'outlaw', Config.Logs.NewBountyCreatedTitle, Config.Logs.Color, '💰 WANTED dead or alive '..data.firstname..' '..data.lastname..' reward $'..bountyamount)
        end
    else
        local cashBalance = Player.PlayerData.money['cash']
        if cashBalance >= amount then
            Player.Functions.RemoveMoney('cash', amount)
            MySQL.update('UPDATE players SET outlawstatus = ? WHERE citizenid = ?', { bountyamount, data.citizenid })
            TriggerClientEvent('ox_lib:notify', src, { title = Config.Messages.BountyAdded, type = 'success', duration = Config.NotificationDuration })
            if Config.Logs.Enabled then
                TriggerEvent('luxr-log:server:CreateLog', 'outlaw', Config.Logs.NewBountyCreatedTitle, Config.Logs.Color, '💰 WANTED dead or alive '..data.firstname..' '..data.lastname..' reward $'..bountyamount)
            end
        else
            TriggerClientEvent('ox_lib:notify', src, { title = Config.Messages.NotEnoughCash, type = 'error', duration = Config.NotificationDuration })
        end
    end
end)
