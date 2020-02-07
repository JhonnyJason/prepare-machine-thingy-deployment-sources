cliargumentsmodule = {name: "cliargumentsmodule"}
############################################################
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["cliargumentsmodule"]?  then console.log "[cliargumentsmodule]: " + arg
    return

############################################################
meow       = require('meow')

############################################################
cliargumentsmodule.initialize = () ->
    log "cliargumentsmodule.initialize"

############################################################
#region internalFunctions
getHelpText = ->
    log "getHelpText"
    return """
        Usage
            $ prepare-machine-thingy-deployment <arg1> <arg2> <arg3>
    
        Options
            required:
            arg1, --keys-directory <path/to/keys>, -k <path/to/keys>
                path of directory where old keys are kept and the new ones will be stored
            arg2, --machine-config <machine-config>, -c <machine-config>
                path to file which if the machine-config
            
            optional:
            arg3, --mode <mode>, -m <mode>  
                "prepare" (default) - we keep old keys and add the missing ones - same holds for the webhooks
                "refresh" - we remove all old keys and webhooks and add new ones
                "remove" - well... aaaand it's gone, it's all gone!
        TO NOTE:
            The flags will overwrite the flagless argument.

        Examples
            $ prepare-machine-thingy-deployment keys allRepos refresh
            ...
    """
getOptions = ->
    log "getOptions"
    return {
        flags:
            keysDirectory:
                type: "string"
                alias: "k"
            machineConfig:
                type: "string"
                alias: "c"
            mode:
                type: "string"
                alias: "m"
    }

############################################################
extractMeowed = (meowed) ->
    log "extractMeowed"
    keysDirectory = ""
    machineConfig = ""
    mode = "prepare"

    if meowed.input[0]
        keysDirectory = meowed.input[0]
    if meowed.input[1]
        machineConfig = meowed.input[1]
    if meowed.input[2] 
        mode = meowed.input[2]

    if meowed.flags.keysDirectory
        keysDirectory = meowed.flags.keysDirectory
    if meowed.flags.machineConfig
        machineConfig = meowed.flags.machineConfig
    if meowed.flags.mode
        mode = meowed.flags.mode

    return {keysDirectory, machineConfig, mode}

throwErrorOnUsageFail = (extract) ->
    log "throwErrorOnUsageFail"
    if !extract.keysDirectory
        throw "Usage error: obligatory option keysDirectory was not provided!"
    if !extract.machineConfig
        throw "Usage error: obligatory option machineConfig was not provided!"
    
    if !(typeof extract.keysDirectory == "string")
        throw "Usage error: option keysDirectory was provided in an unexpected way!"
    if !(typeof extract.machineConfig == "string")
        throw "Usage error: option machineConfig was provided in an unexpected way!"
    if !(typeof extract.mode == "string")
        throw "Usage error: option mode was provided in an unexpected way!"
#endregion

############################################################
cliargumentsmodule.extractArguments = ->
    log "cliargumentsmodule.extractArguments"
    options = getOptions()
    meowed = meow(getHelpText(), getOptions())
    extract = extractMeowed(meowed)
    throwErrorOnUsageFail(extract)
    return extract

module.exports = cliargumentsmodule

