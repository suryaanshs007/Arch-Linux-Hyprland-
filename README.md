#  Arch Linux ARM · Hyprland Dotfiles

> *Built on a MacBook Air M4, from scratch, with patience, broken configs, and too many late nights.*

---

##  System

| | |
|---|---|
| **Host Machine** | MacBook Air M4 (16GB RAM, 256GB SSD, 2025) |
| **Hypervisor** | UTM (Apple Virtualization Framework) |
| **Storage** | 1TB Lexar USB 3.2 Gen 2x2 External SSD |
| **Distro** | Arch Linux ARM (aarch64) |
| **WM** | Hyprland |
| **Bar** | Waybar |
| **Terminal** | Foot |
| **Browser** | LibreWolf |
| **Launcher** | Rofi |
| **Editor** | Neovim + LazyVim |
| **Shell** | Zsh |

---

##  Contents:

```
dotfiles/
├── hypr/          # Hyprland config
├── waybar/        # Waybar config + style
├── foot/          # Foot terminal config
└── nvim/          # Neovim + LazyVim config
```

---

##  The Journey:

### Why this exists

I have a MacBook Air M4 with 256GB of storage. The 512GB upgrade at purchase was a ₹10,000 premium. Instead I bought a 1TB Lexar external SSD for ₹8,000 and it sat unused for six months.

One day I decided to actually use it.

---

### Setting up UTM

UTM is a free virtualisation app for macOS that uses Apple's native Hypervisor framework. The key thing on Apple Silicon is choosing **Virtualize** over **Emulate**, virtualization runs ARM64 Linux natively at near-native performance. Emulation translates x86 instructions, which is slow.

Downloaded UTM from [getutm.app](https://getutm.app) (free). The App Store version is paid for the exact same thing.

Moved the VM storage location to the external SSD so nothing touches the Mac's internal 256GB.

---

### Why Arch and not something easier

Went through the full decision tree:
- **Ubuntu** — too simple, wanted to actually learn
- **Manjaro** — considered it as an Arch-based middle ground
- **Fedora Workstation** — almost settled here, has official ARM64 ISO
- **Arch Linux ARM** — the actual goal

The reason I ended up with Arch: I wanted to understand Linux, not just use it. Arch forces you to build the system yourself. Every component you install, you chose. Every config file, you wrote. There's no magic happening behind the scenes.

---

### The Fedora Bootstrap Method

Here's the problem: Arch Linux ARM doesn't ship a traditional bootable ISO for ARM64. The standard Arch ISO is x86_64 only.

The solution: use **Fedora ARM** as a live environment to bootstrap Arch from within.

Fedora has an official `aarch64` ISO that UTM boots cleanly in Virtualize mode. Once inside Fedora's terminal, you're running a live ARM64 Linux environment — exactly what you need to install Arch manually.

Fedora is just scaffolding. After installation it's completely gone.

---

### Partitioning

Booted into Fedora Workstation 45, opened terminal, ran `lsblk` to identify the virtual disk:

```
vda    64G   → target disk (empty)
sr0    2.5G  → Fedora ISO (do not touch)
```

Partitioned `vda` with `cfdisk`:

```
/dev/vda1   512M    EFI System
/dev/vda2   8G      Linux swap
/dev/vda3   55.5G   Linux filesystem
```

Formatted each partition:

```bash
sudo mkfs.fat -F32 /dev/vda1
sudo mkswap /dev/vda2
sudo mkfs.ext4 /dev/vda3
```

Mounted everything:

```bash
sudo mount /dev/vda3 /mnt
sudo mkdir /mnt/boot
sudo mount /dev/vda1 /mnt/boot
sudo swapon /dev/vda2
```

---

### Installing Arch Linux ARM

Downloaded the aarch64 tarball:

```bash
wget http://os.archlinuxarm.org/os/ArchLinuxARM-aarch64-latest.tar.gz
```

Extracted it into the mounted root partition:

```bash
sudo bsdtar -xpf ArchLinuxARM-aarch64-latest.tar.gz -C /mnt
```

Mounted the necessary virtual filesystems and chrooted in:

```bash
sudo mount --bind /dev /mnt/dev
sudo mount -t proc proc /mnt/proc
sudo mount -t sysfs sys /mnt/sys
sudo mount -t devpts devpts /mnt/dev/pts
sudo chroot /mnt /bin/bash
```

Inside the chroot: initialised the pacman keyring, updated the system, configured locale, hostname, timezone, root password, created a user, installed and configured the bootloader.

Exited the chroot, unmounted everything, rebooted.

Arch Linux ARM booted.

---

### Installing Hyprland

After confirming the base system worked, installed Hyprland and the essential components:

```bash
sudo pacman -S hyprland waybar foot rofi
```

Added display manager, audio via PipeWire, and network management. Configured `hyprland.conf` from scratch.

---

### The Rice

This is where the real time went.

**Waybar** : custom modules for workspaces, clock, volume, network, CPU. Configured through `config.jsonc` and `style.css`.

**Foot** : translucent terminal with custom colours. Config at `~/.config/foot/foot.ini`.

**Hyprglass** : A tool to add an immediate glass-effect
to the terminal windows, it can be installed through hyprpm <em>(make sure hyprm's headers are fully updated, run `hyprpm update`)</em> using the following command in the terminal:
`hyprpm add https://github.com/hyprnux/hyprglass`

**Rofi** : application launcher with blur and custom theme matching the rest of the setup.

**Wallpapers** : rotated through several, managed via `swww`.

**Wallpaper script** : A constantly running loop that executes after an interval of 10 minutes, picking a random wallpaper.

**Matugen** : A tool that automatically picks out a colour palette based on the current wallpaper, applying it dynamically to the waybar.

The aesthetic direction: dark, detailed, Japanese-influenced artwork. High contrast, moody.

At one point I was correcting the AI assistant's Hyprland syntax because it kept giving me deprecated config options. That's when I realised I actually understood what I was doing.

---

### The Git Mess (and how i fixed it):

Setting up this dotfiles repo was its own adventure.
A simple git mistake turned into a full system meltdown.

I accidentally pushed my Hyprland dotfiles to master instead of main. To fix it, I ran a rebase pull and somehow, that wiped my hyprland.conf and the entire hypr config directory clean off my system. My wallpaper scripts, theme switcher, keybinds, all gone. Hyprland panicked, triggered its fallback mechanism, and regenerated a bare-bones boilerplate config. My entire setup went haywire.

To make it worse, my terminal keybind had remapped to the default Cmd+Q, which macOS immediately hijacks, threatening to close the window. I was completely locked out of my own system. Eight days of work, gone.

But I had one fallback: **GNOME**.

I logged out of Hyprland, switched to GNOME, and opened its terminal. From there, I traced the issue, my files hadn't vanished entirely. They'd been pushed to master, not main. I could still see them in GitHub's branch comparison view.

So I rebuilt everything manually. Opened Neovim, recreated the .config/hypr directory structure, and copy-pasted each file back from that GitHub window: hyprland.conf, hyprlock.conf, all my scripts, and the wallpaper folder. Once the structure was restored, I logged back into Hyprland.

It was all back.

One last thing: my wallpaper script wasn't running. Turned out I hadn't made it executable again. A quick chmod +x and everything was back exactly as I'd left it.

The lesson? Always have a fallback session manager. Always verify your git remote before pushing. And never underestimate how far systematic debugging can take you when you stay calm and think through the problem. Most importantly, do NOT be stupid enough to push straight from .config, there's a reason dot files are hidden when a normal "ls" command is passed in the terminal.

No AI. No Stack Overflow. Just pattern recognition and not giving up.

**Problem 2: Divergent branches on pull**

The GitHub repo had a README committed remotely that my local repo didn't have. Running `git pull` without specifying reconciliation strategy gave:

```
fatal: Need to specify how to reconcile divergent branches.
```

Fix:
```bash
git pull origin main --allow-unrelated-histories --no-rebase
```

This merged the remote README into the local branch, resolved the conflict, then pushed cleanly.

---

##  What's Next:

- Rebuild the entire setup from scratch without guides or AI to develop genuine understanding
- Migrate `hyprland.conf` to Lua (the new standard)
- Replace Waybar + Rofi with **QuickShell** for a more modern setup
- Daily drive Linux on bare metal once I get a ThinkPad
- Dual boot immediately on any Windows machine I get (because hyrpland + lazyvim feels incredible).

---

## 📝 Notes

- Everything runs inside UTM on an M4 Mac. Performance is smooth for development and terminal work. Media playback and Spotify stay on macOS natively.
- Foot terminal is used over Kitty/Alacritty due to hardware acceleration restrictions in the VM environment. Foot is Wayland-native and works perfectly.

---

*Started because a 1TB SSD was collecting dust. Ended up learning more Linux in one week than I had in years.*
