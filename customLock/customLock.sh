pkill polybar
i3-msg 'workspace i3lock; exec kitty -1 ~/afs/customLock/cmatrix -L'
nohup i3lock &
~/afs/customLock/wait.sh > file 2>&1 & 
i3 restart ; ~/afs/customLock/cmatrix ;
