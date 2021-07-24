# Package

version       = "0.0.1"
author        = "VVX7"
description   = "A Prelude Operator REST library in Nim."
license       = "GPL3"

# Dependencies

requires "nim >= 1.4.0""

task genDoc, "Generates the documentation for operatorapi":
    rmDir("docs")
    exec("nim doc2 --outdir=docs --project --index:on --git.url:https://github.com/vvx7/operatorapi --git.commit:master operatorapi.nim")
    exec("nim buildindex -o:docs/theindex.html docs/")

    writeFile("docs/index.html", """
    <!DOCTYPE html>
    <html>
      <head>
        <meta http-equiv="Refresh" content="0; url=operatorapi.html"/>
      </head>
      <body>
        <p>Click <a href="operatorapi.html">this link</a> if this does not redirect you.</p>
      </body>
    </html>
    """)