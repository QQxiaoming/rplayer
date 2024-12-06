# root
# |-icon
# |  |-icon.png
# |
# |-image
# |  |-image1
# |  |  |-image11.jpg
# |  |  |-image12.jpg
# |  |
# |  |-image2
# |     |-image21.jpg
# |     |-image22.jpg
# |
# |-video
#    |-video1.mp4
#    |-video2.mp4

mkdir -p $1/json_tmp
for filename in $1/image/*; do
    python3 ./generate_image_data_json.py --dataDir $filename --output $1/json_tmp/$(basename "$filename").json --icon $1/icon/icon.png
done
python3 ./generate_video_data_json.py --dataDir $1/video --output $1/json_tmp/video.json --icon $1/icon/icon.png
python3 ./merge_data_json.py --dataDir $1/json_tmp --output $1/out.json
rm -rf $1/json_tmp

