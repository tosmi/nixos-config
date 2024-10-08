# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      "${builtins.fetchTarball "https://github.com/nix-community/disko/archive/master.tar.gz"}/module.nix"
      ./disk-config.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "lightbook"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_AT.UTF-8";
    LC_IDENTIFICATION = "de_AT.UTF-8";
    LC_MEASUREMENT = "de_AT.UTF-8";
    LC_MONETARY = "de_AT.UTF-8";
    LC_NAME = "de_AT.UTF-8";
    LC_NUMERIC = "de_AT.UTF-8";
    LC_PAPER = "de_AT.UTF-8";
    LC_TELEPHONE = "de_AT.UTF-8";
    LC_TIME = "de_AT.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };


  services.udev.extraRules = ''
# Rules for Oryx web flashing and live training
KERNEL=="hidraw*", ATTRS{idVendor}=="16c0", MODE="0664", GROUP="wheel"
KERNEL=="hidraw*", ATTRS{idVendor}=="3297", MODE="0664", GROUP="wheel"

# Legacy rules for live training over webusb (Not needed for firmware v21+)
# Rule for all ZSA keyboards
SUBSYSTEM=="usb", ATTR{idVendor}=="3297", GROUP="wheel"
 # Rule for the Moonlander
SUBSYSTEM=="usb", ATTR{idVendor}=="3297", ATTR{idProduct}=="1969", GROUP="wheel"
# Rule for the Ergodox EZ
SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="1307", GROUP="wheel"
# Rule for the Planck EZ
SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="6060", GROUP="wheel"

# Wally Flashing rules for the Ergodox EZ
ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1"
ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", ENV{MTP_NO_PROBE}="1"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789ABCD]?", MODE:="0666"
KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", MODE:="0666"

# Keymapp / Wally Flashing rules for the Moonlander and Planck EZ
SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE:="0666", SYMLINK+="stm32_dfu"
# Keymapp Flashing rules for the Voyager
SUBSYSTEMS=="usb", ATTRS{idVendor}=="3297", MODE:="0666", SYMLINK+="ignition_dfu"
'';

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # zsa keyboard support
  hardware.keyboard.zsa.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pinhead = {
    isNormalUser = true;
    description = "Toni Schmidbauer";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "lp"];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    ivpn
    ivpn-service
  #  wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  services.tailscale.enable = true;
  services.flatpak.enable = true;

  programs.virt-manager.enable = true;

  virtualisation = {
    libvirtd = {
       enable = true;
       qemu = {
         package = pkgs.qemu_kvm;
         runAsRoot = true;
         swtpm.enable = true;
         ovmf = {
           enable = true;
           packages = [(pkgs.OVMF.override {
             secureBoot = true;
             tpmSupport = true;
            }).fd];
         };
       };
    };

    containers.enable = true;
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  services.fwupd.enable = true;

  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  services.avahi.openFirewall = true;

  # required for jetbrains tools
  # https://wiki.nixos.org/wiki/Jetbrains_Tools
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
     SDL
     SDL2
     SDL2_image
     SDL2_mixer
     SDL2_ttf
     SDL_image
     SDL_mixer
     SDL_ttf
     alsa-lib
     at-spi2-atk
     at-spi2-core
     atk
     bzip2
     cairo
     cups
     curlWithGnuTls
     dbus
     dbus-glib
     desktop-file-utils
     e2fsprogs
     expat
     flac
     fontconfig
     freeglut
     freetype
     fribidi
     fuse
     fuse3
     gdk-pixbuf
     glew110
     glib
     gmp
     gst_all_1.gst-plugins-base
     gst_all_1.gst-plugins-ugly
     gst_all_1.gstreamer
     gtk2
     harfbuzz
     icu
     keyutils.lib
     libGL
     libGLU
     libappindicator-gtk2
     libcaca
     libcanberra
     libcap
     libclang.lib
     libdbusmenu
     libdrm
     libgcrypt
     libgpg-error
     libidn
     libjack2
     libjpeg
     libmikmod
     libogg
     libpng12
     libpulseaudio
     librsvg
     libsamplerate
     libsecret
     libthai
     libtheora
     libtiff
     libudev0-shim
     libusb1
     libuuid
     libvdpau
     libvorbis
     libvpx
     libxcrypt-legacy
     libxkbcommon
     libxml2
     mesa
     nspr
     nss
     openssl
     p11-kit
     pango
     pixman
     python3
     speex
     stdenv.cc.cc
     tbb
     udev
     vulkan-loader
     wayland
     xorg.libICE
     xorg.libSM
     xorg.libX11
     xorg.libXScrnSaver
     xorg.libXcomposite
     xorg.libXcursor
     xorg.libXdamage
     xorg.libXext
     xorg.libXfixes
     xorg.libXft
     xorg.libXi
     xorg.libXinerama
     xorg.libXmu
     xorg.libXrandr
     xorg.libXrender
     xorg.libXt
     xorg.libXtst
     xorg.libXxf86vm
     xorg.libpciaccess
     xorg.libxcb
     xorg.xcbutil
     xorg.xcbutilimage
     xorg.xcbutilkeysyms
     xorg.xcbutilrenderutil
     xorg.xcbutilwm
     xorg.xkeyboardconfig
     xz
     zlib
   ];
}
