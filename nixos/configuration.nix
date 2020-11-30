# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz}/nixos")
    ];


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Add ZFS Support
  boot.supportedFilesystems = ["zfs"];
  boot.zfs.requestEncryptionCredentials = true;

  # Host ID and Hostname
  networking.hostId = "8ed2bc4a";
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Boot latest linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Set your time zone.
  time.timeZone = "America/Denver";

  # Fonts
  fonts.fonts = with pkgs; [
    fira
    fira-code
    powerline-fonts
    inconsolata
    corefonts
  ];
  
  # Allow Unfree packages
  nixpkgs.config.allowUnfree = true;

  # To use lorri for development
  services.lorri.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.

  # Network Interfaces
  networking.useDHCP = false;
  networking.interfaces.enp0s25.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;
  networking.networkmanager.enable = true;  
  
  # Wireguard 
  networking.wireguard.enable = true;
  services.mullvad-vpn.enable = true;
  networking.iproute2.enable = true; 

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable the Plasma 5 Desktop Environment.
  #services.xserver.enable = true;
  #services.xserver.displayManager.sddm.enable = true;
  #services.xserver.desktopManager.plasma5.enable = true;
  
  # Enable Gnome Desktop
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome3.enable = true;

  # Enable XFCE 
  # services.xserver.desktopManager.xfce.enable = true;
  # services.xserver.displayManager.defaultSession = true;

  #services.picom = {
  #  enable = true;
  #  fade = true;
  #  inactiveOpacity = 0.9;
  #  shadow = true;
  #  fadeDelta = 4;
  #};

  # Enable X11
  services.xserver.enable = true;
  services.xserver.layout = "us";

  # ZFS Services
  services.zfs.autoSnapshot.enable = true;
  services.zfs.autoScrub.enable = true;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  services.xserver.libinput = {
    enable = true;
    NaturalScrolling = true;
    ClickMethod = "clickfinger";
    additionalOptions = ''MatchIsTouchpad "on" '';
  };

  # Home-Manager
  home-manager.users.franz = { pkgs, ... }: {
  home.packages = [ pkgs.atool pkgs.weechat ];
  programs.bash.enable = true;
  };
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.franz = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "disk" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    
    # Command Line Tools
    wget
    neovim
    man
    gitAndTools.gitFull
    mullvad-vpn
    ranger
    syncthing
    tree
    neofetch
    mkpasswd
    zsh
    oh-my-zsh
     
    # GUI Applications
    firefox
    picom
    gnome3.gnome-tweaks
    gnome3.dconf-editor
  ];

  # oh-my-zsh Configuration
  programs.zsh.enable = true;
  programs.zsh.interactiveShellInit = ''
    export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh/

    # Customize oh-my-zsh options
    ZSH_THEME="norm"
    plugins=(git docker)
    bindkey '\e[5~' history-beginning-search-backward
    bindkey '\e[6~' history-beginning-search-forward

    HISTFILESIZE=500000
    HISTSIZE=500000
    setopt SHARE_HISTORY
    setopt HIST_IGNORE_ALL_DUPS
    setopt HIST_IGNORE_DUPS
    setopt INC_APPEND_HISTORY
    autoload -U compinit && compinit
    unsetopt menu_complete
    setopt completealiases

    if [ -f ~/.aliases ]; then
      source ~/.aliases
    fi

    source $ZSH/oh-my-zsh.sh
  '';
  programs.zsh.promptInit = "";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # TLP Power Management
  services.tlp.enable = true;

  # Flatpak Support
  #services.flatpak.enable = true;  
  
  ##### - might need edits
  # xdg.portal.enable = true;

  #Syncthing Configuration
  services = {
     syncthing = {
        enable = true;
	user = "franz";
	dataDir = "/home/franz/Sync";
	configDir = "/home/franz/.config/syncthing";
     };
  };
  #
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
  system.stateVersion = "20.09"; # Did you read the comment?

}

