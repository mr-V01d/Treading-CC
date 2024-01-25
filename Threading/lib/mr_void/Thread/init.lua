local Threading = {}

local threadsPool = {}
local corunning = 0
local pFilters = {}

-- A Thread is an object that instantiates and manages coroutines, serving as a means of communication with the corresponding coroutine --

local Thread = {}

--[[
    A Thread consturctor.
    The reason why this consturctor is so weird,
    it's because i wanted to make thread object
    working only for 1 "thread".
    So to stop/pause etc. thread, you need a "pointer"/"reference"
]]--

function Thread.new(func)
    if type(func) ~= "function" and type(func) ~= "table" then
        error("bad argument #1 (function or table expected, got " .. type(fn) .. ")", 2)
    end
    local id = _threadAdd(func)
    o = setmetatable({}, {__index = function ( table, index )
        if(index == "paused") then
            return (pFilters[id] ~= nil)
        elseif(index == "id") then
            return id
        end
    end
    })
    self = o
    function o:stop()
        threadsPool[id] = nil
        corunning = corunning - 1
    end
    function o:pause()
        pFilters[threadsPool[id]] = true
    end
    function Thread:resume()
        pFilters[threadsPool[id]] = nil
    end
    return o
end

-- Thread --




-- _threadAdd helping function for adding coroutines to pool, don't mind
function _threadAdd(func)
    local co = coroutine.create( func )
    table.insert(threadsPool, co)
    corunning = corunning + 1
    return #threadsPool
end

-- Threading --
function Threading.add(func)
    local thread = Thread.new(func)
    return thread
end



function Threading.start()
    local tFilters = {}
    local eventData = { n = 0 }

    while corunning > 0 do
        for n, r in pairs(threadsPool) do
            if pFilters[r] == nil or tFilters[r] == nil or tFilters[r] == eventData[1] or eventData[1] == "terminate" then
                local ok, param = coroutine.resume(r, table.unpack(eventData, 1, eventData.n))
                if not ok then
                    error(param, 0)
                elseif param == timer then
                    tFilters[r] = param
                end                
                if coroutine.status(r) == "dead" then
                    threadsPool[n] = nil
                    corunning = corunning - 1
                    if corunning <= 0 then
                        return 
                    end
                end
            end
        end
        for n, r in pairs(threadsPool) do
            if coroutine.status(r) == "dead" then
                threadsPool[n] = nil
                corunning = corunning - 1
                if corunning <= 0 then
                    return 
                end
            end
        end
        eventData = table.pack(os.pullEventRaw())
    end
end

return Threading