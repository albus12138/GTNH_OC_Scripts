local os = require("os")
local filesystem = require("filesystem")
local keyboard = require("keyboard")
local component = require("component")
local modem = component.modem
local serialization = require("serialization")

PORT = 5000
TPS = {}

function time()
    f = io.open("/tmp/time", "w")
    f:write("time")
    f:close()
    return filesystem.lastModified("/tmp/time")
end

function start()
    data = {}
    data["type"] = "tps"
    while true do
        old_time = time()
        os.sleep(2)
        new_time = time()
        diff = new_time - old_time
        tps = 40000/diff
        print(string.format("%.02f", tps))
        data["tps"] = string.format("%.02f", tps)
        modem.broadcast(PORT, serialization.serialize(data))
        
        if keyboard.isKeyDown(keyboard.keys.w) and keyboard.isControlDown() then
            os.sleep(0.5)
            os.exit()
        end
    end
end
