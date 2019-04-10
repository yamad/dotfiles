# swap the names of two files
swapfile() {
    mv $1 $1.tmp && mv $2 $1 && mv $1.tmp $2
}

timer_countdown() {
    utimer -c $1 && play ~/downloads/b1_oringz-pack-nine-20.mp3
}

pomodoro() {
    utimer -c 25m && play ~/downloads/b1_oringz-pack-nine-20.mp3
    utimer -c 5m && play ~/downloads/b1_oringz-pack-nine-20.mp3
}

# verbose copy (rsync backend) -- indicates progress, etc
cp_v() {
    rsync -WavP $1 $2
}

webcam-record() {
    ffmpeg -f video4linux2 -r 30 -b 600k -i /dev/video1 -f alsa -i hw:1,0 -f mp4 $1
}
