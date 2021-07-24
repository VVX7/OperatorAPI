#[
    Author: Roger Johnston, Twitter: @VV_X_7
    License: Apache License 2.0
]#

import asyncdispatch, jsony
import ../objects
import requests, tables, strutils

proc getPlugin*(api: RestApi, name: string): Future[Plugin] {.async.} =
    ## Returns the plugin configuration data specified by name.
    ## 
    result = (await api.request("GET", "/plugin/" & name)).fromJson(Plugin)

proc updatePlugin*(api: RestApi, data: Plugin): Future[string] {.async.} =
    ## Updates the plugin configuration data specified by name.
    ## 
    result = await api.request("POST", "/tactics", data.toJson())
