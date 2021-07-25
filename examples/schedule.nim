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

# Get schedules
let schedules = waitFor client.api.getSchedules()
echo schedules.toJson()

# Create a schedule
var schedule = Schedule(
    agentRange: "red",
    adversary: "dd93fc56-25bc-468e-ab73-b35c787569a8",
    dayOfWeek: "5",
    hour: "12",
    minute: "59",
    timeout: 10
)

# Add it to Operator
let response = waitFor client.api.createSchedule(schedule)
echo response

# Delete a schedule
let deleteResponse = waitFor client.api.deleteSchedule("no")
echo deleteResponse