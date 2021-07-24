#[
    Author: Roger Johnston, Twitter: @VV_X_7
    License: Apache License 2.0
]#

import asyncdispatch, jsony
import ../objects
import requests, tables, strutils

proc getAdversaries*(api: RestApi): Future[seq[Adversary]] {.async.} =
    ## Returns a sequence of Adversary objects.
    ## 
    var p: seq[Adversary]
    let r = (await api.request("GET", "/adversary")).fromJson(Table[string, Adversary])
    for k, v  in r.pairs:
        p.add(v)
    result = p

proc getAdversary*(api: RestApi, adversary_id: string): Future[Adversary] {.async.} =
    ## Retrieves an Adversary by "id".
    ## 
    result = (await api.request("GET", "/adversary/" & adversary_id)).newAdversary

proc createAdversary*(api: RestApi, data: Adversary): Future[string] {.async.} =
    ## Creates a new adversary given an Adversary object.
    ## 
    result = await api.request("POST", "/adversary", data.toJson())

proc updateAdversary*(api: RestApi, adversary_id: string;
                    data: AdversaryUpdate): Future[string] {.async.} =
    ## Modifies the TTPs of an Adversary.
    ## 
    result = await api.request("PATCH", "/adversary/" & adversary_id, data.toJson())

proc deleteAdversary*(api: RestApi, adversary_id: string): Future[string] {.async.} =
    ## Deletes the Adversary by it's "id".
    ## 
    result = await api.request("DELETE", "/adversary/" & adversary_id)
