local config = {
    coinId = 24774,
    effect = 15
}

local action = Action()
function action.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if player:getItemCount(config.coinId) > 0 then
        local playerCoins = player:getCoinsBalance() + item:getCount()
        player:getPosition():sendMagicEffect(config.effect)
        player:setCoinsBalance(playerCoins)
        item:remove()
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have to carry tibia coins in your backpack.")
    end
    return true
end

action:id(config.coinId)
action:register()