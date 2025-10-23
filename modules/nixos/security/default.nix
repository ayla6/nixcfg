{...}: {
  imports = [
    ./apparmor.nix
    ./pam.nix
    ./polkit.nix
    ./sudo.nix
  ];

  boot.blacklistedKernelModules = [
    # Obscure network protocols
    "ax25"
    "netrom"
    "rose"
    "dccp"
    "sctp"
    "rds"
    "tipc"
    "n-hdlc"
    "x25"
    "decnet"
    "econet"
    "af_802154"
    "ipx"
    "appletalk"
    "psnap"
    "p8023"
    "p8022"
    "can"
    "atm"

    # Old or rare or insufficiently audited filesystems
    "adfs"
    "affs"
    "bfs"
    "befs"
    "cramfs"
    "efs"
    "erofs"
    "exofs"
    "freevxfs"
    "f2fs"
    "hfs"
    "hpfs"
    "jfs"
    "minix"
    "nilfs2"
    #"ntfs"
    "omfs"
    "qnx4"
    "qnx6"
    "sysv"
    "ufs"
    # Various rare filesystems
    "jffs2"
    "hfsplus"
    #"squashfs"
    "udf"
    "cifs"
    "nfs"
    "nfsv3"
    "nfsv4"
    "gfs2"
    # vivid driver is only useful for testing purposes and has been the cause
    # of privilege escalation vulnerabilities
    "vivid"
  ];
}
