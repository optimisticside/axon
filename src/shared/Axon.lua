-- OptimisticSide
-- Axon.lua
-- 7/29/2020

-- | Variables |

-- Constants
local SERVICE_DRIVEN = false -- Whether or not you prefer to call your modules "Services" and store them in different folders
local BLOCK_REQUIRE = false -- Whether or not modules will NOT be required
local PROTECT_REQUIRES = true -- Whether or not modules will be required in a protected call (AKA pcall)

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local RunService = game:GetService("RunService")

local pcall = pcall

-- Module
local Axon = {}
Axon.directories = {
    shared = "SharedModules";
    server = "ServerModules";
}

-- | Functions |

--[[
    findModule(folder: Instance, name: string) -> module: Instance
    Searches a folder for a module by it's given path or name
]]
function Axon.findModule(folder, name)
    local path = string.split(name, "/")

    for _, category in ipairs(folder:GetChildren()) do
        local pathObject = category:FindFirstChild(path[1])
        if pathObject then
            for _, pathElement in ipairs({select(2, unpack(path))}) do
                pathObject = pathObject:WaitForChild(pathElement)
            end

            return pathObject
        end
    end
end

--[[
    requireModule(moduleScript: Instance) -> result: any
    Requires a ModuleScript and sets up core methods
]]
function Axon.requireModule(moduleScript)
    local success, result = pcall(require, moduleScript)
    if not success then
        warn(("Axon - Unable to load %s: %s"):format(moduleScript.Name, result))
        return {}
    end
    return result
end

--[[
    setupModule(module: any) -> module: any
    Sets up the module with core indexes, and initiates it
]]
function Axon.setupModule(module)
    if typeof(module) == "table" then
        module.__index = module
        module.__axon = true

        if module.__init then
            module.__init(module, Axon)
        end

        module = setmetatable({}, module)
    end

    return module
end

--[[
    getModule(moduleName: string) -> module: any
    Get's a module from a path
]]
function Axon.getModule(moduleName)
    local module

    if RunService:IsServer() then
        local serverModules = ServerStorage:WaitForChild(Axon.directories.server)
        local fromServer = Axon.findModule(serverModules, moduleName)

        if fromServer then
            module = fromServer
        end
    end

    if not module then
        local sharedModules = ReplicatedStorage:WaitForChild(Axon.directories.shared)
        local fromShared = Axon.findModule(sharedModules, moduleName)

        if fromShared then
            module = fromShared
        end
    end

    if module and not BLOCK_REQUIRE then
        module = Axon.setupModule(module)
    end

    return module
end

--[[
    init(void) -> void
    Initializes the module by implementing the constants
]]
function Axon.init()
    if SERVICE_DRIVEN then
        Axon.directories.shared = "SharedServices"
        Axon.directories.server = "ServerServices"
    end

    if not PROTECT_REQUIRES then
        pcall = function(func, ...)
            func(...)
        end
    end
end

--[[
    getService(parameters: tuple) -> module: any
    Provides support for a service-driven setup
]]
function Axon.getService(...)
    return Axon.getModule(...)
end

-- | Driver code |

Axon.init()

return setmetatable(Axon, {
    __call = function(_, moduleName)
        return Axon.getModule(moduleName)
    end;
})