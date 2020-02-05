startupmodule = {name: "startupmodule"}

#region modulesFromEnvironment
c = require "chalk"

prepareProcess = null
cliArguments = null
#endregion

#region logPrintFunctions
##############################################################################
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["startupmodule"]?  then console.log "[startupmodule]: " + arg
    return
#endregion
##############################################################################
startupmodule.initialize = () ->
    log "startupmodule.initialize"
    prepareProcess = allModules.prepareprocessmodule
    cliArguments = allModules.cliargumentsmodule
    return

#region exposedFunctions
startupmodule.cliStartup = ->
    log "startupmodule.cliStartup"
    try
        e = cliArguments.extractArguments()
        await prepareProcess.execute(e.keysDirectory, e.machineConfig, e.mode)
        console.log(c.green('All done!\n'));
    catch err
        console.log(c.red('Error!'));
        console.log(err)
        console.log("\n")
    return
#endregion

module.exports = startupmodule

