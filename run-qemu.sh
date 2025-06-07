#!/bin/bash

# QEMU Live Image Launcher Script
# This script launches the built live image with QEMU

set -e  # Exit on any error

echo "======================================="
echo "QEMU Live Image Launcher"
echo "======================================="
echo

# Function to print colored output
print_status() {
    echo -e "\033[1;34m[INFO]\033[0m $1"
}

print_success() {
    echo -e "\033[1;32m[SUCCESS]\033[0m $1"
}

print_error() {
    echo -e "\033[1;31m[ERROR]\033[0m $1"
}

print_warning() {
    echo -e "\033[1;33m[WARNING]\033[0m $1"
}

# Check if QEMU is installed
print_status "Checking QEMU installation..."
if ! command -v qemu-system-x86_64 &> /dev/null; then
    print_status "QEMU not found. Installing QEMU..."
    
    # Check if running as root or with sudo
    if [[ $EUID -ne 0 ]]; then
        if sudo apt update && sudo apt install -y qemu-system-x86 qemu-utils; then
            print_success "QEMU installed successfully!"
        else
            print_error "Failed to install QEMU. Please run: sudo apt install qemu-system-x86 qemu-utils"
            exit 1
        fi
    else
        if apt update && apt install -y qemu-system-x86 qemu-utils; then
            print_success "QEMU installed successfully!"
        else
            print_error "Failed to install QEMU."
            exit 1
        fi
    fi
else
    print_success "QEMU is already installed"
fi

# Check KVM availability
print_status "Checking KVM support..."
KVM_AVAILABLE=false

if [ -e /dev/kvm ]; then
    if [ -r /dev/kvm ] && [ -w /dev/kvm ]; then
        print_success "KVM is available and accessible"
        KVM_AVAILABLE=true
    else
        print_warning "KVM device exists but not accessible. You may need to add your user to the 'kvm' group:"
        print_warning "sudo usermod -a -G kvm \$USER"
        print_warning "Then log out and log back in."
        KVM_AVAILABLE=false
    fi
else
    print_warning "KVM is not available. Running without hardware acceleration."
    print_warning "Performance will be slower. To enable KVM:"
    print_warning "1. Check if your CPU supports virtualization (VT-x/AMD-V)"
    print_warning "2. Enable virtualization in BIOS/UEFI"
    print_warning "3. Install: sudo apt install qemu-kvm"
    KVM_AVAILABLE=false
fi

# Check if ISO file exists
ISO_FILE="live-image-amd64.hybrid.iso"
print_status "Looking for ISO file: $ISO_FILE"

if [ ! -f "$ISO_FILE" ]; then
    print_error "ISO file '$ISO_FILE' not found!"
    print_status "Available ISO files:"
    ls -la *.iso 2>/dev/null || echo "No ISO files found in current directory"
    echo
    print_status "Please run the build script first: ./build.sh"
    exit 1
fi

print_success "Found ISO file: $ISO_FILE ($(du -h "$ISO_FILE" | cut -f1))"

# Build QEMU command
QEMU_CMD="qemu-system-x86_64"

# Add KVM if available
if [ "$KVM_AVAILABLE" = true ]; then
    QEMU_CMD="$QEMU_CMD -enable-kvm"
    print_status "Using KVM acceleration"
else
    print_status "Running without KVM acceleration"
fi

# Add other parameters
QEMU_CMD="$QEMU_CMD -m 4096 -smp 2 -boot d -cdrom $ISO_FILE -net nic -net user"

echo
print_status "QEMU Configuration:"
echo "  Memory: 4096 MB"
echo "  CPUs: 2"
echo "  Boot: CD-ROM"
echo "  ISO: $ISO_FILE"
echo "  Network: User mode"
echo "  KVM: $([ "$KVM_AVAILABLE" = true ] && echo "Enabled" || echo "Disabled")"

echo
print_status "Starting QEMU..."
print_status "Command: $QEMU_CMD"
echo
print_status "Press Ctrl+Alt+G to release mouse cursor from QEMU window"
print_status "Press Ctrl+Alt+F to toggle fullscreen"
print_status "Close QEMU window or press Ctrl+C to stop"
echo

# Run QEMU
exec $QEMU_CMD 