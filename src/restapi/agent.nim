#[
    Author: Roger Johnston, Twitter: @VV_X_7
    License: Apache License 2.0
]#

import asyncdispatch, jsony
import ../objects
import requests, tables, strutils

proc getAgents*(api: RestApi, facts = true, links = true): Future[seq[Agent]] {.async.} =
    ## Returns a sequence of Agents.
    ## 
    var p: seq[Agent]
    var facts = if facts: "1" else: "0"
    var links = if links: "1" else: "0"
    let r = (await api.request("GET",
     "/agent?facts=" & facts & "&links=" & links)).fromJson(Table[string, Agent])
    for k, v  in r.pairs:
        p.add(v)
    result = p

proc getAgent*(api: RestApi, agentID: string, facts = true, links = true): Future[Agent] {.async.} =
    ## Returns an Agent object by name.
    ## 
    result = (await api.request("GET", 
      "/agent/" & agentID & "?facts=" & $(facts.int) & "&links=" & $(links.int))).fromJson(Agent)

proc taskAgent*(api: RestApi, agentID: string, task: Instruction): Future[string] {.async.} =
    ## Tasks an Instruction to the Agent by name.
    ## FIX ME
    result = await api.request("POST", "/agent/" & agentID, task.toJson())



