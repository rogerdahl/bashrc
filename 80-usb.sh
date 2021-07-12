#!/bin/bash

usb_reset() {
  for xhci in /sys/bus/pci/drivers/?hci_hcd; do
    if ! cd $xhci; then
      echo Weird error. Failed to change directory to $xhci
      exit 1
    fi

    echo Resetting devices from $xhci...

    for i in ????:??:??.?; do
      sudo sh -c 'echo -n "$i" > unbind'
      sudo sh -c 'echo -n "$i" > bind'
    done
  done
}

#usb_reset
