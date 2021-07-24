#[
    Author: Roger Johnston, Twitter: @VV_X_7
    License: Apache License 2.0
]#

import asyncdispatch, jsony
import ../objects
import requests, tables, strutils

proc getSchedules*(api: RestApi): Future[seq[Schedule]] {.async.} =
    ## Returns a sequence of Schedule objects.
    ## 
    result = (await api.request("GET", "/schedule")).fromJson(seq[Schedule])

proc createSchedule*(api: RestApi, data: Schedule): Future[string] {.async.} =
    ## Creates a new schedule given an adversary ID and range.
    ## 
    result = await api.request("POST", "/schedule", data.toJson())

proc deleteSchedule*(api: RestApi, adversaryID: string): Future[string] {.async.} =
    ## Deletes an schedule by adversary ID.
    ## 
    result = await api.request("DELETE", "/schedule/" & adversaryID)