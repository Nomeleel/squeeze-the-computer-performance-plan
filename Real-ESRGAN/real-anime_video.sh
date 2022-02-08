
realesrgan=realesrgan-ncnn-vulkan-20211212-macos

dir=$(basename $1)

echo ${dir}

mkdir -p ${dir}/tmp_frames

ffmpeg -i $1 -qscale:v 1 -qmin 1 -qmax 1 -vsync 0 ${dir}/tmp_frames/frame%09d.png

mkdir -p ${dir}/out_frames

cd ${realesrgan}

chmod u+x ./realesrgan-ncnn-vulkan

./realesrgan-ncnn-vulkan -i ../${dir}/tmp_frames/ -o ../${dir}/out_frames -n RealESRGANv2-animevideo-xsx4 -s 4 -f jpg

cd ../

ffmpeg -i ${dir}/out_frames/frame%09d.jpg -i $1 -map 0:v:0 -map 1:a:0 -c:a copy -c:v libx264 -r 23.98 -pix_fmt yuv420p ${dir}/${dir}