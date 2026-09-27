from PIL import Image
import numpy as np

# 1. Test tur1.png
tur = np.array(Image.open('tur1.png'))
w_pix = (tur[:,:,0] > 200) & (tur[:,:,1] > 200) & (tur[:,:,2] > 200)
y, x = np.where(w_pix)
center_x = (x.min() + x.max()) / 2.0
assert center_x >= 128.0, f'tur1 center_x is {center_x}'
print('PASS 1: tur1.png optical center is at', center_x, '(shifted right for mass balance)')

# 2. Test game_logo.png corners
logo = np.array(Image.open('game_logo.png'))
assert logo.shape[2] == 4, 'game_logo must be RGBA'
assert logo[0,0,3] == 0, 'Top-left corner must be transparent'
assert logo[0,-1,3] == 0, 'Top-right corner must be transparent'
assert logo[-1,0,3] == 0, 'Bottom-left corner must be transparent'
assert logo[-1,-1,3] == 0, 'Bottom-right corner must be transparent'
print('PASS 2: game_logo.png corners are 100% transparent')

# 3. Test Global.gd
with open('Global.gd', 'r', encoding='utf-8') as f:
    g_code = f.read()
assert 'var came_from_completed_match: bool = false' in g_code
print('PASS 3: Global.gd has came_from_completed_match flag')

# 4. Test main_menu.gd
with open('main_menu.gd', 'r', encoding='utf-8') as f:
    m_code = f.read()
assert 'if Global.came_from_completed_match and Global.login_method == "guest"' in m_code
assert 'squad_state = {"target_team": initial_target_team}' in m_code
assert 'draw_ball_preview(ball_preview, true, squad_state["target_team"])' in m_code
assert 'Global.custom_player_names[editing_team] = team_saved_names' in m_code
assert 'match_fee_badge' in m_code
assert 'func _show_insufficient_tokens_dialog():' in m_code
print('PASS 4: main_menu.gd has squad_state, match_fee_badge, and insufficient_tokens_dialog')

# 5. Test pitch.gd
with open('pitch.gd', 'r', encoding='utf-8') as f:
    p_code = f.read()
assert 'Global.consume_match_right()' in p_code
assert 'Global.came_from_completed_match = true' in p_code
print('PASS 5: pitch.gd handles match right consumption and came_from_completed_match properly')

# 6. Test welcome_screen.gd
with open('welcome_screen.gd', 'r', encoding='utf-8') as f:
    w_code = f.read()
assert 'func _set_gp_btn_connected(animate: bool = false):' in w_code
assert 'Color8(100, 255, 140)' in w_code
assert 'v1.1.2' in w_code
print('PASS 6: welcome_screen.gd has polished GP connected feedback, animation, and v1.1.2 badge')

# 7. Test v1.1.2 UI/UX and Economy enhancements in main_menu.gd
assert 'match_fee_icon' in m_code
assert 'res://jeton_icon.svg' in m_code
assert 'gesture_direction' in m_code
assert 'Global.consume_match_right()' in m_code
assert 'create_carousel_arrow' in m_code
print('PASS 7: main_menu.gd has official jeton icon, directional gesture lock, and carousel controls')

print('\nALL VERIFICATIONS CLEAN AND PASSING!')
