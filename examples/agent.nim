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

# Get Agents including facts and links
let agents = waitFor client.api.getAgents()
for agent in agents:
    echo agent.toJson()

# # Get Agent by ID
let agent = waitFor client.api.getAgent("yOXtUvLcDyGl")
echo agent.toJson()

var stagingDir = "6469befa-748a-4b9c-a96d-f191fde47d89"
var operationID = "6784f7a1-b5df-420f-9dd2-ab659b74c278"
var adversaryID = "yOXtUvLcDyGl"

# Create a task
let task = Instruction(
    # use a new uuid for task id
    id: "555d27f5-a110-48f8-9864-6a54fa5da555",
    operation: operationID,
    ttp: stagingDir,
    executor: "sh"
)

# Task an agent
## FIX ME 
## see: https://github.com/preludeorg/operator-support/issues/290
let taskResponse = waitFor client.api.taskAgent("yOXtUvLcDyGl", task)
echo taskResponse

