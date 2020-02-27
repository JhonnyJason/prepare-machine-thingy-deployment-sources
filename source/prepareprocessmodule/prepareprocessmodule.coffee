prepareprocessmodule = {name: "prepareprocessmodule"}
############################################################
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["prepareprocessmodule"]?  then console.log "[prepareprocessmodule]: " + arg
    return

############################################################
#region modulesFromEnvironment
############################################################
fs = require "fs"

############################################################
#region localModules
cfg = null
github = null
deploymentHandler = null
pathHandler = null
#endregion
#endregion

############################################################
prepareprocessmodule.initialize = () ->
    log "prepareprocessmodule.initialize"
    cfg = allModules.configmodule
    github = allModules.githubhandlermodule
    deploymentHandler = allModules.deploymenthandlermodule
    pathHandler = allModules.pathhandlermodule
    return

############################################################
#region internalFunctions
digestConfigFile = () ->
    log "digestRepoListFile"
    requirePath = pathHandler.getConfigRequirePath() 
    config = require(requirePath)

    cfg.serverName = config.serverName
    cfg.name = config.name
    cfg.webhookSecret = config.webhookSecret
    cfg.webhookPort = config.webhookPort
    cfg.generateURL()
    
    for thingy in config.thingies
        deploymentHandler.addDeploymentFor(thingy.repository)

#endregion

############################################################
#region exposedFunctions
prepareprocessmodule.execute = (keysDirectory, configPath, mode) ->
    log "prepareprocessmodule.execute"
    await cfg.checkUserConfig()
    await pathHandler.setKeysDirectory(keysDirectory)
    await pathHandler.setConfigFilePath(configPath)
    await digestConfigFile()
    
    switch mode
        when "prepare" then await deploymentHandler.prepareMissingDeployments()
        when "refresh" then await deploymentHandler.refreshDeployments()
        when "remove" then await deploymentHandler.removeDeployments()
    
    return
#endregion

module.exports = prepareprocessmodule
