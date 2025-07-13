import json
import argparse

def extract_by_title(input_file, output_file, title):
    data = {}
    data['list'] = []
    with open(input_file, 'r') as f:
        rjson = json.load(f)
        for item in rjson['list']:
            if item.get('title') == title:
                data['list'].append(item)

    with open(output_file, 'w') as f:
        json.dump(data, f, ensure_ascii=False, indent=4)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", type=str, required=True)
    parser.add_argument("--output", type=str, required=True)
    parser.add_argument("--title", type=str, required=True)
    args = parser.parse_args()
    extract_by_title(args.input, args.output, args.title)

