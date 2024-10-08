local LUXRCore = exports['luxr-core']:GetCoreObject()

-- Register Target for Bounty Boards
CreateThread(function()
    exports['luxr-target']:AddTargetModel(Config.BountyBoardModels, {
        options = {
            {
                type = 'client',
                icon = Config.BountyBoardActions[1].icon,
                label = Config.BountyBoardActions[1].label,
                action = function()
                    TriggerEvent(Config.BountyBoardActions[1].event)
                end
            },
            {
                type = 'client',
                icon = Config.BountyBoardActions[2].icon,
                label = Config.BountyBoardActions[2].label,
                action = function()
                    TriggerEvent(Config.BountyBoardActions[2].event)
                end
            },
        },
        distance = 3
    })
end)

-- Sort Function for Bounties
local function sortOrder(a, b)
    return (a.args and a.args.reward or 0) > (b.args and b.args.reward or 0)
end

-- Open Bounty Board
RegisterNetEvent('luxr-bountyhunter:client:openboard', function()
    LUXRCore.Functions.TriggerCallback('luxr-bountyhunter:server:getplayers', function(data)
        local options = {}
        for _, value in pairs(data) do
            local character = json.decode(value.charinfo)
            local firstname = character.firstname
            local lastname = character.lastname
            local citizenid = value.citizenid
            local outlawstatus = value.outlawstatus

            if outlawstatus >= Config.MinBounty then
                options[#options + 1] = {
                    title = firstname..' '..lastname..' ('..citizenid..')',
                    description = 'Bounty Reward: $'..outlawstatus,
                    icon = 'fa-solid fa-mask',
                    event = 'luxr-bountyhunter:client:viewoutlaw',
                    args = {
                        firstname = firstname,
                        lastname = lastname,
                        citizenid = citizenid,
                        reward = outlawstatus
                    },
                    arrow = true
                }
            end
        end

        table.sort(options, sortOrder)

        lib.registerContext({
            id = 'main_menu',
            title = Lang:t('client.wanted_outlaws'),
            position = Config.ContextPosition,
            options = options
        })
        lib.showContext('main_menu')
    end)
end)

-- View Outlaw Details
RegisterNetEvent('luxr-bountyhunter:client:viewoutlaw', function(data)
    lib.registerContext({
        id = 'outlaw_menu',
        menu = 'main_menu',
        title = Lang:t('client.outlaw', { firstname = data.firstname, lastname = data.lastname }),
        options = {
            {
                title = Lang:t('client.add_bounty_law_only'),
                description = Lang:t('client.add_bounty_to_player'),
                icon = 'fa-solid fa-money-bill-transfer',
                event = 'luxr-bountyhunter:client:addplayerbounty',
                args = data,
                arrow = true
            },
            {
                title = Lang:t('client.pay_bounty_law_only'),
                description = Lang:t('client.pay_bounty_to_player', { reward = data.reward }),
                icon = 'fa-solid fa-money-bill-transfer',
                event = 'luxr-bountyhunter:client:paybountyhunter',
                args = data,
                arrow = true
            },
        }
    })
    lib.showContext('outlaw_menu')
end)

-- Add More Bounty to Outlaw
RegisterNetEvent('luxr-bountyhunter:client:addplayerbounty', function(data)
    LUXRCore.Functions.GetPlayerData(function(PlayerData)
        if PlayerData.job.type == Config.BountyJobType then
            local input = lib.inputDialog(Lang:t('client.additional_bounty'), {
                {
                    label = Lang:t('client.amount'),
                    type = 'input',
                    required = true,
                    icon = 'fa-solid fa-dollar-sign'
                },
            })

            if not input then return end

            local additionalAmount = tonumber(input[1])
            if not additionalAmount then
                lib.notify({ title = Config.Messages.InvalidAmount, type = 'error', duration = Config.NotificationDuration })
                return
            end

            local newReward = data.reward + additionalAmount
            TriggerServerEvent('luxr-bountyhunter:server:addplayerbounty', additionalAmount, newReward, data)
        else
            lib.notify({ title = Config.Messages.NotLawEnforcement, type = 'inform', duration = Config.NotificationDuration })
        end
    end)
end)

-- Pay Bounty
RegisterNetEvent('luxr-bountyhunter:client:paybountyhunter', function(data)
    LUXRCore.Functions.GetPlayerData(function(PlayerData)
        if PlayerData.job.type == Config.BountyJobType then
            LUXRCore.Functions.TriggerCallback('luxr-bountyhunter:server:getrewardplayers', function(players)
                local options = {}
                for _, v in pairs(players) do
                    options[#options + 1] = {
                        title = 'ID: ' ..v.id..' | '..v.name,
                        icon = 'fa-solid fa-circle-user',
                        event = 'luxr-bountyhunter:client:giveplayerbounty',
                        args = {
                            rewardplayer = v.id,
                            rewardplayername = v.name,
                            rewardamount = data.reward,
                            bountycitizenid = data.citizenid,
                            bountyfirstname = data.firstname,
                            bountylastname = data.lastname
                        },
                        arrow = true,
                    }
                end
                lib.registerContext({
                    id = 'leo_givebounty',
                    title = 'Bounty Reward',
                    menu = 'outlaw_menu',
                    position = Config.ContextPosition,
                    options = options
                })
                lib.showContext('leo_givebounty')
            end)
        else
            lib.notify({ title = Config.Messages.NotLawEnforcement, type = 'inform', duration = Config.NotificationDuration })
        end
    end)
end)

-- Confirm Payment
RegisterNetEvent('luxr-bountyhunter:client:giveplayerbounty', function(data)
    local input = lib.inputDialog(Lang:t('client.confirm_payment', { rewardamount = data.rewardamount }), {
        {
            label = '',
            type = 'select',
            options = {
                { value = 'yes', label = Lang:t('client.yes') },
                { value = 'no',  label = Lang:t('client.no') }
            },
            required = true
        },
    })

    if not input or input[1] == 'no' then return end

    TriggerServerEvent('luxr-bountyhunter:server:payplayer', data)
end)

-- Create Bounty
RegisterNetEvent('luxr-bountyhunter:client:createbounty', function()
    LUXRCore.Functions.TriggerCallback('luxr-bountyhunter:server:getplayers', function(result)
        local options = {}
        for _, value in pairs(result) do
            local character = json.decode(value.charinfo)
            local firstname = character.firstname
            local lastname = character.lastname
            local citizenid = value.citizenid
            local outlawstatus = value.outlawstatus

            if outlawstatus < Config.MaxBounty then
                options[#options + 1] = {
                    title = firstname..' '..lastname..' ('..citizenid..')',
                    icon = 'fa-solid fa-mask',
                    event = 'luxr-bountyhunter:client:setbountyamount',
                    args = {
                        firstname = firstname,
                        lastname = lastname,
                        citizenid = citizenid,
                        currentreward = outlawstatus
                    },
                    arrow = true
                }
            end
        end

        table.sort(options, function(a, b) return a.title < b.title end)

        lib.registerContext({
            id = 'create_bounty',
            title = Lang:t('client.create_bounty'),
            position = Config.ContextPosition,
            options = options
        })
        lib.showContext('create_bounty')
    end)
end)

RegisterNetEvent('luxr-bountyhunter:client:setbountyamount', function(data)
    local input = lib.inputDialog(Lang:t('client.set_bounty_for', { firstname = data.firstname, lastname = data.lastname }), {
        {
            label = Lang:t('client.amount'),
            type = 'input',
            icon = 'fa-solid fa-dollar-sign',
            description = Lang:t('client.min_bounty', { min = Config.MinBounty, max = Config.MaxBounty }),
            required = true
        },
    })

    if not input then return end

    local amount = tonumber(input[1])
    if not amount then
        lib.notify({ title = Config.Messages.InvalidAmount, type = 'error', duration = Config.NotificationDuration })
        return
    end

    if amount > Config.MaxBounty then
        lib.notify({ title = Config.Messages.MaxBountyReached, type = 'inform', duration = Config.NotificationDuration })
        return
    end

    if amount < Config.MinBounty then
        lib.notify({ title = Lang:t('client.min_bounty_amount', { min = Config.MinBounty }), type = 'inform', duration = Config.NotificationDuration })
        return
    end

    local bountyadjust = amount + tonumber(data.currentreward)
    TriggerServerEvent('luxr-bountyhunter:server:createnewbounty', data, bountyadjust, amount)
end)
