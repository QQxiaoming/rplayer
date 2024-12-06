import os
import json
import argparse
import random

def generate(data_dir, output, title="", info="", icon_path="", like=-1, star=-1, bookMark=-1):
    files = os.listdir(data_dir)
    files = [f for f in files if f.endswith('.mp4') or f.endswith('.mkv') or f.endswith('.avi') or f.endswith('.flv') or f.endswith('.mov') or f.endswith('.wmv')]

    data = {}
    data['list'] = []
    for file in files:
        file_path = os.path.abspath(os.path.join(data_dir, file))
        item = {}
        item['type'] = 'video'
        if(len(title)):
            item['title'] = title
        else:
            item['title'] = os.path.basename(file_path)
        if(len(info)):
            item['info'] = info
        else:
            item['info'] = os.path.basename(file_path)
        item['path'] = 'file://{}'.format(file_path)
        if(len(icon_path)):
            item['icon'] = 'file://{}'.format(os.path.abspath(icon_path))
        if(like != -1):
            item['like'] = like
        else:
            item['like'] = random.randint(0, 1000)
        if(star != -1):
            item['star'] = star
        else:
            item['star'] = random.randint(0, 1000)
        if(bookMark != -1):
            item['bookMark'] = bookMark
        else:
            item['bookMark'] = random.randint(0, 1000)
        data['list'].append(item)
    
    with open(output, 'w') as f:
        json.dump(data, f, ensure_ascii=False, indent=4)
    
if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--dataDir", type=str, required=True)
    parser.add_argument("--output", type=str, required=True)
    parser.add_argument("--title", type=str, default="")
    parser.add_argument("--info", type=str, default="")
    parser.add_argument("--icon", type=str, default="")
    parser.add_argument("--like", type=int, default=-1)
    parser.add_argument("--star", type=int, default=-1)
    parser.add_argument("--bookMark", type=int, default=-1)
    args = parser.parse_args()
    generate(args.dataDir, args.output, args.title, args.info, args.icon, args.like, args.star, args.bookMark)