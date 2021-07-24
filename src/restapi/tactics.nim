#[
    Author: Roger Johnston, Twitter: @VV_X_7
    License: Apache License 2.0
]#

import asyncdispatch, jsony
import ../objects
import requests, tables, strutils

proc getTactics*(api: RestApi): Future[seq[Tactic]] {.async.} =
    ## Returns the internal state machine describing the order of the planner.
    ## 
    result = (await api.request("GET", "/tactics")).fromJson(seq[Tactic])

proc updateTactics*(api: RestApi, state: seq[string]): Future[string] {.async.} =
    ## Updates the internal state machine.
    ## 
    var p: Table[string, seq[string]]
    p["killchain"] = state
    result = await api.request("POST", "/tactics", p.toJson())
