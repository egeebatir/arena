import pygame
import random
import sys
import math

# ==========================================
# 1. CONFIGURATION & SETUP
# ==========================================
pygame.init()

# Window Setup
# We want a Square Arena. Let's say 600x600 for the play area.
# We need extra space for Header (100px) and Footer (100px).
ARENA_SIZE = 600
HEADER_HEIGHT = 100
FOOTER_HEIGHT = 100
WIDTH = ARENA_SIZE
HEIGHT = HEADER_HEIGHT + ARENA_SIZE + FOOTER_HEIGHT

screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Territory War: Square Arena")

# Physics Constants
TILE_SIZE = 30  # Bigger blocks as requested
SPEED = 9       # Slightly faster to make the bouncing energetic

# Colors
COLOR_P1 = (255, 255, 255)  # White
COLOR_P2 = (0, 0, 255)      # Blue
COLOR_BG_UI = (20, 20, 20)  # Dark Grey for UI
COLOR_TEXT = (255, 255, 255)

# Fonts
try:
    FONT_MAIN = pygame.font.SysFont("Arial", 28, bold=True)
    FONT_BIG = pygame.font.SysFont("Arial", 40, bold=True)
except:
    FONT_MAIN = pygame.font.Font(None, 28)
    FONT_BIG = pygame.font.Font(None, 40)

# ==========================================
# 2. GAME LOGIC CLASSES
# ==========================================

class Player:
    def __init__(self, name, color, id, start_x, start_y):
        self.name = name
        self.color = color
        self.id = id  # 1 for P1, 2 for P2
        self.rect = pygame.Rect(start_x, start_y, 30, 30) # Player is slightly smaller than a tile
        self.vel_x = random.choice([-SPEED, SPEED])
        self.vel_y = random.choice([-SPEED, SPEED])
        self.score = 0
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
        # We treat the opponent's color AND the screen edges as walls.

        # 1. Check X-Axis Movement
        hit_x = False
        # Check Screen Boundaries
        if next_rect_x.left < 0 or next_rect_x.right > WIDTH:
            self.vel_x *= -1
            hit_x = True
        else:
            # Check Grid Color Collision
            # We check the corners of the player to see what tile they are entering
            corners = [next_rect_x.topleft, next_rect_x.topright, next_rect_x.bottomleft, next_rect_x.bottomright]
            for px, py in corners:
                # Convert to Grid Coords relative to Arena Top
                gy = (py - HEADER_HEIGHT) // TILE_SIZE
                gx = px // TILE_SIZE
                
                # Safety check
                if 0 <= gy < len(grid) and 0 <= gx < len(grid[0]):
                    tile_owner = grid[gy][gx]
                    if tile_owner != self.id:
                        # HIT OPPONENT TILE!
                        grid[gy][gx] = self.id # CAPTURE IT
                        self.vel_x *= -1       # BOUNCE
                        hit_x = True
                        break # Only bounce once per frame
        
        if not hit_x:
            self.rect.x += self.vel_x

        # 2. Check Y-Axis Movement
        hit_y = False
        # Check Screen Boundaries (Arena Top/Bottom)
        if next_rect_y.top < HEADER_HEIGHT or next_rect_y.bottom > HEADER_HEIGHT + ARENA_SIZE:
            self.vel_y *= -1
            hit_y = True
        else:
            # Check Grid Color Collision
            corners = [next_rect_y.topleft, next_rect_y.topright, next_rect_y.bottomleft, next_rect_y.bottomright]
            for px, py in corners:
                gy = (py - HEADER_HEIGHT) // TILE_SIZE
                gx = px // TILE_SIZE
                
                if 0 <= gy < len(grid) and 0 <= gx < len(grid[0]):
                    tile_owner = grid[gy][gx]
                    if tile_owner != self.id:
                        # HIT OPPONENT TILE!
                        grid[gy][gx] = self.id # CAPTURE IT
                        self.vel_y *= -1       # BOUNCE
                        hit_y = True
                        break
        
        if not hit_y:
            self.rect.y += self.vel_y

    def draw(self, surface):
        if not self.is_alive: return
        pygame.draw.circle(surface, self.color, self.rect.center, 15)
        pygame.draw.circle(surface, (0,0,0), self.rect.center, 15, 2)

class Item:
    def __init__(self, type_name):
        self.type = type_name
        self.rect = pygame.Rect(0, 0, 30, 30)
        # Random position within arena
        self.rect.x = random.randint(20, WIDTH - 50)
        self.rect.y = random.randint(HEADER_HEIGHT + 20, HEIGHT - FOOTER_HEIGHT - 50)

    def draw(self, surface):
        if self.type == "bomb":
            pygame.draw.circle(surface, (0, 0, 0), self.rect.center, 15)
            # Fuse
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

    # SET UP INITIAL HALVES
    # Left Half = Player 1 (ID 1)
    # Right Half = Player 2 (ID 2)
    for r in range(rows):
        for c in range(cols):
            if c < cols // 2:
                grid[r][c] = 1
            else:
                grid[r][c] = 2

    # Players spawn deep in their own territory to avoid instant collision loop
    p1 = Player("Player 1", COLOR_P1, 1, WIDTH // 4, HEADER_HEIGHT + ARENA_SIZE // 2)
    p2 = Player("Player 2", COLOR_P2, 2, 3 * WIDTH // 4, HEADER_HEIGHT + ARENA_SIZE // 2)

    items = []
    timer = 0
    game_over = False
    winner_text = ""

    # User Input
    print("--- STARTING ---")
    p1_name_input = input("Enter Name for White (Left): ") or "White"
    p2_name_input = input("Enter Name for Blue (Right): ") or "Blue"
    p1.name = p1_name_input
    p2.name = p2_name_input

    while True:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit(); sys.exit()

        if not game_over:
            # 1. Move & Capture
            p1.move_and_capture(grid)
            p2.move_and_capture(grid)

            # 2. Item Logic
            timer += 1
            if timer > 100 and len(items) < 2: # Spawn item every ~1.5s
                timer = 0
                items.append(Item(random.choice(["bomb", "swap"])))
            
            # Item Collision
            for p in [p1, p2]:
                if not p.is_alive: continue
                for item in items[:]:
                    if p.rect.colliderect(item.rect):
                        if item.type == "bomb":
                            p.health -= 25 # Damage
                        elif item.type == "swap":
                            # Swap Positions
                            p1.rect.center, p2.rect.center = p2.rect.center, p1.rect.center
                        items.remove(item)

            # 3. Check Win Conditions
            if p1.health <= 0:
                game_over = True; winner_text = f"{p2.name} WINS!"
            elif p2.health <= 0:
                game_over = True; winner_text = f"{p1.name} WINS!"

        # --- DRAWING ---
        screen.fill(COLOR_BG_UI)

        # Draw Grid
        for r in range(rows):
            for c in range(cols):
                color = COLOR_P1 if grid[r][c] == 1 else COLOR_P2
                # Draw rect
                pygame.draw.rect(screen, color, 
                                 (c * TILE_SIZE, HEADER_HEIGHT + r * TILE_SIZE, TILE_SIZE, TILE_SIZE))
                # Optional: Draw faint outline for "block" look
                pygame.draw.rect(screen, (50, 50, 50), 
                                 (c * TILE_SIZE, HEADER_HEIGHT + r * TILE_SIZE, TILE_SIZE, TILE_SIZE), 1)

        # Draw Header Info
        header_text = FONT_MAIN.render(f"{p1.name} vs {p2.name}", True, COLOR_TEXT)
        screen.blit(header_text, header_text.get_rect(center=(WIDTH//2, 50)))

        # Health Bars
        # P1
        pygame.draw.rect(screen, (100, 0, 0), (20, 70, 200, 20))
        pygame.draw.rect(screen, (0, 255, 0), (20, 70, 200 * (p1.health/100), 20))
        # P2
        pygame.draw.rect(screen, (100, 0, 0), (WIDTH - 220, 70, 200, 20))
        pygame.draw.rect(screen, (0, 255, 0), (WIDTH - 220, 70, 200 * (p2.health/100), 20))

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