Config = {}

-- General Settings
Config.MaxBounty = 3000          -- Maximum bounty amount
Config.MinBounty = 100           -- Minimum bounty amount
Config.NotificationDuration = 7000 -- Duration for notifications (in milliseconds)
Config.BountyJobType = 'leo'     -- Job type that can add or pay bounties
Config.ContextPosition = 'top-right' -- Position for context menus
Config.BountyBoardModels = {     -- Models for bounty boards
    `mp005_p_mp_bountyboard01x`,
    `mp005_p_mp_bountyboard02x`
}

-- Bounty Board Actions
Config.BountyBoardActions = {
    {
        label = 'View Bounty Board',
        icon = 'far fa-eye',
        event = 'luxr-bountyhunter:client:openboard',
    },
    {
        label = 'Create New Bounty',
        icon = 'far fa-eye',
        event = 'luxr-bountyhunter:client:createbounty',
    },
}

-- Log Settings
Config.Logs = {
    Enabled = true,
    BountyRaisedTitle = 'Bounty Raised',
    OutlawCapturedTitle = 'Outlaw Captured',
    NewBountyCreatedTitle = 'New Bounty Created',
    Color = 'green',
}

-- Messages
Config.Messages = {
    NotLawEnforcement = 'You are not Law Enforcement',
    NotAuthorized = 'You are not authorized',
    InvalidAmount = 'Invalid amount',
    MaxBountyReached = 'Max Bounty Reached!',
    MinBountyRequired = 'Minimum amount is $%s',
    BountyAdded = 'Bounty Added!',
    AdditionalBountyAdded = 'Additional Bounty Added!',
    BountyPaid = 'Bounty Paid!',
    ReceivedBountyReward = 'You received a bounty reward of $%s',
    PlayerNotFound = 'Player Not Found',
    NotEnoughCash = 'Not enough cash!',
}
