configmodule = {name: "configmodule"}

#region modulesFromEnvironment
pathModule = require "path"
os = require "os"

userConfigModule = null
#endregion

#region exposedProperties
configmodule.serverName = "default.server.tld"
configmodule.name = "defaultName"
configmodule.webhookSecret = "defaultSecret"
configmodule.webhookPort = "3000"
configmodule.webhookURL = ""

configmodule.cli =
    userRelativeConfigPath: ".config/thingyBubble/userConfig.json"
    userConfigPath: ""
#endregion

#region pre-init
#region getVersionAndName
packageJson = require "./package.json"
configmodule.cli.version = packageJson.version
configmodule.cli.name = packageJson.name
#endregion

homedir = os.homedir()

#region defineUserConfigPath§
userRelativeConfigPath = configmodule.cli.userRelativeConfigPath
userConfigPath = pathModule.resolve(homedir, userRelativeConfigPath)  
configmodule.cli.userConfigPath = userConfigPath
#endregion

configmodule.userConfig = null
try
    configmodule.userConfig = require(configmodule.cli.userConfigPath)
catch err
#endregion

#region printLogFunctions
##############################################################################
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["configmodule"]?  then console.log "[configmodule]: " + arg
    return
#endregion
##############################################################################
configmodule.initialize = () ->
    log "configmodule.initialize"
    userConfigModule = allModules.userconfigmodule
    return

#region exposedFunctions
configmodule.generateURL = () ->
    log "configmodule.genURL"
    configmodule.webhookURL = "https://" 
    configmodule.webhookURL += configmodule.serverName
    configmodule.webhookURL += ":"
    configmodule.webhookURL += configmodule.webhookPort
    configmodule.webhookURL += "/webhook"
    
configmodule.checkUserConfig = (configure) ->
    log "configmodule.checkUserConfig"
    if configmodule.userConfig then await userConfigModule.checkProcess(configure)
    else await userConfigModule.userConfigurationProcess()
    return
#endregion

module.exports = configmodule