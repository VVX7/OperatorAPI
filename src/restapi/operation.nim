#[
    Author: Roger Johnston, Twitter: @VV_X_7
    License: Apache License 2.0
]#

import asyncdispatch, jsony
import ../objects
import strutils
import requests, tables

proc getOperations*(api: RestApi): Future[seq[Operation]] {.async.} =
    ## Returns a sequence of Operation objects.
    ## 
    result = (await api.request("GET", "/operation")).fromJson(seq[Operation])

proc getOperationLinks*(api: RestApi): Future[Table[string, Operation]] {.async.} =
    ## Returns a map of Operation IDs by Link ID.
    ## 
    result = (await api.request("GET", "/operation/links")).fromJson(Table[string, Operation])
