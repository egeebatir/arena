import pygame
import random
import sys

# ==========================================
# 1. CONFIGURATION & SETUP
# ==========================================
pygame.init()

# Window Setup
ARENA_SIZE = 600
HEADER_HEIGHT = 100
FOOTER_HEIGHT = 100
WIDTH = ARENA_SIZE
HEIGHT = HEADER_HEIGHT + ARENA_SIZE + FOOTER_HEIGHT

screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Territory War: Square Arena")

# Physics Constants
TILE_SIZE = 30
SPEED = 12

# Colors
COLOR_P1 = (255, 255, 255)  # White
COLOR_P2 = (0, 0, 255)      # Blue
COLOR_BG_UI = (20, 20, 20)  # Dark Grey for UI
COLOR_TEXT = (255, 255, 255)

# Fonts
try:
    FONT_MAIN = pygame.font.SysFont("Arial", 28, bold=True)
    FONT_BIG = pygame.font.SysFont("Arial", 40, bold=True)
    FONT_SMALL = pygame.font.SysFont("Arial", 18, bold=True)
except:
    FONT_MAIN = pygame.font.Font(None, 28)
    FONT_BIG = pygame.font.Font(None, 40)
    FONT_SMALL = pygame.font.Font(None, 18)

# ==========================================
# 2. GAME LOGIC CLASSES
# ==========================================

class Player:
    def __init__(self, name, color, id, start_x, start_y):
        self.name = name
        self.color = color
        self.id = id  # 1 for P1, 2 for P2
        # Increased size from 30 to 40 (~30% bigger)
        self.size = 40
        self.rect = pygame.Rect(start_x, start_y, self.size, self.size)
        self.vel_x = random.choice([-SPEED, SPEED])
        self.vel_y = random.choice([-SPEED, SPEED])
        self.health = 100
        self.is_alive = True

    def move_and_capture(self, grid):
        if not self.is_alive: return

        # Predict next position on X axis
        next_rect_x = self.rect.copy()
        next_rect_x.x += self.vel_x

        # Predict next position on Y axis
        next_rect_y = self.rect.copy()
        next_rect_y.y += self.vel_y

        # --- COLLISION LOGIC ---
        
        # 1. Check X-Axis Movement
        hit_x = False
        if next_rect_x.left < 0 or next_rect_x.right > WIDTH:
            self.vel_x *= -1
            hit_x = True
        else:
            corners = [next_rect_x.topleft, next_rect_x.topright, next_rect_x.bottomleft, next_rect_x.bottomright]
            for px, py in corners:
                gy = (py - HEADER_HEIGHT) // TILE_SIZE
                gx = px // TILE_SIZE
                
                if 0 <= gy < len(grid) and 0 <= gx < len(grid[0]):
                    if grid[gy][gx] != self.id:
                        grid[gy][gx] = self.id # CAPTURE
                        self.vel_x *= -1       # BOUNCE
                        hit_x = True
                        break
        
        if not hit_x:
            self.rect.x += self.vel_x

        # 2. Check Y-Axis Movement
        hit_y = False
        if next_rect_y.top < HEADER_HEIGHT or next_rect_y.bottom > HEADER_HEIGHT + ARENA_SIZE:
            self.vel_y *= -1
            hit_y = True
        else:
            corners = [next_rect_y.topleft, next_rect_y.topright, next_rect_y.bottomleft, next_rect_y.bottomright]
            for px, py in corners:
                gy = (py - HEADER_HEIGHT) // TILE_SIZE
                gx = px // TILE_SIZE
                
                if 0 <= gy < len(grid) and 0 <= gx < len(grid[0]):
                    if grid[gy][gx] != self.id:
                        grid[gy][gx] = self.id # CAPTURE
                        self.vel_y *= -1       # BOUNCE
                        hit_y = True
                        break
        
        if not hit_y:
            self.rect.y += self.vel_y

    def draw(self, surface):
        if not self.is_alive: return
        radius = self.size // 2
        pygame.draw.circle(surface, self.color, self.rect.center, radius)
        pygame.draw.circle(surface, (0,0,0), self.rect.center, radius, 3)

class Item:
    def __init__(self, type_name):
        self.type = type_name
        self.rect = pygame.Rect(0, 0, 30, 30)
        self.rect.x = random.randint(20, WIDTH - 50)
        self.rect.y = random.randint(HEADER_HEIGHT + 20, HEIGHT - FOOTER_HEIGHT - 50)
        self.creation_time = pygame.time.get_ticks() # Timestamp when created

    def draw(self, surface):
        # Calculate time left for visuals (optional blinking)
        elapsed = pygame.time.get_ticks() - self.creation_time
        if elapsed > 2000 and (elapsed // 200) % 2 == 0:
            return # Blink effect before disappearing

        if self.type == "bomb":
            pygame.draw.circle(surface, (0, 0, 0), self.rect.center, 15)
            pygame.draw.line(surface, (255, 100, 0), self.rect.center, (self.rect.centerx+5, self.rect.centery-10), 3)
        elif self.type == "swap":
            pygame.draw.circle(surface, (255, 215, 0), self.rect.center, 15)
            pygame.draw.circle(surface, (255, 255, 255), self.rect.center, 15, 2)

# ==========================================
# 3. MAIN LOOP
# ==========================================

def main():
    clock = pygame.time.Clock()
    
    # Grid Initialization
    rows = ARENA_SIZE // TILE_SIZE
    cols = ARENA_SIZE // TILE_SIZE
    grid = [[0 for _ in range(cols)] for _ in range(rows)]

    # Initial Halves
    for r in range(rows):
        for c in range(cols):
            if c < cols // 2:
                grid[r][c] = 1
            else:
                grid[r][c] = 2

    # --- RANDOM SPAWN LOGIC ---
    # P1 (Left Side)
    p1_start_x = random.randint(TILE_SIZE, (WIDTH // 2) - TILE_SIZE * 2)
    p1_start_y = random.randint(HEADER_HEIGHT + TILE_SIZE, HEIGHT - FOOTER_HEIGHT - TILE_SIZE)
    
    # P2 (Right Side)
    p2_start_x = random.randint((WIDTH // 2) + TILE_SIZE, WIDTH - TILE_SIZE * 2)
    p2_start_y = random.randint(HEADER_HEIGHT + TILE_SIZE, HEIGHT - FOOTER_HEIGHT - TILE_SIZE)

    p1 = Player("Player 1", COLOR_P1, 1, p1_start_x, p1_start_y)
    p2 = Player("Player 2", COLOR_P2, 2, p2_start_x, p2_start_y)

    items = []
    # Timers (using milliseconds for precision)
    last_spawn_time = pygame.time.get_ticks()
    spawn_interval = 5000  # 5 Seconds
    item_lifetime = 3000   # 3 Seconds

    game_over = False
    winner_text = ""

    print("--- STARTING ---")
    p1.name = input("Enter Name for White (Left): ") or "White"
    p2.name = input("Enter Name for Blue (Right): ") or "Blue"

    while True:
        current_time = pygame.time.get_ticks()
        
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit(); sys.exit()

        if not game_over:
            # 1. Move & Capture
            p1.move_and_capture(grid)
            p2.move_and_capture(grid)

            # 2. Item Management
            # Spawn Check (Every 5 seconds)
            if current_time - last_spawn_time > spawn_interval:
                if len(items) < 2: # Limit max items on screen
                    items.append(Item(random.choice(["bomb", "swap"])))
                last_spawn_time = current_time
            
            # Despawn Check (Remove after 3 seconds)
            items = [item for item in items if current_time - item.creation_time < item_lifetime]

            # Collision Logic
            for p in [p1, p2]:
                if not p.is_alive: continue
                for item in items[:]:
                    if p.rect.colliderect(item.rect):
                        if item.type == "bomb":
                            p.health -= 25
                        elif item.type == "swap":
                            p1.rect.center, p2.rect.center = p2.rect.center, p1.rect.center
                        items.remove(item)

            # 3. Check Win Conditions (Health based)
            if p1.health <= 0:
                game_over = True; winner_text = f"{p2.name} WINS!"
            elif p2.health <= 0:
                game_over = True; winner_text = f"{p1.name} WINS!"

        # --- DRAWING ---
        screen.fill(COLOR_BG_UI)

        # Draw Grid (NO BORDERS)
        p1_tiles = 0
        p2_tiles = 0
        for r in range(rows):
            for c in range(cols):
                val = grid[r][c]
                color = COLOR_P1 if val == 1 else COLOR_P2
                
                # Count tiles for UI
                if val == 1: p1_tiles += 1
                else: p2_tiles += 1

                pygame.draw.rect(screen, color, 
                                 (c * TILE_SIZE, HEADER_HEIGHT + r * TILE_SIZE, TILE_SIZE, TILE_SIZE))

        # Draw Header Info
        header_text = FONT_MAIN.render(f"{p1.name} vs {p2.name}", True, COLOR_TEXT)
        screen.blit(header_text, header_text.get_rect(center=(WIDTH//2, 30)))

        # --- TERRITORY BAR ---
        # Calculate Percentage
        total_tiles = rows * cols
        p1_ratio = p1_tiles / total_tiles
        
        bar_x = 40
        bar_y = 60
        bar_w = WIDTH - 80
        bar_h = 25
        
        # Draw P1 Portion (Left)
        p1_width = int(bar_w * p1_ratio)
        pygame.draw.rect(screen, COLOR_P1, (bar_x, bar_y, p1_width, bar_h))
        
        # Draw P2 Portion (Right)
        pygame.draw.rect(screen, COLOR_P2, (bar_x + p1_width, bar_y, bar_w - p1_width, bar_h))
        
        # Draw Bar Outline
        pygame.draw.rect(screen, (255, 255, 255), (bar_x, bar_y, bar_w, bar_h), 2)
        
        # Percent Text
        p1_pct_text = FONT_SMALL.render(f"{int(p1_ratio*100)}%", True, (0,0,0))
        p2_pct_text = FONT_SMALL.render(f"{100 - int(p1_ratio*100)}%", True, (255,255,255))
        
        if p1_ratio > 0.1: 
            screen.blit(p1_pct_text, (bar_x + 5, bar_y + 2))
        if p1_ratio < 0.9:
            screen.blit(p2_pct_text, (bar_x + bar_w - 35, bar_y + 2))

        # Draw Entities
        for item in items: item.draw(screen)
        p1.draw(screen)
        p2.draw(screen)

        if game_over:
            overlay = pygame.Surface((WIDTH, HEIGHT), pygame.SRCALPHA)
            overlay.fill((0,0,0, 180))
            screen.blit(overlay, (0,0))
            text_surf = FONT_BIG.render(winner_text, True, (255, 215, 0))
            screen.blit(text_surf, text_surf.get_rect(center=(WIDTH//2, HEIGHT//2)))

        pygame.display.flip()
        clock.tick(60)

if __name__ == "__main__":
    main()