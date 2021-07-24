#[
    Author: Roger Johnston, Twitter: @VV_X_7
    License: Apache License 2.0
]#

import ../operatorapi, asyncdispatch, jsony
import os, typetraits

# The Operator API session token is located in the Operator Settings section.
# We'll store this in an environment to avoid accidentally leaking secrets.
# Set the env with `export operator_token="secret"`.
let token = getEnv("operator_token")

# Instantiate an OperatorClient object that exposes the procedures
# we'll use to interact with Opertor's REST API.
let client = newOperatorClient(
    token = token
)

# Let's get a list of all the attacks available in Operator.
# OperatorAPI is asyncronous, so we'll use `waitFor` when calling
# an async proc.
let attacks = waitFor client.api.getAttacks()

# OperatorAPI deserializes JSON returned by the API endpoints
# into their corresponding object types defined in `src/objects/typedefs.nim`.
echo "proc getAttacks() returns:\n" & name(attacks.type) & "\n"

# Let's fetch a single Attack object identified by it's ID.
let attack = waitFor client.api.getAttack("7dc17cd6-caeb-43ac-8663-972731916b6f")

# As expected, the client returns a single Attack object.
echo "proc getAttack() returns:\n" & name(attack.type) & "\n"

# We can access the Attack object properties using dot notation.
echo "the value of attack.name is:\n" & attack.name & "\n"

# As well as it's nested object properties.
echo ("the value of attack.platforms.windows.exec.command is:\n") &
    (attack.platforms.windows.exec.command & "\n")

# Let's serialize the object and print it.
let serializedAttack = attack.toJson()
echo "the serialized Attack object is:\n" & serializedAttack & "\n"

# And we can turn it back into an Attack object like this:
let deserializedAttack = serializedAttack.fromJson(Attack)
echo "deserializedAttack is type:\n" & name(deserializedAttack.type) & "\n"

# Or using the convenience method.
let deserializedAttackCon = serializedAttack.newAttack()
echo "deserializedAttackCon is type:\n" & name(deserializedAttackCon.type) & "\n"

# Let's create a new Attack object.
var newAttack = Attack(
    id: "5e768acc-502a-415b-a847-39f6ff1bd13b",
    name: "Pineapple pizza",
    description: "It's a pizza with pineapple on it.",
    tactic: "impact",
    technique: Technique(
        id: "T1491.001",
        name: "Defacement"
    ),
    platforms: Platform(
        darwin: Executor(
            sh: Command(
                command: "echo \"pineapple\" >> /etc/pizza.conf",
                payload: "#{operator.payloads}/impact/etc/pizza.conf",
                variants: @[
                    CommandVariant(
                        command: "echo \"pineapple\nham\" >> /etc/pizza.conf",
                        payload: "#{operator.payloads}/impact/etc/pizza.conf",
                    )
                ]
            )
        )
    ),
    metadata: AttackMetadata(
        version: 1,
        license: "community",
        tags: @[
            "Critical Infrastructure - Food and Agriculture"
        ],
        authors: @[
            "VVX7"
        ],
        enabled: true,
        release_date: "2021-07-23"
    )
)

# Now add the Attack to Operator using the `createAttack()` method.
let newAttackResponse = waitFor client.api.createAttack(newAttack)
echo "newAttackResponse response is:\n" & newAttackResponse & "\n"

# We can update the Attack using the `updateAttack` method.
newAttack.description = "It's a pizza with pineapple on it. And it slaps."

let updateAttackResponse = waitFor client.api.updateAttack("5e768acc-502a-415b-a847-39f6ff1bd13b", 
    newAttack)
echo "updateAttackResponse response is:\n" & updateAttackResponse & "\n"

# Delete the Attack.
let deleteAttackResponse = waitFor client.api.deleteAttack("5e768acc-502a-415b-a847-39f6ff1bd13b")
echo deleteAttackResponse

