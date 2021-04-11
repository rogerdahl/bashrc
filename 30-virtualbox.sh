# VirtualBox, VM

# You can modify the xml configuration file belonging to your virtual machine and setting this value:
#
# <ExtraDataItem name="GUI/Fullscreen" value="on"/>
# -------------------------------------------------------------------------------
# Example:
# pask@micene:~$ vi .VirtualBox/Machines/edilClima/edilClima.xml
#
# <?xml version="1.0" encoding="UTF-8" standalone="no" ?>
# <!-- innotek VirtualBox Machine Configuration -->
# <VirtualBox xmlns="http://www.innotek.de/VirtualBox-settings" version="1.2-linux">
#
# <Machine OSType="winxp" currentSnapshot="{bf314e7e-dbbc-483f-0ca9-eca9181fe416}" lastStateChange="2008-04-20T14:01:14Z" name="edilClima" snapshotFolder="Snapshots" uuid="{b442add2-c420-4c04-9b99-3c8f15694fd0}">
# <ExtraData>
# <ExtraDataItem name="GUI/SaveMountedAtRuntime" value="yes"/>
# <ExtraDataItem name="GUI/LastCloseAction" value="powerOff"/>
# <ExtraDataItem name="GUI/LastWindowPostion" value="228,49,644,533"/>
# <ExtraDataItem name="GUI/Fullscreen" value="on"/>
# <ExtraDataItem name="GUI/Seamless" value="off"/>
# <ExtraDataItem name="GUI/AutoresizeGuest" value="on"/>
# </ExtraData>
# ............................................

# setvideomodehint <xres> <yres> <bpp>
#                  [[<display>] [<enabled:yes|no> |
#                  [<xorigin> <yorigin>]]] |
# setscreenlayout <display> on|primary <xorigin> <yorigin> <xres> <yres> <bpp> | off

ISO_ROOT="${BASHRC_DIR}/iso"
VM_ROOT="${HOME}/vm"

# After starting or stopping a VM, we use polling to wait until VirtualBox starts
# reporting the new state. However, VirtualBox 6.1 (latest as of now), starts reporting
# the new state before it's actually ready to accept commands that would work in that
# state, so we need to wait a bit longer. This value sets seconds (fractions supported),
# for that additional wait.
BUG_WAIT_SEC=5

#VBM="vboxmanage"
#CVM="createvm"
#MVM="modifyvm"
#CHD="createhd"
#STL="storagectl"
#SCH="storageattach"
#VSS="vboxheadless"
#
#perl -i -pe 's/\"\$VBM\"/vboxmanage/' /home/dahl/bin/bashrc.d/30-virtualbox.sh
#perl -i -pe 's/\"\$CVM\"/createvm/' /home/dahl/bin/bashrc.d/30-virtualbox.sh
#perl -i -pe 's/\"\$MVM\"/modifyvm/' /home/dahl/bin/bashrc.d/30-virtualbox.sh
#perl -i -pe 's/\"\$CHD\"/createhd/' /home/dahl/bin/bashrc.d/30-virtualbox.sh
#perl -i -pe 's/\"\$STL\"/storagectl/' /home/dahl/bin/bashrc.d/30-virtualbox.sh
#perl -i -pe 's/\"\$SCH\"/storageattach/' /home/dahl/bin/bashrc.d/30-virtualbox.sh
#perl -i -pe 's/\"\$VSS\"/vboxheadless/' /home/dahl/bin/bashrc.d/30-virtualbox.sh

# VM aliases
alias edi-local='vm_start_local_3840_2160 edi'
alias cdl-local='vm_start_local_3840_2160 cdl'
alias edi-remote='vm_start_remote_2560_1440 edi'
alias cdl-remote='vm_start_remote_2560_1440 cdl'

vm_create() {
  printf "Creating new VM...\n"

  local vm_name='arch3'
  local iso_name='debian2.iso'
  local ram_mb='2048'
  local vram_mb='128'
  local disk_gb='100'
  local nic_mode='nat'

  local iso_url=''
  iso_url+='https://cdimage.debian.org/'
  iso_url+='debian-cd/current/amd64/iso-cd/'
  iso_url+='debian-10.7.0-amd64-netinst.iso'

  local vm_dir="$VM_ROOT/$vm_name"
  local iso_path="$ISO_ROOT/$iso_name"
  local vdi_path="$vm_dir/$vm_name.vdi"

  echo '-'
  echo "vm_name = $vm_name"
  echo "iso_name = $iso_name"
  echo "vm_dir = $vm_dir"
  echo "iso_path = $iso_path"
  echo "ram_mb = $ram_mb"
  echo "vram_mb = $vram_mb"
  echo "disk_gb = $disk_gb"
  echo "nic_mode = $nic_mode"
  echo "vdi_path = $vdi_path"

  mkdir -p "$ISO_ROOT"
  mkdir -p "$VM_ROOT"

  # Download debian.iso
  [[ -f "$iso_name" ]] || {
    curl --location "$iso_url" -o "$iso_path"
  }

  # Create vm_name
  vboxmanage createvm --name "$vm_name" --ostype 'Debian_64' --register --basefolder "$vm_dir"

  # Set memory and network
  vboxmanage modifyvm "$vm_name" --ioapic on
  vboxmanage modifyvm "$vm_name" --memory "$ram_mb" --vram "$vram_mb"
  vboxmanage modifyvm "$vm_name" --nic1 "$nic_mode"

  # Create Disk and connect Debian Iso
  vboxmanage createhd --filename "$vdi_path" --size "$(("$disk_gb" * 1024))" --format VDI
  vboxmanage storagectl "$vm_name" --name "SATA Controller" --add sata --controller IntelAhci
  vboxmanage storageattach "$vm_name" "--${STL}" "SATA Controller" --port 0 --device 0 --type hdd --medium "$vdi_path"
  vboxmanage storagectl "$vm_name" --name "IDE Controller" --add ide --controller PIIX4
  vboxmanage storageattach "$vm_name" "--${STL}" "IDE Controller" --port 1 --device 0 --type dvddrive --medium "$iso_path"
  vboxmanage modifyvm "$vm_name" --boot1 dvd --boot2 disk --boot3 none --boot4 none

  # Enable RDP
  vboxmanage modifyvm "$vm_name" --vrde on
  vboxmanage modifyvm "$vm_name" --vrdemulticon on --vrdeport 10001

  # Start the vm_name
  vboxheadless --startvm "$vm_name"

  set_opt exit_on_error false
}

vm_help() {
  subcmd="$1"
  # "vboxmanage"
  # "createvm"
  # "modifyvm"
  # "createhd"
  # "storagectl"
  # "storageattach"
  # "vboxheadless"
  vboxmanage "$subcmd" --help |& source-highlight --src-lang shell --out-format esc256 |& less -R
}

# Configure VM for local or remote, then start

# Start a VM locally that may have been configured for remote usage.
vm_start_local_3840_2160() {
  if [ "$1" == "" ]; then
    echo "Usage: $0 <vm name>"
    return 1
  fi
  vm="$1"
  printf "VM \"%s\": Starting for local @ 4K...\n" "$vm"
  #	if is_running "$vm"; then
  #	  vm_stop_acpi "$vm"
  ##	  vm_stop_savestate "$vm"
  #	fi
  #	set_local "$vm"
  #	vm_set_rdp "$vm" off
  #  sleep 5
  #	vboxmanage startvm "$vm" --type gui #--accelerate3d on
  #	wait_until_running "$vm"
  vm_start_local "$vm"
  vm_set_resolution "$vm" 3840 2160
}

vm_start_remote_2560_1440() {
  if [ "$1" == "" ]; then
    echo "Usage: $0 <vm name>"
    return 1
  fi
  vm="$1"
  printf "VM \"%s\": Starting for remote RDP @ 2560x1440...\n" "$vm"
  vm_start_remote "$vm"
  vm_set_resolution "$vm" 2560 1440
}

# Start

vm_start_local() {
  if [ "$1" == "" ]; then
    echo "Usage: $0 <vm name>"
    return 1
  fi
  vm="$1"
  printf "VM \"%s\": Starting for local...\n" "$vm"
  if is_running "$vm"; then
    vm_stop_acpi "$vm"
    #	  vm_stop_savestate "$vm"
  fi
  set_local "$vm"
  vm_set_rdp "$vm" off
  vboxmanage startvm "$vm" #--type gui #--accelerate3d on
  wait_until_running "$vm"
}

vm_start_remote() {
  if [ "$1" == "" ]; then
    echo "Usage: $0 <vm name>"
    return 1
  fi
  vm="$1"
  printf "VM \"%s\": Starting for remote RDP...\n" "$vm"
  if is_running "$vm"; then
    vm_stop_acpi "$vm"
    #	  vm_stop_savestate "$vm"
  fi
  set_remote "$vm"
  vm_set_rdp "$vm" on
  # Prevent the VM display from opening on the remote machine via X protocol (ssh -X)
  env -u DISPLAY vboxmanage startvm "$vm" # --type headless #--accelerate3d off
  wait_until_running "$vm"
}

# Stop

vm_stop_acpi() {
  # On MATE, This takes 60 seconds, unless changing logout-timeout:
  # dconf write '/org/mate/desktop/session/logout-timeout' 5
  if [ "$1" == "" ]; then
    echo "Usage: $0 <vm name>"
    return 1
  fi
  vm="$1"
  printf "VM \"%s\": Stopping with ACPI...\n" "$vm"
  vboxmanage controlvm "$vm" acpipowerbutton
  wait_until_stopped "$vm"
}

vm_stop_poweroff() {
  if [ "$1" == "" ]; then
    echo "Usage: $0 <vm name>"
    return 1
  fi
  vm="$1"
  printf "VM \"%s\": Stopping with poweroff...\n" "$vm"
  vboxmanage controlvm "$vm" poweroff
  wait_until_stopped "$vm"
}

vm_stop_savestate() {
  if [ "$1" == "" ]; then
    echo "Usage: $0 <vm name>"
    return 1
  fi
  vm="$1"
  printf "VM \"%s\": Stopping with savestate...\n" "$vm"
  vboxmanage controlvm "$vm" savestate
  wait_until_stopped "$vm"
}

# Resolution

# If the guest reverts back to another resolution, try
# to toggle 'Remote Display'.

vm_set_resolution() {
  [[ "$#" -ne 4 ]] || {
    echo "Usage: $0 <vm name> width height"
    return 1
  }
  vm="$1"
  w="$2"
  h="$3"
  printf "VM \"%s\": Setting resolution to %sx%s...\n" "$vm" "$w" "$h"
  vboxmanage setextradata "$vm" CustomVideoMode1 "${w}x${h}x32"
  vboxmanage controlvm "$vm" setvideomodehint "$w" "$h" 32
}

#

wait_until_running() {
  vm="$1"
  printf "Waiting for VM \"%s\" to start." "$vm"
  while true; do
    {
      is_running "$vm" && {
        printf " started\n"
        return
      }
      sleep 1
      printf "%s" "."
    }
  done
  printf "Additional %s sec wait to work around bug in VirtualBox..." "$BUG_WAIT_SEC"
  sleep "$BUG_WAIT_SEC"
}

wait_until_stopped() {
  vm="$1"
  printf "Waiting for VM \"%s\" to stop." "$vm"
  while true; do
    {
      is_running "$vm" || {
        printf " stopped\n"
        return
      }
      sleep 1
      printf "%s" "."
    }
  done
  printf "Additional %s sec wait to work around bug in VirtualBox..." "$BUG_WAIT_SEC"
  sleep "$BUG_WAIT_SEC"
}

# Set the GUI frontend that will be used when starting the VM in the VirtualBox Manager GUI

# Integrated (default, not detachable, local only))
set_local() {
  vm="$1"
  set_frontend_gui "$vm" "gui"
}

# Headless (remote, desktop is reachable only via RDP, fast)
set_remote() {
  vm="$1"
  set_frontend_gui "$vm" "headless"
}

# Detachable (can be detached, but performance is bad, no acceleration)
set_detachable() {
  vm="$1"
  set_frontend_gui "$vm" "separate"
}

set_frontend_gui() {
  vm="$1"
  gui="$2"
  printf "VM \"%s\": Setting front end GUI: %s\n" "$vm" "$gui"
  vboxmanage modifyvm "$vm" --defaultfrontend "$gui"
}

# Misc

is_running() {
  vm="$1"
  [[ "$(vboxmanage list runningvms)" =~ \"$vm\" ]] && return 0
  return 1
}

vm_set_rdp() {
  [[ "$#" -ne 3 ]] || {
    echo "Usage: $0 <vm name> <on/off>"
    return 1
  }
  vm="$1"
  onoff="$2"
  printf "VM \"%s\": Setting RDP: %s\n" "$vm" "$onoff"
  vboxmanage modifyvm "$vm" --vrde "$onoff"
}
