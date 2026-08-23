DISTRO=$(grep -E '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')

case "$DISTRO" in
    fedora)
        echo "You are using a fedora-based distro."
        echo "(*) Installing dependencies and needed packages..."
        sudo dnf copr enable lyh/maple-mono
        sudo dnf install curl wget git coreutils make fish maple-mono-fonts nvim
        echo "(*) Installing vxwm dotfiles"
        echo "-- Step 1.1: Go to the vxwm directory where to compile VXWM..."
        cd ~/vxwm-dots/COMPILE/vxwm/
        echo "(*) Installing compilation dependencies...)"
        sudo dnf groupinstall -y "Development Tools" && sudo dnf install -y \
        meson ninja-build pkgconfig pixman-devel libX11-devel \
        libXext-devel libXft-devel libXinerama-devel libconfig-devel \
        dbus-devel libglvnd-devel libepoxy-devel pcre2-devel \
        libev-devel uthash-devel libxcb-devel xcb-util-devel \
        xcb-util-image-devel xcb-util-renderutil-devel
        echo "-- Step 2: Compile VXWM..."
        make
        sudo make clean install
        echo "-- Step 2.5: Go to the picom directory where to compile yshui's picom..."
        cd ~/vxwm-dots/COMPILE/picom/
        echo "(+) Compilation dependencies done."
        echo "-- Step 3: Compile picom..."
        pwd
        meson setup --buildtype=release build
        ninja -C build
        sudo ninja -C build install
        echo "-- Step 4: Install matugen, kitty, etc..."
        sudo dnf install matugen kitty rofi dmenu
        echo "-- Step 5: Go back to the root vxwm-dots directory..."
        cd ~/vxwm-dots
        echo "-- Step 6: Create the configuration folders (in case there is none)..."
        mkdir -p ~/.config
        mkdir -p ~/.config/kitty
        mkdir -p ~/.config/picom
        echo "-- Step 6.5: Remove whats inside them to prevent conflicts..."
        rm -rf ~/.config/kitty/*
        rm -rf ~/.config/picom/*
        echo "-- Step 7: Install the dotfiles into our programs"
        cp ~/vxwm-dots/.config/kitty/kitty.conf ~/.config/kitty/
        cp ~/vxwm-dots/.config/picom/picom.conf ~/.config/picom/
        cp -r ~/vxwm-dots/.config/matugen/ ~/.config/
        echo "-- Step 8: Update"
        sudo dnf upgrade --refresh
        sudo dnf autoremove
        echo "-- Step 9: Update font cache once again"
        fc-cache -f -v
        echo "Done. if this install broke, install everything manually or tell us at github.com/theskepticpillow/vxwm-dots"
        ;;
    linuxmint|ubuntu|debian)
        echo "You are using a debian-based distro."
        echo "(*) Installing dependencies and needed packages..."
        sudo apt install curl wget git make coreutils fish nvim
        sudo apt update && sudo apt install -y \
        build-essential git meson ninja-build ccache pkg-config \
        libx11-dev libx11-xcb-dev libxcb1-dev libxcb-composite0-dev \
        libxcb-damage0-dev libxcb-glx0-dev libxcb-image0-dev \
        libxcb-present-dev libxcb-randr0-dev libxcb-render0-dev \
        libxcb-render-util0-dev libxcb-shape0-dev libxcb-util-dev \
        libxcb-xfixes0-dev libxext-dev libpixman-1-dev libconfig-dev \
        libdbus-1-dev libgl-dev libegl-dev libepoxy-dev libpcre2-dev \
        libev-dev uthash-dev libxft-dev libinerama-dev
        echo "(*) Installing Maple Mono font"
        echo "-- Step 1: Creating directory in ~/.local/share/fonts..."
        mkdir -p ~/.local/share/fonts/maple-mono
        echo "-- Step 2: Downloading the TrueType .zip file with the Maple Mono font family..."
        wget https://github.com/subframe7536/maple-font/releases/download/v7.9/MapleMono-TTF.zip -O /tmp/MapleMono-TTF.zip
        echo "-- Step 3: Unzipping the .zip file and copying the contents to the directory we made in Step 1..."
        unzip /tmp/MapleMono-TTF.zip -d ~/.local/share/fonts/maple-mono/
        echo "-- Step 4: Updating font cache..."
        fc-cache -f -v
        echo "-- Step 5: Deleting the .zip file..."
        rm /tmp/MapleMono-TTF.zip
        echo "(+) Maple Mono installation done."
        sleep 0.6
        echo "(*) Installing vxwm dotfiles"
        echo "-- Step 1: Go to the vxwm directory where to compile VXWM..."
        cd ~/vxwm-dots/COMPILE/vxwm/
        echo "-- Step 2: Compile VXWM..."
        make
        sudo make clean install
        echo "-- Step 3.5: Go to the picom directory where to compile yshui's picom..."
        cd ~/vxwm-dots/COMPILE/picom/
        echo "-- Step 3: Compile picom..."
        pwd
        meson setup --buildtype=release build
        ninja -C build
        sudo ninja -C build install
        echo "-- Step 4: Install matugen, kitty, etc..."
        sudo apt install matugen kitty rofi dmenu
        echo "-- Step 5: Go back to the root vxwm-dots directory..."
        cd ~/vxwm-dots
        echo "-- Step 6: Create the configuration folders (in case there is none)..."
        mkdir -p ~/.config
        mkdir -p ~/.config/kitty
        mkdir -p ~/.config/picom
        echo "-- Step 6.5: Remove whats inside them to prevent conflicts..."
        rm -rf ~/.config/kitty/*
        rm -rf ~/.config/picom/*
        echo "-- Step 7: Install the dotfiles into our programs"
        cp ~/vxwm-dots/.config/kitty/kitty.conf ~/.config/kitty/
        cp ~/vxwm-dots/.config/picom/picom.conf ~/.config/picom/
        cp -r ~/vxwm-dots/.config/matugen/ ~/.config/
        echo "-- Step 8: Update"
        sudo apt update && sudo apt upgrade --refresh
        sudo apt autoremove
        echo "-- Step 9: Update font cache once again"
        fc-cache -f -v
        echo "Done. if this install broke, install everything manually or tell us at github.com/theskepticpillow/vxwm-dots"
        ;;
    void)
        echo "You are using void, very good taste!"
        echo "(*) Installing dependencies and needed packages..."
        sudo xbps-install -Sy curl wget git fish coreutils make nvim
        sudo xbps-install -Sy \
        base-devel git meson ninja pkg-config \
        libX11-devel libXext-devel libXft-devel libXinerama-devel \
        pixman-devel libconfig-devel dbus-devel libepoxy-devel \
        pcre2-devel libev-devel uthash \
        libxcb-devel xcb-util-devel xcb-util-image-devel xcb-util-renderutil-devel
        echo "(*) Installing Maple Mono font" 
        echo "-- Step 1: Creating directory in ~/.local/share/fonts..."
        mkdir -p ~/.local/share/fonts/maple-mono
        echo "-- Step 2: Downloading the TrueType .zip file with the Maple Mono font family..."
        wget https://github.com/subframe7536/maple-font/releases/download/v7.9/MapleMono-TTF.zip -O /tmp/MapleMono-TTF.zip
        echo "-- Step 3: Unzipping the .zip file and copying the contents to the directory we made in Step 1..."
        unzip /tmp/MapleMono-TTF.zip -d ~/.local/share/fonts/maple-mono/
        echo "-- Step 4: Updating font cache..."
        fc-cache -f -v
        echo "-- Step 5: Deleting the .zip file..."
        rm /tmp/MapleMono-TTF.zip
        echo "(+) Maple Mono installation done."
        sleep 0.6
        echo "(*) Installing vxwm dotfiles"
        echo "-- Step 1: Go to the vxwm directory where to compile VXWM..."
        cd ~/vxwm-dots/COMPILE/vxwm/
        echo "-- Step 2: Compile VXWM..."
        make
        sudo make clean install
        echo "-- Step 2.5: Go to the picom directory where to compile yshui's picom..."
        cd ~/vxwm-dots/COMPILE/picom/
        echo "-- Step 3: Compile picom..."
        pwd
        meson setup --buildtype=release build
        ninja -C build
        sudo ninja -C build install
        echo "-- Step 4: Install matugen, kitty, etc..."
        sudo xbps-install -Sy matugen kitty rofi dmenu
        echo "-- Step 5: Go back to the root vxwm-dots directory..."
        cd ~/vxwm-dots
        echo "-- Step 6: Create the configuration folders (in case there is none)..."
        mkdir -p ~/.config
        mkdir -p ~/.config/kitty
        mkdir -p ~/.config/picom
        echo "-- Step 6.5: Remove whats inside them to prevent conflicts..."
        rm -rf ~/.config/kitty/*
        rm -rf ~/.config/picom/*
        echo "-- Step 7: Install the dotfiles into our programs..."
        cp ~/vxwm-dots/.config/kitty/kitty.conf ~/.config/kitty/
        cp ~/vxwm-dots/.config/picom/picom.conf ~/.config/picom/
        cp -r ~/vxwm-dots/.config/matugen/ ~/.config/
        echo "-- Step 8: Update"
        sudo xbps-install -Su
        echo "-- Step 9: Update font cache once again"
        fc-cache -f -v
        echo "Done. if this install broke, install everything manually or tell us at github.com/theskepticpillow/vxwm-dots"
        ;;
    nixos)
        echo "You are using NixOS. Some of you make my life more complicated..."
        echo "(*) Creating COMPILE/nixos folder..."
        mkdir -p COMPILE/nixos
        echo "(+) Created COMPILE/nixos folder."
        sleep 0.3
        echo "(*) Generating picom.nix..."
        cat << 'EOF' > COMPILE/nixos/picom.nix
{ pkgs, ... }:

{
  services.picom = {
    enable = true;
    
    package = pkgs.picom;

    # O NixOS lê as configurações extras em formato de string ou atributos.
    # Como você usa o Matugen, você pode apontar para o seu arquivo gerado futuramente
    # ou injetar as regras básicas do yshui aqui:
    settings = {
      # rendering
      backend = "glx";
      use-damage = true;
        vsync = true;
        
        # window rules
        mark-wmwin-focused = true;
        mark-ovl-redir-focused = true;
        detect-rounded-corners = true;
        detect-client-opacity = true;
        detect-transient = true;
        detect-client-leader = true;
        
        # transparency
        opacity-rule = [
          "76:class_g = 'kitty'"
        ];
        
        # blur
        blur-method = "dual_kawase";
        blur-strength = 2.3;
        blur-background = true;
        blur-background-frame = false;
        blur-background-fixed = false;
        blur-background-exclude = [
          "window_type = 'dock'",
          "window_type = 'desktop'",
        ];
        
        # animation
        animations = (
          {
            triggers = ["open", "show"];
            
            # width scale
            scale-x = {
              curve = "cubic-bezier(0.175, 0.885, 0.32, 1.35)";
              duration = 0.35;
              start = 0.8;
              end = 1.0;
            };
            
            # height scale
            scale-y = {
              curve = "cubic-bezier(0.175, 0.885, 0.32, 1.35)";
              duration = 0.35;
              start = 0.8;
              end = 1.0;
            };
            
            # fade in opacity
            opacity = {
              curve = "linear";
              duration = 0.25;
              start = 0.0;
              end = 1.0;
            };
          },
          {
            triggers = ["close", "hide"];
            
            # inward pull
            scale-x = {
              curve = "cubic-bezier(0.6, -0.28, 0.735, 0.045)";
              duration = 0.2;
              start = 1.0;
              end = 0.8;
            };
            scale-y = {
              curve = "cubic-bezier(0.6, -0.28, 0.735, 0.045)";
              duration = 0.2;
              start = 1.0;
              end = 0.8;
            };
            opacity = {
              curve = "linear";
              duration = 0.2;
              start = 1.0;
              end = 0.0;
            };
          }
        );
        
        # window type overrides
        wintypes = {
          tooltip = { fade = true; shadow = true; opacity = 0.75; focus = true; full-shadow = false; };
          dock = { shadow = false; clip-shadow-above = true; }
          dnd = { shadow = false; }
          popup_menu = { opacity = 0.9; }
          dropdown_menu = { opacity = 0.9; }
            };
          };
          environment.systemPackages = [ pkgs.picom ];
        }
EOF
        echo "(+) File 'picom.nix' generated in COMPILE/nixos/"
        sleep 0.5
        echo "(*) Instructions:"
        sleep 1
        echo "    To apply, add './COMPILE/nixos/picom.nix' on the array 'imports' of your configuration.nix"
        echo "    Then run: sudo nixos-rebuild switch"
        sleep 8
        ;;

        echo "Distro not listed explictly ($DISTRO)."
        ;;
esac
