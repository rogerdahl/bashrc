#!/usr/bin/env bash

ISO_ROOT="${BASHRC_DIR}/iso"
VM_ROOT="${HOME}/vm"

VBM="vboxmanage"
CVM="createvm"
MVM="modifyvm"
CHD="createhd"
STL="storagectl"
SCH="storageattach"
VSS="vboxheadless"

vbox_create() {
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

	set -e
	set -x

	mkdir -p "$ISO_ROOT"
	mkdir -p "$VM_ROOT"

	# Download debian.iso
	[[ -f "$iso_name" ]] || {
		curl --location "$iso_url" -o "$iso_path"
	}

	# Create vm_name
	"$VBM" "$CVM" --name "$vm_name" --ostype 'Debian_64' --register --basefolder "$vm_dir"

	# Set memory and network
	"$VBM" "$MVM" "$vm_name" --ioapic on
	"$VBM" "$MVM" "$vm_name" --memory "$ram_mb" --vram "$vram_mb"
	"$VBM" "$MVM" "$vm_name" --nic1 "$nic_mode"

	# Create Disk and connect Debian Iso
	"$VBM" "$CHD" --filename "$vdi_path" --size "$(( "$disk_gb" * 1024 ))" --format VDI
	"$VBM" "$STL" "$vm_name" --name "SATA Controller" --add sata --controller IntelAhci
	"$VBM" "$SCH" "$vm_name" "--${STL}" "SATA Controller" --port 0 --device 0 --type hdd --medium "$vdi_path"
	"$VBM" "$STL" "$vm_name" --name "IDE Controller" --add ide --controller PIIX4
	"$VBM" "$SCH" "$vm_name" "--${STL}" "IDE Controller" --port 1 --device 0 --type dvddrive --medium "$iso_path"
	"$VBM" "$MVM" "$vm_name" --boot1 dvd --boot2 disk --boot3 none --boot4 none

	# Enable RDP
	"$VBM" "$MVM" "$vm_name" --vrde on
	"$VBM" "$MVM" "$vm_name" --vrdemulticon on --vrdeport 10001

	# Start the vm_name
	"$VSS" --startvm "$vm_name"

	set_opt exit_on_error false
}

vbox_help() {
	"$VBM" "$MVM" --help |& source-highlight --src-lang shell --out-format esc256 |& less -R
}


vm-acpi-shutdown() {

if [ "$1" == "" ]; then
    echo "Usage: $0 <vm name>"
    exit 1
fi
vboxmanage controlvm $1 acpipowerbutton
}

vm-enable-rdp() {

if [ "$1" == "" ]; then
    echo "Usage: $0 <vm name>"
    exit 1
fi

vboxmanage modifyvm $1 --vrde on
}

vm-poweroff() {

if [ "$1" == "" ]; then
    echo "Usage: $0 <vm name>"
    exit 1
fi

vboxmanage controlvm $1 poweroff
}

vm-remote() {
if [ "$1" == "" ]; then
    echo "Usage: $0 <vm name>"
    exit 1
fi

set -e
set -x

vm-acpi-shutdown.sh "$1" || true
#vm-poweroff.sh "$1" || true
#vm-save-and-stop.sh "$1" || true

sleep 10

vm-enable-rdp.sh "$1" || true
#vm-start.sh "$1"
vm-start-headless.sh "$1"

sleep 10
vm-set-resolution-2560x1440.sh "$1"
#vm-set-resolution-3840-2160.sh "$1"
}

vm-save-and-stop() {

if [ "$1" == "" ]; then
    echo "Usage: $0 <vm name>"
    exit 1
fi

vboxmanage controlvm $1 savestate
}

vm-set-resolution-2560x1440() {


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

if [ "$1" == "" ]; then
    echo "Usage: $0 <vm name>"
    exit 1
fi

vboxmanage setextradata $1 CustomVideoMode1 2560x1440x32
vboxmanage controlvm $1 setvideomodehint 2560 1440 32
}

vm-set-resolution-3840-2160() {

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

if [ "$1" == "" ]; then
    echo "Usage: $0 <vm name>"
    exit 1
fi

vboxmanage setextradata $1 CustomVideoMode1 3840x2160x32
vboxmanage controlvm $1 setvideomodehint 3840 2160 32

echo If the guest reverts back to another resolution, try
echo to toggle 'Remote Display'.
}

vm-start-headless() {

if [ "$1" == "" ]; then
    echo "Usage: $0 <vm name>"
    exit 1
fi

export -n DISPLAY
vboxmanage startvm $1 --type headless #--accelerate3d off
}

vm-start() {

if [ "$1" == "" ]; then
    echo "Usage: $0 <vm name>"
    exit 1
fi

# Prevent the VM display from opening on client when connected with ssh -X
export -n DISPLAY
vboxmanage startvm $1
#--type headless --accelerate3d off
}

