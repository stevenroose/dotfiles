[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

xinput set-prop 12 "libinput Natural Scrolling Enabled" 1

exec awesome
