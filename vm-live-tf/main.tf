variable "resource_group_name" {
  default = "nanitetemp"
}

variable "location" {
  default = "Central India"
}

# 🔹 Create a new Resource Group for this deployment
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# 🔹 Lookup the existing SSH key stored in Azure (in RG: trellin)
data "azurerm_ssh_public_key" "trellin" {
  name                = "trellin_key" # name of your Azure SSH key
  resource_group_name = "trellin"     # resource group where SSH key lives
}

# 🔹 Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

# 🔹 Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# 🔹 Network Security Group for SSH access
resource "azurerm_network_security_group" "nsg" {
  name                = "nanite-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# 🔹 Public IP
resource "azurerm_public_ip" "publicip" {
  name                = "public-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static" # Changed to Static for consistent IP
  sku                 = "Standard"
}

# 🔹 Associate Network Security Group to Subnet
resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# 🔹 Network Interface
resource "azurerm_network_interface" "nic" {
  name                = "nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }

  depends_on = [azurerm_subnet_network_security_group_association.nsg_association]
}

# 🔹 Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "nanite-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  size                = "Standard_D4as_v5"
  admin_username      = "yash"

  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  # 👇 Use your existing SSH key from Azure RG: trellin
  admin_ssh_key {
    username   = "yash"
    public_key = data.azurerm_ssh_public_key.trellin.public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 30
  }

  source_image_reference {
    publisher = "debian"
    offer     = "debian-12"
    sku       = "12"
    version   = "latest"
  }

  disable_password_authentication = true

  # Custom data script to run after VM initialization
  custom_data = base64encode(<<-EOF
#!/bin/bash
# Log all output to a file for debugging
exec > >(tee /var/log/vm-setup.log) 2>&1

echo "Starting VM setup at $(date)"

# Update system and install live-build dependencies
echo "Updating system and installing live-build tools..."
apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
DEBIAN_FRONTEND=noninteractive apt-get install -y \
  live-build \
  debootstrap \
  syslinux \
  squashfs-tools \
  xorriso \
  isolinux \
  grub-pc-bin \
  grub-efi-amd64-bin \
  mtools

echo "Pre-configuring apt-cacher-ng to avoid interactive prompts..."
echo 'apt-cacher-ng apt-cacher-ng/tunnelenable boolean false' | debconf-set-selections

echo "Installing additional build tools..."
DEBIAN_FRONTEND=noninteractive apt-get install -y \
  apt-cacher-ng \
  wget \
  curl \
  git \
  rsync \
  genisoimage \
  dosfstools \
  qemu-utils \
  qemu-system-x86

# Clone the Nanite configs repository
echo "Cloning Nanite-configs repository..."
cd /home/yash
git clone https://github.com/Project-Nanite/Nanite-configs.git
chown -R yash:yash /home/yash/Nanite-configs

echo "VM setup completed at $(date)"
echo "Setup log available at /var/log/vm-setup.log"
EOF
  )
}


