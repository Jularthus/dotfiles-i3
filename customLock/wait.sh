while true; do
    if [ $(ps aux | grep i3lock | wc -l) -eq 1 ]; then
        nohup polybar &
        i3-msg workspace prev
        pkill cmatrix;
        exit 0;
    fi
done
