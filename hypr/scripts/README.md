### Wallpaper Loop update: 
 The loop's target directory has been updated, we are now sourcing wallpapers from a different github repo (which has been cloned). 

#### Link: <a href="https://github.com/JaKooLit/Wallpaper-Bank">https://github.com/JaKooLit/Wallpaper-Bank</a>

### Matugen Styling update: 

Waybar wasn't exactly replicating the current wallpaper's colour palette, this was because of the matugen configuration within the wallpaper switcher script, the origin point of the matugen trigger. Within the help section for matugen image, information regarding theming by using -t was referenced, -t was set to: -t scheme-vibrant --prefer saturation, this helps bring out the accurate primary colours of the wallpaper's palette. 

More importantly, however, the source-colour was set to 1, forcing matugen to focus on the high intensity colours instead of 0, which is sometimes misleading and can cause matugen to pick something lighter and less appealing. 
