#!/bin/bash

# ================================================================
#                     i3 SETUP SCRIPT
# ================================================================

set -e  # остановить скрипт если любая команда упадёт

echo ""
echo "================================================================"
echo "                  Начинаем установку i3..."
echo "================================================================"
echo ""


# --- 1. ОБНОВЛЕНИЕ СИСТЕМЫ ---
echo "[1/8] Обновление системы..."
sudo apt update && sudo apt upgrade -y


# --- 2. УСТАНОВКА ПАКЕТОВ ---
echo "[2/8] Установка пакетов..."
sudo apt install -y \
  i3 i3lock xorg xinit feh picom rofi alacritty polybar \
  thunar network-manager-gnome pulseaudio pavucontrol \
  brightnessctl playerctl flameshot xclip \
  fonts-font-awesome lxappearance unzip wget


# --- 3. NERD FONT ---
echo "[3/8] Установка JetBrainsMono Nerd Font..."
mkdir -p ~/.local/share/fonts
cd /tmp
wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip -q JetBrainsMono.zip -d JetBrainsMono
cp JetBrainsMono/*.ttf ~/.local/share/fonts/
fc-cache -fv
echo "Шрифты установлены."


# --- 4. ОБОИ ---
echo "[4/8] Скачиваем обои..."
mkdir -p ~/Pictures
wget -q -O ~/Pictures/wallpaper.jpg https://w.wallhaven.cc/full/ex/wallhaven-ex9gwo.jpg
echo "Обои сохранены в ~/Pictures/wallpaper.jpg"


# --- 5. КОНФИГ i3 ---
echo "[5/8] Создаём конфиг i3..."
mkdir -p ~/.config/i3
cat > ~/.config/i3/config << 'EOF'
set $mod Mod4
font pango:JetBrainsMono Nerd Font 10

exec --no-startup-id picom -b
exec --no-startup-id feh --bg-scale ~/Pictures/wallpaper.jpg
exec --no-startup-id nm-applet
exec_always --no-startup-id polybar main

bindsym $mod+Return exec alacritty
bindsym $mod+d exec rofi -show drun
bindsym $mod+q kill
bindsym $mod+Shift+r restart
bindsym $mod+Shift+e exec i3-msg exit
bindsym $mod+Shift+l exec i3lock
bindsym Print exec flameshot gui

bindsym $mod+h focus left
bindsym $mod+j focus down
bindsym $mod+k focus up
bindsym $mod+l focus right

bindsym $mod+Shift+h move left
bindsym $mod+Shift+j move down
bindsym $mod+Shift+k move up
bindsym $mod+Shift+l move right

bindsym $mod+1 workspace 1
bindsym $mod+2 workspace 2
bindsym $mod+3 workspace 3
bindsym $mod+4 workspace 4
bindsym $mod+5 workspace 5

bindsym $mod+Shift+1 move container to workspace 1
bindsym $mod+Shift+2 move container to workspace 2
bindsym $mod+Shift+3 move container to workspace 3
bindsym $mod+Shift+4 move container to workspace 4
bindsym $mod+Shift+5 move container to workspace 5

bindsym $mod+b split h
bindsym $mod+v split v
bindsym $mod+f fullscreen toggle
bindsym $mod+Shift+space floating toggle

bindsym XF86AudioRaiseVolume exec pactl set-sink-volume @DEFAULT_SINK@ +5%
bindsym XF86AudioLowerVolume exec pactl set-sink-volume @DEFAULT_SINK@ -5%
bindsym XF86AudioMute exec pactl set-sink-mute @DEFAULT_SINK@ toggle
bindsym XF86MonBrightnessUp exec brightnessctl set +5%
bindsym XF86MonBrightnessDown exec brightnessctl set 5%-

gaps inner 8
gaps outer 4
EOF


# --- 6. КОНФИГ POLYBAR ---
echo "[6/8] Создаём конфиг polybar..."
mkdir -p ~/.config/polybar
cat > ~/.config/polybar/config.ini << 'EOF'
[bar/main]
width = 100%
height = 28
background = #1e1e2e
foreground = #cdd6f4
font-0 = JetBrainsMono Nerd Font:size=10;2
padding-left = 1
padding-right = 1
module-margin = 1

modules-left = i3
modules-center = date
modules-right = pulseaudio network battery

[module/i3]
type = internal/i3
format = <label-state> <label-mode>
label-focused = %index%
label-focused-foreground = #cba6f7
label-unfocused = %index%
label-urgent = %index%

[module/date]
type = internal/date
interval = 1
date = %H:%M  %d.%m.%Y

[module/pulseaudio]
type = internal/pulseaudio
format-volume = 󰕾 <label-volume>
label-muted = 󰖁 muted

[module/network]
type = internal/network
interface-type = any
format-connected =  <label-connected>
label-connected = %essid%

[module/battery]
type = internal/battery
battery = BAT0
adapter = AC
format-charging =  <label-charging>
format-discharging =  <label-discharging>
EOF


# --- 7. КОНФИГ ALACRITTY ---
echo "[7/8] Создаём конфиг alacritty..."
mkdir -p ~/.config/alacritty
cat > ~/.config/alacritty/alacritty.toml << 'EOF'
[font]
normal = { family = "JetBrainsMono Nerd Font", style = "Regular" }
size = 11.0

[window]
padding = { x = 8, y = 8 }
opacity = 0.95

[colors.primary]
background = "#1e1e2e"
foreground = "#cdd6f4"
EOF


# --- 8. ГОТОВО ---
echo ""
echo "[8/8] Всё установлено!"
echo ""
echo "================================================================"
echo "  Перезагрузи систему: sudo reboot"
echo "  На экране входа нажми шестерёнку и выбери i3"
echo "================================================================"
echo ""
echo "  ШОРТКАТЫ:"
echo "  Super + Enter        терминал"
echo "  Super + D            лаунчер"
echo "  Super + Q            закрыть окно"
echo "  Super + H/J/K/L      фокус окон"
echo "  Super + Shift+H/J/K/L  переместить окно"
echo "  Super + 1..5         воркспейс"
echo "  Super + F            fullscreen"
echo "  Super + Shift+Space  float"
echo "  Super + Shift+R      перезагрузить конфиг"
echo "  Super + Shift+L      заблокировать экран"
echo "  Print                скриншот"
echo "================================================================"
