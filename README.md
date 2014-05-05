# Lua zipfile support (zlib based)

This adds support for native unzip (reading .zip files) and loading lua code from .zip files.

## How to use

1. put your Lua code in `code.zip`
2. run `export LUA_ZPATH='code.zip/?.lua'; lua -l zloader`
3. require modules
4. be happy.

The code can also be statically linked into lua to provide the same capability; so you can run a lua-based program with just a binary and an accompanying zip file.

This module requires `zlib` (http://www.zlib.net/) in the runtime environment.

This is based on zlib's `contrib/minizip` available under the Info-ZIP license (http://www.info-zip.org/license.html).


Kresten Krab Thorup






