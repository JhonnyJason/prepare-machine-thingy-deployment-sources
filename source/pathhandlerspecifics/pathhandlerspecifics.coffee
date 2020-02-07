pathhandlerspecifics = {}
############################################################
print = (arg) -> console.log(arg)

############################################################
#region exposed
#region exposedProperties
pathhandlerspecifics.keysDirectory = "I'm here"
pathhandlerspecifics.configPath = "xD"
#endregion

pathhandlerspecifics.experiment = ->
    log "pathhandlerspecifics.experiment"
    print "this.name"
    print this.name
    print "this.homedir"
    print this.homedir
    print "pathhandlerspecifics.homedir"
    print pathhandlerspecifics.homedir
    print "this.keysDirectory"
    print this.keysDirectory
    print "pathhandlerspecifics.keysDirectory"
    print pathhandlerspecifics.keysDirectory
    return

#endregion
module.exports = pathhandlerspecifics