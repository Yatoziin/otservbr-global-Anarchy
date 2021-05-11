local table = {
  
        -- [1,5] = ID DA VOCACAO
        -- [LEVEL] = {items = {{itemid = ID_ITEM, count = QUANTIDADE}}, storage = VOCE_ESCOLHE, msg = "MENSAGEM QUE APARECERA PARA O PLAYER"},

   [{1, 5}] = {
     [50] = {items = {{itemid = 2160, count = 6}}, storage = 40100, msg = "Your reward for reaching level 50"},
     [100] = {items = {{itemid = 2160, count = 20}}, storage = 40101, msg = "Your reward for reaching level 100"},
     [150] = {items = {{itemid = 2160, count = 25}}, storage = 40106, msg = "Your reward for reaching level 150"}
   },
   [{2, 6}] = {
     [50] = {items = {{itemid = 2160, count = 6}}, storage = 40201, msg = "Your reward for reaching level 50"},
     [100] = {items = {{itemid = 2160, count = 20}}, storage = 40202, msg = "Your reward for reaching level 100"},
     [150] = {items = {{itemid = 2160, count = 25}}, storage = 40207, msg = "Your reward for reaching level 150"}
   },
   [{3, 7}] = {
     [50] = {items = {{itemid = 2160, count = 6}}, storage = 40301, msg = "Your reward for reaching level 50"},
     [100] = {items = {{itemid = 2160, count = 20}}, storage = 40302, msg = "Your reward for reaching level 100"},
     [150] = {items = {{itemid = 2160, count = 25}}, storage = 40306, msg = "Your reward for reaching level 150"},
     
   },
   [{4, 8}] = {
     [50] = {items = {{itemid = 2160, count = 6}}, storage = 40401, msg = "Your reward for reaching level 50"},
     [100] = {items = {{itemid = 2160, count = 20}}, storage = 40402, msg = "Your reward for reaching level 100"},
     [150] = {items = {{itemid = 2160, count = 25}}, storage = 40403, msg = "Your reward for reaching level 150"}
   }
}

local rewardLevel = CreatureEvent("RewardLevel")
function rewardLevel.onAdvance(player, skill, oldLevel, newLevel)


    if skill ~= SKILL_LEVEL or newLevel <= oldLevel then
        
        return true
    
    end

        for voc, x in pairs(table) do
            if isInArray(voc, player:getVocation():getId()) then
            	for level, z in pairs(x) do
            		if newLevel >= level and player:getStorageValue(z.storage) ~= 1 then
                		for v = 1, #z.items do
                			local ret = ", "
                			if v == 1 then
                			ret = ""
                		
                                        end
				        player:addItem(z.items[v].itemid, z.items[v].count)
            				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, z.msg)
            				player:setStorageValue(z.storage, 1)
                		end
                        end
                end
      
   			player:save()

   			return true
   
            end
         end
end

rewardLevel:register()