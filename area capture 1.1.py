import pygame
import random
import math
import sys

# --- CONFIGURATION ---
WIDTH, HEIGHT = 600, 800  # Vertical phone-style aspect ratio
FPS = 60
TILE_SIZE = 20  # Size of the grid blocks
SPEED = 5       # Speed of the players

# Colors
COLOR_BG = (128, 128, 128)  # Grey (Neutral)
COLOR_P1 = (255, 255, 255)  # White
COLOR_P2 = (0, 0, 255)      # Blue
COLOR_TEXT = (0, 0, 0)

# --- CLASSES ---

class Player:
    def __init__(self, name, color, start_pos, image_path=None):
        self.name = name
        self.color = color
        self.rect = pygame.Rect(start_pos[0], start_pos[1], 40, 40) # 40px avatar
        self.vel = [random.choice([-SPEED, SPEED]), random.choice([-SPEED, SPEED])]
        self.score = 0
        
        # Load image if exists, else make a circle
        self.image = pygame.Surface((40, 40), pygame.SRCALPHA)
        if image_path:
            try:
                img = pygame.image.load(image_path)
                img = pygame.transform.scale(img, (40, 40))
                # Create circular mask
                pygame.draw.circle(self.image, (255, 255, 255), (20, 20), 20)
                self.image.blit(img, (0, 0), special_flags=pygame.BLEND_RGBA_MIN)
            except:
                self.create_default_avatar()
        else:
            self.create_default_avatar()

    def create_default_avatar(self):
        """Creates a simple colored circle with the first letter of the name."""
        pygame.draw.circle(self.image, self.color, (20, 20), 20)
        pygame.draw.circle(self.image, (0,0,0), (20, 20), 20, 2) # Border
        font = pygame.font.SysFont("Arial", 20, bold=True)
        text = font.render(self.name[0].upper(), True, (0,0,0) if self.color == (255,255,255) else (255,255,255))
        text_rect = text.get_rect(center=(20, 20))
        self.image.blit(text, text_rect)

    def move(self):
        self.rect.x += self.vel[0]
        self.rect.y += self.vel[1]

        # Bounce off walls
        if self.rect.left <= 0 or self.rect.right >= WIDTH:
            self.vel[0] *= -1
            # Push back to prevent sticking
            self.rect.x = max(0, min(self.rect.x, WIDTH - self.rect.width))
            
        if self.rect.top <= 0 or self.rect.bottom >= HEIGHT:
            self.vel[1] *= -1
            self.rect.y = max(0, min(self.rect.y, HEIGHT - self.rect.height))

    def draw(self, surface):
        surface.blit(self.image, self.rect)

class Item:
    def __init__(self, type_name):
        self.type = type_name # "bomb" or "swap"
        self.rect = pygame.Rect(random.randint(50, WIDTH-50), random.randint(50, HEIGHT-50), 30, 30)
        self.spawn_time = pygame.time.get_ticks()

    def draw(self, surface):
        # Draw Bomb icon
        if self.type == "bomb":
            pygame.draw.circle(surface, (0,0,0), self.rect.center, 15) # Bomb body
            pygame.draw.rect(surface, (100,100,100), (self.rect.centerx-3, self.rect.top-5, 6, 8)) # Fuse
            # Simple fuse spark
            if (pygame.time.get_ticks() // 200) % 2 == 0:
                pygame.draw.circle(surface, (255, 100, 0), (self.rect.centerx, self.rect.top-8), 4)
        
        # Draw Swap icon
        elif self.type == "swap":
            pygame.draw.circle(surface, (255, 215, 0), self.rect.center, 15) # Gold coin look
            font = pygame.font.SysFont("Arial", 12, bold=True)
            text = font.render("SWAP", True, (0,0,0))
            surface.blit(text, text.get_rect(center=self.rect.center))

# --- GAME ENGINE ---

def capture_territory(grid, player_rect, player_id):
    """Converts tiles under the player to the player's ID."""
    # We convert the player's pixel position to grid coordinates
    # We capture a slightly larger area than 1 tile to make it feel smooth (brush size)
    brush_radius = 1 
    
    center_col = player_rect.centerx // TILE_SIZE
    center_row = player_rect.centery // TILE_SIZE
    
    cols = len(grid[0])
    rows = len(grid)

    for r in range(center_row - brush_radius, center_row + brush_radius + 1):
        for c in range(center_col - brush_radius, center_col + brush_radius + 1):
            if 0 <= r < rows and 0 <= c < cols:
                grid[r][c] = player_id

def explode_bomb(grid, center_x, center_y):
    """Clears a large radius around the bomb back to 0 (neutral)."""
    center_col = center_x // TILE_SIZE
    center_row = center_y // TILE_SIZE
    radius = 8 # Radius in tiles
    
    cols = len(grid[0])
    rows = len(grid)
    
    for r in range(center_row - radius, center_row + radius + 1):
        for c in range(center_col - radius, center_col + radius + 1):
            if 0 <= r < rows and 0 <= c < cols:
                # Circular explosion check
                if math.sqrt((r - center_row)**2 + (c - center_col)**2) <= radius:
                    grid[r][c] = 0 # Set to Neutral

def main():
    # 1. SETUP
    pygame.init()
    
    print("--- WELCOME TO THE TERRITORY WAR ---")
    p1_name = input("Enter name for Player 1 (White): ") or "Player 1"
    p2_name = input("Enter name for Player 2 (Blue): ") or "Player 2"
    
    screen = pygame.display.set_mode((WIDTH, HEIGHT))
    pygame.display.set_caption(f"{p1_name} vs {p2_name}")
    clock = pygame.time.Clock()
    font = pygame.font.SysFont("Arial", 20, bold=True)
    large_font = pygame.font.SysFont("Arial", 40, bold=True)

    # Grid: 0=Neutral, 1=Player1, 2=Player2
    cols = WIDTH // TILE_SIZE
    rows = HEIGHT // TILE_SIZE
    grid = [[0 for _ in range(cols)] for _ in range(rows)]

    # Create Players
    p1 = Player(p1_name, COLOR_P1, (WIDTH//4, HEIGHT//2))
    p2 = Player(p2_name, COLOR_P2, (3*WIDTH//4, HEIGHT//2))
    
    items = []
    start_time = pygame.time.get_ticks()
    game_over = False
    winner = None

    # 2. GAME LOOP
    while True:
        current_time = pygame.time.get_ticks()
        
        # Event Handling
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                sys.exit()

        if not game_over:
            # --- LOGIC ---
            
            # Move players
            p1.move()
            p2.move()

            # Capture Territory
            capture_territory(grid, p1.rect, 1)
            capture_territory(grid, p2.rect, 2)

            # Item Spawning (Every 3 seconds roughly)
            if random.random() < 0.005 and len(items) < 3:
                item_type = random.choice(["bomb", "bomb", "swap"]) # Bombs are more common
                items.append(Item(item_type))

            # Item Collision
            for item in items[:]:
                # Check P1
                if p1.rect.colliderect(item.rect):
                    if item.type == "bomb":
                        explode_bomb(grid, item.rect.centerx, item.rect.centery)
                    elif item.type == "swap":
                        p1.rect.center, p2.rect.center = p2.rect.center, p1.rect.center
                    items.remove(item)
                    continue

                # Check P2
                if p2.rect.colliderect(item.rect):
                    if item.type == "bomb":
                        explode_bomb(grid, item.rect.centerx, item.rect.centery)
                    elif item.type == "swap":
                        p1.rect.center, p2.rect.center = p2.rect.center, p1.rect.center
                    items.remove(item)

            # Score Calculation
            score_p1 = sum(row.count(1) for row in grid)
            score_p2 = sum(row.count(2) for row in grid)
            total_tiles = rows * cols
            
            # Win Condition (e.g., 75% coverage or timeout)
            if score_p1 > total_tiles * 0.8:
                game_over = True
                winner = p1
            elif score_p2 > total_tiles * 0.8:
                game_over = True
                winner = p2

        # --- DRAWING ---
        screen.fill(COLOR_BG)

        # Draw Grid (Optimize by drawing rects only for captured tiles)
        for r in range(rows):
            for c in range(cols):
                val = grid[r][c]
                if val == 1:
                    pygame.draw.rect(screen, COLOR_P1, (c*TILE_SIZE, r*TILE_SIZE, TILE_SIZE, TILE_SIZE))
                elif val == 2:
                    pygame.draw.rect(screen, COLOR_P2, (c*TILE_SIZE, r*TILE_SIZE, TILE_SIZE, TILE_SIZE))

        # Draw Items
        for item in items:
            item.draw(screen)

        # Draw Players
        p1.draw(screen)
        p2.draw(screen)

        # Draw UI (Progress Bars)
        # Bar Background
        pygame.draw.rect(screen, (50,50,50), (0, 0, WIDTH, 40))
        
        # Calculate bar widths
        p1_ratio = score_p1 / total_tiles
        p2_ratio = score_p2 / total_tiles
        
        # P1 Bar (Left)
        pygame.draw.rect(screen, COLOR_P1, (10, 10, int((WIDTH/2 - 20) * (p1_ratio * 2)), 20))
        # P2 Bar (Right)
        p2_bar_width = int((WIDTH/2 - 20) * (p2_ratio * 2))
        pygame.draw.rect(screen, COLOR_P2, (WIDTH - 10 - p2_bar_width, 10, p2_bar_width, 20))
        
        # Names
        name1_surf = font.render(f"{p1_name}: {int(p1_ratio*100)}%", True, COLOR_P1)
        name2_surf = font.render(f"{p2_name}: {int(p2_ratio*100)}%", True, COLOR_P2)
        screen.blit(name1_surf, (10, 45))
        screen.blit(name2_surf, (WIDTH - name2_surf.get_width() - 10, 45))

        # Game Over Screen
        if game_over:
            overlay = pygame.Surface((WIDTH, HEIGHT), pygame.SRCALPHA)
            overlay.fill((0, 0, 0, 180))
            screen.blit(overlay, (0,0))
            
            win_text = large_font.render(f"VICTORY!", True, (255, 215, 0))
            name_text = large_font.render(f"{winner.name} Wins!", True, winner.color)
            
            screen.blit(win_text, win_text.get_rect(center=(WIDTH//2, HEIGHT//2 - 40)))
            screen.blit(name_text, name_text.get_rect(center=(WIDTH//2, HEIGHT//2 + 20)))

        pygame.display.flip()
        clock.tick(FPS)

if __name__ == "__main__":
    main()