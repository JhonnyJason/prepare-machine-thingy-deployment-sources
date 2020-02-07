deploymenthandlermodule = {name: "deploymenthandlermodule"}
############################################################
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["deploymenthandlermodule"]?  then console.log "[deploymenthandlermodule]: " + arg
    return

############################################################
#region modulesFromEnvironment
CLI         = require('clui')
Spinner     = CLI.Spinner

############################################################
keyModule = null
cloud = null
cfg = null
#endregion

############################################################
allDeployments = []

############################################################
deploymenthandlermodule.initialize = () ->
    log "deploymenthandlermodule.initialize"
    keyModule = allModules.keymodule
    cloud = allModules.cloudservicemodule
    cfg = allModules.configmodule
    return

############################################################
#region classes
class deploymentEntry
    constructor: (@repo) ->
        return
    
    establishKeyPairs: ->
        pair = await keyModule.getKeyPairForRepo(@repo)
        @pub = pair.pub
        @priv = pair.priv

    ############################################################
    addKey: ->
        log "addKey on " + @repo
        if !@pub or !@priv then await @establishKeyPairs()
        try await cloud.addDeployKey(@repo, @pub, cfg.name)
        catch err
            log "error on cloud creating deploy key! " + @repo
            ##TODO figure out when the error was 404
        return

    removeKey: ->
        log "removeKey on " + @repo
        keyModule.removeKeyPairForRepo(@repo)
        try await cloud.removeDeployKey(@repo, cfg.name)
        catch err 
            log "error on cloud removing deploy key! " + @repo
            log err
            ##TODO figure out when the error was 404
        return

    addWebhook: ->
        log "addWebhook on " + @repo
        try await cloud.addWebhook(@repo, cfg.webhookURL, cfg.webhookSecret)
        catch err 
            log "error on cloud creating webhook! " + @repo
            ##TODO figure out when the error was 404
        return

    removeWebhook: ->
        log "removeWebhook on " + @repo
        try await cloud.removeWebhook(@repo, cfg.webhookURL)
        catch err 
            log "error on cloud removing webhook! " + @repo
            log err
            ##TODO figure out when the error was 404
        return
#endregion

############################################################
#region exposedFunctions
deploymenthandlermodule.addDeploymentFor = (repo) ->
    # log "deploymenthandlermodule.addDeploymentFor"
    deployment = new deploymentEntry(repo)
    allDeployments.push(deployment)

############################################################
deploymenthandlermodule.prepareMissingDeployments = ->
    log "deploymenthandlermodule.prepareMissingDeployments"
    promises = []
    for deployment in allDeployments
        promises.push deployment.addKey()
        promises.push deployment.addWebhook()
    status = new Spinner('Adding missing webhooks and keys...');
    try 
        status.start()
        await Promise.all(promises)
    finally status.stop()

deploymenthandlermodule.removeDeployments = ->
    log "deploymenthandlermodule.removeDeployments"
    promises = []
    for deployment in allDeployments
        promises.push deployment.removeKey()
        promises.push deployment.removeWebhook()
    status = new Spinner('Removing webhooks and keys...');
    try 
        status.start()
        await Promise.all(promises)
    finally status.stop()

deploymenthandlermodule.refreshDeployments = ->
    log "deploymenthandlermodule.refreshDeployments"
    await deploymenthandlermodule.removeDeployments()
    await deploymenthandlermodule.prepareMissingDeployments()
#endregion exposed functions

module.exports = deploymenthandlermodule

