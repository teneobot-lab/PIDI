-- PIDI Loader for the modular TOFHub package
-- 1) Download and extract TOFHub.zip from this repository into the executor workspace.
-- 2) Keep the extracted folder named "TOFHub".
-- 3) Run this loader.
--
-- The original TOFHub package expects readfile/loadstring support.
-- This launcher deliberately uses the original module loader so all dependencies
-- are resolved by TOFHub/main.lua in its declared BOOT order.

local MAIN_PATH = "TOFHub/main.lua"

if type(readfile) ~= "function" then
    warn("[PIDI] This executor does not provide readfile(). Extract the TOFHub folder and run TOFHub/main.lua directly.")
    return
end

local okRead, source = pcall(readfile, MAIN_PATH)
if not okRead or type(source) ~= "string" or source == "" then
    warn("[PIDI] Missing " .. MAIN_PATH .. ". Download and extract TOFHub.zip first.")
    return
end

if type(loadstring) ~= "function" then
    warn("[PIDI] loadstring() is unavailable in this environment.")
    return
end

local okCompile, chunk = pcall(loadstring, source, "@PIDI/TOFHub/main.lua")
if not okCompile or type(chunk) ~= "function" then
    warn("[PIDI] Could not compile main.lua: " .. tostring(chunk))
    return
end

local okRun, err = pcall(chunk)
if not okRun then
    warn("[PIDI] TOFHub startup failed: " .. tostring(err))
end
