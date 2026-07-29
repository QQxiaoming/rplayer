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
input_dir=$1
output_dir=$2
icon=$3
title=$4
info=$5
prefix=$6
input_dir_name=$6$(basename $input_dir)

mkdir -p $input_dir/json_tmp
for filename in $input_dir/*; do
    if [ "$filename" = "$input_dir/json_tmp" ]; then
        continue
    fi
    if [ -d "$filename" ]; then
        python3 ./generate_image_data_json.py --dataDir $filename --output $input_dir/json_tmp/$(basename "$filename").json --icon "$icon" --title "$title" --info "$info"
    fi
done
python3 ./generate_video_data_json.py --dataDir $input_dir --output $input_dir/json_tmp/video.json --icon "$icon" --title "$title" --info "$info"
if [ -f "$input_dir/json_tmp/video.json" ]; then
    python3 ./merge_data_json.py --dataDir $input_dir/json_tmp --output $output_dir/$input_dir_name.json
fi
rm -rf $input_dir/json_tmp

