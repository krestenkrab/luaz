# zlib support

This adds support for native unzip (reading .zip files) and loading lua code from .zip files.

1. put code in `code.zip`
2. run `export LUA_ZPATH='code.zip/?.lua'; lua -l zloader`
3. require modules
4. be happy.

The code can also be statically linked into lua to provide the same capability.

This module requires `zlib` in the runtime environment.

Kresten Krab Thorup






