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

# Get order of internal state machine planner
let tactics = waitFor client.api.getTactics()
echo tactics.toJson()

# Update order of internal state machine planner
var n = @[
    "resource-development",
    "defense-evasion",
    "command-and-control",
    "discovery",
    "collection",
    "persistence",
    "credential-access",
    "privilege-escalation",
    "lateral-movement",
    "execution",
    "exfiltration",
    "impact"
]

let response = waitFor client.api.updateTactics(n)
echo response