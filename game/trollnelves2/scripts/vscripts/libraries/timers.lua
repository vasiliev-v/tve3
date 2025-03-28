TIMERS_VERSION = "1.03"

--[[

  -- A timer running every second that starts immediately on the next frame, respects pauses
  Timers:CreateTimer(function()
      print ("Hello. I'm running immediately and then every second thereafter.")
      return 1.0
    end
  )

  -- A timer which calls a function with a table context
  Timers:CreateTimer(trollnelves2.someFunction, trollnelves2)

  -- A timer running every second that starts 5 seconds in the future, respects pauses
  Timers:CreateTimer(5, function()
      print ("Hello. I'm running 5 seconds after you called me and then every second thereafter.")
      return 1.0
    end
  )

  -- 10 second delayed, run once using gametime (respect pauses)
  Timers:CreateTimer({
    endTime = 10, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
    callback = function()
      print ("Hello. I'm running 10 seconds after when I was started.")
    end
  })

  -- 10 second delayed, run once regardless of pauses
  Timers:CreateTimer({
    useGameTime = false,
    endTime = 10, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
    callback = function()
      print ("Hello. I'm running 10 seconds after I was started even if someone paused the game.")
    end
  })


  -- A timer running every second that starts after 2 minutes regardless of pauses
  Timers:CreateTimer("uniqueTimerString3", {
    useGameTime = false,
    endTime = 120,
    callback = function()
      print ("Hello. I'm running after 2 minutes and then every second thereafter.")
      return 1
    end
  })


  -- A timer using the old style to repeat every second starting 5 seconds ahead
  Timers:CreateTimer("uniqueTimerString3", {
    useOldStyle = true,
    endTime = GameRules:GetGameTime() + 5,
    callback = function()
      print ("Hello. I'm running after 5 seconds and then every second thereafter.")
      return GameRules:GetGameTime() + 1
    end
  })

]]

TIMERS_THINK = 0.03

if Timers == nil then
    print('[Timers] creating Timers')
    Timers = setmetatable({}, { __call = function(t, ...) return t:CreateTimer(...) end })
end

function Timers:start()
    self.timers = {}
    local ent = SpawnEntityFromTableSynchronous("info_target", { targetname = "timers_lua_thinker" })
    ent:SetThink("Think", self, "timers", TIMERS_THINK)
end

function Timers:Think()
    local now = GameRules:GetGameTime()

    for k, v in pairs(self.timers) do
        local currentTime = v.useGameTime == false and Time() or now
        if v.endTime == nil then v.endTime = currentTime end

        if currentTime >= v.endTime then
            self.timers[k] = nil  -- Удаление таймера перед вызовом функции
            local success, nextCall = xpcall(function() return v.callback(v.context or v) end, debug.traceback)

            if success and nextCall then
                v.endTime = currentTime + nextCall
                self.timers[k] = v
            elseif not success then
                self:HandleEventError('Timer', k, nextCall)
            end
        end
    end

    return next(self.timers) and TIMERS_THINK or nil  -- Остановка Think, если таймеров нет
end

function Timers:HandleEventError(name, event, err)
    print(("[Timers] Ошибка в %s (%s): %s"):format(tostring(name), tostring(event), tostring(err)))
    Error_debug.SendData({ Log = err, Srok = "" }, callback)
end

function Timers:CreateTimer(name, args, context)
    if type(name) == "function" then
        args, name, context = { callback = name }, DoUniqueString("timer"), args
    elseif type(name) == "table" then
        args, name = name, DoUniqueString("timer")
    elseif type(name) == "number" then
        args, name = { endTime = name, callback = args }, DoUniqueString("timer")
    end

    if not args.callback then
        return self:HandleEventError("Invalid Timer", name, "Callback is missing")
    end

    local now = args.useGameTime == false and Time() or GameRules:GetGameTime()
    args.endTime = args.endTime and (now + args.endTime) or now
    args.context = context

    self.timers[name] = args
    return name
end

function Timers:RemoveTimer(name)
    self.timers[name] = nil
end

function Timers:RemoveTimers(killAll)
    if killAll then
        self.timers = {}
    else
        for k, v in pairs(self.timers) do
            if not v.persist then
                self.timers[k] = nil
            end
        end
    end
end

if not Timers.timers then Timers:start() end
GameRules.Timers = Timers
