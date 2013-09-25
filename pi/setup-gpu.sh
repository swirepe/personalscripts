#!/usr/bin/env bash
# straight bogarted from https://github.com/asb/raspi-config/blob/master/raspi-config



set_config_var() {
  lua - "$1" "$2" "$3" <<EOF > "$3.bak"
local key=assert(arg[1])
local value=assert(arg[2])
local fn=assert(arg[3])
local file=assert(io.open(fn))
local made_change=false
for line in file:lines() do
if line:match("^#?%s*"..key.."=.*$") then
line=key.."="..value
made_change=true
end
print(line)
end

if not made_change then
print(key.."="..value)
end
EOF
mv "$3.bak" "$3"
}

echo "Turning down the gpu memory to 16."
set_config_var gpu_mem 16 /boot/config.txt
