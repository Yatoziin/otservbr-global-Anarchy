local effects = {
    {position = Position(32365, 32236, 7), text = 'Trainers!', effect = CONST_ME_GROUNDSHAKER},
    {position = Position(1051, 1040, 7), text = 'TRAINERS', effect = CONST_ME_GROUNDSHAKER},
    {position = Position(1063, 1024, 7), text = 'Quiz', effect = CONST_ME_GROUNDSHAKER},
    {position = Position(1057, 1023, 7), text = 'Temple', effect = CONST_ME_GROUNDSHAKER},    
    {position = Position(32342, 32220, 7), text = 'Trade Island', effect = CONST_ME_GROUNDSHAKER},
    {position = Position(32373, 32236, 7), text = 'Trade Island', effect = CONST_ME_GROUNDSHAKER}, 
	{position = Position(1063, 1010, 7), text = 'Trade Npc', effect = CONST_ME_GROUNDSHAKER},
	{position = Position(989, 1028, 6), text = 'Thais Temple', effect = CONST_ME_GROUNDSHAKER},
}

local animatedText = GlobalEvent("AnimatedText") 
function animatedText.onThink(interval)
    for i = 1, #effects do
        local settings = effects[i]
        local spectators = Game.getSpectators(settings.position, false, true, 7, 7, 5, 5)
        if #spectators > 0 then
            if settings.text then
                for i = 1, #spectators do
                    spectators[i]:say(settings.text, TALKTYPE_MONSTER_SAY, false, spectators[i], settings.position)
                end
            end
            if settings.effect then
                settings.position:sendMagicEffect(settings.effect)
            end
        end
    end
   return true
end

animatedText:interval(4550)
animatedText:register()