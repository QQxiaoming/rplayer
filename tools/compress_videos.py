import os
import sys
import subprocess
import shutil

# ==================== 参数配置 ====================
# CRF（恒定质量因子）：libx264 的无损范围通常在 18-23。
# 18 是工业标准的“视觉无损”，所有画面细节（图像合成视频的边缘纹理）都会像素级保留。
CRF_VALUE = 18

# 编码预设速度：medium 兼顾了压缩率和速度；如果追求更小体积，可以改为 "slow"
PRESET_MODE = "medium"

def check_dependencies():
    """检查系统环境是否支持 ffmpeg"""
    if not shutil.which("ffmpeg"):
        print("❌ 错误: 未检测到 ffmpeg，请先运行 'brew install ffmpeg' 安装。")
        sys.exit(1)

def get_target_directory():
    """解析并验证输入的目录参数"""
    if len(sys.argv) > 1:
        target_path = sys.argv[1].strip()
        target_path = target_path.replace("\\", "")
        abs_path = os.path.abspath(target_path)
    else:
        abs_path = os.getcwd()
        
    if not os.path.isdir(abs_path):
        print(f"❌ 错误: 指定的目录不存在 -> '{abs_path}'")
        sys.exit(1)
        
    return abs_path

def compress_videos():
    check_dependencies()
    target_dir = get_target_directory()
    output_root_dir = os.path.join(target_dir, "compressed_output")
    
    print("=" * 60)
    print("  🎬 全兼容高画质视频批量压缩工具 (H.264 视觉无损)")
    print(f"  📂 目标根目录: {target_dir}")
    print(f"  💾 输出根目录: {output_root_dir}")
    print(f"  ⚙️  配置参数:   CRF={CRF_VALUE}, Preset={PRESET_MODE}")
    print("=" * 60)
    
    os.makedirs(output_root_dir, exist_ok=True)
    count = 0
    
    for root, dirs, files in os.walk(target_dir):
        if output_root_dir in root:
            continue
            
        for file in files:
            if file.lower().endswith('.mp4'):
                count += 1
                absolute_src = os.path.join(root, file)
                relative_path = os.path.relpath(absolute_src, target_dir)
                absolute_dest = os.path.join(output_root_dir, relative_path)
                
                os.makedirs(os.path.dirname(absolute_dest), exist_ok=True)
                print(f"\n⏳ [{count}] 正在处理: {relative_path}")
                
                # 🌟 核心修改点：
                # 1. 放弃 hevc_videotoolbox，改用最稳定的主流兼容之王 libx264
                # 2. 引入 -movflags +faststart，这会把视频的索引头移到文件最前面，可以让 Mac Finder 预览实现“秒开”
                cmd = [
                    "ffmpeg", "-y",
                    "-i", absolute_src,
                    "-c:v", "libx264",
                    "-crf", str(CRF_VALUE),
                    "-preset", PRESET_MODE,
                    "-pix_fmt", "yuv420p",
                    "-movflags", "+faststart",
                    "-c:a", "copy",
                    absolute_dest
                ]
                
                try:
                    process = subprocess.Popen(
                        cmd, 
                        stdout=subprocess.PIPE, 
                        stderr=subprocess.STDOUT, 
                        universal_newlines=True,
                        encoding='utf-8',
                        errors='ignore'
                    )
                    
                    while True:
                        line = process.stdout.readline()
                        if not line and process.poll() is not None:
                            break
                        if "frame=" in line or "Error" in line or "failed" in line:
                            print(line.strip(), end="\r", flush=True)
                            
                    process.wait()
                    if process.returncode != 0:
                        print(f"\n❌ 文件压缩失败 (返回码 {process.returncode})")
                        
                except Exception as e:
                    print(f"\n❌ 处理过程中发生异常: {e}")
                    
    print("\n" + "=" * 60)
    print(f"  🎉 🎉 全兼容处理完成！共成功压缩 {count} 个视频。")
    print(f"  📂 兼容版视频目录: {output_root_dir}")
    print("=" * 60)

if __name__ == "__main__":
    compress_videos()
