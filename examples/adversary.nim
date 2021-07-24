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

# List of Adversary by name
let adversaries = waitFor client.api.getAdversaries()
for adversary in adversaries:
    echo adversary.name
    echo adversary.toJson()

# Get a single Adversary by ID
let adversary = waitFor client.api.getAdversary("2c5f1313-03f3-468a-ae2c-08dcfb355da8")
for ttp in adversary.ttps:
    echo ttp
    

# Create a new Adversary
var newAdversary = Adversary(
    id: "5a1af2c9-8b39-48c6-bc5f-a87653b0cb2c",
    name: "File Hunter 2",
    ttps: @[
        "90c2efaa-8205-480d-8bb6-61d90dbaf81b",
        "6469befa-748a-4b9c-a96d-f191fde47d89",
        "4e97e699-93d7-4040-b5a3-2e906a58199e",
        "300157e5-f4ad-4569-b533-9d1fa0e74d74"
    ]
)

# Add it to Operator
let newAdversaryResponse = waitFor client.api.createAdversary(newAdversary)
echo newAdversaryResponse

# Delete the Adversary from Operator
let deleteAdversaryResponse = client.api.deleteAdversary("5a1af2c9-8b39-48c6-bc5f-a87653b0cb2c", Adversary)
echo deleteAdversaryResponse