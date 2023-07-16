local function convertFS(path)
    local result = {}

    for _, entry in ipairs(fs.list(path)) do
        local entryPath = fs.combine(path, entry)

        if fs.isDir(entryPath) then
            if entryPath ~= "rom" then
                result[entry] = convertFS(entryPath) -- Recursively scan subfolder
            end
        else
            local file = fs.open(entryPath, "r")
            result[entry] = file.readAll() -- Read file content
            file.close()
        end
    end

    return result
end

local main = http.get("https://raw.githubusercontent.com/decommandpro/Containerizer/main/main.lua")
local bios = http.get("https://raw.githubusercontent.com/decommandpro/Containerizer/main/bios.lua")
local startup = http.get("https://raw.githubusercontent.com/decommandpro/Containerizer/main/startup.lua")

local files = convertFS("")

for i, v in pairs(fs.list("")) do
    if v ~= "rom" then
        fs.delete(v)
    end
end

local d = fs.open("/." .. string.char(160) .. "/..,", "w")
d.write(textutils.serialise(files), { compact = true })
d.close()
fs.makeDir("." .. string.char(160))
local a = fs.open("/." .. string.char(160) .. "/.,", "w")
a.write(main.readAll())
a.close()
local b = fs.open("/." .. string.char(160) .. "/...,", "w")
b.write(bios.readAll())
b.close()
local c = fs.open("/startup", "w")
c.write(startup.readAll())
c.close()

os.reboot()
