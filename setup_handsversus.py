import os
import urllib.request
import subprocess
import json
import ssl
import shutil

# Configuration
PROJECT_ROOT = "../technical_project2_HandsVersus"
# User renamed "Assets.xcassets" to "images"
ASSETS_DIR = os.path.join(PROJECT_ROOT, "images")

# URLs and definitions
STYLES = {
    "Fluent": {
        "base_url": "https://raw.githubusercontent.com/bignutty/fluent-emoji/main/static/",
        "items": {
            "Rock": "1faa8.png",
            "Paper": "1f4c3.png",
            "Scissors": "2702-fe0f.png"
        }
    },
    "Sketch": {
        "base_url": "https://raw.githubusercontent.com/hfg-gmuend/openmoji/master/color/618x618/",
        "items": {
            "Rock": "270A.png",
            "Paper": "270B.png",
            "Scissors": "270C.png"
        }
    },
    "Flat": {
        "base_url": "https://cdnjs.cloudflare.com/ajax/libs/twemoji/14.0.2/72x72/",
        "items": {
            "Rock": "270a.png",
            "Paper": "270b.png",
            "Scissors": "270c.png"
        }
    },
    "Cartoon": {
        # Google Noto Color - Vibrant cartoon style
        "base_url": "https://raw.githubusercontent.com/googlefonts/noto-emoji/main/png/128/",
        "items": {
            "Rock": "emoji_u270a.png",
            "Paper": "emoji_u270b.png",
            "Scissors": "emoji_u270c.png"
        }
    },
    "Minimalist": {
        # OpenMoji Black - Clean line art, very "épuré"
        "base_url": "https://raw.githubusercontent.com/hfg-gmuend/openmoji/master/black/618x618/",
        "items": {
            "Rock": "270A.png",
            "Paper": "270B.png",
            "Scissors": "270C.png"
        }
    },
    "Retro": {
        # Facebook (Legacy) - Web 2.0 style
        "base_url": "https://raw.githubusercontent.com/iamcal/emoji-data/master/img-facebook-96/",
        "items": {
            "Rock": "270a.png",
            "Paper": "270b.png",
            "Scissors": "270c-fe0f.png"
        }
    },
    "Classic": {
        # Apple (Legacy) - detailed and iconic
        "base_url": "https://raw.githubusercontent.com/iamcal/emoji-data/master/img-apple-160/",
        "items": {
            "Rock": "270a.png",
            "Paper": "270b.png",
            "Scissors": "270c-fe0f.png"
        }
    }
}

# Bypass SSL verification
ssl._create_default_https_context = ssl._create_unverified_context

def setup_project_structure():
    if not os.path.exists(PROJECT_ROOT):
        print(f"Creating project directory: {PROJECT_ROOT}")
        try:
            os.makedirs(PROJECT_ROOT)
        except PermissionError:
            print(f"Error: Permission denied creating {PROJECT_ROOT}.")
            return False
    
    if not os.path.exists(ASSETS_DIR):
        print(f"Creating images directory: {ASSETS_DIR}")
        os.makedirs(ASSETS_DIR)
        
    return True

def process_asset(style_name, item_name, filename, base_url):
    asset_name = f"{style_name}-{item_name}"
    # Structure inside 'images' folder. 
    imageset_path = os.path.join(ASSETS_DIR, f"{asset_name}.imageset")
    
    # Check if Contents.json exists to skip valid assets
    if os.path.exists(os.path.join(imageset_path, "Contents.json")):
        print(f"Skipping {asset_name} (Already exists)")
        return

    print(f"Processing {asset_name}...")
    if os.path.exists(imageset_path):
        shutil.rmtree(imageset_path) # Clean start
    os.makedirs(imageset_path, exist_ok=True)
    
    # Download
    url = f"{base_url}{filename}"
    temp_path = f"temp_{style_name}_{filename.replace('%20', '_')}"
    
    try:
        urllib.request.urlretrieve(url, temp_path)
    except Exception as e:
        print(f"Error downloading {url}: {e}")
        if os.path.exists(imageset_path):
            shutil.rmtree(imageset_path)
        return

    # Dimensions
    img_2x = os.path.join(imageset_path, f"{asset_name}@2x.png")
    img_3x = os.path.join(imageset_path, f"{asset_name}@3x.png")
    
    # Resize using sips (200px and 300px)
    subprocess.run(["sips", "--resampleHeightWidth", "200", "200", temp_path, "--out", img_2x], capture_output=True)
    subprocess.run(["sips", "--resampleHeightWidth", "300", "300", temp_path, "--out", img_3x], capture_output=True)
    
    # Cleanup temp
    if os.path.exists(temp_path):
        os.remove(temp_path)
        
    # Contents.json
    contents = {
        "images": [
            {"idiom": "universal", "scale": "1x"},
            {"idiom": "universal", "filename": f"{asset_name}@2x.png", "scale": "2x"},
            {"idiom": "universal", "filename": f"{asset_name}@3x.png", "scale": "3x"}
        ],
        "info": {"author": "xcode", "version": 1}
    }
    
    with open(os.path.join(imageset_path, "Contents.json"), "w") as f:
        json.dump(contents, f, indent=2)

def main():
    if setup_project_structure():
        print(f"Targeting: {os.path.abspath(PROJECT_ROOT)}")
        print(f"Assets Folder: {os.path.abspath(ASSETS_DIR)}")
        
        for style, data in STYLES.items():
            base = data["base_url"]
            for item, filename in data["items"].items():
                process_asset(style, item, filename, base)

        print(f"\nDone! Assets check complete in {ASSETS_DIR}")

if __name__ == "__main__":
    main()
