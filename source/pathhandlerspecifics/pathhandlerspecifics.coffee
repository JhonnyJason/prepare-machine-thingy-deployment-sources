pathhandlerspecifics = {}
############################################################
print = (arg) -> console.log(arg)

### FYI:
This module is to be injected into the pathhandlermodule
At best keep it most minimal to the specifics of this cli
We may use everything off the pathhandlermodule using @
as @ = this. and this will be the pathhandlermodule
###

pathModule = require "path"

############################################################
pathhandlerspecifics.keysDirectory = ""
pathhandlerspecifics.configPath = ""

############################################################
pathhandlerspecifics.setKeysDirectory = (keysDir) ->
    if !keysDir then throw new Error("No keysDir to set!")
    if pathModule.isAbsolute(keysDir) then @keysDirectory = keysDir
    else @keysDirectory = pathModule.resolve(process.cwd(), keysDir)
    exists = await @directoryExists(@keysDirectory)
    if !exists
        throw new Error("Provided directory " + keysDir + " does not exist!")
    return

pathhandlerspecifics.setConfigFilePath = (configPath) ->
    if !configPath then throw new Error("No configPath to set!")
    if pathModule.isAbsolute(configPath)
        @configPath = configPath
        return
    @configPath = pathModule.resolve(process.cwd(), configPath)
    return

############################################################
#region getterFunctions
pathhandlerspecifics.getConfigRequirePath = -> @configPath

pathhandlerspecifics.getPrivKeyPath = (repoName) ->
    return pathModule.resolve(@keysDirectory, repoName)

pathhandlerspecifics.getPubKeyPath = (repoName) ->
    return pathModule.resolve(@keysDirectory, repoName + ".pub")
#endregion
module.exports = pathhandlerspecifics