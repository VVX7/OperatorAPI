#[
    Author: Roger Johnston, Twitter: @VV_X_7
    License: Apache License 2.0
]#

const
    libName* = "OperatorApi"
    libVer* = "0.0.1"
    libAgent* = "OperatorApi (https://github.com/VVX7/OperatorApi, v" & libVer & ")"

proc log*(msg: string, info: tuple) =
    when defined(dimscordDebug):
        var finalmsg = "[Lib]: " & msg
        let tup = $info

        finalmsg = finalmsg & "\n    " & tup[1..tup.high - 1]

        echo finalmsg

proc log*(msg: string) =
    when defined(dimscordDebug):
        echo "[Lib]: " & msg