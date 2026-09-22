import os
import numpy as np
from PIL import Image
from collections import deque
from scipy.ndimage import binary_dilation
import shutil

BRAIN_DIR = r"C:\Users\egebatir\.gemini\antigravity\brain\e599f675-da6c-4b3f-b6ef-e8a93f0767ba"
FUTBOL_DIR = r"c:\Users\egebatir\Documents\futbol"
AUTOMATION_CRESTS = r"c:\Users\egebatir\Documents\futbol_automation\assets\crests"
WEB_CRESTS = r"c:\Users\egebatir\Documents\antigravity\charming-pasteur"

MAPPING = {
    "che1.png": "chelsea_crest_1790111023236.jpg",
    "juv1.png": "juventus_crest_1790111036418.jpg",
    "int1.png": "inter_crest_1790111047898.jpg",
    "mil1.png": "milan_crest_1790111057962.jpg",
    "nap1.png": "napoli_crest_1790111069657.jpg",
    "tor1.png": "torino_crest_1790111082447.jpg",
    "liv1.png": "liverpool_crest_1790111095989.jpg",
    "mun1.png": "man_utd_crest_1790111109666.jpg",
    "mc1.png":  "man_city_crest_1790111124810.jpg",
    "rma1.png": "real_madrid_crest_1790111138542.jpg",
    "bar1.png": "barcelona_crest_1790111151877.jpg",
    "atm1.png": "atletico_crest_1790111165180.jpg",
}

def remove_bg_and_center(jpg_file, target_png_name):
    jpg_path = os.path.join(BRAIN_DIR, jpg_file)
    if not os.path.exists(jpg_path):
        print(f"ERROR: {jpg_path} not found!")
        return False
        
    im = Image.open(jpg_path).convert("RGB")
    arr = np.array(im, dtype=np.float32)
    h, w, _ = arr.shape
    
    # 1. Sample background color from four corners
    corners = np.vstack([
        arr[:15, :15].reshape(-1, 3),
        arr[:15, -15:].reshape(-1, 3),
        arr[-15:, :15].reshape(-1, 3),
        arr[-15:, -15:].reshape(-1, 3),
    ])
    bg_color = corners.mean(axis=0)
    
    dist = np.linalg.norm(arr - bg_color, axis=2)
    is_bg = dist < 28.0
    
    # Flood-fill only from exterior boundaries
    exterior_mask = np.zeros((h, w), dtype=bool)
    q = deque()
    
    for y in range(h):
        for x in [0, w-1]:
            if is_bg[y, x] and not exterior_mask[y, x]:
                exterior_mask[y, x] = True
                q.append((y, x))
    for x in range(w):
        for y in [0, h-1]:
            if is_bg[y, x] and not exterior_mask[y, x]:
                exterior_mask[y, x] = True
                q.append((y, x))
                
    while q:
        cy, cx = q.popleft()
        for dy, dx in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
            ny, nx = cy + dy, cx + dx
            if 0 <= ny < h and 0 <= nx < w:
                if is_bg[ny, nx] and not exterior_mask[ny, nx]:
                    exterior_mask[ny, nx] = True
                    q.append((ny, nx))
                    
    # Smooth antialiased boundary transition
    dilated = binary_dilation(exterior_mask, iterations=2)
    alpha = np.ones((h, w), dtype=np.uint8) * 255
    for y in range(h):
        for x in range(w):
            if exterior_mask[y, x]:
                alpha[y, x] = 0
            elif dilated[y, x] and is_bg[y, x]:
                alpha[y, x] = int(np.clip(dist[y, x] / 28.0, 0, 1) * 255)
                
    rgba = Image.fromarray(np.dstack([arr.astype(np.uint8), alpha]), mode="RGBA")
    bbox = rgba.getbbox()
    if not bbox:
        print(f"ERROR: {target_png_name} bbox is empty!")
        return False
        
    cropped = rgba.crop(bbox)
    
    # Scale to 760x760 maximum dimension
    target_inner = 760
    scale = target_inner / max(cropped.width, cropped.height)
    new_w = int(round(cropped.width * scale))
    new_h = int(round(cropped.height * scale))
    resized = cropped.resize((new_w, new_h), Image.Resampling.LANCZOS)
    
    # Center perfectly on 800x800
    final_canvas = Image.new("RGBA", (800, 800), (0, 0, 0, 0))
    paste_x = (800 - new_w) // 2
    paste_y = (800 - new_h) // 2
    final_canvas.paste(resized, (paste_x, paste_y), resized)
    
    # Save to futbol
    out_path = os.path.join(FUTBOL_DIR, target_png_name)
    final_canvas.save(out_path, "PNG")
    
    # Mirror to automation
    if os.path.exists(AUTOMATION_CRESTS):
        auto_path = os.path.join(AUTOMATION_CRESTS, target_png_name)
        final_canvas.save(auto_path, "PNG")
        
    final_bbox = final_canvas.getbbox()
    cx = (final_bbox[0] + final_bbox[2]) / 2.0
    cy = (final_bbox[1] + final_bbox[3]) / 2.0
    print(f"SUCCESS: {target_png_name:10s} -> size=(800, 800) bbox={final_bbox} center=({cx}, {cy})")
    return True

if __name__ == "__main__":
    print("--- Processing and Perfectly Centering Club Crests ---")
    for png_name, jpg_file in MAPPING.items():
        remove_bg_and_center(jpg_file, png_name)
    print("Done!")
