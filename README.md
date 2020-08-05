![logo](https://raw.githubusercontent.com/OptimisticSide/Axon/master/assets/logo.png)
<div align="center">The framework for you.</div>


## About
Axon is a lightweight, flexible framework intended to accelerate development on the ROBLOX platform. With full support for both functional and object-oriented programming paradigms, you have full control on how you shape your game. 

## Layout
Axon follows a very simple (yet flexible) layout. There are two main folders. These are `ServerModules`, and `SharedModules`. The ServerModules folder is to be kept in `ServerStorage`, and used to store server-sided modules. The SharedMdoules folder is to be kept in `ReplicatedStorage`, and used to store shared modules. In each of these folders, are folders which wil act as categories. The names do not matter, as they are only for organization of the modules. In each of the categories, are the modules. A module is simply a `ModuleScript`, that can be required by another script in order to utilize it's contents.
## Using modules
It's very easy to use Axon. Simply require the module from the `ReplicatedStorage` service, as such:
```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Axon = require(ReplicatedStorage.Axon)
```
Once this is done, the module offers a variety of functions, but these are mostly used internally. The module can also ba called as a function, which serves it's main purpose of retrieving the desired module. Note that the `getModule` function offers the same purpose.
```lua
local Signal = Axon("Signal")
```
This also allows for children of an instance to be refrenced using the `/` operator.
```lua
local SignalConnection = Axon("Signal/Connection")
```
On newer version of Axon, this allows you to require any module you pass as a parameter, whether that be a table or tuple. It depends on your style.
```lua
local Signal, SignalConnection = Axon("Signal", "Signal/Connection")

local Roact, Rodux = Axon {
	"Roact",
	"Rodux"
}
```
You can also use Axon as your primary require function, as it can handle instances being passed as parameters (as well as asset-IDs).
```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local require = require(ReplicatedStorage.Axon)

local Signal = require("Signal")
local Child = require(script.Child)
```
As you can see, this really cleans up your code, and can be *extrimely* helpful when trying to utilize several modules.
## Creating modules
Creating modules is a very simple process.  Simply follow the layout (above) a `ModuleScript`. This will be our module. It's name will be what it will be refered to as. A basic module format should be as follows
```lua
local Module = {}

return Module
```
`Module` can be replaced by our module's name, and elements can be added to this table.
### Example
Here is an example module I made for printing things.
```lua
-- Debugger module
local Debugger = {}

function Debugger.print(...)
	print(table.concat({...}, " - "))
end

return Debugger
```
```lua
-- Server script
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local require = require(ReplicatedStorage.Axon)

local Debugger = require("Debugger")

Debugger.log("Server", "Hello world!") -- Output: Server - Hello world!
```
## Imports
On newer versions of Axon, you are allowed to make Python-like import statements. These will not require you to declare any sort of variables. This, of-course, does not have to be called `import` necessarily, as you can still call it whatever you want (just as before).
Note that this requires the `INJECT_ENVIRONMENT` constant in the main script to be set to `true`.
```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local import = require(ReplicatedStorage.import)

import("Roact")

local e = Roact.createElement
```
