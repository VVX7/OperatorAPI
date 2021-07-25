#[
    Author: Roger Johnston, Twitter: @VV_X_7
    License: Apache License 2.0
]#
import ../operatorapi, asyncdispatch, jsony
import os, typetraits

let token = getEnv("operator_token")

let client = newOperatorClient(
    token = token
)

# Get internal settings
let settings = waitFor client.api.getInternalSettings()
echo settings.local.udpPort

# Update internal settings
var updatedSettings = waitFor client.api.getInternalSettings()
updatedSettings.local.udpPort = 5454

let updateResponse = waitFor client.api.updateInternalSettings(updatedSettings)
echo updateResponse

updatedSettings = waitFor client.api.getInternalSettings()
echo updatedSettings.local.udpPort

# Get redirectors
let redirectors = waitFor client.api.getInternalGlobalRedirectors()
echo redirectors.toJson()

# Get facts
let facts = waitFor client.api.getInternalGlobalFacts()
echo facts.toJson()
