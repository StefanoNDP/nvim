# How to Install kitty in Ubuntu in WSL2
These seteps have been tested on Windows 10 with WSL2 running Kali Linux.


## 1. Dependencies
First install the dependencies:
#### Install OpenGL
```bash
apt install mesa-utils libglu1-mesa-dev freeglut3-dev mesa-common-dev
```
There are more than we need, but also include GLut and Glu libraries to link against during compilation.

Check OpenGL version using `glxinfo -B`. kitty requires working OpenGL 3.3 drivers.

## 2. Window Server
### Installing
Then, you will need to setup a window server. Windows 11 should have this built in and work out of the box (skip to step 3). Windows 10 you will need to install one [VcXsrv](https://sourceforge.net/projects/vcxsrv/) is a popular option (also known as XLaunch).

### Configuration
Once installed, then you will need to make a configuration. You want the following settings:
- __First Screen:__ Multi-Window, Display=0
<!-- ![screen1](https://user-images.githubusercontent.com/10600905/138349466-d0f4fb11-06ae-42e6-b82e-9972b8e31231.png) -->
<img src="https://user-images.githubusercontent.com/10600905/138349466-d0f4fb11-06ae-42e6-b82e-9972b8e31231.png" width="40%" height="40%" />

- __Second Screen:__ Start No Client
<!-- ![screen2](https://user-images.githubusercontent.com/10600905/138320532-51ea5e92-9ee1-4087-bda4-634d5da02ace.png) -->
<img src="https://user-images.githubusercontent.com/10600905/138320532-51ea5e92-9ee1-4087-bda4-634d5da02ace.png" width="40%" height="40%" />

- __Third Screen:__ Clipboard=True, Primary Selection=True, Native OpenGL=False, Disable Access Control=True
<!-- ![screen3](https://user-images.githubusercontent.com/10600905/138320530-257be735-e0d1-4271-b5db-6d1823782243.png) -->
<img src="https://user-images.githubusercontent.com/10600905/138320530-257be735-e0d1-4271-b5db-6d1823782243.png" width="40%" height="40%" />

I then recomend you save your configuration file somewhere so that each time you start you window server you can open it instead of rebuilding it.
Then start your window server.

### WSL Display
Once you have setup and started your Window server, you need to tell Ubuntu/WSL where your display is, we can do this by running the following command:
```bash
export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0
export LIBGL_ALWAYS_INDIRECT=0
```
You will need to do this for every new shell you open. Alternatively, you can add this to your `.bashrc` file to have your shell do it for you an start up.


## 3. Running a Test
After the following configuration you should be able to run the test application below and see some multi-colored gears spinning:
```bash
glxgears
```

## 4. Installing kitty
Install kitty via `sudo apt install kitty`

(Optional : If you want to display images in terminal) Install ImageMagick using `sudo apt install imagemagick` and verify it `convert -version`

start it via `kitty`

To display emojis in the terminal:
- Install an [emoji font](https://github.com/googlefonts/noto-emoji) 
- Create a file `~/.config/fontconfig/fonts.conf` and add the content to tell the preferred font for rendering emojis: 

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <alias>
    <family>serif</family>
    <prefer>
      <family>Noto Color Emoji</family>
    </prefer>
  </alias>
  <alias>
    <family>sans-serif</family>
    <prefer>
      <family>Noto Color Emoji</family>
    </prefer>
  </alias>
  <alias>
    <family>monospace</family>
    <prefer>
      <family>Noto Color Emoji</family>
    </prefer>
  </alias>
</fontconfig>
```

- To get the font family name use: `fc-query -f '%{family[0]}\n' /path/to/font.ttf`
