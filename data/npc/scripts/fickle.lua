local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end
 
function creatureSayCallback(cid, type, msg)
if(not npcHandler:isFocused(cid)) then
return false
end
local talkUser = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid
local shopWindow = {}
local t = {
          [30882] = {price = 1000, price2 = 0}, -- [ITEMID TO SELL] = {Buy cost (0 = not buyable), sell cost (0 = not sellable)}
		  [30884] = {price = 1000, price2 = 0},
		  [30885] = {price = 1000, price2 = 0},
		  [30883] = {price = 1000, price2 = 0},
		  [32419] = {price = 1200, price2 = 0},
		  [32420] = {price = 1200, price2 = 0},
		  [32415] = {price = 1200, price2 = 0},
		  [32414] = {price = 1200, price2 = 0},
		  [32422] = {price = 1200, price2 = 0},
		  [32417] = {price = 900, price2 = 0},
		  [32416] = {price = 900, price2 = 0},
		  [32418] = {price = 900, price2 = 0},
		  [38992] = {price = 600, price2 = 0},
		  [36414] = {price = 600, price2 = 0},
		  [36413] = {price = 600, price2 = 0},
		  [38930] = {price = 2000, price2 = 0},
		  [38931] = {price = 2000, price2 = 0},
		  [38929] = {price = 2000, price2 = 0},
		  [38991] = {price = 600, price2 = 0},
		  [36412] = {price = 600, price2 = 0},
		  [36417] = {price = 600, price2 = 0},
		  [38989] = {price = 700, price2 = 0},
		  [38934] = {price = 2000, price2 = 0},
		  [38988] = {price = 2000, price2 = 0},
		  [38932] = {price = 2000, price2 = 0},
		  [38933] = {price = 2000, price2 = 0},
		  [38928] = {price = 2000, price2 = 0},
		  [38927] = {price = 2000, price2 = 0},
		  [26133] = {price = 200, price2 = 0},
		  [37454] = {price = 100, price2 = 0},
		  [34062] = {price = 100, price2 = 0},
		  [38925] = {price = 1500, price2 = 0},
		  [38926] = {price = 1500, price2 = 0},
		  [38924] = {price = 1500, price2 = 0},
		  [38923] = {price = 1500, price2 = 0},
		  [38917] = {price = 1500, price2 = 0},
		  [38918] = {price = 1500, price2 = 0},
		  [38920] = {price = 1500, price2 = 0},
		  [38919] = {price = 1500, price2 = 0},
		  [38921] = {price = 1500, price2 = 0},
		  [38922] = {price = 1500, price2 = 0},
		  [37451] = {price = 300, price2 = 0},
          [38993] = {price = 700, price2 = 0}
          }
local TradeItem = 25377
local onBuy = function(cid, item, subType, amount, ignoreCap, inBackpacks)
	if getPlayerItemCount(cid, TradeItem) < t[item].price*amount then
		selfSay("You don't have enough Gold Tokens.", cid)
	else
		doPlayerAddItem(cid, item, amount)
		doPlayerRemoveItem(cid, TradeItem, t[item].price*amount)
		doPlayerSendTextMessage(cid, 20, "You have bought " .. amount .. "x " .. getItemName(item) .. " for " .. t[item].price*amount .. " Gold Token.")
	end
	return true
end
local onSell = function(cid, item, subType, amount)
	doPlayerRemoveItem(cid, item, amount)
	doPlayerAddItem(cid, TradeItem, t[item].price2*amount)
	doPlayerSendTextMessage(cid, 20, "You have sold " .. amount .. "x " .. getItemName(item) .. " for " .. t[item].price*amount .. " Gold Token.")
	--selfSay("Here your are!", cid)
	return true
end
if (msgcontains(msg, 'trade') or msgcontains(msg, 'TRADE'))then
	for var, ret in pairs(t) do
		table.insert(shopWindow, {id = var, subType = 0, buy = ret.price, sell = ret.price2, name = getItemName(var)})
	end
	openShopWindow(cid, shopWindow, onBuy, onSell) end
	return true
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())