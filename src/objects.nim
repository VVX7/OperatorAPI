#[
    Author: Roger Johnston, Twitter: @VV_X_7
    License: Apache License 2.0
]#

import options, jsony, tables, strutils
include objects/typedefs

proc newOperatorClient*(token: string, port: string = "8888",
 url: string = "http://localhost"): OperatorClient =
    result = OperatorClient(
        api: RestApi(
            token: token,
            port: port,
            url: url
        )
    )

proc newGoal*(data: string): Goal =
    result = data.fromJson(Goal)
    
proc newAdversary*(data: string): Adversary =
    result = data.fromJson(Adversary)

proc newAgentHandler*(data: string): AgentHandler =
    result = data.fromJson(AgentHandler)

proc newAgent*(data: string): Agent =
    result = data.fromJson(Agent)

proc newAttack*(data: string): Attack =
    result = data.fromJson(Attack)

proc newSchedule*(data: string): Schedule =
    result = data.fromJson(Schedule)

proc newOperation*(data: string): Operation =
    result = data.fromJson(Operation)

proc newProgram*(data: string): Program =
    result = data.fromJson(Program)

proc newPlugin*(data: string): Plugin = 
    result = data.fromJson(Plugin)
