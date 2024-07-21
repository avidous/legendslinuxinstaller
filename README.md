# legendslinuxinstaller 🍁

**Build Status: Pre-Alpha🍌** 

legendslinuxinstaller: A soon to-be MapleLegends Linux installer, launcher, toolbox, and configurator.

This installer is a bash script that automatically extracts the ML Wineskin, downloads (most) needed dependencies, sets up a custom wine prefix and creates a basic launcher. 

🛑 Pre-Reqs
- Linux System running Wayland. (Steam Deck Included!)
- MapleLegends MAC Wineskin Download

✅ Works
- Installs ML from the Wineskin with user prompts.
- Sets up the Wine Envrionment including Core Fonts in a separate wine prefix
- Creates a basic startlegends script in the install directory.
- lutris support

🚫 Doesn't Work/Todo
- TODO: X11 & Wayland HD2 support in progress.
    - Both involve running a second wine prefix with desktop emulation. This is planned.
- TODO: Auto-Audio Driver support. Need to create scripts to check for lib32 alsa/pipewire dependencies.
- TODO: Create configurable multiclient settings and environment.
- TODO: Create system bin for execution
- TODO: Create formal launcher.


## Installation
### curl
You can the following script in terminal to download and run the install script.
```
curl -o legendsinstaller.sh https://raw.githubusercontent.com/avidous/legendslinuxinstaller/main/legendsinstaller.sh &&
chmod +x legendsinstaller.sh &&
./legendsinstaller.sh
```

### Git Clone
1. Ensure that `git` is installed on your system.
2. Navigate to any directory to download the install script.
3. Use `git clone` to download the repository.
4. Mark `legendsinstaller.sh` as executable with `chmod +x legendsinstaller.sh`
5. Run `legendsinstaller.sh` with `./legendsinstaller.sh`

### Git Clone Script

Alternatively use this git clone script to run the installer.

```
git clone https://github.com/avidous/legendslinuxinstaller &&
cd ./legendslinuxinstaller
chmod +x legendsinstaller.sh
./legendsinstaller.sh
```
