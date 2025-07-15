import os
import json
import argparse

def remove_duplicates_from_json(json_path):
    with open(json_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    changed = False
    for item in data.get('list', []):
        for key in item:
            if isinstance(item[key], list):
                original = item[key]
                # 保持原顺序去重
                seen = set()
                deduped = []
                for v in original:
                    if v not in seen:
                        deduped.append(v)
                        seen.add(v)
                if len(deduped) != len(original):
                    item[key] = deduped
                    changed = True

    if changed:
        with open(json_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=4)
        print("去重完成，已覆盖原文件。")
    else:
        print("未发现重复项，无需修改。")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", type=str, required=True)
    args = parser.parse_args()
    remove_duplicates_from_json(args.input)
