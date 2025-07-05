# Use systemd to mount CIFS shares on demand
#
# This is a huge improvement over /etc/fstab, as it allows the shares to be mounted dynamically on
# access, and unmounted after a period of inactivity. With /etc/fstab, mounting on boot causes
# problems when the mountpoints are not available, and mounting manually is a hassle. This also
# avoids issues with stale mounts if the remote machines are turned off while the mounts are active.
#
# Example usage:
# create_mount_unit 'username' '//someserver/someshare' '/mnt/someshare'
#
# Example smb.conf share definition on someserver:
#
# [global]
# writable = yes
# acl allow execute always = yes
#
# [someshare]
# path = /mnt/share
#
# Example smb-pw.txt file:
#
# username=myusername
# password=mypassword
#
# List servers on remote:
# smbclient -L //someserver -U username

CREDS="/mnt/smb-pw.txt"
COMMON_OPTS="credentials=$CREDS,iocharset=utf8,_netdev,x-systemd.automount,x-systemd.idle-timeout=600"

create_mount_unit() {
  local username="$1"
  local what="$2"
  local where="$3"
  local unit_name="${where#/}"

  # Dashes are used as separators in systemd unit names, so we need to escape them. This takes care
  # of that and any other special characters that might be in the path.
  unit_name="$(systemd-escape -p --suffix=mount "$where")"
  local unit_file="/etc/systemd/system/${unit_name}"

  # Ensure the mount point exists
  sudo mkdir -p "$where"

  # Create the systemd mount unit file
  sudo tee "$unit_file" > /dev/null <<EOF
[Unit]
Description=Mount CIFS Share ${what} at ${where}
Requires=network-online.target
After=network-online.target

[Mount]
What=${what}
Where=${where}
Type=cifs
Options=uid=${username},gid=${username},${COMMON_OPTS}
TimeoutSec=30

[Install]
WantedBy=multi-user.target
EOF

  # Enable the mount units
  sudo systemctl daemon-reload
  sudo systemctl enable --now "$unit_file"

  echo "Created $unit_file"
}

