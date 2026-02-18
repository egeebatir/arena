import pygame
import math
import random
import os

# --- CONFIGURATION ---
WIDTH, HEIGHT = 1000, 800
FPS = 80
FRAMES_PER_SIM_MINUTE = 31

ARENA_RADIUS = 250
BALL_RADIUS = 38
GOAL_WIDTH_RADIANS = 0.33
POST_RADIUS = 7
GOAL_DEPTH = 50

SPEED = 5.2
MIN_SPEED = 3.6

# PHYSICS CONSTANTS
GRAVITY = 0.015
BOUNCE_DAMPING = 0.95
FRICTION = 0.99999
ELASTICITY = 0.96
POST_ELASTICITY = 1.04

# COLORS
GRASS_1 = (50, 160, 50)
GRASS_2 = (40, 140, 40)
WHITE = (245, 245, 245)
BLACK = (10, 10, 10)
NET_COLOR = (200, 200, 200)
GOLD = (255, 215, 0)
MENU_BG = (30, 30, 40)
SELECTED_COLOR = (50, 255, 50)
SCROLLBAR_BG = (50, 50, 60)
SCROLLBAR_HANDLE = (150, 150, 150)
RED_CARD_COLOR = (250, 10, 10) 
OVERLAY_BG = (20, 20, 20, 200)
# UPDATED: Greyish background for scoreboard
TABLE_BG = (180, 180, 180, 230) 
# UPDATED: Darker inner post color
POST_INNER_COLOR = (50, 50, 50) 

# --- SES AYARLARI ---
STADIUM_FILE = "stadium.mp3"
COLLISION_FILE = "collision1.wav" 
RED_CARD_FILE = "whistle.wav" 

GS_GOAL_FILE = "gs.mp3"
FB_GOAL_FILE = "fb.wav"   
BJK_GOAL_FILE = "bjk.wav" 
TS_GOAL_FILE = "ts.wav"   

GOAL1_FILE = "goal1.mp3"
GOAL2_FILE = "goal2.mp3"
GOAL3_FILE = "goal3.mp3"

STADIUM_VOLUME = 0.4
GOAL_MUSIC_VOLUME = 0.6
COLLISION_VOLUME = 0.05
RED_CARD_VOLUME = 0.5

# --- TAKIM VERİTABANI ---
TEAMS = {
    "GALATASARAY":    {"colors": [(169, 4, 50), (253, 185, 18)], "short": "GS"},
    "FENERBAHÇE":     {"colors": [(255, 255, 0), (0, 0, 128)],   "short": "FB"},
    "BEŞİKTAŞ":       {"colors": [(255, 255, 255), (10, 10, 10)],"short": "BJK"},
    "TRABZONSPOR":    {"colors": [(128, 0, 0), (0, 191, 255)],   "short": "TS"},
    "BAŞAKŞEHİR":     {"colors": [(255, 102, 0), (0, 0, 102)],   "short": "BFK"},
    "KASIMPAŞA":      {"colors": [(255, 255, 255), (0, 0, 128)], "short": "KAS"},
    "SİVASSPOR":      {"colors": [(255, 0, 0), (255, 255, 255)], "short": "SVS"},
    "ALANYASPOR":     {"colors": [(255, 165, 0), (0, 128, 0)],   "short": "ALN"},
    "RİZESPOR":       {"colors": [(0, 128, 0), (0, 0, 255)],     "short": "RİZ"},
    "ANTALYASPOR":    {"colors": [(255, 0, 0), (255, 255, 255)], "short": "ANT"},
    "GAZİANTEP FK":   {"colors": [(200, 16, 46), (10, 10, 10)],  "short": "GFK"},
    "KONYASPOR":      {"colors": [(0, 128, 0), (255, 255, 255)], "short": "KON"},
    "KAYSERİSPOR":    {"colors": [(255, 204, 0), (255, 0, 0)],   "short": "KAY"},
    "BODRUM FK":      {"colors": [(0, 128, 0), (255, 255, 255)], "short": "BOD"},
    "EYÜPSPOR":       {"colors": [(230, 230, 250), (255, 215, 0)],"short": "EYP"},
    "GÖZTEPE":        {"colors": [(255, 215, 0), (255, 0, 0)],   "short": "GÖZ"},
    "SAMSUNSPOR":     {"colors": [(255, 0, 0), (255, 255, 255)], "short": "SAM"},
    "HATAYSPOR":      {"colors": [(128, 0, 0), (255, 255, 255)], "short": "HAT"},
    "ADANA DEMİR":    {"colors": [(0, 0, 255), (173, 216, 230)], "short": "ADS"},
    "MAN CITY":       {"colors": [(108, 171, 221), (255, 255, 255)],"short": "MC"},
    "LIVERPOOL":      {"colors": [(200, 16, 46), (255, 255, 255)],  "short": "LIV"},
    "ARSENAL":        {"colors": [(239, 1, 7), (255, 255, 255)],    "short": "ARS"},
    "ASTON VILLA":    {"colors": [(103, 14, 54), (149, 191, 229)],  "short": "AVL"},
    "TOTTENHAM":      {"colors": [(255, 255, 255), (19, 34, 87)],   "short": "TOT"},
    "MAN UTD":        {"colors": [(218, 41, 28), (255, 255, 255)],  "short": "MUN"},
    "CHELSEA":        {"colors": [(3, 70, 148), (255, 255, 255)],   "short": "CHE"},
    "REAL MADRID":    {"colors": [(255, 255, 255), (255, 215, 0)],"short": "RMA"},
    "BARCELONA":      {"colors": [(0, 77, 152), (165, 0, 68)],    "short": "BAR"},
    "ATLETICO":       {"colors": [(203, 53, 36), (255, 255, 255)],"short": "ATM"},
    "GIRONA":         {"colors": [(200, 16, 46), (255, 255, 255)],"short": "GIR"},
    "B. MUNIH":       {"colors": [(220, 5, 45), (255, 255, 255)], "short": "BAY"},
    "DORTMUND":       {"colors": [(253, 225, 0), (10, 10, 10)],   "short": "BVB"},
    "LEVERKUSEN":     {"colors": [(10, 10, 10), (227, 34, 25)],   "short": "B04"},
    "RB LEIPZIG":     {"colors": [(255, 255, 255), (221, 5, 43)], "short": "RBL"},
    "INTER":          {"colors": [(0, 102, 187), (10, 10, 10)],   "short": "INT"},
    "MILAN":          {"colors": [(251, 9, 11), (10, 10, 10)],    "short": "MIL"},
    "JUVENTUS":       {"colors": [(255, 255, 255), (10, 10, 10)], "short": "JUV"},
    "ATALANTA":       {"colors": [(30, 113, 184), (10, 10, 10)],  "short": "ATA"},
    "ROMA":           {"colors": [(134, 38, 51), (240, 188, 66)], "short": "ROM"},
    "LAZIO":          {"colors": [(135, 206, 235), (255, 255, 255)],"short": "LAZ"},
    "PSG":            {"colors": [(0, 65, 112), (218, 41, 28)],   "short": "PSG"},
    "LILLE":          {"colors": [(238, 36, 54), (0, 51, 102)],   "short": "LIL"},
    "MONACO":         {"colors": [(255, 0, 0), (255, 255, 255)],  "short": "ASM"},
    "BENFICA":        {"colors": [(232, 48, 48), (255, 255, 255)],"short": "SLB"},
    "SPORTING":       {"colors": [(0, 128, 0), (255, 255, 255)],  "short": "SCP"},
    "PORTO":          {"colors": [(0, 0, 255), (255, 255, 255)],  "short": "POR"},
    "AJAX":           {"colors": [(255, 255, 255), (210, 18, 46)],"short": "AJX"},
    "PSV":            {"colors": [(255, 0, 0), (255, 255, 255)],  "short": "PSV"},
    "FEYENOORD":      {"colors": [(255, 255, 255), (255, 0, 0)],  "short": "FEY"},
    "PANATHINAIKOS":  {"colors": [(0, 123, 58), (255, 255, 255)], "short": "PAO"},
    "VIKTORIA PLZEN": {"colors": [(237, 27, 36), (0, 77, 152)],   "short": "PLZ"},
    "DINAMO ZAGREB":  {"colors": [(0, 51, 153), (255, 255, 255)], "short": "DZG"},
    "GENK":           {"colors": [(0, 71, 156), (255, 255, 255)], "short": "GNK"},
    "NOTTM FOREST":   {"colors": [(229, 30, 42), (255, 255, 255)],"short": "NFO"},
    "BRANN":          {"colors": [(226, 0, 26), (255, 255, 255)], "short": "BRA"},
    "BOLOGNA":        {"colors": [(158, 27, 50), (26, 35, 66)],   "short": "BOL"},
    "PAOK":           {"colors": [(0, 0, 0), (255, 255, 255)],    "short": "PAOK"},
    "CELTA VIGO":     {"colors": [(138, 195, 238), (255, 255, 255)],"short": "CEL"},
    "LUDOGORETS":     {"colors": [(13, 104, 56), (255, 255, 255)],"short": "LUD"},
    "FERENCVAROS":    {"colors": [(28, 127, 55), (255, 255, 255)],"short": "FER"},
    "CRVENA ZVEZDA":  {"colors": [(208, 16, 35), (255, 255, 255)],"short": "CZV"},
    "CELTIC":         {"colors": [(0, 128, 0), (255, 255, 255)],  "short": "CLT"},
    "STUTTGART":      {"colors": [(255, 255, 255), (227, 34, 25)],"short": "VFB"},
}

TEAM_NAMES = list(TEAMS.keys())
PLAYER_DATABASE = {}

# --- LOAD PLAYER DATABASE (FIXED PATH) ---
def load_player_database():
    db = {}
    base_path = os.path.dirname(os.path.abspath(__file__))
    file_path = os.path.join(base_path, "players.txt")
    
    print(f"Looking for players.txt at: {file_path}") 

    if os.path.exists(file_path):
        try:
            with open(file_path, "r", encoding="utf-8") as f:
                for line in f:
                    if ":" in line:
                        parts = line.split(":")
                        t_name = parts[0].strip().upper() 
                        p_names = [p.strip() for p in parts[1].split(",")]
                        p_names = [p for p in p_names if p] 
                        
                        if p_names:
                            db[t_name] = p_names
            print(f"SUCCESS: Loaded {len(db)} teams from database.") 
        except Exception as e:
            print(f"ERROR reading players.txt: {e}")
    else:
        print("ERROR: players.txt file NOT FOUND at that location.")
        
    return db

PLAYER_DATABASE = load_player_database()

def get_random_player_name(team_key):
    if team_key in PLAYER_DATABASE:
        players = PLAYER_DATABASE[team_key]
        if players:
            return random.choice(players)
    return f"Oyuncu {random.randint(1, 3)}"

# --- SETUP ---
pygame.init()
pygame.mixer.init()
pygame.mixer.set_num_channels(8)

screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Futbol Simulasyonu - Final")

# --- SES YÜKLEME ---
stadium_music_loaded = False
if os.path.exists(STADIUM_FILE):
    try:
        pygame.mixer.music.load(STADIUM_FILE)
        pygame.mixer.music.set_volume(STADIUM_VOLUME)
        stadium_music_loaded = True
    except Exception:
        pass

# --- COLLISION SOUND ---
collision_sound = None
if os.path.exists(COLLISION_FILE):
    try:
        collision_sound = pygame.mixer.Sound(COLLISION_FILE)
        collision_sound.set_volume(COLLISION_VOLUME)
    except:
        pass

# --- RED CARD SOUND ---
red_card_sound = None
if os.path.exists(RED_CARD_FILE):
    try:
        red_card_sound = pygame.mixer.Sound(RED_CARD_FILE)
        red_card_sound.set_volume(RED_CARD_VOLUME)
    except:
        pass

# UPDATED: Audio Priority System
def play_collision_sound():
    global goal_sound_channel
    # If goal music is playing, DO NOT play collision sound
    if goal_sound_channel and goal_sound_channel.get_busy():
        return
    if collision_sound:
        collision_sound.play()

def play_red_card_sound():
    if red_card_sound:
        red_card_sound.play()

goal_sounds = {}
def load_sound(path):
    if os.path.exists(path):
        try:
            snd = pygame.mixer.Sound(path)
            snd.set_volume(GOAL_MUSIC_VOLUME)
            return snd
        except: return None
    return None

goal_sounds["GS"] = load_sound(GS_GOAL_FILE)
goal_sounds["FB"] = load_sound(FB_GOAL_FILE)   
goal_sounds["BJK"] = load_sound(BJK_GOAL_FILE) 
goal_sounds["TS"] = load_sound(TS_GOAL_FILE)   

goal_sounds["GOAL1"] = load_sound(GOAL1_FILE)
goal_sounds["GOAL2"] = load_sound(GOAL2_FILE)
goal_sounds["GOAL3"] = load_sound(GOAL3_FILE)

general_pool = []
if goal_sounds["GOAL1"]: general_pool.append(goal_sounds["GOAL1"])
if goal_sounds["GOAL2"]: general_pool.append(goal_sounds["GOAL2"])
if goal_sounds["GOAL3"]: general_pool.append(goal_sounds["GOAL3"])

# FONTS
font_score = pygame.font.SysFont("impact", 54) 
font_timer = pygame.font.SysFont("impact", 28)
font_event = pygame.font.SysFont("impact", 50)
font_team = pygame.font.SysFont("impact", 48) 
# UPDATED: Smaller font size (16 -> 13)
font_goal_list = pygame.font.SysFont("impact", 13)
font_goll_msg = pygame.font.SysFont("impact", 90)
font_menu_title = pygame.font.SysFont("impact", 40)
font_menu_item = pygame.font.SysFont("impact", 20)
font_ball = pygame.font.SysFont("impact", 20)
font_notification = pygame.font.SysFont("impact", 32)

clock = pygame.time.Clock()

# --- HELPER FUNCTIONS ---

def draw_striped_pitch(surface, cx, cy, radius):
    pygame.draw.circle(surface, GRASS_1, (cx, cy), radius)
    stripe_surf = pygame.Surface((radius*2, radius*2), pygame.SRCALPHA)
    for i in range(0, radius*2, 60):
        pygame.draw.rect(stripe_surf, GRASS_2, (0, i, radius*2, 30))
    mask_surf = pygame.Surface((radius*2, radius*2), pygame.SRCALPHA)
    pygame.draw.circle(mask_surf, (255, 255, 255, 255), (radius, radius), radius)
    stripe_surf.blit(mask_surf, (0,0), special_flags=pygame.BLEND_RGBA_MIN)
    surface.blit(stripe_surf, (cx - radius, cy - radius))
    
    # --- NEW: RGB GRADIENT EDGE ---
    for angle in range(0, 360):
        rad_start = math.radians(angle)
        rad_end = math.radians(angle + 1.5) 
        start_pos = (cx + math.cos(rad_start) * radius, cy + math.sin(rad_start) * radius)
        end_pos = (cx + math.cos(rad_end) * radius, cy + math.sin(rad_end) * radius)
        color = pygame.Color(0)
        color.hsla = (angle % 360, 100, 50, 100) 
        pygame.draw.line(surface, color, start_pos, end_pos, 6)

    pygame.draw.circle(surface, WHITE, (cx, cy), 50, 2)
    pygame.draw.line(surface, WHITE, (cx - radius + 20, cy), (cx + radius - 20, cy), 2)

def calculate_goal_posts(cx, cy, radius, angle, width_rad):
    start_angle = angle - width_rad / 2
    end_angle = angle + width_rad / 2
    p1x = cx + math.cos(start_angle) * radius
    p1y = cy + math.sin(start_angle) * radius
    p2x = cx + math.cos(end_angle) * radius
    p2y = cy + math.sin(end_angle) * radius
    return (p1x, p1y), (p2x, p2y), start_angle, end_angle

def draw_real_goal(surface, cx, cy, radius, angle, width_rad):
    (p1x, p1y), (p2x, p2y), start_angle, end_angle = calculate_goal_posts(cx, cy, radius, angle, width_rad)
    depth = GOAL_DEPTH
    b1x = cx + math.cos(start_angle) * (radius + depth)
    b1y = cy + math.sin(start_angle) * (radius + depth)
    b2x = cx + math.cos(end_angle) * (radius + depth)
    b2y = cy + math.sin(end_angle) * (radius + depth)

    for i in range(1, 6):
        ratio = i / 6
        lx1 = p1x + (b1x - p1x) * ratio
        ly1 = p1y + (b1y - p1y) * ratio
        lx2 = p2x + (b2x - p2x) * ratio
        ly2 = p2y + (b2y - p2y) * ratio
        pygame.draw.line(surface, NET_COLOR, (lx1, ly1), (lx2, ly2), 1)

        lx3 = p1x + (p2x - p1x) * ratio
        ly3 = p1y + (p2y - p1y) * ratio
        lx4 = b1x + (b2x - b1x) * ratio
        ly4 = b1y + (b2y - b1y) * ratio
        pygame.draw.line(surface, NET_COLOR, (lx3, ly3), (lx4, ly4), 1)

    pygame.draw.lines(surface, WHITE, False, [(p1x, p1y), (b1x, b1y), (b2x, b2y), (p2x, p2y)], 3)
    pygame.draw.circle(surface, WHITE, (int(p1x), int(p1y)), POST_RADIUS)
    pygame.draw.circle(surface, WHITE, (int(p2x), int(p2y)), POST_RADIUS)
    # UPDATED: Use POST_INNER_COLOR constant
    pygame.draw.circle(surface, POST_INNER_COLOR, (int(p1x), int(p1y)), POST_RADIUS-2)
    pygame.draw.circle(surface, POST_INNER_COLOR, (int(p2x), int(p2y)), POST_RADIUS-2)

def get_random_spawn(cx, cy, r_limit):
    while True:
        rx = random.randint(cx - 150, cx + 150)
        ry = random.randint(cy - 200, cy + 50)
        dist = math.hypot(rx - cx, ry - cy)
        if dist < r_limit - BALL_RADIUS - 10:
            return rx, ry

# --- NEW: PARTICLE CLASS ---
class Particle:
    def __init__(self, x, y, color):
        self.x = x
        self.y = y
        self.color = color
        # Fly outwards/randomly
        angle = random.uniform(0, 2 * math.pi)
        speed = random.uniform(1, 3)
        self.vx = math.cos(angle) * speed
        self.vy = math.sin(angle) * speed
        self.life = FPS * 0.8 # 1 second total
        self.fade_start = FPS * 0.5 # Start decaying after 0.5s
        self.radius = random.randint(1, 3)

    def update(self):
        self.x += self.vx
        self.y += self.vy
        self.life -= 1

    def draw(self, surface):
        if self.life > 0:
            alpha = 255
            if self.life < self.fade_start:
                # Decay alpha
                alpha = int(255 * (self.life / self.fade_start))
            
            # Use a temporary surface for alpha transparency
            s = pygame.Surface((self.radius*2, self.radius*2), pygame.SRCALPHA)
            pygame.draw.circle(s, (*self.color, alpha), (self.radius, self.radius), self.radius)
            surface.blit(s, (int(self.x - self.radius), int(self.y - self.radius)))

particles = []

class Ball:
    def __init__(self, x, y, color_scheme, text):
        self.x, self.y = x, y
        self.vx = random.choice([-SPEED, SPEED])
        self.vy = random.choice([-SPEED, SPEED])
        self.radius = BALL_RADIUS
        self.color = color_scheme
        self.text = text
        self.mass = 1.0
        # --- NERF MECHANIC ---
        self.nerf_timer = 0
        self.speed_multiplier = 1

    def move(self):
        self.vy += GRAVITY
        
        # Apply nerf logic
        if self.nerf_timer > 0:
            self.nerf_timer -= 1
            self.speed_multiplier = 0.8 # -20% speed
        else:
            self.speed_multiplier = 1.0

        current_friction = FRICTION 
        
        self.vx *= current_friction
        self.vy *= current_friction
        
        current_speed = math.hypot(self.vx, self.vy)
        
        target_speed = SPEED * self.speed_multiplier
        target_min_speed = MIN_SPEED * self.speed_multiplier

        if current_speed < target_min_speed and current_speed > 0:
            scale = target_min_speed / current_speed
            self.vx *= scale
            self.vy *= scale
        elif current_speed == 0:
            self.vx = random.choice([-1, 1]) * target_min_speed
            self.vy = random.choice([-1, 1]) * target_min_speed
            
        self.x += self.vx
        self.y += self.vy

    def draw(self, surface):
        # Create a temporary surface to draw the split ball
        ball_surf = pygame.Surface((self.radius * 2, self.radius * 2), pygame.SRCALPHA)
        
        # Draw left/top half
        pygame.draw.circle(ball_surf, self.color[0], (self.radius, self.radius), self.radius)
        
        # Draw right/bottom half using a rect clip logic
        # Simple way: Draw a rect covering the right half
        half_rect = pygame.Rect(self.radius, 0, self.radius, self.radius * 2)
        pygame.draw.rect(ball_surf, self.color[1], half_rect)
        
        # Now mask it to a circle again so the rect doesn't stick out
        mask_surf = pygame.Surface((self.radius * 2, self.radius * 2), pygame.SRCALPHA)
        pygame.draw.circle(mask_surf, (255, 255, 255), (self.radius, self.radius), self.radius)
        
        # Apply mask
        ball_surf.blit(mask_surf, (0, 0), special_flags=pygame.BLEND_RGBA_MIN)
        
        # Draw outline
        # UPDATED: White outline, thickness 4
        pygame.draw.circle(ball_surf, WHITE, (self.radius, self.radius), self.radius, 4)
        
        # Blit the ball surface to the main screen
        surface.blit(ball_surf, (int(self.x) - self.radius, int(self.y) - self.radius))
        
        # Draw nerf indicator
        if self.nerf_timer > 0:
            pygame.draw.circle(surface, (255, 0, 0), (int(self.x), int(self.y)), self.radius + 4, 2)

    def collide_wall(self, cx, cy, radius):
        dx = self.x - cx
        dy = self.y - cy
        dist = math.hypot(dx, dy)
        if dist + self.radius >= radius:
            nx, ny = dx / dist, dy / dist
            dot = self.vx * nx + self.vy * ny
            if dot > 0:
                self.vx = (self.vx - 2 * dot * nx) * BOUNCE_DAMPING
                self.vy = (self.vy - 2 * dot * ny) * BOUNCE_DAMPING
            overlap = (dist + self.radius) - radius
            self.x -= nx * overlap
            self.y -= ny * overlap

            # --- SPAWN PARTICLES ON WALL HIT ---
            # Spawn slightly outside the ball at the collision point
            hit_x = self.x + nx * self.radius
            hit_y = self.y + ny * self.radius
            
            # Choose color based on ball side
            p_color = random.choice(self.color)
            for _ in range(6): # Spawn 12 particles
                p = Particle(hit_x, hit_y, p_color)
                # Add some outward velocity (away from center)
                p.vx += nx * 2
                p.vy += ny * 2
                particles.append(p)

            return True # Collided
        return False

    def collide_post(self, px, py):
        dx = self.x - px
        dy = self.y - py
        dist = math.hypot(dx, dy)
        if dist < self.radius + POST_RADIUS:
            nx, ny = dx / dist, dy / dist
            dot = self.vx * nx + self.vy * ny
            if dot < 0:
                self.vx = (self.vx - 2 * dot * nx) * POST_ELASTICITY
                self.vy = (self.vy - 2 * dot * ny) * POST_ELASTICITY
                overlap = (self.radius + POST_RADIUS) - dist
                self.x += nx * overlap
                self.y += ny * overlap
                return True
        return False

def resolve_collisions(b1, b2):
    dx = b2.x - b1.x
    dy = b2.y - b1.y
    dist = math.hypot(dx, dy)
    if dist < b1.radius + b2.radius:
        if dist == 0: dist = 0.1
        nx, ny = dx/dist, dy/dist
        overlap = (b1.radius + b2.radius) - dist
        total_mass = b1.mass + b2.mass
        m1_ratio = b2.mass / total_mass
        m2_ratio = b1.mass / total_mass
        b1.x -= nx * overlap * m1_ratio
        b1.y -= ny * overlap * m1_ratio
        b2.x += nx * overlap * m2_ratio
        b2.y += ny * overlap * m2_ratio
        rx = b2.vx - b1.vx
        ry = b2.vy - b1.vy
        vel_along_normal = rx * nx + ry * ny
        if vel_along_normal > 0: return False # Moving away, no sound
        
        j = -(1 + ELASTICITY) * vel_along_normal
        j /= (1 / b1.mass + 1 / b2.mass)
        impulse_x = j * nx
        impulse_y = j * ny
        b1.vx -= impulse_x / b1.mass
        b1.vy -= impulse_y / b1.mass
        b2.vx += impulse_x / b2.mass
        b2.vy += impulse_y / b2.mass
        return True # Collision handled

class RedCard:
    def __init__(self, cx, cy):
        # 1. Random Spawn (Anywhere but not too close to edge)
        angle = random.uniform(0, 2 * math.pi)
        # Using sqrt ensures uniform distribution in a circle, subtract padding to keep away from edge
        dist = math.sqrt(random.random()) * (ARENA_RADIUS - 60)
        
        self.x = cx + math.cos(angle) * dist
        self.y = cy + math.sin(angle) * dist
        
        # 2. Slow Random Movement
        self.vx = random.uniform(-0.4, 0.4)
        self.vy = random.uniform(-0.4, 0.4)
        
        self.width = 16
        self.height = 24
        self.rect = pygame.Rect(self.x - self.width//2, self.y - self.height//2, self.width, self.height)
        
        self.life_timer = 10 * FRAMES_PER_SIM_MINUTE 
        self.blink_start_time = 5 * FRAMES_PER_SIM_MINUTE 
        self.visible = True
        self.active = True

    def update(self):
        if not self.active: return
        self.life_timer -= 1
        if self.life_timer <= 0:
            self.active = False
            return
        
        # 3. Apply Movement
        self.x += self.vx
        self.y += self.vy
        
        # Bounce off the "invisible wall" (keep it inside the arena)
        dist_from_center = math.hypot(self.x - center_x, self.y - center_y)
        if dist_from_center > ARENA_RADIUS - 50:
            self.vx *= -1
            self.vy *= -1
            
        self.rect.center = (self.x, self.y)
        
        # Blinking logic
        if self.life_timer < (10 * FRAMES_PER_SIM_MINUTE) - self.blink_start_time:
            if (self.life_timer // 10) % 2 == 0:
                self.visible = False
            else:
                self.visible = True
        else:
            self.visible = True

    def draw(self, surface):
        if self.active and self.visible:
            pygame.draw.rect(surface, RED_CARD_COLOR, self.rect)
            pygame.draw.rect(surface, WHITE, self.rect, 1)

    def check_collision(self, ball):
        if not self.active: return False
        closest_x = max(self.rect.left, min(ball.x, self.rect.right))
        closest_y = max(self.rect.top, min(ball.y, self.rect.bottom))
        dx = ball.x - closest_x
        dy = ball.y - closest_y
        dist_sq = dx*dx + dy*dy
        if dist_sq < ball.radius**2:
            self.active = False
            play_red_card_sound() # Play sound
            return True
        return False

# --- GLOBAL GAME VARIABLES ---
center_x, center_y = WIDTH // 2, HEIGHT // 2
score1, score2 = 0, 0
goal_angle = 1 * math.pi / 2
goal_rotating = False
goal_rot_speed = 0.015
goll_timer = 0
goal_text_color = GOLD # Default
# Modified to store Frame AND STATE: (Time, Type, ScorerName, Frame, StateWhenOccurred)
goal_events_1 = [] 
goal_events_2 = [] 
state = "MENU"
frame_counter = 0
added_time_1 = random.randint(2, 4)
added_time_2 = random.randint(3, 9)
display_added_time = False
end_match_timer = 0
halftime_timer = 0 

# --- RED CARD VARIABLES ---
red_card_obj = None
red_card_spawned_this_half = False

# MENU VARIABLES
selected_home_idx = 0
selected_away_idx = 1
team1_name = ""
team2_name = ""
team1_colors = []
team2_colors = []

# Scrollbar Variables
menu_scroll_y = 0
is_dragging_scroll = False

# Placeholder objects
ball1 = None
ball2 = None
crowd = []

# SOUND CHANNELS
goal_sound_channel = None

# --- NEW: Helper for outlined text ---
def draw_text_with_outline(surface, text, font, color, x, y, align="center"):
    outline_color = BLACK
    offsets = [(-2, -2), (-2, 2), (2, -2), (2, 2), (-2, 0), (2, 0), (0, -2), (0, 2)]
    
    # Render outline first
    for ox, oy in offsets:
        surf = font.render(text, True, outline_color)
        if align == "center":
            rect = surf.get_rect(center=(x + ox, y + oy))
        elif align == "right":
            rect = surf.get_rect(topright=(x + ox, y + oy))
        else: # left
            rect = surf.get_rect(topleft=(x + ox, y + oy))
        surface.blit(surf, rect)
        
    # Render main text
    surf = font.render(text, True, color)
    if align == "center":
        rect = surf.get_rect(center=(x, y))
    elif align == "right":
        rect = surf.get_rect(topright=(x, y))
    else: # left
        rect = surf.get_rect(topleft=(x, y))
    surface.blit(surf, rect)

def play_goal_music_for_team(team_short_name):
    global goal_sound_channel
    
    # 1. Stop current sound if playing
    if goal_sound_channel and goal_sound_channel.get_busy():
        goal_sound_channel.stop()

    sound_to_play = None
    
    # 2. Select sound based on team name
    if team_short_name == "GS":
        sound_to_play = goal_sounds["GS"]
    elif team_short_name == "FB":
        sound_to_play = goal_sounds["FB"]
    elif team_short_name == "BJK":
        sound_to_play = goal_sounds["BJK"]
    elif team_short_name == "TS":
        sound_to_play = goal_sounds["TS"]
    else:
        # All other teams get a random generic goal sound
        if len(general_pool) > 0:
            sound_to_play = random.choice(general_pool)

    # 3. Play the sound
    if sound_to_play:
        goal_sound_channel = sound_to_play.play()

def start_match():
    global ball1, ball2, crowd, team1_name, team2_name, team1_colors, team2_colors, state, score1, score2, goal_events_1, goal_events_2, frame_counter, goal_rotating, goal_sound_channel
    global red_card_obj, red_card_spawned_this_half, halftime_timer, particles
    
    score1, score2 = 0, 0
    goal_events_1 = []
    goal_events_2 = []
    frame_counter = 0
    goal_rotating = False
    particles = []
    
    # Reset Red Card
    red_card_obj = None
    red_card_spawned_this_half = False
    halftime_timer = 0

    goal_sound_channel = None

    home_key = TEAM_NAMES[selected_home_idx]
    away_key = TEAM_NAMES[selected_away_idx]

    team1_name = TEAMS[home_key]["short"]
    team2_name = TEAMS[away_key]["short"]
    team1_colors = TEAMS[home_key]["colors"]
    team2_colors = TEAMS[away_key]["colors"]

    sx1, sy1 = get_random_spawn(center_x, center_y, ARENA_RADIUS)
    sx2, sy2 = get_random_spawn(center_x, center_y, ARENA_RADIUS)
    ball1 = Ball(sx1, sy1, team1_colors, team1_name)
    ball2 = Ball(sx2, sy2, team2_colors, team2_name)

    crowd = []
    for _ in range(120):
        rand_val = random.random()
        if rand_val < 0.45:
            col = random.choice(team1_colors)
        elif rand_val < 0.90:
            col = random.choice(team2_colors)
        else:
            col = (50, 50, 50)
        crowd.append((random.randint(0, WIDTH), random.randint(0, HEIGHT), col))

    if stadium_music_loaded:
        pygame.mixer.music.play(-1, fade_ms=500)

    state = "FIRST_HALF"

running = True
while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False

        if state == "MENU":
            list_start_y = 120
            visible_h = HEIGHT - 220
            total_items_h = len(TEAM_NAMES) * 40
            max_scroll = total_items_h - visible_h
            if max_scroll < 0: max_scroll = 0
            scrollbar_w = 15
            scrollbar_x = WIDTH - 20
            scrollbar_y_start = 120
            scrollbar_h_total = visible_h
            if total_items_h > 0:
                handle_h = max(30, (visible_h / total_items_h) * scrollbar_h_total)
            else:
                handle_h = scrollbar_h_total
            if max_scroll > 0:
                scroll_ratio = abs(menu_scroll_y) / max_scroll
                handle_y = scrollbar_y_start + scroll_ratio * (scrollbar_h_total - handle_h)
            else:
                handle_y = scrollbar_y_start
            scrollbar_rect = pygame.Rect(scrollbar_x, scrollbar_y_start, scrollbar_w, scrollbar_h_total)
            handle_rect = pygame.Rect(scrollbar_x, handle_y, scrollbar_w, handle_h)

            start_btn_rect = pygame.Rect(WIDTH//2 - 150, HEIGHT - 100, 300, 60)

            if event.type == pygame.MOUSEBUTTONDOWN:
                mx, my = pygame.mouse.get_pos()
                if handle_rect.collidepoint(mx, my):
                    is_dragging_scroll = True
                    mouse_offset_y = my - handle_y
                for i, name in enumerate(TEAM_NAMES):
                    item_y = 120 + i * 40 + menu_scroll_y
                    if item_y > 100 and item_y < HEIGHT - 110:
                        rect = pygame.Rect(50, item_y, 200, 30)
                        if rect.collidepoint(mx, my):
                            selected_home_idx = i
                for i, name in enumerate(TEAM_NAMES):
                    item_y = 120 + i * 40 + menu_scroll_y
                    if item_y > 100 and item_y < HEIGHT - 110:
                        rect = pygame.Rect(350, item_y, 200, 30)
                        if rect.collidepoint(mx, my):
                            selected_away_idx = i

                if start_btn_rect.collidepoint(mx, my):
                    start_match()
            elif event.type == pygame.MOUSEBUTTONUP:
                is_dragging_scroll = False
            elif event.type == pygame.MOUSEMOTION:
                if is_dragging_scroll and max_scroll > 0:
                    mx, my = pygame.mouse.get_pos()
                    new_handle_y = my - mouse_offset_y
                    if new_handle_y < scrollbar_y_start: new_handle_y = scrollbar_y_start
                    if new_handle_y > scrollbar_y_start + scrollbar_h_total - handle_h:
                        new_handle_y = scrollbar_y_start + scrollbar_h_total - handle_h
                    percent = (new_handle_y - scrollbar_y_start) / (scrollbar_h_total - handle_h)
                    menu_scroll_y = -(percent * max_scroll)
            elif event.type == pygame.MOUSEWHEEL:
                menu_scroll_y += event.y * 30
                if menu_scroll_y > 0: menu_scroll_y = 0
                if menu_scroll_y < -max_scroll: menu_scroll_y = -max_scroll

        elif state == "FULLTIME":
            if end_match_timer > 2 * FPS: 
                # UPDATED: Button Y position lowered from 150 to 120
                restart_btn_rect = pygame.Rect(WIDTH//2 - 150, HEIGHT - 120, 300, 60)
                if event.type == pygame.MOUSEBUTTONDOWN:
                    mx, my = pygame.mouse.get_pos()
                    if restart_btn_rect.collidepoint(mx, my):
                        state = "MENU"
                        # --- RESET GOAL POSITION TO BOTTOM ---
                        goal_angle = 1 * math.pi / 2
                        if goal_sound_channel: goal_sound_channel.stop()

    # --- UPDATE LOGIC ---
    if state == "MENU":
        screen.fill(MENU_BG)
        title = font_menu_title.render("TAKIM SEÇİMİ", True, GOLD)
        screen.blit(title, (WIDTH//2 - title.get_width()//2, 20))
        home_header = font_team.render("EV SAHİBİ", True, WHITE)
        screen.blit(home_header, (45, 68))
        away_header = font_team.render("DEPLASMAN", True, WHITE)
        screen.blit(away_header, (335, 68))
        clip_rect = pygame.Rect(0, 110, WIDTH, HEIGHT - 210)
        screen.set_clip(clip_rect)
        for i, name in enumerate(TEAM_NAMES):
            item_y = 120 + i * 40 + menu_scroll_y
            if item_y < 100 or item_y > HEIGHT - 100:
                continue
            col = SELECTED_COLOR if i == selected_home_idx else WHITE
            name_surf = font_menu_item.render(name, True, col)
            screen.blit(name_surf, (50, item_y))
            col = SELECTED_COLOR if i == selected_away_idx else WHITE
            name_surf = font_menu_item.render(name, True, col)
            screen.blit(name_surf, (350, item_y))
        screen.set_clip(None)
        pygame.draw.rect(screen, SCROLLBAR_BG, scrollbar_rect)
        pygame.draw.rect(screen, SCROLLBAR_HANDLE, handle_rect, border_radius=5)

        pygame.draw.rect(screen, MENU_BG, (0, HEIGHT-110, WIDTH, 110))

        btn_rect = pygame.Rect(WIDTH//2 - 150, HEIGHT - 100, 300, 60)
        pygame.draw.rect(screen, GRASS_1, btn_rect, border_radius=15)
        pygame.draw.rect(screen, WHITE, btn_rect, 3, border_radius=15)

        btn_txt = font_menu_title.render("MAÇI BAŞLAT", True, WHITE)
        btn_txt_rect = btn_txt.get_rect(center=btn_rect.center)
        screen.blit(btn_txt, btn_txt_rect)

    elif state in ["FIRST_HALF", "SECOND_HALF", "HALFTIME", "FULLTIME"]:
        if state in ["FIRST_HALF", "SECOND_HALF"]:
            frame_counter += 1
            total_mins_played = frame_counter // FRAMES_PER_SIM_MINUTE
            if state == "FIRST_HALF":
                sim_minute = total_mins_played
                
                # --- RED CARD SPAWN LOGIC (FIRST HALF 8%) ---
                if not red_card_spawned_this_half and not red_card_obj:
                    if random.random() < 0.08 / (45 * 60) * 10: 
                        red_card_obj = RedCard(center_x, center_y)
                        red_card_spawned_this_half = True
                
                if sim_minute >= 45:
                    display_added_time = True
                    if sim_minute >= 45 + added_time_1:
                        state = "HALFTIME"
                        halftime_timer = 0
                        red_card_obj = None # Remove card at halftime
                else:
                    display_added_time = False
            elif state == "SECOND_HALF":
                sim_minute = 45 + total_mins_played

                # --- RED CARD SPAWN LOGIC (SECOND HALF 25%) ---
                if not red_card_spawned_this_half and not red_card_obj:
                    if random.random() < 0.25 / (45 * 60) * 10: 
                        red_card_obj = RedCard(center_x, center_y)
                        red_card_spawned_this_half = True

                if sim_minute >= 90:
                    display_added_time = True
                    if sim_minute >= 90 + added_time_2:
                        state = "FULLTIME"
                        end_match_timer = 0
                else:
                    display_added_time = False

            if state == "FIRST_HALF" and display_added_time and sim_minute >= 45 + added_time_1:
                state = "HALFTIME"
                halftime_timer = 0
                red_card_obj = None

            if goal_rotating:
                goal_angle = (goal_angle + goal_rot_speed) % (2 * math.pi)
            if goll_timer > 0:
                goll_timer -= 1
            
            # --- UPDATE RED CARD ---
            if red_card_obj:
                red_card_obj.update()
                if not red_card_obj.active:
                    red_card_obj = None 
                else:
                    # Check collisions
                    for b in [ball1, ball2]:
                        if red_card_obj.check_collision(b):
                            # APPLY NERF
                            b.nerf_timer = 20 * FRAMES_PER_SIM_MINUTE
                            
                            # STORE EVENT AS TUPLE: (Time, Type, ScorerName, Frame, State)
                            time_mark = f"{sim_minute}'"
                            if b == ball1:
                                goal_events_1.append((time_mark, "RED_CARD", "", frame_counter, state))
                            else:
                                goal_events_2.append((time_mark, "RED_CARD", "", frame_counter, state))
                            
                            red_card_obj = None
                            break

            (p1, p2, _, _) = calculate_goal_posts(center_x, center_y, ARENA_RADIUS, goal_angle, GOAL_WIDTH_RADIANS)
            for b in [ball1, ball2]:
                b.move()
                b.collide_post(p1[0], p1[1])
                b.collide_post(p2[0], p2[1])
            for _ in range(8):
                # --- COLLISION SOUNDS FOR WALL ---
                if ball1.collide_wall(center_x, center_y, ARENA_RADIUS):
                    play_collision_sound()
                if ball2.collide_wall(center_x, center_y, ARENA_RADIUS):
                    play_collision_sound()
                # --- COLLISION SOUNDS FOR BALLS ---
                if resolve_collisions(ball1, ball2):
                    play_collision_sound()
                    
            for b in [ball1, ball2]:
                dist = math.hypot(b.x - center_x, b.y - center_y)
                if dist > ARENA_RADIUS - b.radius - 5:
                    ball_ang = math.atan2(b.y - center_y, b.x - center_x)
                    goal_n = goal_angle % (2*math.pi)
                    ball_n = ball_ang % (2*math.pi)
                    diff = abs(ball_n - goal_n)
                    while diff > math.pi: diff = abs(diff - 2*math.pi)
                    if diff < GOAL_WIDTH_RADIANS / 2:
                        goll_timer = 90
                        time_mark = f"{sim_minute}'"
                        if state == "FIRST_HALF":
                            if sim_minute > 45:
                                time_mark = f"45+{sim_minute - 45}'"
                        elif state == "SECOND_HALF":
                            if sim_minute > 90:
                                time_mark = f"90+{sim_minute - 90}'"
                        if b == ball1:
                            score1 += 1
                            goal_text_color = team1_colors[0] # Set text color
                            # GET PLAYER NAME
                            scorer_name = get_random_player_name(TEAM_NAMES[selected_home_idx])
                            # STORE EVENT AS TUPLE: (Time, Type, ScorerName, Frame, State)
                            goal_events_1.append((time_mark, "GOAL", scorer_name, frame_counter, state))
                            ball1.x, ball1.y = center_x, center_y
                            play_goal_music_for_team(team1_name)
                        else:
                            score2 += 1
                            goal_text_color = team2_colors[0] # Set text color
                            # GET PLAYER NAME
                            scorer_name = get_random_player_name(TEAM_NAMES[selected_away_idx])
                            # STORE EVENT AS TUPLE: (Time, Type, ScorerName, Frame, State)
                            goal_events_2.append((time_mark, "GOAL", scorer_name, frame_counter, state))
                            ball2.x, ball2.y = center_x, center_y
                            play_goal_music_for_team(team2_name)

                        if score1 + score2 >= 1: goal_rotating = True
                        ball1.vx = random.choice([-SPEED, SPEED]) * random.uniform(0.8, 1.2)
                        ball1.vy = random.choice([-SPEED, SPEED]) * random.uniform(0.8, 1.2)
                        ball2.vx = random.choice([-SPEED, SPEED]) * random.uniform(0.8, 1.2)
                        ball2.vy = random.choice([-SPEED, SPEED]) * random.uniform(0.8, 1.2)

        if state == "HALFTIME":
            halftime_timer += 1
            if halftime_timer > 3 * FPS: # Show halftime for 3 seconds
                state = "SECOND_HALF"
                frame_counter = 0
                red_card_spawned_this_half = False 
                red_card_obj = None
                display_added_time = False
                rx1, ry1 = get_random_spawn(center_x, center_y, ARENA_RADIUS)
                rx2, ry2 = get_random_spawn(center_x, center_y, ARENA_RADIUS)
                ball1.x, ball1.y = rx1, ry1
                ball2.x, ball2.y = rx2, ry2

        # --- UPDATE PARTICLES ---
        for p in particles[:]:
            p.update()
            if p.life <= 0:
                particles.remove(p)

        screen.fill(BLACK)
        for dot in crowd:
            pygame.draw.circle(screen, dot[2], (dot[0], dot[1]), 2)
        draw_striped_pitch(screen, center_x, center_y, ARENA_RADIUS)
        draw_real_goal(screen, center_x, center_y, ARENA_RADIUS, goal_angle, GOAL_WIDTH_RADIANS)
        
        # --- DRAW RED CARD ---
        if red_card_obj:
            red_card_obj.draw(screen)

        ball1.draw(screen)
        ball2.draw(screen)

        # --- DRAW PARTICLES ---
        for p in particles:
            p.draw(screen)

        # --- DRAW REDESIGNED SCOREBOARD ---
        # Slimmer, rounded, cleaner table
        panel_w, panel_h = 500, 105 
        panel_x = WIDTH // 2 - panel_w // 2
        
        # Transparent Background with Radius
        table_surf = pygame.Surface((panel_w, panel_h), pygame.SRCALPHA)
        # Using a specialized rect draw for rounded corners on surface
        pygame.draw.rect(table_surf, TABLE_BG, (0, 0, panel_w, panel_h), border_radius=15)
        screen.blit(table_surf, (panel_x, 20))
        
        # Border
        pygame.draw.rect(screen, WHITE, (panel_x, 20, panel_w, panel_h), 2, border_radius=15)
        
        # --- FIXED ALIGNMENT FOR NAMES AND SCORES ---
        # Center of scoreboard vertically is approx Y=72
        align_y = 72
        
        # Team Names
        draw_text_with_outline(screen, TEAMS[TEAM_NAMES[selected_home_idx]]["short"], font_team, team1_colors[0], panel_x + 30, align_y - 30, "left")
        draw_text_with_outline(screen, TEAMS[TEAM_NAMES[selected_away_idx]]["short"], font_team, team2_colors[0], panel_x + panel_w - 30, align_y - 30, "right")
        
        # Scores
        center_score_x = WIDTH // 2
        draw_text_with_outline(screen, str(score1), font_score, team1_colors[1], center_score_x - 50, align_y)
        draw_text_with_outline(screen, "-", font_score, BLACK, center_score_x, align_y)
        draw_text_with_outline(screen, str(score2), font_score, team2_colors[1], center_score_x + 50, align_y)

        # Time Display (Inside table, below scores, smaller)
        time_str = ""
        col = BLACK # Black time color inside white table
        if state == "FIRST_HALF":
            if display_added_time:
                time_str = f"45+{sim_minute - 45}'"
                col = (200, 0, 0)
            else:
                time_str = f"{sim_minute}'"
        elif state == "HALFTIME":
            time_str = "İY"
            col = (0, 0, 0)
        elif state == "SECOND_HALF":
            if display_added_time:
                time_str = f"90+{sim_minute - 90}'"
                col = (200, 0, 0)
            else:
                time_str = f"{sim_minute}'"
        elif state == "FULLTIME":
            time_str = "MS"
            col = (0, 0, 0)
        
        timer_surf = font_timer.render(time_str, True, col)
        screen.blit(timer_surf, (WIDTH//2 - timer_surf.get_width()//2, 85))
        
        # --- EVENT NOTIFICATIONS (BIG THEN SMALL) ---
        # 2.5 seconds * 80 FPS = 200 frames
        notif_duration = 200
        
        # Check for recent events
        active_notif = None
        
        # Helper to process events list
        def draw_event_list(events_list, x_pos, align_right=False):
            y_off = 130
            recent_event = None
            
            # Get last 5 events
            visible_events = events_list[-5:]
            
            for event_data in visible_events:
                t_str, e_type, scorer, ev_frame, ev_state = event_data
                
                # Check if this event is new (less than 2.5s old) AND happened in current half
                # If state changed (e.g. halftime), frame_counter reset, so check ev_state matches state
                is_new = (ev_state == state) and (0 <= (frame_counter - ev_frame) < notif_duration)
                
                if is_new:
                    # It will be drawn big in the center
                    if e_type == "GOAL":
                        txt = f"GOLLL! {scorer} ({t_str})"
                        col = GOLD
                    else:
                        txt = f"Kırmızı Kart! ({t_str})"
                        col = RED_CARD_COLOR
                    recent_event = (txt, col)
                    continue 

                # Draw Small in List
                if e_type == "GOAL":
                    display_str = f"{t_str} {scorer}"
                else:
                    display_str = t_str

                t_surf = font_goal_list.render(display_str, True, WHITE)
                
                draw_x = x_pos
                if align_right:
                    draw_x = x_pos - t_surf.get_width()
                
                screen.blit(t_surf, (draw_x, y_off))
                
                if e_type == "RED_CARD":
                    rc_rect = pygame.Rect(draw_x + t_surf.get_width() + 5, y_off + 2, 10, 14)
                    if align_right: # adjust for right alignment
                        rc_rect.x = draw_x - 15
                    pygame.draw.rect(screen, RED_CARD_COLOR, rc_rect)
                    pygame.draw.rect(screen, WHITE, rc_rect, 1)
                
                y_off += 20
            
            return recent_event

        # Draw Lists and capture recent events
        recent1 = draw_event_list(goal_events_1, panel_x + 20, align_right=False)
        recent2 = draw_event_list(goal_events_2, panel_x + panel_w - 20, align_right=True)
        
        # Draw BIG notifications with fitting background
        notif_y = 150
        
        def draw_big_notif(txt, col, y):
            draw_text_with_outline(screen, txt, font_notification, col, WIDTH//2, y + 20)
            return y + 40

        if recent1:
            notif_y = draw_big_notif(recent1[0], recent1[1], notif_y)
            
        if recent2:
            notif_y = draw_big_notif(recent2[0], recent2[1], notif_y)

        if goll_timer > 0:
            # UPDATED: Use goal_text_color variable
            goll_surf = font_goll_msg.render("GOLLL!", True, goal_text_color)
            outline_surf = font_goll_msg.render("GOLLL!", True, BLACK)
            gx, gy = WIDTH//2 - goll_surf.get_width()//2, HEIGHT//2 - 50
            screen.blit(outline_surf, (gx+4, gy+4))
            screen.blit(goll_surf, (gx, gy))

        if state == "HALFTIME":
            overlay_text = font_event.render("İlk Yarı", True, WHITE)
            text_rect = overlay_text.get_rect(center=(WIDTH//2, HEIGHT//2 + 50))
            
            # UPDATED: REMOVED BACKGROUND RECTANGLE DRAWING
            
            screen.blit(overlay_text, text_rect)

        elif state == "FULLTIME":
            end_match_timer += 1
            overlay_text = font_event.render("Maç Sonucu", True, WHITE)
            text_rect = overlay_text.get_rect(center=(WIDTH//2, HEIGHT//2 + 70))
            
            # UPDATED: REMOVED BACKGROUND RECTANGLE DRAWING
            
            screen.blit(overlay_text, text_rect)

            if end_match_timer > 2 * FPS:
                # UPDATED: Button Y position lowered from 150 to 120
                restart_btn_rect = pygame.Rect(WIDTH//2 - 150, HEIGHT - 120, 300, 60)
                pygame.draw.rect(screen, GRASS_1, restart_btn_rect, border_radius=15)
                pygame.draw.rect(screen, WHITE, restart_btn_rect, 3, border_radius=15)

                restart_txt = font_menu_title.render("MENÜYE DÖN", True, WHITE)
                restart_txt_rect = restart_txt.get_rect(center=restart_btn_rect.center)
                screen.blit(restart_txt, restart_txt_rect)

    pygame.display.flip()
    clock.tick(FPS)

pygame.quit()