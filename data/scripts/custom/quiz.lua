if not Quiz then
    Quiz = {
        subscribeTime = 300 * 1000,
        messageDelayTime = 60 * 1000, -- delay between broadcast messages
        minPlayersToStart = 1,
        questionsPerGame = 5, --how many questions you want to roll (unique questions)
        reward = {25377, 20} --count,id
    }
    --maybe sometimes im using double check for somethings but im not always sure how things works in tfs 1.3.
    Quiz.mapConfig = {
        waitingRoom = {
            ['top_left_corner'] = {x = 1038, y = 978, z = 7},
            ['bot_right_corner'] = {x = 1051, y = 991, z = 7}, -- i  will ignore z_pos, maybe in future there will be multifloor
            ['tile_action_id'] = 30000, --auto system will set waiting room tiles to this uid
        },

        gameRoom = {
            ['center'] = {x = 1062, y = 974, z = 7},
            leftAnswer = { --sqms for left side answers
                ['top_left_corner'] = {x = 1055, y = 970, z = 7},
                ['bot_right_corner'] = {x = 1061, y = 978, z = 7},
                ['tile_action_id'] = 30001,
            },
            rightAnswer = { --sqms for right side answers
                ['top_left_corner'] = {x = 1063, y = 970, z = 7},
                ['bot_right_corner'] = {x = 1069, y = 978, z = 7},
                ['tile_action_id'] = 30002,
            },
            teleportAble = { --place to check if players can be teleported to game pos (need if a lot of players will join event.)
                ['top_left_corner'] = {x = 1061, y = 970, z = 7},
                ['bot_right_corner'] = {x = 1063, y = 978, z = 7}
            }
        },
    }

    Quiz.LeftAnswer = Quiz.mapConfig.gameRoom.leftAnswer['tile_action_id']
    Quiz.RightAnswer = Quiz.mapConfig.gameRoom.rightAnswer['tile_action_id']

    Quiz.Questions = { --questions
        {
            text="1+1=", answers = {
            bad = "4",  --bad/good cuz side for every answer is random
            good = "2",
        }},
        {
            text="Who played Joey?", answers = {
            bad = "David Schwimmer",
            good = "Matt Le Blanc",
        }},
        {
		    text="What level do you have to be in order to leave Rookgaard?", answers = {
            bad = "10",
            good = "8",
        }},
        {
		    text="Which monsters drop a Mastermind Shield?", answers = {
            bad = "Behemoth",
            good = "Demon",
        }},
        {
		    text="What is the defense of Dragon Scail Mail?", answers = {
            bad = "16",
            good = "15",
        }},
        {
			text="How much is one crystal coin equivalent to?", answers = {
            bad = "100 gold coins",
            good = "100 platinum coins",
        }},
        {
			text="Where is the Great Barrier Reef located?", answers = {
            bad = "New Zealand",
            good = "Australia",
        }},
        {
			text="What sport does Cristiano Ronaldo play?", answers = {
            bad = "Rugby",
            good = "Soccer",
        }},
        {
			text="Which fictional city is the home of Batman?", answers = {
            bad = "Arkham",
            good = "Gotham",
        }},
        {
			text="Which planet is closest to Earth?", answers = {
            bad = "Mars",
            good = "Venus",
        }},
        {
			text="What is the name of Han Solo’s ship?", answers = {
            bad = "Millennium Eagle",
            good = "Millennium Falcon",
        }},
        {
			text="Which country occupies half of South America’s western coast?", answers = {
            bad = "Brazil",
            good = "Chile",
        }},
        {
			text="What is the name of the 1993 movie about dinosaurs?", answers = {
            bad = "Dino Land",
            good = "Jurassic Park",
        }},
        {
			text="What language is the most popularly spoken worldwide?", answers = {
            bad = "English",
            good = "Chinese",
        }},
        {
			text="What has a gravitational pull so strong that light cannot even escape it?", answers = {
            bad = "Bum Hole",
            good = "Black Hole",
        }},
        {
			text="What vegetable is known to help you see in the dark?", answers = {
            bad = "Broccoli",
            good = "Carrot",
        }},
        {
			text="What was Bruce Banner exposed to that turned him into the Hulk?", answers = {
            bad = "The Gays",
            good = "Gamma Radiation",
        }},
        {
			text="Who was the first American astronaut to step foot on the moon?", answers = {
            bad = "Bart Simpson",
            good = "Neil Armstrong",
        }},
        {
			text="Which actor played the prince of Bel-Air?", answers = {
            bad = "Jayden Smith",
            good = "Will Smith",
        }},
        {
            text="What element does 'O' represent on the periodic table?", answers = {
            bad = "Opium",
            good = "Oxygen",
        }},

    }

    Quiz.Storage = {
        players = {}, --players in event
        eventEnabled = false,
        WaitingRoomEvent = nil,
        waitingRoomEnabled = false,
        subscribeTime = 0,
        messageDelayTime = 0,
        Questions = {}, --text/goodUid =
        QuestionEvent = nil,
        currentQuestion = 0
    }

    function Quiz.Disable()
        Quiz.Storage.players = {} --know new pointer but idk if matter to clean current
        Quiz.Storage.Questions = {}
        Quiz.Storage.eventEnabled = false
        Quiz.Storage.QuestionEvent = nil
    end

    function Quiz.shuffleTable(tbl)
        local len, random = #tbl, math.random ;
        for i = len, 2, -1 do
            local j = random( 1, i );
            tbl[i], tbl[j] = tbl[j], tbl[i];
        end
        return tbl;
    end

    function Quiz.QuestionEvent(times)
        local currentIndex = Quiz.Storage.currentQuestion
        if(not Quiz.Storage.Questions[currentIndex]) then
            --can add teleport out players but it can't happen
            Quiz.Disable()
            return true
        else
            for i = 1, #Quiz.Storage.players do
                local player = Player(Quiz.Storage.players[i])
                if(player) then
                    local text = "[Question]: "..Quiz.Storage.Questions[currentIndex].text.." Left Side: "..Quiz.Storage.Questions[currentIndex].left..", Right Side: "..Quiz.Storage.Questions[currentIndex].right
                    text = text.." - "..times.." seconds left."
                    player:sendTextMessage(MESSAGE_INFO_DESCR, text)                     
                end
            end 
        end
        times = times - 1
        if(times > -1) then --check
            Quiz.Storage.QuestionEvent = addEvent(Quiz.QuestionEvent, 1000, times)
        else
            if(Quiz.Storage.Questions[currentIndex].goodAnswerTileId == Quiz.LeftAnswer) then
                Quiz.sideEffect('right')
            else
                Quiz.sideEffect('left')
            end

            for i = 1, #Quiz.Storage.players do
                local player = Player(Quiz.Storage.players[i])
                if(player) then
                    local t = Tile(player:getPosition())
                    if t ~= nil then
                        local tileItem = t:getThing();
                        local tileaid = tileItem:getActionId()
                        if(tileaid ~= Quiz.Storage.Questions[currentIndex].goodAnswerTileId) then
                            Quiz.kickPlayer(player)
                        end
                    end       
                end
            end

            if(#Quiz.Storage.players > 0) then
                local questionsLeft = #Quiz.Storage.Questions - currentIndex
                for i = 1, #Quiz.Storage.players do
                    local player = Player(Quiz.Storage.players[i])
                    if(player) then
                        if(questionsLeft > 0) then
                            player:sendTextMessage(MESSAGE_INFO_DESCR, "Quiz: "..#Quiz.Storage.players.." players left. Questions left: "..questionsLeft..".")
                        else
                            player:sendTextMessage(MESSAGE_INFO_DESCR, "Congratulations! You won!")
                            player:addItem(Quiz.reward[1], Quiz.reward[2])
                            player:teleportTo(player:getTown():getTemplePosition())
                        end
                    end
                end
                if(questionsLeft > 0) then
                    Quiz.Storage.currentQuestion = Quiz.Storage.currentQuestion + 1
                    addEvent(Quiz.QuestionEvent, 5000, 25)
                else
                    Quiz.Disable()
                end
            else
                Quiz.Disable()
            end
        end
    end

    function Quiz.kickPlayer(player)
        local playerId = player:getId()
        if(table.contains(Quiz.Storage.players, playerId)) then
            for i = 1, #Quiz.Storage.players do
                if(Quiz.Storage.players[i] == playerId) then
                    table.remove(Quiz.Storage.players, i)
                    player:sendTextMessage(MESSAGE_INFO_DESCR, "You lost. Try again next time.")
                    player:teleportTo(player:getTown():getTemplePosition())
                    break
                end
            end
        end
    end


    function Quiz.FillRandomQuestions()
        if(Quiz.questionsPerGame > #Quiz.Questions) then
            Quiz.questionsPerGame = #Quiz.Questions
        end

        local tmpTbl = {}
        for i = 1, #Quiz.Questions do
            table.insert(tmpTbl, i)
        end
        tmpTbl = Quiz.shuffleTable(tmpTbl)

        for i = 1, Quiz.questionsPerGame do
            local questionInfo = {text = Quiz.Questions[tmpTbl[i]].text}
            if(math.random(100) < 50) then --randomize answer options
                questionInfo.left = Quiz.Questions[tmpTbl[i]].answers.good
                questionInfo.goodAnswerTileId = Quiz.LeftAnswer
                questionInfo.right = Quiz.Questions[tmpTbl[i]].answers.bad
            else
                questionInfo.right = Quiz.Questions[tmpTbl[i]].answers.good
                questionInfo.goodAnswerTileId = Quiz.RightAnswer
                questionInfo.left = Quiz.Questions[tmpTbl[i]].answers.bad
            end

            table.insert(Quiz.Storage.Questions, questionInfo)
        end
        return true
    end

    function Quiz.InitAnswerTiles()

        if(Quiz.InitLeftAnswer() and Quiz.InitRightAnswer()) then
            if(Quiz.FillRandomQuestions()) then
                Quiz.Storage.currentQuestion = 1
                addEvent(Quiz.QuestionEvent, 5000,25)
            end
        end
    end

    function Quiz.sideEffect(side)
        if(side == 'left') then
            local leftAnswerTiles = Quiz.mapConfig.gameRoom.leftAnswer
            for x = leftAnswerTiles['top_left_corner'].x, leftAnswerTiles['bot_right_corner'].x do
                for y = leftAnswerTiles['top_left_corner'].y, leftAnswerTiles['bot_right_corner'].y do
                    local position = {x=x,y=y,z=leftAnswerTiles['top_left_corner'].z}
                    Position(position):sendMagicEffect(7)
                end
            end
        elseif(side == 'right') then
            local rightAnswerTiles = Quiz.mapConfig.gameRoom.rightAnswer
            for x = rightAnswerTiles['top_left_corner'].x, rightAnswerTiles['bot_right_corner'].x do
                for y = rightAnswerTiles['top_left_corner'].y, rightAnswerTiles['bot_right_corner'].y do
                    local position = {x=x,y=y,z=rightAnswerTiles['top_left_corner'].z}
                    Position(position):sendMagicEffect(7)
                end
            end
        end
    end

    function Quiz.InitLeftAnswer()
        local leftAnswerTiles = Quiz.mapConfig.gameRoom.leftAnswer
        for x = leftAnswerTiles['top_left_corner'].x, leftAnswerTiles['bot_right_corner'].x do
            for y = leftAnswerTiles['top_left_corner'].y, leftAnswerTiles['bot_right_corner'].y do
                local position = {x=x,y=y,z=leftAnswerTiles['top_left_corner'].z}
                local t = Tile(position)
                if t ~= nil then
                    local tileItem = t:getThing();
                    tileItem:setActionId(leftAnswerTiles['tile_action_id'])
                end
            end
        end
        return true
    end

    function Quiz.InitRightAnswer()
        local rightAnswerTiles = Quiz.mapConfig.gameRoom.rightAnswer
        for x = rightAnswerTiles['top_left_corner'].x, rightAnswerTiles['bot_right_corner'].x do
            for y = rightAnswerTiles['top_left_corner'].y, rightAnswerTiles['bot_right_corner'].y do
                local position = {x=x,y=y,z=rightAnswerTiles['top_left_corner'].z}
                local t = Tile(position)
                if t ~= nil then
                    local tileItem = t:getThing();
                    tileItem:setActionId(rightAnswerTiles['tile_action_id'])
                end
            end
        end
        return true
    end

    function Quiz.teleportPlayerToGame(player)
        local tryPos = player:getClosestFreePosition(Quiz.mapConfig.gameRoom['center'], true)
        if(tryPos) then
            if(tryPos.x >= Quiz.mapConfig.gameRoom.teleportAble['top_left_corner'].x and tryPos.x <= Quiz.mapConfig.gameRoom.teleportAble['bot_right_corner'].x) then
                if(tryPos.y >= Quiz.mapConfig.gameRoom.teleportAble['top_left_corner'].y and tryPos.y <= Quiz.mapConfig.gameRoom.teleportAble['bot_right_corner'].y) then
                    player:teleportTo(tryPos)
                    return true
                end
            end
        end
        

        player:sendTextMessage(MESSAGE_INFO_DESCR, "Sorry, not enough place for you. Try next time.")
        Quiz.kickPlayer(player)
        return false
    end

    function Quiz.WaitingRoomEvent()
        if(Quiz.Storage.waitingRoomEnabled) then           
            if(Quiz.Storage.subscribeTime <= 0) then
                Quiz.disableWaitingRoom()   
                local canStart = false
                if(#Quiz.Storage.players >= Quiz.minPlayersToStart) then
                    canStart = true
                end
                for i = 1, #Quiz.Storage.players do
                    local player = Player(Quiz.Storage.players[i])
                    if(player) then
                        if(canStart) then
                            Quiz.teleportPlayerToGame(player)
                            player:sendTextMessage(MESSAGE_INFO_DESCR, "Welcome on Quiz Event! Wait for first question.")
                        else
                            player:sendTextMessage(MESSAGE_INFO_DESCR, "Not enough players to start event. Event Canceled.")
                        end                       
                    end
                end 
                Quiz.InitAnswerTiles()     
            else
                if(Quiz.Storage.messageDelayTime <= 0) then
                    broadcastMessage("Quiz waiting room is open! Subscribe to event! Trade island Depo Tp. Players subscribed: "..#Quiz.Storage.players, MESSAGE_STATUS_WARNING) 
                    Quiz.Storage.messageDelayTime = Quiz.messageDelayTime --reset timer
                else
                    Quiz.Storage.messageDelayTime = Quiz.Storage.messageDelayTime - 1000
                end
            end

            Quiz.Storage.subscribeTime = Quiz.Storage.subscribeTime - 1000
            Quiz.Storage.WaitingRoomEvent = addEvent(Quiz.WaitingRoomEvent, 1000)
        end
    end


    --main func
    function Quiz.open()
        Quiz.resetTimers()
        Quiz.enableWaitingRoom()
        Quiz.WaitingRoomEvent()
        Quiz.Storage.eventEnabled = true
    end

    function Quiz.resetTimers()
        Quiz.Storage.subscribeTime = Quiz.subscribeTime
        Quiz.Storage.messageDelayTime = Quiz.messageDelayTime
    end

    local quizTalkaction = TalkAction("/quiz")
    function quizTalkaction.onSay(player, words, param)
        if(player:getGroup():getAccess()) then
            if(param == "start") then
                if(not Quiz.Storage.eventEnabled) then
                    Quiz.open()
                    player:sendTextMessage(MESSAGE_INFO_DESCR, "You started quiz event")
                    return true
                else
                    player:sendTextMessage(MESSAGE_INFO_DESCR, "Quiz event started already")
                    return true
                end
            else
                player:sendTextMessage(MESSAGE_INFO_DESCR, "Wrong param.")
                return true
            end
        end
    end
    quizTalkaction:separator(" ")
    quizTalkaction:register()

    function Quiz.disableWaitingRoom()       
        local wRoom = Quiz.mapConfig.waitingRoom
        for x = wRoom['top_left_corner'].x, wRoom['bot_right_corner'].x do
            for y = wRoom['top_left_corner'].y, wRoom['bot_right_corner'].y do
                local position = {x=x,y=y,z=wRoom['top_left_corner'].z}
                local t = Tile(position)
                if t ~= nil then
                    local tileItem = t:getThing();
                    if(tileItem:getActionId() == Quiz.mapConfig.waitingRoom['tile_action_id']) then
                        tileItem:removeAttribute('aid')
                    end
                end
            end
        end
        Quiz.Storage.waitingRoomEnabled = false
        broadcastMessage("Quiz waiting room is now closed!", MESSAGE_STATUS_WARNING) 
    end

    function Quiz.enableWaitingRoom()
        local wRoom = Quiz.mapConfig.waitingRoom
        for x = wRoom['top_left_corner'].x, wRoom['bot_right_corner'].x do
            for y = wRoom['top_left_corner'].y, wRoom['bot_right_corner'].y do
                local position = {x=x,y=y,z=wRoom['top_left_corner'].z}
                local t = Tile(position)
                if t ~= nil then
                    local tileItem = t:getThing();
                    tileItem:setActionId(wRoom['tile_action_id'])
                end
            end
        end
        broadcastMessage("Quiz waiting room is now open!", MESSAGE_STATUS_WARNING) 
        Quiz.Storage.waitingRoomEnabled = true       
    end

    local waitingRoomStepIn = MoveEvent()   
    function waitingRoomStepIn.onStepIn(creature, item, position, fromPosition)
        if(not creature:isPlayer()) then
            return false
        end

        local fromPosItem = Tile(fromPosition)
        if(fromPosItem ~= nil) then
            fromPosItem = fromPosItem:getThing()
            if(fromPosItem:getActionId() == Quiz.mapConfig.waitingRoom['tile_action_id']) then
                return true
            end
        end
        local playerId = creature:getId()
        if(not table.contains(Quiz.Storage.players, playerId)) then
            table.insert(Quiz.Storage.players, playerId)
            creature:sendTextMessage(MESSAGE_INFO_DESCR, "You subscribed to Quiz event. Players on event: "..#Quiz.Storage.players..".")           
        end
        return true
    end   
    waitingRoomStepIn:aid(Quiz.mapConfig.waitingRoom['tile_action_id'])
    waitingRoomStepIn:register()

    local waitingRoomStepOut = MoveEvent()
    function waitingRoomStepIn.onStepOut(creature, item, position, fromPosition)
        if(not creature:isPlayer()) then
            return false
        end

        local currentPosTile = Tile(creature:getPosition())
        if(currentPosTile ~= nil) then
            currentPosTile = currentPosTile:getThing()
            if(currentPosTile:getActionId() ~= Quiz.mapConfig.waitingRoom['tile_action_id']) then
                local playerId = creature:getId()
                if(table.contains(Quiz.Storage.players, playerId)) then
                    for i = 1, #Quiz.Storage.players do
                        if(Quiz.Storage.players[i] == playerId) then
                            table.remove(Quiz.Storage.players, i)
                            creature:sendTextMessage(MESSAGE_INFO_DESCR, "You unsubscribed from Quiz event. Players on event: "..#Quiz.Storage.players..".")
                            break
                        end
                    end
                end
                return true
            end
        end
    end
    waitingRoomStepOut:aid(Quiz.mapConfig.waitingRoom['tile_action_id'])
    waitingRoomStepOut:register()
end