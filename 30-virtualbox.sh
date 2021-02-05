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
	"$VBM" "$CHD" --filename "$vdi_path" --size "$(("$disk_gb" * 1024))" --format VDI
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
