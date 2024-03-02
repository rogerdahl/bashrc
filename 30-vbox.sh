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
# [[<display>] [<enabled:yes|no> |
# [<xorigin> <yorigin>]]] |
# setscreenlayout <display> on|primary <xorigin> <yorigin> <xres> <yres> <bpp> | off

ISO_ROOT="${BASHRC_DIR}/iso"
VM_ROOT="${HOME}/vm"

DEFAULT_VM_NAME='test-vm'
DEFAULT_RAM_GB='4'
DEFAULT_VRAM_MB='128'
DEFAULT_DISK_GB='100'
DEFAULT_NETWORK_MODE='bridged'

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

declare -A STD_REZ=(
  [2k]='2560x1440'
  [4k]='3840x2160'
)

# VM aliases
# shellcheck disable=SC2139
alias edi-local='vm_start local 4k edi'
alias edi-remote='vm_start remote 2k edi'
alias cdl-local='vm_start local 4k cdl'
alias cdl-remote='vm_start remote 2k cdl'
alias edi-remote-4k='vm_start remote 4k edi'
alias cdl-remote-4k='vm_start remote 4k cdl'
alias d1-local='vm_start local  4k d1'
alias d1-remote='vm_start remote 2k d1'
alias pasta-local='vm_start local 4k PASTA'
alias pasta-remote='vm_start remote 2k PASTA'

vm_create() {
  printf "\nCreate a new virtual machine (Ctrl+C to cancel):\n\n"
  local files=("$BASHRC_DIR/iso/"*)
  local iso_path="$(select_file files)"
  local vm_name
  read -r -p "Name to display for VM: " vm_name
  local ram_gb
  read -r -p "RAM (GB) (Enter for ${DEFAULT_RAM_GB}: GB): " ram_gb
  local vram_mb
  read -r -p "VRAM (MB) (Enter for ${DEFAULT_VRAM_MB} MB): " vram_mb
  local disk_gb
  read -r -p "Disk (GB) (Enter for ${DEFAULT_DISK_GB} GB): " disk_gb
  local nic_mode
  # TODO: Select from none|null|nat|bridged|intnet|hostonly|generic|natnetwork
  read -r -p "Network mode (Enter for ${DEFAULT_NETWORK_MODE}): " nic_mode

  local vm_dir="$VM_ROOT/$vm_name"
  local vdi_path="$vm_dir/$vm_name.vdi"

  vm_name="${vm_name:=${DEFAULT_VM_NAME}}"
  ram_gb="${ram_gb:=${DEFAULT_RAM_GB}}"
  vram_mb="${vram_mb:=${DEFAULT_VRAM_MB}}"
  disk_gb="${disk_gb:=${DEFAULT_DISK_GB}}"
  nic_mode="${nic_mode:=${DEFAULT_NETWORK_MODE}}"

  #  IFS=$'\n' read -ra xy <<<$(vboxmanage list stypes)
  # TODO: Select ostype like iso file
  # vboxmanage list ostypes | rg 'Family ID: *Linux' -B1 | rg 'Descr'
  ostype="Ubuntu_64"

  confirm || return

  set -x

  local vm_dir="$VM_ROOT/$vm_name"
  local vdi_path="$vm_dir/$vm_name.vdi"

  mkdir -p "$ISO_ROOT"
  mkdir -p "$VM_ROOT"

  # Create vm_name
  vboxmanage createvm --name "$vm_name" --ostype "$ostype" --register --basefolder "$vm_dir"

  # Set memory and network
  vboxmanage modifyvm "$vm_name" --ioapic on
  vboxmanage modifyvm "$vm_name" --memory "$((ram_gb * 1024))" --vram "$vram_mb"
  vboxmanage modifyvm "$vm_name" --nic1 "$nic_mode"

  printf 'xxx%sxxx' "$iso_path"

  # Create Disk and connect ISO
  vboxmanage createhd --filename "$vdi_path" --size "$(("$disk_gb" * 1024))" --format VDI
  vboxmanage storagectl "$vm_name" --name "SATA Controller" --add sata --controller IntelAhci
  vboxmanage storageattach "$vm_name" "--storagectl" "SATA Controller" --port 0 --device 0 --type hdd --medium "$vdi_path"
  vboxmanage storagectl "$vm_name" --name "IDE Controller" --add ide --controller PIIX4
  vboxmanage storageattach "$vm_name" "--storagectl" "IDE Controller" --port 1 --device 0 --type dvddrive --medium "$iso_path"
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

## Start a VM locally that may have been configured for remote usage.
#vm_start_local_4K() {
# if [ "$1" == "" ]; then
# echo "Usage: $0 <vm name>"
# return 1
# fi
# vm="$1"
# #	if is_running "$vm"; then
# #	 vm_stop_acpi "$vm"
# ##	 vm_stop_savestate "$vm"
# #	fi
# #	set_local "$vm"
# #	vm_set_rdp "$vm" off
# # sleep 5
# #	vboxmanage startvm "$vm" --type gui #--accelerate3d on
# #	wait_until_running "$vm"
# vm_start_local "$vm"
# vm_set_resolution "$vm" 3840 2160
#}

#vm_start_remote_4K() {
# if [ "$1" == "" ]; then
# echo "Usage: $0 <vm name>"
# return 1
# fi
# vm="$1"
# printf "VM \"%s\": Starting for remote RDP @ 4K...\n" "$vm"
# vm_start_remote "$vm"
# vm_set_resolution "$vm" 3840 2160
#}

#vm_start_remote_2560_1440() {
# if [ "$1" == "" ]; then
# echo "Usage: $0 <vm name>"
# return 1
# fi
# vm="$1"
# printf "VM \"%s\": Starting for remote RDP @ 2k...\n" "$vm"
# vm_start_remote "$vm"
# vm_set_resolution "$vm" 2560 1440
#}

# Start

#vm_start_local() {
# if [ "$1" == "" ]; then
# echo "Usage: $0 <vm name>"
# return 1
# fi
# vm="$1"
# printf "VM \"%s\": Starting for local...\n" "$vm"
# if is_running "$vm"; then
# vm_stop_acpi "$vm"
# #	 vm_stop_savestate "$vm"
# fi
# set_local "$vm"
# vm_set_rdp "$vm" off
# vboxmanage startvm "$vm" #--type gui #--accelerate3d on
# wait_until_running "$vm"
#}

vm_start() {
  # 'vm_start remote 2k edi'
  # printf "VM \"%s\": Starting for local @ 4K...\n" "$vm"
  access_type="$1"
  rez="$2"
  vm="$3"

  # For some reason, these commands connect to X, which causes an unfortunate
  # link back to the box from which the command was issued, if connected with
  # ssh and X forwarding enabled (-X).
  unset DISPLAY

  if is_running "$vm"; then
    vm_stop_acpi "$vm"
  # vm_stop_savestate "$vm"
  fi

  case "$access_type" in
  local)
    # Integrated (default, not detachable, local only))
    vm_set_rdp "$vm" 'off'
    set_frontend_gui "$vm" "gui"
    ;;
  remote)
    vm_set_rdp "$vm" 'on'
    # Headless (remote, desktop is reachable only via RDP, fast)
    set_frontend_gui "$vm" "headless"
    ;;
    # set_frontend_gui "$vm" "separate"
  esac

  # Prevent the VM display from opening on the remote machine via X protocol (ssh -X)
  env -u DISPLAY vboxmanage startvm "$vm" # --type headless #--accelerate3d off
  wait_until_running "$vm"
  vm_set_resolution "$vm" "$rez"
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
  vboxmanage controlvm "$vm" poweroff -f
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
  # [[ "$#" -ne 4 ]] || {
  # echo "Usage: $0 <vm name> width height"
  # return 1
  # }
  vm="$1"
  # rez = WxH
  rez="${STD_REZ[$2]}"
  printf "VM \"%s\": Setting resolution to %s...\n" "$vm" "$rez"
  IFS='x' read -ra rez_arr <<<"$rez"
  vboxmanage setextradata "$vm" CustomVideoMode1 "${rez}x32"
  vboxmanage controlvm "$vm" setvideomodehint "${rez_arr[0]}}" "${rez_arr[1]}}" 32
}

wait_until_running() {
  vm="$1"
  printf "Waiting for VM \"%s\" to start." "$vm"
  while true; do
    {
      is_running "$vm" && {
        printf " started\n"
        break
      }
      sleep 1
      printf "%s" "."
    }
  done
  printf "Additional %s sec wait to work around bug in VirtualBox...\n" "$BUG_WAIT_SEC"
  sleep "$BUG_WAIT_SEC"
}

wait_until_stopped() {
  vm="$1"
  printf "Waiting for VM \"%s\" to stop." "$vm"
  while true; do
    {
      is_running "$vm" || {
        printf " stopped\n"
        break
      }
      sleep 1
      printf "%s" "."
    }
  done
  printf "Additional %s sec wait to work around bug in VirtualBox...\n" "$BUG_WAIT_SEC"
  sleep "$BUG_WAIT_SEC"
}

# Set the GUI frontend that will be used when starting the VM in the VirtualBox Manager
# GUI
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

  case "$onoff" in
  on)
    # Integrated (default, not detachable, local only))
    printf "Setting up for remote access (RDP, slower local access)\n"
    ;;
  off)
    printf "Setting up for local access (fast local, but no RDP access)\n"
    ;;
  esac
  vboxmanage modifyvm "$vm" --vrde "$onoff"
}
