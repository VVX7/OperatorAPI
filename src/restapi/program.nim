#[
    Author: Roger Johnston, Twitter: @VV_X_7
    License: Apache License 2.0
]#

import asyncdispatch, jsony
import ../objects
import strutils
import requests, tables

proc getProgram*(api: RestApi): Future[Table[string, Program]] {.async.} =
    ## Returns training programs.
    ## 
    result = (await api.request("GET", "/program")).fromJson(Table[string, Program])
