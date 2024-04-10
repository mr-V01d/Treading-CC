--[[
Thread library v 2.0(?)

Please report any bugs to github issue page, i'd really appreciate it

GPLv3 License
]]

---@class Thread Thread library, allows to born and kill pseudo asynchronous tasks
local app = {}

local threadPool = {}
local sFilters = {}
local curentThreadId = 0
---@type thread
local thread = {}

---Inner function-helper for creating thread objects
---@param id number
---@return thread
local function new_thread(id)
	local o = setmetatable({ attachedThreads = {} }, { __index = thread })

	function o:kill()
		threadPool[id] = nil
		for i, v in ipairs(self.attachedThreads) do
			v:kill()
		end
	end

	function o:suspend()
		sFilters[threadPool[id]] = true
		for i, v in ipairs(self.attachedThreads) do
			v:suspend()
		end
	end

	function o:resume()
		sFilters[threadPool[id]] = nil
		for i, v in ipairs(self.attachedThreads) do
			v:resume()
		end
	end

	function o.status()
		if threadPool[id] then
			if sFilters[id] then
				return "suspended"
			else
				return "running"
			end
		else
			return "dead"
		end
	end

	return o --[[@as thread]]
end

---Attach to a parent thread, a child thread
---@param thr any Child thread
function thread:attach(thr)
	table.insert(self.attachedThreads, thr)
	local i = #self.attachedThreads
	thr.detach = function(t)
		table.remove(self.attachedThreads, i)
		t.detach = thread.detach
		return true
	end
end

---Detach thread from parent thread
---@return boolean result
function thread.detach()
	return false
end

---Create new thread
---@param func function Function that will be executed in thread
---@return thread thread Thread object
function app.create(func)
	if type(func) ~= "function" then
		error("bad argument #1 function expected, got " .. type(func) .. ")", 2)
	end
	table.insert(threadPool, coroutine.create(func))
	local id = #threadPool
	return new_thread(id)
end

---Get object of current thread
---@return thread thread Current thread
function app.current()
	return thread.new(curentThreadId)
end

---Master thread, it should be called once, in the start of program/os
function app.start()
	local tFilters = {}
	local eventData = { n = 0 }

	while true do
		for n, r in pairs(threadPool) do
			curentThreadId = n
			if not sFilters[r] or not tFilters[r] and tFilters[r] == eventData[1] or eventData[1] == "terminate" then
				local ok, param = coroutine.resume(r, table.unpack(eventData, 1, eventData.n))
				if not ok then
					error(param, 0)
				elseif param == "timer" then
					tFilters[r] = param
				end
				if coroutine.status(r) == "dead" then
					threadPool[n] = nil
				end
			end
		end
		for n, r in pairs(threadPool) do
			if coroutine.status(r) == "dead" then
				threadPool[n] = nil
			end
		end
		eventData = table.pack(os.pullEvent())
	end
end

return app
