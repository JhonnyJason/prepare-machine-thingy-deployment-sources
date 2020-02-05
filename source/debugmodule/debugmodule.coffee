debugmodule = {name: "debugmodule"}

##############################################################################
debugmodule.initialize = () ->
    return
    console.log "debugmodule.initialize - nothing to do"

##############################################################################
debugmodule.modulesToDebug = 
    unbreaker: true
    # cliargumentsmodule: true
    # cloudservicemodule: true
    configmodule: true
    # deploymenthandlermodule: true
    # encryptionmodule: true
    # githubhandlermodule: true
    # globalscopemodule
    # keymodule: true
    # pathhandlermodule: true
    # prepareprocessmodule: true
    # startupmodule: true
    # useractionmodule: true
    userconfigmodule: true
    # userinquirermodule: true
    # utilmodule: true

module.exports = debugmodule