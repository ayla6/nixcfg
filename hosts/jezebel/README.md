a super low end upcloud vm that i got

VERY VERY IMPORTANT NOTES:

this was hell to setup, mostly because i wasn't sure if i could modprobe zram. but you can in fact do it and turn a 1gb of ram system into something more usable that let's you actually build the damn thing

so three very important things

USE ZRAM ON THE INSTALLER
run this

```sh
modprobe zram
echo zstd >/sys/block/zram0/comp_algorithm
echo "2G" >/sys/block/zram0/disksize
mkswap /dev/zram0
swapon --priority 100 /dev/zram0
```

and when building it with nixos-anywhere be sure to use the --no-diskos-deps flag!!!

```sh
nix run github:nix-community/nixos-anywhere -- --no-disko-deps --flake <flake_location>#<system> --target-host root@<ip_address>
```

thank you @nocab.lol for helping me quite a lot with the disko part!!

I FUCKING LOVE ZRAM
