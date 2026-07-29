# root
# |-image1
# |  |-image11.jpg
# |  |-image12.jpg
# |
# |-image2
# |  |-image21.jpg
# |  |-image22.jpg
# |
# |-video1.mp4
# |-video2.mp4
current_dir=$(cd $(dirname $0); pwd)
output_dir=$1
output_dir_name=$(basename $output_dir)
icon=$2
title=$3
info=$4

mkdir -p $output_dir/json_tmp
for filename in $output_dir/*; do
    if [ -d "$filename" ]; then
        python3 ./generate_image_data_json.py --dataDir $filename --output $output_dir/json_tmp/$(basename "$filename").json --icon $icon --title $title --info $info
    fi
done
python3 ./generate_video_data_json.py --dataDir $output_dir --output $output_dir/json_tmp/video.json --icon $icon --title $title --info $info
python3 ./merge_data_json.py --dataDir $output_dir/json_tmp --output $current_dir/$output_dir_name.json
rm -rf $output_dir/json_tmp

