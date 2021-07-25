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

# Get operations
let operations = waitFor client.api.getOperations()
echo operations.toJson()

# Get operation links
let operationsLinks = waitFor client.api.getOperationLinks()
echo operationsLinks.toJson()
