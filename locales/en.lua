local Translations = {
    client = {
        view_bounty_board = 'View Bounty Board',
        create_new_bounty = 'Create New Bounty',
        wanted_outlaws = 'Wanted Outlaws',
        outlaw = 'Outlaw %{firstname} %{lastname}',
        add_bounty_law_only = 'Add Bounty (Law Only)',
        add_bounty_to_player = 'Add bounty to a player',
        pay_bounty_law_only = 'Pay Bounty (Law Only)',
        pay_bounty_to_player = 'Pay bounty of $%{reward} to player',
        additional_bounty = 'Additional Bounty',
        amount = 'Amount',
        confirm_payment = 'Confirm Payment of $%{rewardamount}',
        yes = 'Yes',
        no = 'No',
        create_bounty = 'Create Bounty',
        set_bounty_for = 'Set Bounty for %{firstname} %{lastname}',
        min_bounty = 'min = $%{min} : max = $%{max}',
        invalid_amount = 'Invalid amount',
        greater_than_max_bounty = 'Greater than Max Bounty',
        min_bounty_amount = 'Minimum amount is $%{min}',
        not_law_enforcement = 'You are not Law Enforcement',
        not_authorized = 'You are not authorized',
        additional_bounty_added = 'Additional Bounty Added!',
        max_bounty_reached = 'Max Bounty Reached!',
        bounty_paid = 'Bounty Paid!',
        received_bounty_reward = 'You received a bounty reward of $%{amount}',
        player_not_found = 'Player Not Found',
        bounty_added = 'Bounty Added!',
        not_enough_cash = 'Not enough cash!',
    },
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
