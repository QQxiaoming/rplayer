import os
import json
import argparse

def merge(data_dir, output):
    files = os.listdir(data_dir)
    files = [f for f in files if f.endswith('.json')]

    data = {}
    data['list'] = []
    for file in files:
        file_path = os.path.abspath(os.path.join(data_dir, file))
        with open(file_path, 'r') as f:
            rjson = json.load(f)
            for item in rjson['list']:
                data['list'].append(item)
    
    with open(output, 'w') as f:
        json.dump(data, f, ensure_ascii=False, indent=4)
    
if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--dataDir", type=str, required=True)
    parser.add_argument("--output", type=str, required=True)
    args = parser.parse_args()
    merge(args.dataDir, args.output)