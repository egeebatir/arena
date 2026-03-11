extends Node

var bg_music_player: AudioStreamPlayer

var current_lang = "TR"
var home_team_name = "GALATASARAY"
var away_team_name = "FENERBAHÇE"
var LANG = {
	"TR": {
		"GOAL": "GOL!", "HT": "İY", "FT": "MS"
	},
	"ENG": {
		"GOAL": "GOAL!", "HT": "HT", "FT": "FT"
	},
	"ESP": {
		"GOAL": "¡GOL!", "HT": "MT", "FT": "FINAL"
	},
	"POR": {
		"GOAL": "GOLO!", "HT": "INT", "FT": "FIM"
	}
}

# --- NEW SETTINGS & THEMES ---
var master_vol = 1.0
var vol_settings = {
	"stadium": 0.2,
	"menu_music": 0.4,
	"music": 0.6,
	"collision": 0.02,
	"whistle": 0.4
}

var current_theme = "Mavi"
var shake_enabled = true
var match_duration = 1 # 0 = Kısa (24s), 1 = Normal (36s), 2 = Uzun (48s)

var THEMES = {
	"Buz": {
		"bg_top": Color8(250, 255, 255), "bg_bottom": Color8(180, 210, 240),
		"pitch_1": Color8(200, 220, 245), "pitch_2": Color8(220, 240, 255),
		"panel": Color8(150, 180, 200, 230), "accent": Color8(0, 255, 255)
	},
	"Pembe": {
		"bg_top": Color8(255, 180, 200), "bg_bottom": Color8(60, 10, 30),
		"pitch_1": Color8(90, 20, 50), "pitch_2": Color8(120, 30, 70),
		"panel": Color8(30, 5, 15, 230), "accent": Color8(255, 0, 150)
	},
	"Turkuaz": {
		"bg_top": Color8(150, 230, 230), "bg_bottom": Color8(0, 50, 50),
		"pitch_1": Color8(0, 80, 80), "pitch_2": Color8(0, 110, 110),
		"panel": Color8(5, 25, 25, 230), "accent": Color8(0, 255, 200)
	},
	"Sarı": {
		"bg_top": Color8(220, 210, 150), "bg_bottom": Color8(50, 40, 10),
		"pitch_1": Color8(80, 65, 15), "pitch_2": Color8(110, 90, 25),
		"panel": Color8(30, 25, 5, 230), "accent": Color8(173, 255, 47)
	},
	"Yeşil": {
		"bg_top": Color8(160, 200, 160), "bg_bottom": Color8(10, 40, 15),
		"pitch_1": Color8(15, 60, 20), "pitch_2": Color8(25, 80, 30),
		"panel": Color8(5, 20, 10, 230), "accent": Color8(0, 250, 154)
	},
	"Mavi": {
		"bg_top": Color8(150, 170, 200), "bg_bottom": Color8(0, 18, 40),
		"pitch_1": Color8(0, 18, 40), "pitch_2": Color8(0, 35, 75),
		"panel": Color8(5, 10, 20, 230), "accent": Color8(255, 100, 0)
	},
	"Turuncu": {
		"bg_top": Color8(255, 180, 120), "bg_bottom": Color8(80, 25, 0),
		"pitch_1": Color8(120, 40, 0), "pitch_2": Color8(150, 60, 10),
		"panel": Color8(40, 10, 5, 230), "accent": Color8(255, 255, 0)
	},
	"Bordo": {
		"bg_top": Color8(200, 100, 120), "bg_bottom": Color8(50, 0, 10),
		"pitch_1": Color8(70, 10, 20), "pitch_2": Color8(100, 20, 30),
		"panel": Color8(25, 5, 10, 230), "accent": Color8(255, 105, 180)
	},
	"Mor": {
		"bg_top": Color8(180, 150, 220), "bg_bottom": Color8(30, 10, 50),
		"pitch_1": Color8(45, 15, 80), "pitch_2": Color8(60, 25, 110),
		"panel": Color8(20, 5, 30, 230), "accent": Color8(0, 255, 255)
	},
	"Kırmızı": {
		"bg_top": Color8(210, 160, 160), "bg_bottom": Color8(40, 10, 15),
		"pitch_1": Color8(60, 15, 20), "pitch_2": Color8(90, 25, 30),
		"panel": Color8(25, 5, 10, 230), "accent": Color8(255, 255, 0)
	},
	"Kahverengi": {
		"bg_top": Color8(160, 130, 110), "bg_bottom": Color8(50, 30, 15),
		"pitch_1": Color8(60, 40, 20), "pitch_2": Color8(80, 50, 30),
		"panel": Color8(30, 20, 10, 230), "accent": Color8(255, 215, 0)
	},
	"Siyah": {
		"bg_top": Color8(100, 100, 100), "bg_bottom": Color8(10, 10, 10),
		"pitch_1": Color8(20, 20, 20), "pitch_2": Color8(40, 40, 40),
		"panel": Color8(15, 15, 15, 230), "accent": Color8(0, 255, 255)
	}
}

var TEAM_LOGOS = {}

var TEAMS = {
	# --- SÜPER LİG ---
	"GALATASARAY":    {"colors": [Color8(169, 4, 50), Color8(253, 185, 18)], "short": "GS", "league": "Süper Lig"},
	"FENERBAHÇE":     {"colors": [Color8(255, 255, 0), Color8(0, 0, 128)],   "short": "FB", "league": "Süper Lig"},
	"BEŞİKTAŞ":       {"colors": [Color8(255, 255, 255), Color8(10, 10, 10)],"short": "BJK", "league": "Süper Lig"},
	"TRABZONSPOR":    {"colors": [Color8(128, 0, 0), Color8(0, 191, 255)],   "short": "TS", "league": "Süper Lig"},
	"BAŞAKŞEHİR":     {"colors": [Color8(255, 102, 0), Color8(0, 0, 102)],   "short": "BFK", "league": "Süper Lig"},
	"KASIMPAŞA":      {"colors": [Color8(255, 255, 255), Color8(0, 0, 128)], "short": "KAS", "league": "Süper Lig"},
	"SİVASSPOR":      {"colors": [Color8(255, 0, 0), Color8(255, 255, 255)], "short": "SVS", "league": "Süper Lig"},
	"ALANYASPOR":     {"colors": [Color8(255, 165, 0), Color8(0, 128, 0)],   "short": "ALN", "league": "Süper Lig"},
	"RİZESPOR":       {"colors": [Color8(0, 128, 0), Color8(0, 0, 255)],     "short": "RİZ", "league": "Süper Lig"},
	"ANTALYASPOR":    {"colors": [Color8(255, 0, 0), Color8(255, 255, 255)], "short": "ANT", "league": "Süper Lig"},
	"GAZİANTEP FK":   {"colors": [Color8(200, 16, 46), Color8(10, 10, 10)],  "short": "GFK", "league": "Süper Lig"},
	"KONYASPOR":      {"colors": [Color8(0, 128, 0), Color8(255, 255, 255)], "short": "KON", "league": "Süper Lig"},
	"KAYSERİSPOR":    {"colors": [Color8(255, 204, 0), Color8(255, 0, 0)],   "short": "KAY", "league": "Süper Lig"},
	"BODRUM FK":      {"colors": [Color8(0, 128, 0), Color8(255, 255, 255)], "short": "BOD", "league": "Süper Lig"},
	"EYÜPSPOR":       {"colors": [Color8(230, 230, 250), Color8(255, 215, 0)],"short": "EYP", "league": "Süper Lig"},
	"GÖZTEPE":        {"colors": [Color8(255, 215, 0), Color8(255, 0, 0)],   "short": "GÖZ", "league": "Süper Lig"},
	"SAMSUNSPOR":     {"colors": [Color8(255, 0, 0), Color8(255, 255, 255)], "short": "SAM", "league": "Süper Lig"},
	"KOCAELİSPOR":    {"colors": [Color8(0, 128, 0), Color8(10, 10, 10)],    "short": "KOC", "league": "Süper Lig"},
	"KARAGÜMRÜK":     {"colors": [Color8(255, 0, 0), Color8(10, 10, 10)],    "short": "FKG", "league": "Süper Lig"},
	"GENÇLERBİRLİĞİ": {"colors": [Color8(200, 16, 46), Color8(10, 10, 10)],  "short": "GEN", "league": "Süper Lig"},
	"HATAYSPOR":      {"colors": [Color8(128, 0, 0), Color8(255, 255, 255)], "short": "HAT", "league": "Süper Lig"},
	"ADANA DEMİR":    {"colors": [Color8(0, 0, 255), Color8(173, 216, 230)], "short": "ADS", "league": "Süper Lig"},

	# --- PREMIER LEAGUE ---
	"NOTTM FOREST":   {"colors": [Color8(229, 30, 42), Color8(255, 255, 255)],"short": "NFO", "league": "Premier League"},
	"MAN CITY":       {"colors": [Color8(108, 171, 221), Color8(255, 255, 255)],"short": "MC", "league": "Premier League"},
	"LIVERPOOL":      {"colors": [Color8(200, 16, 46), Color8(255, 255, 255)],  "short": "LIV", "league": "Premier League"},
	"ARSENAL":        {"colors": [Color8(239, 1, 7), Color8(255, 255, 255)],    "short": "ARS", "league": "Premier League"},
	"ASTON VILLA":    {"colors": [Color8(103, 14, 54), Color8(149, 191, 229)],  "short": "AVL", "league": "Premier League"},
	"TOTTENHAM":      {"colors": [Color8(255, 255, 255), Color8(19, 34, 87)],   "short": "TOT", "league": "Premier League"},
	"MAN UTD":        {"colors": [Color8(218, 41, 28), Color8(255, 255, 255)],  "short": "MUN", "league": "Premier League"},
	"CHELSEA":        {"colors": [Color8(3, 70, 148), Color8(255, 255, 255)],   "short": "CHE", "league": "Premier League"},
	"NEWCASTLE":      {"colors": [Color8(0, 0, 0), Color8(255, 255, 255)],    "short": "NEW", "league": "Premier League"},
	"BOURNEMOUTH":    {"colors": [Color8(200, 16, 46), Color8(0, 0, 0)],        "short": "BOU", "league": "Premier League"},
	"BRENTFORD":      {"colors": [Color8(227, 6, 19), Color8(255, 255, 255)],   "short": "BRE", "league": "Premier League"},
	"BRIGHTON":       {"colors": [Color8(0, 87, 184), Color8(255, 255, 255)],   "short": "BHA", "league": "Premier League"},
	"BURNLEY":        {"colors": [Color8(108, 29, 69), Color8(153, 214, 234)],  "short": "BUR", "league": "Premier League"},
	"EVERTON":        {"colors": [Color8(0, 51, 153), Color8(255, 255, 255)],   "short": "EVE", "league": "Premier League"},
	"FULHAM":         {"colors": [Color8(255, 255, 255), Color8(0, 0, 0)],      "short": "FUL", "league": "Premier League"},
	"LEEDS UTD":      {"colors": [Color8(255, 255, 255), Color8(29, 66, 138)],  "short": "LEE", "league": "Premier League"},
	"CRYSTAL PALACE": {"colors": [Color8(27, 69, 143), Color8(196, 18, 46)],    "short": "CRY", "league": "Premier League"},
	"SUNDERLAND":     {"colors": [Color8(255, 0, 0), Color8(255, 255, 255)],    "short": "SUN", "league": "Premier League"},
	"WEST HAM":       {"colors": [Color8(122, 38, 58), Color8(27, 177, 231)],   "short": "WHU", "league": "Premier League"},
	"WOLVES":         {"colors": [Color8(253, 185, 19), Color8(0, 0, 0)],       "short": "WOL", "league": "Premier League"},

	# --- LA LIGA ---
	"REAL MADRID":    {"colors": [Color8(255, 255, 255), Color8(255, 215, 0)],"short": "RMA", "league": "La Liga"},
	"BARCELONA":      {"colors": [Color8(0, 77, 152), Color8(165, 0, 68)],    "short": "BAR", "league": "La Liga"},
	"ATLETICO":       {"colors": [Color8(203, 53, 36), Color8(255, 255, 255)],"short": "ATM", "league": "La Liga"},
	"GIRONA":         {"colors": [Color8(200, 16, 46), Color8(255, 255, 255)],"short": "GIR", "league": "La Liga"},
	"CELTA VIGO":     {"colors": [Color8(138, 195, 238), Color8(255, 255, 255)],"short": "CEL", "league": "La Liga"},
	"ATHLETIC CLUB":  {"colors": [Color8(237, 28, 36), Color8(255, 255, 255)], "short": "ATH", "league": "La Liga"},
	"REAL SOCIEDAD":  {"colors": [Color8(0, 103, 177), Color8(255, 255, 255)], "short": "RSO", "league": "La Liga"},
	"VILLARREAL":     {"colors": [Color8(255, 230, 0), Color8(0, 0, 102)],     "short": "VIL", "league": "La Liga"},
	"VALENCIA":       {"colors": [Color8(255, 255, 255), Color8(0, 0, 0)],     "short": "VAL", "league": "La Liga"},
	"SEVILLA":        {"colors": [Color8(255, 255, 255), Color8(218, 41, 28)], "short": "SEV", "league": "La Liga"},
	"REAL BETIS":     {"colors": [Color8(0, 148, 72), Color8(255, 255, 255)],  "short": "BET", "league": "La Liga"},
	"OSASUNA":        {"colors": [Color8(193, 29, 39), Color8(0, 27, 73)],     "short": "OSA", "league": "La Liga"},
	"MALLORCA":       {"colors": [Color8(226, 0, 26), Color8(0, 0, 0)],        "short": "MLL", "league": "La Liga"},
	"ALAVES":         {"colors": [Color8(0, 68, 148), Color8(255, 255, 255)],  "short": "ALA", "league": "La Liga"},
	"RAYO VALLECANO": {"colors": [Color8(255, 255, 255), Color8(227, 6, 19)],  "short": "RAY", "league": "La Liga"},
	"GETAFE":         {"colors": [Color8(0, 75, 151), Color8(255, 255, 255)],  "short": "GET", "league": "La Liga"},
	"ESPANYOL":       {"colors": [Color8(0, 122, 195), Color8(255, 255, 255)], "short": "ESP", "league": "La Liga"},
	"ELCHE":          {"colors": [Color8(0, 100, 0), Color8(255, 255, 255)],   "short": "ELC", "league": "La Liga"},
	"OVIEDO":         {"colors": [Color8(0, 51, 160), Color8(255, 255, 255)],  "short": "OVI", "league": "La Liga"},
	"LEVANTE":        {"colors": [Color8(0, 51, 102), Color8(153, 0, 51)],     "short": "LEV", "league": "La Liga"},

	# --- BUNDESLIGA ---
	"B. MUNIH":       {"colors": [Color8(220, 5, 45), Color8(255, 255, 255)], "short": "BAY", "league": "Bundesliga"},
	"DORTMUND":       {"colors": [Color8(253, 225, 0), Color8(10, 10, 10)],   "short": "BVB", "league": "Bundesliga"},
	"LEVERKUSEN":     {"colors": [Color8(10, 10, 10), Color8(227, 34, 25)],   "short": "B04", "league": "Bundesliga"},
	"RB LEIPZIG":     {"colors": [Color8(255, 255, 255), Color8(221, 5, 43)], "short": "RBL", "league": "Bundesliga"},
	"STUTTGART":      {"colors": [Color8(255, 255, 255), Color8(227, 34, 25)],"short": "VFB", "league": "Bundesliga"},
	"AUGSBURG":       {"colors": [Color8(255, 255, 255), Color8(186, 32, 38)], "short": "AUG", "league": "Bundesliga"},
	"FRANKFURT":      {"colors": [Color8(0, 0, 0), Color8(227, 34, 25)],       "short": "FRA", "league": "Bundesliga"},
	"FREIBURG":       {"colors": [Color8(218, 41, 28), Color8(255, 255, 255)], "short": "FRE", "league": "Bundesliga"},
	"HAMBURG":        {"colors": [Color8(0, 85, 164), Color8(255, 255, 255)],  "short": "HSV", "league": "Bundesliga"},
	"HEIDENHEIM":     {"colors": [Color8(227, 34, 25), Color8(0, 51, 160)],    "short": "HEI", "league": "Bundesliga"},
	"HOFFENHEIM":     {"colors": [Color8(0, 92, 169), Color8(255, 255, 255)],  "short": "HOF", "league": "Bundesliga"},
	"KÖLN":           {"colors": [Color8(227, 34, 25), Color8(255, 255, 255)], "short": "KÖL", "league": "Bundesliga"},
	"MAINZ 05":       {"colors": [Color8(237, 28, 36), Color8(255, 255, 255)], "short": "MAI", "league": "Bundesliga"},
	"M. GLADBACH":    {"colors": [Color8(0, 0, 0), Color8(255, 255, 255)],     "short": "BMG", "league": "Bundesliga"},
	"ST. PAULI":      {"colors": [Color8(105, 57, 4), Color8(255, 255, 255)],  "short": "STP", "league": "Bundesliga"},
	"UNION BERLIN":   {"colors": [Color8(218, 41, 28), Color8(255, 255, 255)], "short": "UNB", "league": "Bundesliga"},
	"WERDER BREMEN":  {"colors": [Color8(29, 162, 83), Color8(255, 255, 255)], "short": "WER", "league": "Bundesliga"},
	"WOLFSBURG":      {"colors": [Color8(98, 179, 48), Color8(255, 255, 255)], "short": "WOB", "league": "Bundesliga"},

	# --- SERIE A ---
	"INTER":          {"colors": [Color8(0, 102, 187), Color8(10, 10, 10)],   "short": "INT", "league": "Serie A"},
	"MILAN":          {"colors": [Color8(251, 9, 11), Color8(10, 10, 10)],    "short": "MIL", "league": "Serie A"},
	"JUVENTUS":       {"colors": [Color8(255, 255, 255), Color8(10, 10, 10)], "short": "JUV", "league": "Serie A"},
	"ATALANTA":       {"colors": [Color8(30, 113, 184), Color8(10, 10, 10)],  "short": "ATA", "league": "Serie A"},
	"ROMA":           {"colors": [Color8(134, 38, 51), Color8(240, 188, 66)], "short": "ROM", "league": "Serie A"},
	"LAZIO":          {"colors": [Color8(135, 206, 235), Color8(255, 255, 255)],"short": "LAZ", "league": "Serie A"},
	"BOLOGNA":        {"colors": [Color8(158, 27, 50), Color8(26, 35, 66)],   "short": "BOL", "league": "Serie A"},
	"CAGLIARI":       {"colors": [Color8(163, 19, 51), Color8(0, 35, 80)],     "short": "CAG", "league": "Serie A"},
	"COMO":           {"colors": [Color8(0, 71, 169), Color8(255, 255, 255)],  "short": "COM", "league": "Serie A"},
	"CREMONESE":      {"colors": [Color8(130, 130, 130), Color8(227, 34, 25)], "short": "CRE", "league": "Serie A"},
	"FIORENTINA":     {"colors": [Color8(72, 46, 146), Color8(255, 255, 255)], "short": "FIO", "league": "Serie A"},
	"GENOA":          {"colors": [Color8(166, 28, 49), Color8(0, 36, 81)],     "short": "GNO", "league": "Serie A"},
	"LECCE":          {"colors": [Color8(255, 217, 0), Color8(227, 34, 25)],   "short": "LEC", "league": "Serie A"},
	"NAPOLI":         {"colors": [Color8(18, 160, 215), Color8(255, 255, 255)],"short": "NAP", "league": "Serie A"},
	"PARMA":          {"colors": [Color8(255, 204, 0), Color8(0, 51, 153)],    "short": "PAR", "league": "Serie A"},
	"PISA":           {"colors": [Color8(0, 0, 0), Color8(0, 84, 166)],       "short": "PIS", "league": "Serie A"},
	"SASSUOLO":       {"colors": [Color8(0, 160, 90), Color8(0, 0, 0)],        "short": "SAS", "league": "Serie A"},
	"TORINO":         {"colors": [Color8(138, 30, 50), Color8(255, 255, 255)], "short": "TOR", "league": "Serie A"},
	"UDINESE":        {"colors": [Color8(0, 0, 0), Color8(255, 255, 255)],     "short": "UDI", "league": "Serie A"},
	"VERONA":         {"colors": [Color8(0, 51, 102), Color8(255, 204, 0)],    "short": "VER", "league": "Serie A"},

	# --- LIGUE 1 ---
	"PSG":            {"colors": [Color8(0, 65, 112), Color8(218, 41, 28)],   "short": "PSG", "league": "Ligue 1"},
	"LILLE":          {"colors": [Color8(238, 36, 54), Color8(0, 51, 102)],   "short": "LIL", "league": "Ligue 1"},
	"MONACO":         {"colors": [Color8(255, 0, 0), Color8(255, 255, 255)],  "short": "ASM", "league": "Ligue 1"},
	"MARSEILLE":      {"colors": [Color8(255, 255, 255), Color8(0, 150, 214)], "short": "OM", "league": "Ligue 1"},
	"LYON":           {"colors": [Color8(255, 255, 255), Color8(218, 41, 28)], "short": "OL", "league": "Ligue 1"},
	"LENS":           {"colors": [Color8(237, 28, 36), Color8(255, 215, 0)],   "short": "RCL", "league": "Ligue 1"},
	"NICE":           {"colors": [Color8(218, 41, 28), Color8(0, 0, 0)],       "short": "NIC", "league": "Ligue 1"},
	"RENNES":         {"colors": [Color8(227, 34, 25), Color8(0, 0, 0)],       "short": "REN", "league": "Ligue 1"},
	"STRASBOURG":     {"colors": [Color8(0, 82, 159), Color8(255, 255, 255)],  "short": "STR", "league": "Ligue 1"},
	"REIMS":          {"colors": [Color8(226, 0, 26), Color8(255, 255, 255)],  "short": "SDR", "league": "Ligue 1"},
	"TOULOUSE":       {"colors": [Color8(92, 45, 145), Color8(255, 255, 255)], "short": "TFC", "league": "Ligue 1"},
	"NANTES":         {"colors": [Color8(253, 233, 34), Color8(0, 100, 50)],   "short": "FCN", "league": "Ligue 1"},
	"MONTPELLIER":    {"colors": [Color8(0, 35, 96), Color8(243, 108, 33)],    "short": "MHS", "league": "Ligue 1"},
	"ANGERS":         {"colors": [Color8(0, 0, 0), Color8(255, 255, 255)],     "short": "SCO", "league": "Ligue 1"},
	"BREST":          {"colors": [Color8(226, 0, 26), Color8(255, 255, 255)],  "short": "SB2", "league": "Ligue 1"},
	"LE HAVRE":       {"colors": [Color8(111, 172, 222), Color8(0, 31, 73)],   "short": "HAC", "league": "Ligue 1"},
	"AUXERRE":        {"colors": [Color8(255, 255, 255), Color8(0, 68, 148)],  "short": "AJA", "league": "Ligue 1"},
	"SAINT-ETIENNE":  {"colors": [Color8(0, 102, 51), Color8(255, 255, 255)],  "short": "ASE", "league": "Ligue 1"},

	# --- MLS ---
	"INTER MIAMI":    {"colors": [Color8(244, 181, 205), Color8(0, 0, 0)],     "short": "MIA", "league": "MLS"},
	"LAFC":           {"colors": [Color8(0, 0, 0), Color8(195, 158, 109)],     "short": "LAF", "league": "MLS"},
	"LA GALAXY":      {"colors": [Color8(0, 36, 93), Color8(255, 210, 0)],     "short": "LAG", "league": "MLS"},
	"COLUMBUS CREW":  {"colors": [Color8(255, 223, 0), Color8(0, 0, 0)],       "short": "CCW", "league": "MLS"},
	"FC CINCINNATI":  {"colors": [Color8(240, 83, 35), Color8(38, 59, 128)],   "short": "CIN", "league": "MLS"},
	"SEATTLE SOUNDERS":{"colors": [Color8(93, 151, 50), Color8(0, 85, 149)],   "short": "SEA", "league": "MLS"},
	"NEW YORK CITY FC":{"colors": [Color8(108, 172, 228), Color8(4, 30, 66)],  "short": "NYC", "league": "MLS"},
	"NY RED BULLS":   {"colors": [Color8(226, 24, 54), Color8(255, 255, 255)], "short": "NYR", "league": "MLS"},
	"ATLANTA UTD":    {"colors": [Color8(128, 0, 0), Color8(0, 0, 0)],         "short": "ATL", "league": "MLS"},
	"PORTLAND TIMBERS":{"colors": [Color8(0, 72, 39), Color8(234, 170, 0)],    "short": "PTL", "league": "MLS"},
	"ORLANDO CITY":   {"colors": [Color8(99, 52, 146), Color8(255, 255, 255)], "short": "ORL", "league": "MLS"},
	"HOUSTON DYNAMO": {"colors": [Color8(255, 107, 0), Color8(0, 0, 0)],       "short": "HOU", "league": "MLS"},
	"REAL SALT LAKE": {"colors": [Color8(179, 11, 34), Color8(1, 31, 91)],     "short": "RSL", "league": "MLS"},
	"PHILADELPHIA U.":{"colors": [Color8(0, 45, 85), Color8(179, 163, 105)],   "short": "PHI", "league": "MLS"},
	"SPORTING KC":    {"colors": [Color8(145, 176, 213), Color8(0, 42, 92)],   "short": "SKC", "league": "MLS"},
	"NEW ENGLAND REV":{"colors": [Color8(226, 24, 54), Color8(0, 43, 92)],     "short": "NER", "league": "MLS"},
	"NASHVILLE SC":   {"colors": [Color8(236, 232, 58), Color8(31, 22, 70)],   "short": "NSC", "league": "MLS"},
	"FC DALLAS":      {"colors": [Color8(226, 24, 54), Color8(0, 62, 126)],    "short": "DAL", "league": "MLS"},
	"VANCOUVER WC":   {"colors": [Color8(0, 36, 94), Color8(255, 255, 255)],   "short": "VAN", "league": "MLS"},
	"MINNESOTA UTD":  {"colors": [Color8(135, 142, 144), Color8(122, 184, 237)],"short": "MIN", "league": "MLS"},
	"COLORADO RAPIDS":{"colors": [Color8(134, 38, 51), Color8(139, 171, 204)], "short": "COL", "league": "MLS"},
	"CHARLOTTE FC":   {"colors": [Color8(0, 133, 202), Color8(0, 0, 0)],       "short": "CHR", "league": "MLS"},
	"SAN JOSE EQ":    {"colors": [Color8(0, 0, 0), Color8(0, 81, 186)],        "short": "SJE", "league": "MLS"},
	"AUSTIN FC":      {"colors": [Color8(0, 180, 81), Color8(0, 0, 0)],        "short": "AUS", "league": "MLS"},
	"CHICAGO FIRE":   {"colors": [Color8(255, 0, 0), Color8(0, 42, 92)],       "short": "CHI", "league": "MLS"},
	"D.C. UNITED":    {"colors": [Color8(0, 0, 0), Color8(239, 62, 66)],       "short": "DCU", "league": "MLS"},
	"CF MONTREAL":    {"colors": [Color8(0, 51, 160), Color8(0, 0, 0)],        "short": "MTL", "league": "MLS"},
	"ST. LOUIS CITY": {"colors": [Color8(226, 24, 54), Color8(0, 43, 92)],     "short": "STL", "league": "MLS"},
	"TORONTO FC":     {"colors": [Color8(227, 38, 54), Color8(32, 42, 68)],    "short": "TFC", "league": "MLS"},
	"SAN DIEGO FC":   {"colors": [Color8(0, 193, 213), Color8(0, 0, 0)],       "short": "SDF", "league": "MLS"},

	# --- SAUDI PRO LEAGUE ---
	"AL HILAL":       {"colors": [Color8(0, 94, 184), Color8(255, 255, 255)],  "short": "HIL", "league": "Saudi Pro League"},
	"AL NASSR":       {"colors": [Color8(254, 209, 65), Color8(0, 52, 120)],   "short": "NAS", "league": "Saudi Pro League"},
	"AL AHLI":        {"colors": [Color8(0, 166, 81), Color8(255, 255, 255)],  "short": "AHL", "league": "Saudi Pro League"},
	"AL ITTIHAD":     {"colors": [Color8(255, 215, 0), Color8(0, 0, 0)],       "short": "ITT", "league": "Saudi Pro League"},
	"AL SHABAB":      {"colors": [Color8(255, 255, 255), Color8(0, 0, 0)],     "short": "SHA", "league": "Saudi Pro League"},
	"AL TAAWOUN":     {"colors": [Color8(255, 215, 0), Color8(0, 51, 153)],    "short": "TAA", "league": "Saudi Pro League"},
	"AL ETTIFAQ":     {"colors": [Color8(0, 128, 64), Color8(255, 255, 255)],  "short": "ETT", "league": "Saudi Pro League"},
	"DAMAC":          {"colors": [Color8(255, 0, 0), Color8(255, 215, 0)],     "short": "DAM", "league": "Saudi Pro League"},
	"AL FAYHA":       {"colors": [Color8(255, 165, 0), Color8(0, 0, 255)],     "short": "FAY", "league": "Saudi Pro League"},
	"AL FATEH":       {"colors": [Color8(0, 100, 0), Color8(255, 255, 255)],   "short": "FAT", "league": "Saudi Pro League"},
	"AL RIYADH":      {"colors": [Color8(255, 0, 0), Color8(0, 0, 0)],         "short": "RIY", "league": "Saudi Pro League"},
	"AL WEHDA":       {"colors": [Color8(255, 0, 0), Color8(255, 255, 255)],   "short": "WEH", "league": "Saudi Pro League"},
	"AL KHALEEJ":     {"colors": [Color8(255, 255, 0), Color8(0, 128, 0)],     "short": "KHA", "league": "Saudi Pro League"},
	"AL RAED":        {"colors": [Color8(255, 0, 0), Color8(0, 0, 0)],         "short": "RAE", "league": "Saudi Pro League"},
	"AL QADSIAH":     {"colors": [Color8(255, 0, 0), Color8(255, 255, 0)],     "short": "QAD", "league": "Saudi Pro League"},
	"AL OKHDOOD":     {"colors": [Color8(0, 191, 255), Color8(255, 255, 255)], "short": "OKH", "league": "Saudi Pro League"},
	"NEOM SC":        {"colors": [Color8(0, 0, 139), Color8(255, 215, 0)],     "short": "NEO", "league": "Saudi Pro League"},
	"AL KHOLOOD":     {"colors": [Color8(255, 0, 0), Color8(255, 255, 255)],   "short": "KHO", "league": "Saudi Pro League"},

	# --- OTHER ---
	"CLUB BRUGGE":    {"colors": [Color8(0, 0, 0), Color8(0, 116, 217)],      "short": "CLB", "league": "Other"},
	"QARABAG":        {"colors": [Color8(0, 0, 128), Color8(227, 141, 26)],   "short": "QFK", "league": "Other"},
	"OLYMPIACOS":     {"colors": [Color8(255, 255, 255), Color8(221, 0, 0)],  "short": "OLY", "league": "Other"},
	"BODO/GLIMT":     {"colors": [Color8(255, 220, 0), Color8(0, 0, 0)],      "short": "BOD", "league": "Other"},
	"BENFICA":        {"colors": [Color8(232, 48, 48), Color8(255, 255, 255)],"short": "SLB", "league": "Other"},
	"SPORTING":       {"colors": [Color8(0, 128, 0), Color8(255, 255, 255)],  "short": "SCP", "league": "Other"},
	"PORTO":          {"colors": [Color8(0, 0, 255), Color8(255, 255, 255)],  "short": "POR", "league": "Other"},
	"AJAX":           {"colors": [Color8(255, 255, 255), Color8(210, 18, 46)],"short": "AJX", "league": "Other"},
	"PSV":            {"colors": [Color8(255, 0, 0), Color8(255, 255, 255)],  "short": "PSV", "league": "Other"},
	"FEYENOORD":      {"colors": [Color8(255, 255, 255), Color8(255, 0, 0)],  "short": "FEY", "league": "Other"},
	"PANATHINAIKOS":  {"colors": [Color8(0, 123, 58), Color8(255, 255, 255)], "short": "PAO", "league": "Other"},
	"VIKTORIA PLZEN": {"colors": [Color8(237, 27, 36), Color8(0, 77, 152)],   "short": "PLZ", "league": "Other"},
	"DINAMO ZAGREB":  {"colors": [Color8(0, 51, 153), Color8(255, 255, 255)], "short": "DZG", "league": "Other"},
	"GENK":           {"colors": [Color8(0, 71, 156), Color8(255, 255, 255)], "short": "GNK", "league": "Other"},
	"BRANN":          {"colors": [Color8(226, 0, 26), Color8(255, 255, 255)], "short": "BRA", "league": "Other"},
	"PAOK":           {"colors": [Color8(0, 0, 0), Color8(255, 255, 255)],    "short": "PAOK", "league": "Other"},
	"LUDOGORETS":     {"colors": [Color8(13, 104, 56), Color8(255, 255, 255)],"short": "LUD", "league": "Other"},
	"FERENCVAROS":    {"colors": [Color8(28, 127, 55), Color8(255, 255, 255)],"short": "FER", "league": "Other"},
	"CRVENA ZVEZDA":  {"colors": [Color8(208, 16, 35), Color8(255, 255, 255)],"short": "CZV", "league": "Other"},
	"CELTIC":         {"colors": [Color8(0, 128, 0), Color8(255, 255, 255)],  "short": "CLT", "league": "Other"}
}

func _ready():
	for team_name in TEAMS:
		var short_name = TEAMS[team_name]["short"]
		var logo_path = "res://assets/" + short_name.to_lower() + ".png"
		if ResourceLoader.exists(logo_path):
			TEAM_LOGOS[team_name] = load(logo_path)
		else:
			TEAM_LOGOS[team_name] = null

	bg_music_player = AudioStreamPlayer.new()
	bg_music_player.stream = preload("res://main_menu.mp3")
	if bg_music_player.stream is AudioStreamMP3:
		bg_music_player.stream.loop = true
	add_child(bg_music_player)
	_update_bg_music_volume()

func _update_bg_music_volume():
	if is_instance_valid(bg_music_player):
		var target_vol = master_vol * vol_settings.get("menu_music", 0.4)
		if target_vol <= 0.01:
			bg_music_player.volume_db = -80.0
		else:
			bg_music_player.volume_db = linear_to_db(target_vol)
