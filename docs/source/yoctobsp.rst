.. _thin_edge_tauri_imx8mm_build:

Integration of Thin-edge.io with Tauri-L i.MX8MM Yocto BSP
==========================================================

This section describes the procedure to set up and build the
Thin-edge enabled Yocto BSP for the PHYTEC phyGATE-Tauri-L i.MX8MM platform.

**Release Information:**

- **BSP:** BSP-Yocto-NXP-i.MX8MM-PD25.1.0  
- **Yocto Version:** 5.0.8 LTS  
- **Branch:** scarthgap  

Host Preparation & Yocto BSP build Steps:
-----------------------------------------

You can set up the host or use one of our build-container to run a Yocto build. You need to have a running Linux distribution. It should be running on a powerful machine since a lot of compiling will need to be done.

**Host setup:**

Yocto needs a handful of additional packages on your host. For Ubuntu you need:
::

      host:~$ sudo apt install gawk wget git diffstat unzip texinfo \
      gcc build-essential chrpath socat cpio python3 python3-pip \
      python3-pexpect xz-utils debianutils iputils-ping python3-git \
      python3-jinja2 libegl1-mesa libsdl1.2-dev \
      python3-subunit mesa-common-dev zstd liblz4-tool file locales libacl1

If you want to use a build-container, you only need to install following packages on your host
::

  host:~$ sudo apt install wget git
  
Continue with the next step Git Configuration after that. Also see the Phytec Yocto documentation for using build-container.

https://phytec.github.io/doc-bsp-yocto/yocto/scarthgap.html#using-build-container 

**Git configuration:**

You should set name and email in your Git configuration, otherwise, Bitbake will complain during the first build. You can use the two commands to set them directly.

::
  
  $ git config --global user.email "your@email.com"
  $ git config --global user.name "Your Name"

Create a new working directory:

::

   $ mkdir yocto-imx8mm-Tauri-L
   $ cd yocto-imx8mm-Tauri-L

**Download phyLinux Tool**

The phyLinux setup tool is available from the PHYTEC download server:

https://download.phytec.de/Software/Linux/Yocto/Tools/phyLinux

Download the tool:

::

   $ wget https://download.phytec.de/Software/Linux/Yocto/Tools/phyLinux

Make it executable and initialize:

::

   $ chmod +x phyLinux
   $ ./phyLinux init

On the first initialization, the phyLinux script will ask you to install the Repo tool in your /usr/local/bin directory. During the execution of the init command, you need to choose your processor platform (SoC), PHYTEC’s BSP release number, and the hardware you are working on
   
**Selecting SoC Platform:**

During BSP setup, select the SoC platform(Choose number):

::

***************************************************
* Please choose one of the available SoC Platforms:
*
*   1: am335x
*   2: am57x
*   3: am62ax
*   4: am62lx
*   5: am62px
*   6: am62x
*   7: am64x
*   8: am67x
*   9: am68x
*   10: imx6
*   11: imx6ul
*   12: imx7
*   13: imx8
*   14: imx8m
*   15: imx8mm
*   16: imx8mp
*   ........
*
* $  15

**Selecting Release:**

::

***************************************************
* Please choose one of the available Releases:
*
*   1: BSP-Yocto-Ampliphy-i.MX8MM-master (master)
*   2: BSP-Yocto-FSL-i.MX8MM-ALPHA1 (unknown)
*   3: BSP-Yocto-FSL-i.MX8MM-ALPHA2 (unknown)
*   4: BSP-Yocto-FSL-i.MX8MM-PD20.1-rc1 (unknown)
*   5: BSP-Yocto-FSL-i.MX8MM-PD20.1-rc2 (unknown)
*   6: BSP-Yocto-FSL-i.MX8MM-PD20.1-rc3 (warrior)
*   7: BSP-Yocto-FSL-i.MX8MM-PD20.1.0 (warrior)
*   8: BSP-Yocto-FSL-i.MX8MM-PD21.1-rc1 (zeus)
*   9: BSP-Yocto-FSL-i.MX8MM-PD21.1-rc2 (zeus)
*   10: BSP-Yocto-FSL-i.MX8MM-PD21.1-rc3 (zeus)
*   11: BSP-Yocto-FSL-i.MX8MM-PD21.1.0 (zeus)
*   12: BSP-Yocto-NXP-i.MX8MM-PD22.1-rc2 (hardknott)
*   13: BSP-Yocto-NXP-i.MX8MM-PD22.1-rc3 (hardknott)
*   14: BSP-Yocto-NXP-i.MX8MM-PD22.1.0 (hardknott)
*   15: BSP-Yocto-NXP-i.MX8MM-PD22.1.1-rc1 (hardknott)
*   16: BSP-Yocto-NXP-i.MX8MM-PD22.1.1-rc2 (hardknott)
*   17: BSP-Yocto-NXP-i.MX8MM-PD22.1.1-rc3 (hardknott)
*   18: BSP-Yocto-NXP-i.MX8MM-PD22.1.1-rc4 (hardknott)
*   19: BSP-Yocto-NXP-i.MX8MM-PD22.1.1 (hardknott)
*   20: BSP-Yocto-NXP-i.MX8MM-PD22.1.y (hardknott)
*   21: BSP-Yocto-NXP-i.MX8MM-PD23.1-rc1 (kirkstone)
*   22: BSP-Yocto-NXP-i.MX8MM-PD23.1-rc2 (kirkstone)
*   23: BSP-Yocto-NXP-i.MX8MM-PD23.1-rc3 (kirkstone)
*   24: BSP-Yocto-NXP-i.MX8MM-PD23.1-rc4 (kirkstone)
*   25: BSP-Yocto-NXP-i.MX8MM-PD23.1-rc5 (kirkstone)
*   26: BSP-Yocto-NXP-i.MX8MM-PD23.1.0 (kirkstone)
*   27: BSP-Yocto-NXP-i.MX8MM-PD23.1.y (kirkstone)
*   28: BSP-Yocto-NXP-i.MX8MM-PD25.1-rc1 (scarthgap)
*   29: BSP-Yocto-NXP-i.MX8MM-PD25.1-rc2 (scarthgap)
*   30: BSP-Yocto-NXP-i.MX8MM-PD25.1.0 (scarthgap)
*   31: BSP-Yocto-NXP-i.MX8MM-PD25.1.1-rc1 (scarthgap)
*   32: BSP-Yocto-NXP-i.MX8MM-PD25.1.y (scarthgap)
*
* $ 30

**Selecting Target Machine**

::

*********************************************************************
* Please choose one of the available builds:
*
* no:                 machine: description and article number
*                             distro: supported yocto distribution
*                             target: supported build target
*
* 1: phyboard-polis-imx8mm-5: PHYTEC phyBOARD-Polis i.MX8M Mini 1-4 GB RAM
*                             Polis PL1532.2(a)/PL1532.3
*                             PB-02820-00I.A6
*                             distro: ampliphy-vendor
*                             target: -c populate_sdk phytec-qt6demo-image
*                             target: phytec-headless-image
*                             target: phytec-qt6demo-image
*                             target: phytec-vision-image
* 2: phyboard-polis-imx8mm-5: PHYTEC phyBOARD-Polis i.MX8M Mini 1-4 GB RAM
*                             Polis PL1532.2(a)/PL1532.3
*                             PB-02820-00I.A6
*                             distro: ampliphy-vendor-rauc
*                             target: phytec-headless-bundle
*                             target: phytec-headless-image
* 3: phyboard-polis-imx8mm-5: PHYTEC phyBOARD-Polis i.MX8M Mini 1-4 GB RAM
*                             Polis PL1532.2(a)/PL1532.3
*                             PB-02820-00I.A6
*                             distro: securiphy-vendor
*                             target: phytec-securiphy-bundle
*                             target: phytec-securiphy-image
* 4: phyboard-polis-imx8mm-5: PHYTEC phyBOARD-Polis i.MX8M Mini 1-4 GB RAM
*                             Polis PL1532.2(a)/PL1532.3
*                             PB-02820-00I.A6
*                             distro: securiphy-vendor-provisioning
*                             target: phytec-provisioning-image
* 5: phygate-tauri-l-imx8mm-2: PHYTEC phyGATE-Tauri-L i.MX8M Mini 2GB RAM
*                             RS232/RS485 16GB eMMC
*                             PB-03420-001.A2, PB-03420-002.A1
*                             distro: ampliphy-vendor
*                             target: phytec-headless-image
* 6: phygate-tauri-l-imx8mm-2: PHYTEC phyGATE-Tauri-L i.MX8M Mini 2GB RAM
*                             RS232/RS485 16GB eMMC
*                             PB-03420-001.A2, PB-03420-002.A1
*                             distro: securiphy-vendor
*                             target: phytec-securiphy-bundle
*                             target: phytec-securiphy-image
* 7: phygate-tauri-l-imx8mm-2: PHYTEC phyGATE-Tauri-L i.MX8M Mini 2GB RAM
*                             RS232/RS485 16GB eMMC
*                             PB-03420-001.A2, PB-03420-002.A1
*                             distro: securiphy-vendor-provisioning
*                             target: phytec-provisioning-image
*
* $ 5

This sets:

::

   MACHINE = "phygate-tauri-l-imx8mm-2"
   DISTRO  = "ampliphy-vendor"

**Build Environment Setup**

Before starting the build, verify host configuration in:

::

   build/conf/local.conf

Your local modifications for the current build are stored here. Depending on the SoC, you might need to accept license agreements. 
For example, to build the image for Freescale/NXP processors you need to accept the GPU and VPU binary license agreements. You have to uncomment the corresponding line:

::

  # Uncomment to accept NXP EULA # EULA can be found under
  ../sources/meta-freescale/EULA ACCEPT_FSL_EULA = "1"
  ACCEPT_FSL_EULA = "1"

Initialize the Yocto build environment:

::

   $ source sources/poky/oe-init-build-env


**Building the Image**

To build the default headless image:

::

   $ bitbake phytec-headless-image

This generates the production-ready image for the
phyGATE-Tauri-L i.MX8MM platform.

Output images will be located under:

::

   build/tmp/deploy/images/phygate-tauri-l-imx8mm-2/

Thin-edge.io Integration
------------------------

**Adding required Thin-edge Layers**

To enable Thin-edge.io support, the following layers must be added:

- meta-tedge
- meta-lts-mixins

**Layer Placement**

Clone both layers inside the ``sources`` directory:

::

   $ cd sources
   $ git clone https://github.com/thin-edge/meta-tedge.git -b scarthgap
   $ git clone https://github.com/thin-edge/meta-lts-mixins -b scarthgap/rust
   
**Add Layers to bblayers.conf**

From the yocto/build directory, run:

::

   $ bitbake-layers add-layer ../sources/meta-tedge/meta-tedge
   $ bitbake-layers add-layer ../sources/meta-tedge/meta-tedge-common
   $ bitbake-layers add-layer ../sources/meta-lts-mixins

**Verify and Check that the layers are Added or Not:**

::

  $ bitbake-layers show-layers
  
::

  phy@phytec:~/yocto-imx8mm-Tauri-L/build$ bitbake-layers show-layers
  NOTE: Starting bitbake server...
  layer                 path                                                                        priority
  ===========================================================================================================
  core                  /home/phytec/tauri-L-test_yocto/sources/poky/../poky/meta                    5
  yocto                 /home/phytec/tauri-L-test_yocto/sources/poky/../poky/meta-poky               5
  openembedded-layer    /home/phytec/tauri-L-test_yocto/sources/poky/../meta-openembedded/meta-oe       5
  networking-layer      /home/phytec/tauri-L-test_yocto/sources/poky/../meta-openembedded/meta-networking  5
  meta-python           /home/phytec/tauri-L-test_yocto/sources/poky/../meta-openembedded/meta-python    5
  multimedia-layer      /home/phytec/tauri-L-test_yocto/sources/poky/../meta-openembedded/meta-multimedia 5
  filesystems-layer     /home/phytec/tauri-L-test_yocto/sources/poky/../meta-openembedded/meta-filesystems  5
  perl-layer            /home/phytec/tauri-L-test_yocto/sources/poky/../meta-openembedded/meta-perl  5
  chromium-browser-layer  /home/phytec/tauri-L-test_yocto/sources/poky/../meta-browser/meta-chromium  7
  clang-layer           /home/phytec/tauri-L-test_yocto/sources/poky/../meta-clang            7
  freescale-layer       /home/phytec/tauri-L-test_yocto/sources/poky/../meta-freescale        5
  freescale-3rdparty    /home/phytec/tauri-L-test_yocto/sources/poky/../meta-freescale-3rdparty  4
  freescale-distro      /home/phytec/tauri-L-test_yocto/sources/poky/../meta-freescale-distro  4
  meta-arm              /home/phytec/tauri-L-test_yocto/sources/poky/../meta-arm/meta-arm     5
  arm-toolchain         /home/phytec/tauri-L-test_yocto/sources/poky/../meta-arm/meta-arm-toolchain  5
  qt6-layer             /home/phytec/tauri-L-test_yocto/sources/poky/../meta-qt6              5
  security              /home/phytec/tauri-L-test_yocto/sources/poky/../meta-security         8
  tpm-layer             /home/phytec/tauri-L-test_yocto/sources/poky/../meta-security/meta-tpm  6
  virtualization-layer  /home/phytec/tauri-L-test_yocto/sources/poky/../meta-virtualization   8
  fsl-bsp-release       /home/phytec/tauri-L-test_yocto/sources/poky/../meta-imx/meta-imx-bsp  8
  fsl-sdk-release       /home/phytec/tauri-L-test_yocto/sources/poky/../meta-imx/meta-imx-sdk  8
  imx-machine-learning  /home/phytec/tauri-L-test_yocto/sources/poky/../meta-imx/meta-imx-ml  8
  imx-demo              /home/phytec/tauri-L-test_yocto/sources/poky/../meta-nxp-demo-experience  7
  rauc                  /home/phytec/tauri-L-test_yocto/sources/poky/../meta-rauc             6
  phytec                /home/phytec/tauri-L-test_yocto/sources/poky/../meta-phytec           20
  ampliphy              /home/phytec/tauri-L-test_yocto/sources/poky/../meta-ampliphy         10
  qt6-phytec            /home/phytec/tauri-L-test_yocto/sources/poky/../meta-qt6-phytec       11
  meta-tedge            /home/phytec/tauri-L-test_yocto/sources/poky/../meta-tedge/meta-tedge  6
  meta-tedge-common     /home/phytec/tauri-L-test_yocto/sources/poky/../meta-tedge/meta-tedge-common  6
  scarthgap-rust-mixin  /home/phytec/tauri-L-test_yocto/sources/poky/../meta-lts-mixins       6  
  
**To avoid update-rc.d / SysVinit Conflict**:

.. error:: 
   inherits update-rc.d but doesn't set INITSCRIPT_NAME
   
Disable SysVinit in Yocto/build/conf/local.conf:

::
  
  #Disable SysVinit explicitly
  DISTRO_FEATURES:remove = " sysvinit"
  
Tauri-L Thin-Edge Standard Release Patch Integration
----------------------------------------------------

This section describes the official method used to integrate Thin-edge modifications into the Tauri-L i.MX8MM BSP release.

Since ``meta-phytec`` is a maintained internal vendor layer, patches are applied directly using the controlled automation script.

**Release Version**

Target BSP:

::

   BSP-Yocto-NXP-i.MX8MM-PD25.1.0

Thin-Edge Release Tag:

::

   Te-PD-25.1.0

**Note:** Please find the patches and the setup script in the 
`thin-edge-demo <https://github.com/phytec-india/thin-edge-demo/tree/main/bsp>`_ 
GitHub repository.

**Directory Structure**

Inside the BSP root directory:

::

   bsp/
   ├── patches
   │   ├── 0001-Add-Te-PD-25.1.0-and-custom-headless-image-modificat.patch
   │   └── 0002-meta-tpm-Fix-tpm2-tss-engine-build-issue.patch
   ├── Release-Notes-Tauri-L_i.MX8MM-Thin-Edge
   └── setupTE.sh

**Patch Repository**

All official release patches and automation scripts are hosted in the
internal release repository.

Link:

::

   https://<internal-git-server>/Tauri-L/Te-PD-25.1.0-release

The repository must contain:

- Version-tagged patches
- setupTE.sh script
- Release notes

**Applying Patches**

Make the script executable & Execute:

::

   $ chmod +x setupTE.sh
   $ ./setupTE.sh

Expected Output:

::

   ==============================================
    Applying Layer Patches for Te-PD-25.1.0
   ==============================================

   Checking Patch 0001 (meta-phytec)...
   Patch 0001 applied successfully.

   Checking Patch 0002 (meta-security)...
   Patch 0002 applied successfully.

   ==============================================
    All required patches processed successfully.
   ==============================================

Whitespace warnings may appear but do not impact functionality.

Patch Scope
-----------

**Patch 0001**

Layer: ``meta-phytec``

Purpose:

- Add Te-PD-25.1.0 support
- Modify phytec-headless-image
- Integrate Thin-edge components
- Add required configuration updates

**Patch 0002**

Layer: ``meta-security/meta-tpm``

Purpose:

- Fix tpm2-tss-engine build issue
- Ensure compatibility with scarthgap toolchain

**Build After Patch Application**

Initialize build environment:

::

   $ source poky/oe-init-build-env build

Build image:

::

   $ bitbake phytec-headless-image

Verification
------------

Verify new directory inside meta-phytec:

::

   $ ls sources/meta-phytec/Te-PD-25.1.0

Verify TPM fix modification:

::

   $ vi sources/meta-security/meta-tpm/recipes-tpm2/tpm2-tss-engine/tpm2-tss-engine_1.1.0.bb

Flashing and Initial Setup of Tauri-L Device
--------------------------------------------

step-by-step instructions for flashing the Thin-Edge image to your Tauri-L device and performing the initial setup.

**Prerequisites:**

- A microSD card (minimum 8GB recommended)
- SD card reader/writer
- Access to the Thin-Edge.wic image from OneDrive
- Linux PC with network connectivity
- Ethernet cable
- Tauri-L device

**Downloading and Flashing the Image**

1. Download the release image for Tauri-L i.MX8MM from `Thin-edge Demo - Version 0.1.0 <https://github.com/phytec-india/thin-edge-demo/releases/tag/v0.1.0>`_ and extract the release file to get the .wic.xz image.

.. warning::

   Make sure to verify the integrity of the downloaded image before flashing.

2. Write the image to the SD card using the `xzcat` command. Replace `<your_device>` with your SD card device (e.g., sdb, mmcblk0).

.. code-block:: shell

   xzcat phytec-headless-image-phygate-tauri-l-imx8mm-2.rootfs.wic.xz | sudo dd of=/dev/sd* bs=1M conv=fsync status=progress

.. warning::

   Double-check the device name to avoid overwriting the wrong drive. You can use `lsblk` command to identify your SD card device.

**Hardware Setup**

3. Insert the flashed SD card into the Tauri-L device and power it on.

4. Connect an ethernet cable to the LAN2 port of the Tauri-L device.

.. note::

   Port mapping on Tauri-L:
   
   - MAC1 corresponds to LAN2
   - MAC2 corresponds to LAN1

**Hardware Device Connection**

5. Locate the MAC address on the top label of your Tauri-L device.

6. Connect your PC to the same network and scan for devices using:

.. code-block:: shell

   sudo arp-scan --interface=<your_interface> --localnet

.. note::

   Replace `<your_interface>` with your network interface name (e.g., enp2s0, eth0).
   You can find your interface name using `ip link show` command.

7. Find your Tauri-L's MAC address in the scan output to identify its IP address.

**Initial Access**

8. Connect to the Tauri-L device via SSH:

.. code-block:: shell

   ssh root@<Tauri-L_IP_address>

Verify Thin-edge installation after flashing:

::

   root@device:~# tedge --version
   root@device:~# systemctl status tedge-agent
  
