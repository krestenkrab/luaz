
-- Load LUA code from .zip file
-- http://lua-users.org/lists/lua-l/2011-01/msg00202.html
-- Due to Zhiguo Zhao <zhaozg@gmail.com> (https://github.com/zhaozg)
-- Adopted for use with luaz (libz/minizip) by Kresten Krab Thorup

local table,string,os,package = table,string,os,package
local pairs,ipairs,print,loadstring,assert = pairs,ipairs,print,loadstring,assert

local zip = require("unzip")

module('zloader')

local htab = {}	 --zip handle
local ftab = {}	 --file list
local ztab = {}  --zip file with pattern

local function mklibs()
   package.zpath = package.zpath or os.getenv('LUA_ZPATH') or ''

   for path,pattern in string.gmatch(package.zpath..";", "([^;]*zip)[\\/](.-);") do	--split at ;
      if not htab[path] then
         local z,err = zip.open(path)
         if z then
            htab[path] = z
            ftab[path] = {}
            for fn in z:files() do
               ftab[path][fn.filename] = path
            end
         end
      end

      local t = ztab[path] or {}
      if not t[pattern] then t[pattern] = true end
      ztab[path] = t
   end
   return ztab
end

function zloader(modulename)
   local ztab = mklibs()

   --load module
   for path,v in pairs(ztab) do
      for pat,_ in pairs(v) do
         pat = string.gsub(pat, "%?", (string.gsub(modulename, "%.", "/")))

         if ftab[path] and ftab[path][pat] then
            local z = htab[path]
            local s = z:read(pat)
            if s then
               return assert(loadstring(s, pat))
            end
         end
      end
   end
end

table.insert(package.loaders, zloader)
