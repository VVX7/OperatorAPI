#[
    Author: Roger Johnston, Twitter: @VV_X_7
    License: Apache License 2.0
]#

import asyncdispatch, jsony
import ../objects
import requests, tables

proc getAttacks*(api: RestApi): Future[seq[Attack]] {.async.} =
    ## Returns a sequence of Attack objects.
    ## 
    var p: seq[Attack]
    let r = (await api.request("GET", "/attack")).fromJson(Table[string, Attack])
    for k, v  in r.pairs:
        p.add(v)
    result = p

proc getAttack*(api: RestApi, attackID: string): Future[Attack] {.async.} =
    ## Retrieves an Attack by "id".
    ## 
    result = (await api.request("GET", "/attack/" & attackID)).newAttack

proc createAttack*(api: RestApi, data: Attack): Future[string] {.async.} =
    ## Creates a new Attack given an Attack object.
    ## 
    result = await api.request("POST", "/attack", data.toJson())

proc updateAttack*(api: RestApi,  attackID: string, data: Attack): Future[string] {.async.} =
    ## Updates an Attack by "id".
    ## 
    result = await api.request("PUT", "/attack/" & attackID, data.toJson())

proc deleteAttack*(api: RestApi, attackID: string): Future[string] {.async.} =
    ## Deletes an Attack by "id".
    ## 
    result = await api.request("DELETE", "/attack/" & attackID)

proc importAttackFile*(api: RestApi, path: string): Future[string] {.async.} =
    ## Imports an Attack file.
    ## 
    var data: Table[string, string]
    data["path"] = path
    result = await api.request("POST", "/attack/import/file", data.toJson())

proc importAttackFileDir*(api: RestApi, path: string): Future[string] {.async.} =
    ## Imports a directory of Attack files.
    ## 
    var data: Table[string, string]
    data["path"] = path
    result = await api.request("POST", "/attack/import/directory", data.toJson())

proc importAttackRepo*(api: RestApi, path: string): Future[string] {.async.} =
    ## Imports a git repo of Attack files.
    ## 
    var data: Table[string, string]
    data["path"] = path
    result = await api.request("POST", "/attack/import/repo", data.toJson())
