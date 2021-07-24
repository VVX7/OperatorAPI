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
    echo agent.label

# Get Agent by ID
let agent = waitFor client.api.getAgent("yOXtUvLcDyGl")
echo agent.toJson()

# Task an agent with a TTP
# let task = Instruction(

# )
# let taskResponse = waitFor client.api.taskAgent("tTawjRJOwfHX", task)


