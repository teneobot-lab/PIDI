-- PIDI Loader
-- Entry point: https://github.com/teneobot-lab/PIDI
-- Keep this file small; project logic belongs in src/main.lua.

local SOURCE_URL = "https://raw.githubusercontent.com/teneobot-lab/PIDI/main/src/main.lua"

local function report(message)
    warn("[PIDI] " .. tostring(message))
end

if type(loadstring) ~= "function" then
    report("loadstring is unavailable in this environment.")
    return
end

local requestOk, source = pcall(function()
    return game:HttpGet(SOURCE_URL)
end)

if not requestOk or type(source) ~= "string" or source == "" then
    report("Could not download src/main.lua.")
    return
end

local compileOk, chunk = pcall(loadstring, source)
if not compileOk or type(chunk) ~= "function" then
    report("Failed to compile the downloaded entry point: " .. tostring(chunk))
    return
end

local runOk, runError = pcall(chunk)
if not runOk then
    report("Entry point stopped with an error: " .. tostring(runError))
    return
end

print("[PIDI] Loader finished.")
