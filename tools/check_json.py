import os
import json
import argparse


def load_json_files(json_path):
    dir_path = os.path.dirname(json_path)
    with open(json_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    files = set()
    for item in data.get('list', []):
        if 'path' in item:
            if isinstance(item['path'], list):
                for path in item['path']:
                    file_name = path.replace('file://{JSON_PATH}', dir_path)
                    files.add(file_name)
            else:
                file_name = item['path'].replace('file://{JSON_PATH}', dir_path)
                files.add(file_name)
    
    return set(files)

def list_actual_files(data_dir):
    files = set()
    for root, _, filenames in os.walk(data_dir):
        for filename in filenames:
            if filename == '.DS_Store':
                continue
            file_path = os.path.join(root, filename)
            files.add(file_path)
    return files

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--json_path", type=str, required=True, help="Path to the JSON file")
    parser.add_argument("--data_dir", type=str, required=True, help="Path to the data directory")
    args = parser.parse_args()

    json_files = load_json_files(args.json_path)
    actual_files = list_actual_files(args.data_dir)

    # json中有但实际不存在的文件
    missing_files = json_files - actual_files
    # 实际存在但json中没有的文件
    extra_files = actual_files - json_files

    print('JSON中有但实际不存在的文件:')
    for f in missing_files:
        print(f)

    print('\n实际存在但JSON中没有的文件:')
    for f in extra_files:
        print(f)


if __name__ == '__main__':
    main()
