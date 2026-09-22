extends Control

var custom_font = preload("res://Teko-Bold.ttf")
var billing



var LANG = {
	"TR": {
		"TEAM_SELECTION": "TAKIM SEÇİMİ", "SETTINGS": "AYARLAR",
		"HOME": "EV SAHİBİ", "AWAY": "DEPLASMAN", "SEARCH": "Takım Ara...",
		"START_MATCH": "MAÇI BAŞLAT", "LANG_BTN": "TR", "CLOSE": "KAPAT", "SAVE": "KAYDET",
		"LBL_MASTER": "GENEL SES", "LBL_MENU_MUSIC": "MENÜ MÜZİĞİ", "LBL_STADIUM": "STADYUM", "LBL_MUSIC": "GOL MÜZİĞİ",
		"LBL_THEME": "TEMA SEÇİMİ", "LBL_SHAKE": "EKRAN TİTREŞİMİ", "LBL_VIBRATION": "TİTREŞİM", "LBL_SPEED": "MAÇ SÜRESİ",
		"SEC_THEME": "TEMA", "SEC_GAME": "OYUN AYARLARI", "SEC_AUDIO": "SES AYARLARI",
		"STATS_TITLE": "İSTATİSTİKLER", "SHOP_TITLE": "MAĞAZA",
		"STATS_NO_DATA": "Henüz maç oynanmadı.\nBir maç oyna ve istatistiklerin burada görünecek!",
		"STATS_RECENT": "Son Maçlar", "STATS_TOTAL": "Toplam Maç",
		"STATS_HOME_W": "Galibiyet (Ev)", "STATS_AWAY_W": "Dep. Galibiyet",
		"STATS_DRAW": "Beraberlik", "STATS_MOST_GOALS": "En Çok Gol", "STATS_BIGGEST_WIN": "En Büyük Fark",
		"SHOP_COSMETICS": "KOZMETİKLER", "SHOP_BALL_SKINS": "Top Görünümleri",
		"SHOP_BUY": "49.99 TL — SATIN AL", "SHOP_CANCEL": "VAZGEÇ",
		"SHOP_PRO_DESC": "Tüm özel temalar, özel toplar, taçlar ve reklamsız deneyim",
		"REPLAY_ASK": "Aynı maçı tekrar oynatmak istediğinize emin misiniz?",
		"RANDOM": "RASTGELE",
		"SHOP_WATCH_AD": "VİDEO İZLE (+50 Jeton)", "SHOP_EQUIPPED": "SEÇİLİ", "SHOP_EQUIP": "KULLAN",
		"SKIN_CLASSIC": "Klasik", "SKIN_GOLD": "Altın", "SKIN_NEON": "Neon", 
		"SKIN_CHROME": "Krom", "SKIN_LAVA": "Lav", "SKIN_ICE": "Buz",
		"FAV_YOURS": "Favori Takım", "FAV_MAKE": "Favorim Yap",
		"FAV_CONFIRM_TITLE": "Favori Takımı Değiştir",
		"FAV_CONFIRM_DESC": "Favori takımını \"%s\" olarak değiştirmek istediğine emin misin?",
		"CONFIRM_YES": "ONAYLA",
		"CURRENCY": "Jeton",
		"FAV_STATS_PLAYED": "Oynanan Maç",
		"FAV_STATS_WINRATE": "Galibiyet Oranı",
		"FAV_STATS_GOALS_FOR": "Atılan / Yenilen",
		"FAV_STATS_GOALS_AGAINST": "Yenilen Gol",
		"FAV_STATS_BIGGEST_WIN": "En Farklı Galibiyet",
		"FAV_STATS_BIGGEST_LOSS": "En Farklı Mağlubiyet",
		"FAV_STATS_CARDS": "Kartlar",
		"ON": "AÇIK", "OFF": "KAPALI",
		"STATS_GENERAL": "GENEL İSTATİSTİKLER", "STATS_TEAM": "%s İSTATİSTİKLERİ",
		"GOALS_DIFF_LABEL": "Averaj: %+d",
		"FAV_STATS_YELLOW_CARDS": "Sarı Kart", "FAV_STATS_RED_CARDS": "Kırmızı Kart",
		"PLAYER_LIST_TITLE": "KADRO", "PLAYER_LIST_BTN": "Oyuncu Kadrosu",
		"NO_FAV_TEAM_WARN": "Favori Takım Seçilmedi",
		"MAX_CHAR_WARN": "Maksimum 20 karakter yazabilirsiniz!", "ADD_PLAYER": "+ OYUNCU EKLE",
		"PRO_ACTIVE": "PRO AKTİF", "RESTORE_PURCHASES": "Satın Alımları Geri Yükle",
		"PRIVACY_POLICY": "Gizlilik Politikası", "PRIVACY_TITLE": "GİZLİLİK POLİTİKASI",
		"RESTORE_CHECK": "Satın alımlar kontrol ediliyor...", "RESTORE_SUCCESS": "Satın alımlar geri yüklendi!",
		"EXIT_CONFIRM": "Çıkmak istediğinize emin misiniz?", "EXIT_TITLE": "ÇIKIŞ", "SEC_ACCOUNT": "HESAP & GİZLİLİK",
		"SHOP_HATS": "Taçlar & Aksesuarlar", "HAT_KINGS_CROWN": "Kral Tacı", "HAT_QUEENS_CROWN": "Kraliçe Tacı",
		"HAT_VIKING": "Viking Miğferi", "HAT_MAGIC": "Büyücü Şapkası",
		"HAT_NONE": "Taç Yok", "HAT_FAV_NOTICE": "Taçlar yalnızca favori takımının topunda görünür.",
		"SHOP_UNEQUIP": "ÇIKAR", "NEED_MORE_COINS": "Yetersiz Jeton!",
		"ACHIEVEMENTS_BTN": "Google Play Başarımları", "AD_PREPARING": "Reklam hazırlanıyor, lütfen birkaç saniye sonra tekrar deneyin...",
		"DAILY_QUESTS_TITLE": "GÜNLÜK GÖREVLER", "DAILY_QUESTS_BTN": "Günlük Görevler",
		"QUEST_CLAIM": "AL", "QUEST_CLAIMED": "ALINDI", "QUEST_IN_PROGRESS": "Devam Ediyor",
		"LUCKY_WHEEL_TITLE": "ŞANS ÇARKI", "LUCKY_WHEEL_BTN": "Şans Çarkı",
		"LUCKY_WHEEL_SPIN": "ÇEVİR", "LUCKY_WHEEL_FREE": "ÜCRETSİZ ÇEVİR", "LUCKY_WHEEL_AD": "REKLAM İZLE & ÇEVİR",
		"LUCKY_WHEEL_NO_SPINS": "Bugünlük çevirme hakkın bitti! Yarın tekrar gel.",
		"LEADERBOARD_TITLE": "LİDERLİK TABLOSU", "LEADERBOARD_BTN": "Liderlik Tablosu",
		"LEADERBOARD_PLAYER": "Oyuncu - Takım", "LEADERBOARD_GOALS": "Toplam Gol", "LEADERBOARD_RANK": "Sıra",
		"QUEST_PROGRESS": "İlerleme", "QUEST_REWARD": "Ödül", "REMAINING_AD_SPINS": "Kalan Reklamlı Çevirme",
		"LEADERBOARD_OPEN": "DÜNYA SIRALAMASINI GÖR", "LEADERBOARD_SYNC": "SKORU EŞİTLE",
		"LEADERBOARD_HINT": "Google Play Games ile dünya sıralamasına katıl ve diğer oyuncularla yarış!",
		"GOALS_SUFFIX": "Gol", "PRO_UPGRADE_TITLE": "PRO'ya Yükselt", "LEADERBOARD_LOCAL_TITLE": "Skor Kartın",
		"LEADERBOARD_GLOBAL_TITLE": "Google Play Games Dünya Sıralaması",
		"LEAGUE_TURKEY": "Türkiye Ligi", "LEAGUE_NATIONAL": "Milli Takımlar", "LEAGUE_ENGLAND": "İngiltere Ligi", "LEAGUE_SPAIN": "İspanya Ligi",
		"LEAGUE_GERMANY": "Almanya Ligi", "LEAGUE_ITALY": "İtalya Ligi", "LEAGUE_FRANCE": "Fransa Ligi",
		"LEAGUE_USA": "Amerika Ligi", "LEAGUE_SAUDI": "Suudi Arabistan Ligi", "LEAGUE_WORLD": "Dünya Kulüpleri",
		"LEAGUE_ALL": "Tüm Takımlar", "LEAGUE_SELECT": "Lig Seç...",
		"STATS_FORM": "Son 5 Maç", "STATS_CLEAN_SHEETS": "%d Maç Gol Yemedi",
		"STATS_TOTAL_GOALS": "Toplam Gol", "STATS_AVG_GOALS": "Maç Başı Gol",
		"STATS_SELECT_FAV_PROMPT": "Takımına özel rekorları ve detaylı istatistikleri görmek için favori takımını seç!",
		"STATS_CHOOSE_FAV_BTN": "FAVORİ TAKIM SEÇ",
		"DUR_SHORT": "Kısa", "DUR_NORMAL": "Normal", "DUR_LONG": "Uzun",
		"EARNED_REWARD": "+%s %s Kazandın!",
		"SQUAD_SUFFIX": "KADROSU", "TAP_TO_SWITCH_TEAM": "Takım değiştirmek için dokun",
		"SELECT_TEAM": "TAKIM SEÇ", "SEARCH_TEAM": "Takım ara..."
	},
	"ENG": {
		"TEAM_SELECTION": "TEAM SELECTION", "SETTINGS": "SETTINGS",
		"HOME": "HOME", "AWAY": "AWAY", "SEARCH": "Search Team...",
		"START_MATCH": "START MATCH", "LANG_BTN": "ENG", "CLOSE": "CLOSE", "SAVE": "SAVE",
		"LBL_MASTER": "MASTER VOL", "LBL_MENU_MUSIC": "MENU MUSIC", "LBL_STADIUM": "STADIUM", "LBL_MUSIC": "GOAL MUSIC",
		"LBL_THEME": "SELECT THEME", "LBL_SHAKE": "SCREEN SHAKE", "LBL_VIBRATION": "VIBRATION", "LBL_SPEED": "MATCH DURATION",
		"SEC_THEME": "THEME", "SEC_GAME": "GAME SETTINGS", "SEC_AUDIO": "AUDIO SETTINGS",
		"STATS_TITLE": "STATISTICS", "SHOP_TITLE": "SHOP",
		"STATS_NO_DATA": "No matches played yet.\nPlay a match and your stats will appear here!",
		"STATS_RECENT": "Recent Matches", "STATS_TOTAL": "Total Matches",
		"STATS_HOME_W": "Home Wins", "STATS_AWAY_W": "Away Wins",
		"STATS_DRAW": "Draws", "STATS_MOST_GOALS": "Most Goals", "STATS_BIGGEST_WIN": "Biggest Win",
		"SHOP_COSMETICS": "COSMETICS", "SHOP_BALL_SKINS": "Ball Skins",
		"SHOP_BUY": "$0.99 — BUY NOW", "SHOP_CANCEL": "CANCEL",
		"SHOP_PRO_DESC": "Unlock all themes, custom balls, crowns and ad-free experience",
		"REPLAY_ASK": "Are you sure you want to replay the exact same match?",
		"RANDOM": "RANDOM",
		"SHOP_WATCH_AD": "WATCH VIDEO (+50 Coins)", "SHOP_EQUIPPED": "EQUIPPED", "SHOP_EQUIP": "EQUIP",
		"SKIN_CLASSIC": "Classic", "SKIN_GOLD": "Gold", "SKIN_NEON": "Neon", 
		"SKIN_CHROME": "Chrome", "SKIN_LAVA": "Lava", "SKIN_ICE": "Ice",
		"FAV_YOURS": "Your Favorite", "FAV_MAKE": "Make Favorite",
		"FAV_CONFIRM_TITLE": "Change Favorite Team",
		"FAV_CONFIRM_DESC": "Are you sure you want to change your favorite team to \"%s\"?",
		"CONFIRM_YES": "CONFIRM",
		"CURRENCY": "Coins",
		"FAV_STATS_PLAYED": "Matches Played",
		"FAV_STATS_WINRATE": "Win Rate",
		"FAV_STATS_GOALS_FOR": "Goals (For / Ag.)",
		"FAV_STATS_GOALS_AGAINST": "Goals Conceded",
		"FAV_STATS_BIGGEST_WIN": "Biggest Win",
		"FAV_STATS_BIGGEST_LOSS": "Biggest Loss",
		"FAV_STATS_CARDS": "Cards",
		"ON": "ON", "OFF": "OFF",
		"STATS_GENERAL": "GENERAL STATS", "STATS_TEAM": "%s STATS",
		"GOALS_DIFF_LABEL": "Diff: %+d",
		"FAV_STATS_YELLOW_CARDS": "Yellow Cards", "FAV_STATS_RED_CARDS": "Red Cards",
		"PLAYER_LIST_TITLE": "PLAYER LIST", "PLAYER_LIST_BTN": "Player Squad",
		"NO_FAV_TEAM_WARN": "No Favorite Team Selected",
		"MAX_CHAR_WARN": "Maximum 20 characters!", "ADD_PLAYER": "+ ADD PLAYER",
		"PRO_ACTIVE": "PRO ACTIVE", "RESTORE_PURCHASES": "Restore Purchases",
		"PRIVACY_POLICY": "Privacy Policy", "PRIVACY_TITLE": "PRIVACY POLICY",
		"RESTORE_CHECK": "Checking purchases...", "RESTORE_SUCCESS": "Purchases restored!",
		"EXIT_CONFIRM": "Are you sure you want to exit?", "EXIT_TITLE": "EXIT", "SEC_ACCOUNT": "ACCOUNT & PRIVACY",
		"SHOP_HATS": "Crowns & Accessories", "HAT_KINGS_CROWN": "King's Crown", "HAT_QUEENS_CROWN": "Queen's Crown",
		"HAT_VIKING": "Viking Helmet", "HAT_MAGIC": "Magic Hat",
		"HAT_NONE": "No Crown", "HAT_FAV_NOTICE": "Crowns only appear on your favorite team's ball.",
		"SHOP_UNEQUIP": "UNEQUIP", "NEED_MORE_COINS": "Insufficient Coins!",
		"ACHIEVEMENTS_BTN": "Google Play Achievements", "AD_PREPARING": "Ad is preparing, please try again in a few seconds...",
		"DAILY_QUESTS_TITLE": "DAILY QUESTS", "DAILY_QUESTS_BTN": "Daily Quests",
		"QUEST_CLAIM": "CLAIM", "QUEST_CLAIMED": "CLAIMED", "QUEST_IN_PROGRESS": "In Progress",
		"LUCKY_WHEEL_TITLE": "LUCKY WHEEL", "LUCKY_WHEEL_BTN": "Lucky Wheel",
		"LUCKY_WHEEL_SPIN": "SPIN", "LUCKY_WHEEL_FREE": "FREE SPIN", "LUCKY_WHEEL_AD": "WATCH AD & SPIN",
		"LUCKY_WHEEL_NO_SPINS": "No spins left today! Come back tomorrow.",
		"LEADERBOARD_TITLE": "LEADERBOARD", "LEADERBOARD_BTN": "Leaderboard",
		"LEADERBOARD_PLAYER": "Player - Team", "LEADERBOARD_GOALS": "Total Goals", "LEADERBOARD_RANK": "Rank",
		"QUEST_PROGRESS": "Progress", "QUEST_REWARD": "Reward", "REMAINING_AD_SPINS": "Remaining Ad Spins",
		"LEADERBOARD_OPEN": "VIEW GLOBAL LEADERBOARD", "LEADERBOARD_SYNC": "SYNC SCORE",
		"LEADERBOARD_HINT": "Join Google Play Games global leaderboard and compete worldwide!",
		"GOALS_SUFFIX": "Goals", "PRO_UPGRADE_TITLE": "Upgrade to PRO", "LEADERBOARD_LOCAL_TITLE": "Your Scorecard",
		"LEADERBOARD_GLOBAL_TITLE": "Google Play Games Global Leaderboard",
		"LEAGUE_TURKEY": "Turkish League", "LEAGUE_NATIONAL": "National Teams", "LEAGUE_ENGLAND": "English League", "LEAGUE_SPAIN": "Spanish League",
		"LEAGUE_GERMANY": "German League", "LEAGUE_ITALY": "Italian League", "LEAGUE_FRANCE": "French League",
		"LEAGUE_USA": "American League", "LEAGUE_SAUDI": "Saudi League", "LEAGUE_WORLD": "World Clubs",
		"LEAGUE_ALL": "All Teams", "LEAGUE_SELECT": "Select League...",
		"STATS_FORM": "Last 5 Matches", "STATS_CLEAN_SHEETS": "%d Clean Sheets",
		"STATS_TOTAL_GOALS": "Total Goals", "STATS_AVG_GOALS": "Goals Per Match",
		"STATS_SELECT_FAV_PROMPT": "Select your favorite team to track custom records and deep stats!",
		"STATS_CHOOSE_FAV_BTN": "SELECT FAVORITE TEAM",
		"DUR_SHORT": "Short", "DUR_NORMAL": "Normal", "DUR_LONG": "Long",
		"EARNED_REWARD": "Earned +%s %s!",
		"SQUAD_SUFFIX": "SQUAD", "TAP_TO_SWITCH_TEAM": "Tap to switch team",
		"SELECT_TEAM": "SELECT TEAM", "SEARCH_TEAM": "Search team..."
	},
	"ESP": {
		"TEAM_SELECTION": "SELECCIÓN DE EQUIPO", "SETTINGS": "AJUSTES",
		"HOME": "LOCAL", "AWAY": "VISITANTE", "SEARCH": "Buscar...",
		"START_MATCH": "INICIAR PARTIDO", "LANG_BTN": "ESP", "CLOSE": "CERRAR", "SAVE": "GUARDAR",
		"LBL_MASTER": "VOL MAESTRO", "LBL_MENU_MUSIC": "MÚSICA DEL MENÚ", "LBL_STADIUM": "ESTADIO", "LBL_MUSIC": "MÚSICA",
		"LBL_THEME": "TEMA", "LBL_SHAKE": "VIBRACIÓN", "LBL_VIBRATION": "VIBRACIÓN", "LBL_SPEED": "DURACIÓN",
		"SEC_THEME": "TEMA", "SEC_GAME": "AJUSTES DE JUEGO", "SEC_AUDIO": "AUDIO",
		"STATS_TITLE": "ESTADÍSTICAS", "SHOP_TITLE": "TIENDA",
		"STATS_NO_DATA": "Aún no hay partidos.\n¡Juega un partido y tus estadísticas aparecerán aquí!",
		"STATS_RECENT": "Partidos Recientes", "STATS_TOTAL": "Total Partidos",
		"STATS_HOME_W": "Victorias (Local)", "STATS_AWAY_W": "Vic. (Visitante)",
		"STATS_DRAW": "Empates", "STATS_MOST_GOALS": "Más Goles", "STATS_BIGGEST_WIN": "Mayor Diferencia",
		"SHOP_COSMETICS": "COSMÉTICOS", "SHOP_BALL_SKINS": "Apariencias de Balón",
		"SHOP_BUY": "0.99€ — COMPRAR", "SHOP_CANCEL": "CANCELAR",
		"SHOP_PRO_DESC": "Desbloquea todos los temas, balones y experiencia sin anuncios",
		"REPLAY_ASK": "¿Estás seguro de que quieres volver a jugar el mismo partido?",
		"RANDOM": "ALEATORIO",
		"SHOP_WATCH_AD": "VER VIDEO (+50 Monedas)", "SHOP_EQUIPPED": "EQUIPADO", "SHOP_EQUIP": "EQUIPAR",
		"SKIN_CLASSIC": "Clásico", "SKIN_GOLD": "Oro", "SKIN_NEON": "Neón", 
		"SKIN_CHROME": "Cromo", "SKIN_LAVA": "Lava", "SKIN_ICE": "Hielo",
		"FAV_YOURS": "Tu Favorito", "FAV_MAKE": "Hacer Favorito",
		"FAV_CONFIRM_TITLE": "Cambiar Equipo Favorito",
		"FAV_CONFIRM_DESC": "¿Estás seguro de que quieres cambiar tu equipo favorito a \"%s\"?",
		"CONFIRM_YES": "CONFIRMAR",
		"CURRENCY": "Monedas",
		"FAV_STATS_PLAYED": "Partidos Jugados",
		"FAV_STATS_WINRATE": "Tasa de Victorias",
		"FAV_STATS_GOALS_FOR": "Goles (Fav / Con)",
		"FAV_STATS_GOALS_AGAINST": "Goles en Contra",
		"FAV_STATS_BIGGEST_WIN": "Mayor Diferencia",
		"FAV_STATS_BIGGEST_LOSS": "Mayor Derrota",
		"FAV_STATS_CARDS": "Tarjetas",
		"ON": "ENCENDIDO", "OFF": "APAGADO",
		"STATS_GENERAL": "ESTADÍSTICAS GENERALES", "STATS_TEAM": "ESTADÍSTICAS DE %s",
		"GOALS_DIFF_LABEL": "Dif: %+d",
		"FAV_STATS_YELLOW_CARDS": "Tarjetas Amarillas", "FAV_STATS_RED_CARDS": "Tarjetas Rojas",
		"PLAYER_LIST_TITLE": "LISTA DE JUGADORES", "PLAYER_LIST_BTN": "Lista de Jugadores",
		"NO_FAV_TEAM_WARN": "Sin Equipo Favorito",
		"MAX_CHAR_WARN": "¡Máximo 20 caracteres!", "ADD_PLAYER": "+ AÑADIR JUGADOR",
		"PRO_ACTIVE": "PRO ACTIVO", "RESTORE_PURCHASES": "Restaurar Compras",
		"PRIVACY_POLICY": "Política de Privacidad", "PRIVACY_TITLE": "POLÍTICA DE PRIVACIDAD",
		"RESTORE_CHECK": "Comprobando compras...", "RESTORE_SUCCESS": "¡Compras restauradas!",
		"EXIT_CONFIRM": "¿Estás seguro de que quieres salir?", "EXIT_TITLE": "SALIR", "SEC_ACCOUNT": "CUENTA Y PRIVACIDAD",
		"SHOP_HATS": "Coronas y Accesorios", "HAT_KINGS_CROWN": "Corona de Rey", "HAT_QUEENS_CROWN": "Corona de Reina",
		"HAT_VIKING": "Casco Vikingo", "HAT_MAGIC": "Sombrero Mágico",
		"HAT_NONE": "Sin Corona", "HAT_FAV_NOTICE": "Las coronas solo aparecen en el balón favorito.",
		"SHOP_UNEQUIP": "QUITAR", "NEED_MORE_COINS": "¡Monedas insuficientes!",
		"ACHIEVEMENTS_BTN": "Logros de Google Play", "AD_PREPARING": "El anuncio se está preparando, por favor intenta en unos segundos...",
		"DAILY_QUESTS_TITLE": "MISIONES DIARIAS", "DAILY_QUESTS_BTN": "Misiones Diarias",
		"QUEST_CLAIM": "RECLAMAR", "QUEST_CLAIMED": "RECLAMADO", "QUEST_IN_PROGRESS": "En Progreso",
		"LUCKY_WHEEL_TITLE": "RULETA DE LA SUERTE", "LUCKY_WHEEL_BTN": "Ruleta",
		"LUCKY_WHEEL_SPIN": "GIRAR", "LUCKY_WHEEL_FREE": "GIRO GRATIS", "LUCKY_WHEEL_AD": "VER ANUNCIO & GIRAR",
		"LUCKY_WHEEL_NO_SPINS": "¡Sin giros hoy! Vuelve mañana.",
		"LEADERBOARD_TITLE": "TABLA DE CLASIFICACIÓN", "LEADERBOARD_BTN": "Clasificación",
		"LEADERBOARD_PLAYER": "Jugador - Equipo", "LEADERBOARD_GOALS": "Goles Totales", "LEADERBOARD_RANK": "Puesto",
		"QUEST_PROGRESS": "Progreso", "QUEST_REWARD": "Recompensa", "REMAINING_AD_SPINS": "Giros Restantes",
		"LEADERBOARD_OPEN": "VER CLASIFICACIÓN GLOBAL", "LEADERBOARD_SYNC": "SINCRONIZAR PUNTUACIÓN",
		"LEADERBOARD_HINT": "¡Únete a la clasificación global de Google Play Games y compite mundialmente!",
		"GOALS_SUFFIX": "Goles", "PRO_UPGRADE_TITLE": "Mejorar a PRO", "LEADERBOARD_LOCAL_TITLE": "Tu Tarjeta de Puntuación",
		"LEADERBOARD_GLOBAL_TITLE": "Clasificación Global de Google Play Games",
		"LEAGUE_TURKEY": "Liga Turca", "LEAGUE_NATIONAL": "Selecciones", "LEAGUE_ENGLAND": "Liga Inglesa", "LEAGUE_SPAIN": "Liga Española",
		"LEAGUE_GERMANY": "Liga Alemana", "LEAGUE_ITALY": "Liga Italiana", "LEAGUE_FRANCE": "Liga Francesa",
		"LEAGUE_USA": "Liga Americana", "LEAGUE_SAUDI": "Liga Saudí", "LEAGUE_WORLD": "Clubes del Mundo",
		"LEAGUE_ALL": "Todos los Equipos", "LEAGUE_SELECT": "Elegir Liga...",
		"STATS_FORM": "Últimos 5 Partidos", "STATS_CLEAN_SHEETS": "%d Vallas Invictas",
		"STATS_TOTAL_GOALS": "Goles Totales", "STATS_AVG_GOALS": "Promedio de Goles",
		"STATS_SELECT_FAV_PROMPT": "¡Elige tu equipo favorito para seguir récords y estadísticas detalladas!",
		"STATS_CHOOSE_FAV_BTN": "ELEGIR EQUIPO",
		"DUR_SHORT": "Corto", "DUR_NORMAL": "Normal", "DUR_LONG": "Largo",
		"EARNED_REWARD": "¡Ganaste +%s %s!",
		"SQUAD_SUFFIX": "PLANTILLA", "TAP_TO_SWITCH_TEAM": "Toca para cambiar de equipo",
		"SELECT_TEAM": "SELECCIONAR EQUIPO", "SEARCH_TEAM": "Buscar equipo..."
	},
	"POR": {
		"TEAM_SELECTION": "SELEÇÃO DE EQUIPA", "SETTINGS": "DEFINIÇÕES",
		"HOME": "CASA", "AWAY": "FORA", "SEARCH": "Pesquisar...",
		"START_MATCH": "INICIAR JOGO", "LANG_BTN": "POR", "CLOSE": "FECHAR", "SAVE": "GUARDAR",
		"LBL_MASTER": "VOL PRINCIPAL", "LBL_MENU_MUSIC": "MÚSICA DO MENU", "LBL_STADIUM": "ESTÁDIO", "LBL_MUSIC": "MÚSICA",
		"LBL_THEME": "TEMA", "LBL_SHAKE": "VIBRAÇÃO", "LBL_VIBRATION": "VIBRAÇÃO", "LBL_SPEED": "DURAÇÃO",
		"SEC_THEME": "TEMA", "SEC_GAME": "DEFINIÇÕES DE JOGO", "SEC_AUDIO": "ÁUDIO",
		"STATS_TITLE": "ESTATÍSTICAS", "SHOP_TITLE": "LOJA",
		"STATS_NO_DATA": "Ainda não há jogos.\nJogue uma partida e as suas estatísticas aparecerão aqui!",
		"STATS_RECENT": "Jogos Recentes", "STATS_TOTAL": "Total de Jogos",
		"STATS_HOME_W": "Vitórias (Casa)", "STATS_AWAY_W": "Vit. (Fora)",
		"STATS_DRAW": "Empates", "STATS_MOST_GOALS": "Mais Golos", "STATS_BIGGEST_WIN": "Maior Diferença",
		"SHOP_COSMETICS": "COSMÉTICOS", "SHOP_BALL_SKINS": "Visuais de Bola",
		"SHOP_BUY": "0.99€ — COMPRAR", "SHOP_CANCEL": "CANCELAR",
		"SHOP_PRO_DESC": "Desbloqueie todos os temas, bolas e experiência sem anúncios",
		"REPLAY_ASK": "Tem certeza de que deseja jogar a mesma partida?",
		"RANDOM": "ALEATÓRIO",
		"SHOP_WATCH_AD": "VER VÍDEO (+50 Moedas)", "SHOP_EQUIPPED": "EQUIPADO", "SHOP_EQUIP": "EQUIPAR",
		"SKIN_CLASSIC": "Clássico", "SKIN_GOLD": "Ouro", "SKIN_NEON": "Neon", 
		"SKIN_CHROME": "Cromo", "SKIN_LAVA": "Lava", "SKIN_ICE": "Gelo",
		"FAV_YOURS": "O Seu Favorito", "FAV_MAKE": "Tornar Favorito",
		"FAV_CONFIRM_TITLE": "Alterar Equipa Favorita",
		"FAV_CONFIRM_DESC": "Tem certeza de que deseja alterar a sua equipa favorita para \"%s\"?",
		"CONFIRM_YES": "CONFIRMAR",
		"CURRENCY": "Moedas",
		"FAV_STATS_PLAYED": "Jogos Realizados",
		"FAV_STATS_WINRATE": "Taxa de Vitórias",
		"FAV_STATS_GOALS_FOR": "Golos (Pró / Con)",
		"FAV_STATS_GOALS_AGAINST": "Golos Sofridos",
		"FAV_STATS_BIGGEST_WIN": "Maior Diferença",
		"FAV_STATS_BIGGEST_LOSS": "Maior Derrota",
		"FAV_STATS_CARDS": "Cartões",
		"ON": "LIGADO", "OFF": "DESLIGADO",
		"STATS_GENERAL": "ESTATÍSTICAS GERAIS", "STATS_TEAM": "ESTATÍSTICAS DE %s",
		"GOALS_DIFF_LABEL": "Dif: %+d",
		"FAV_STATS_YELLOW_CARDS": "Cartões Amarelos", "FAV_STATS_RED_CARDS": "Cartões Vermelhos",
		"PLAYER_LIST_TITLE": "PLANTEL", "PLAYER_LIST_BTN": "Plantel",
		"NO_FAV_TEAM_WARN": "Nenhuma Equipa Favorita",
		"MAX_CHAR_WARN": "Máximo 20 caracteres!", "ADD_PLAYER": "+ ADICIONAR JUGADOR",
		"PRO_ACTIVE": "PRO ATIVO", "RESTORE_PURCHASES": "Restaurar Compras",
		"PRIVACY_POLICY": "Política de Privacidade", "PRIVACY_TITLE": "POLÍTICA DE PRIVACIDADE",
		"RESTORE_CHECK": "A verificar compras...", "RESTORE_SUCCESS": "Compras restauradas!",
		"EXIT_CONFIRM": "Tem certeza de que deseja sair?", "EXIT_TITLE": "SAIR", "SEC_ACCOUNT": "CONTA E PRIVACIDADE",
		"SHOP_HATS": "Coroas e Acessórios", "HAT_KINGS_CROWN": "Coroa de Rei", "HAT_QUEENS_CROWN": "Coroa de Rainha",
		"HAT_VIKING": "Capacete Viking", "HAT_MAGIC": "Chapéu Mágico",
		"HAT_NONE": "Sem Coroa", "HAT_FAV_NOTICE": "As coroas só aparecem na bola favorita.",
		"SHOP_UNEQUIP": "REMOVER", "NEED_MORE_COINS": "Moedas insuficientes!",
		"ACHIEVEMENTS_BTN": "Conquistas do Google Play", "AD_PREPARING": "O anúncio está a preparar-se, tente novamente em algun segundos...",
		"DAILY_QUESTS_TITLE": "MISSÕES DIÁRIAS", "DAILY_QUESTS_BTN": "Missões Diárias",
		"QUEST_CLAIM": "RESCATAR", "QUEST_CLAIMED": "RESCATADO", "QUEST_IN_PROGRESS": "Em Progresso",
		"LUCKY_WHEEL_TITLE": "RODA DA SORTE", "LUCKY_WHEEL_BTN": "Roda da Sorte",
		"LUCKY_WHEEL_SPIN": "GIRAR", "LUCKY_WHEEL_FREE": "GIRO GRÁTIS", "LUCKY_WHEEL_AD": "VER ANÚNCIO & GIRAR",
		"LUCKY_WHEEL_NO_SPINS": "Sem giros hoje! Volte amanhã.",
		"LEADERBOARD_TITLE": "TABELA DE LIDERANÇA", "LEADERBOARD_BTN": "Liderança",
		"LEADERBOARD_PLAYER": "Jogador - Equipa", "LEADERBOARD_GOALS": "Golos Totais", "LEADERBOARD_RANK": "Posição",
		"QUEST_PROGRESS": "Progresso", "QUEST_REWARD": "Recompensa", "REMAINING_AD_SPINS": "Giros Restantes",
		"LEADERBOARD_OPEN": "VER CLASSIFICAÇÃO GLOBAL", "LEADERBOARD_SYNC": "SINCRONIZAR PONTUAÇÃO",
		"LEADERBOARD_HINT": "Junte-se à classificação global do Google Play Games e compita mundialmente!",
		"GOALS_SUFFIX": "Golos", "PRO_UPGRADE_TITLE": "Melhorar para PRO", "LEADERBOARD_LOCAL_TITLE": "O Seu Cartão de Pontuação",
		"LEADERBOARD_GLOBAL_TITLE": "Classificação Global do Google Play Games",
		"LEAGUE_TURKEY": "Liga Turca", "LEAGUE_NATIONAL": "Seleções", "LEAGUE_ENGLAND": "Liga Inglesa", "LEAGUE_SPAIN": "Liga Espanhola",
		"LEAGUE_GERMANY": "Liga Alemã", "LEAGUE_ITALY": "Liga Italiana", "LEAGUE_FRANCE": "Liga Francesa",
		"LEAGUE_USA": "Liga Americana", "LEAGUE_SAUDI": "Liga Saudita", "LEAGUE_WORLD": "Clubes do Mundo",
		"LEAGUE_ALL": "Todas as Equipas", "LEAGUE_SELECT": "Escolher Liga...",
		"STATS_FORM": "Últimos 5 Jogos", "STATS_CLEAN_SHEETS": "%d Jogos sem Sofrer Gol",
		"STATS_TOTAL_GOALS": "Golos Totais", "STATS_AVG_GOALS": "Média de Golos",
		"STATS_SELECT_FAV_PROMPT": "Escolha a sua equipa favorita para acompanhar recordes e estatísticas!",
		"STATS_CHOOSE_FAV_BTN": "ESCOLHER EQUIPA",
		"DUR_SHORT": "Curto", "DUR_NORMAL": "Normal", "DUR_LONG": "Longo",
		"EARNED_REWARD": "Ganhou +%s %s!",
		"SQUAD_SUFFIX": "PLANTEL", "TAP_TO_SWITCH_TEAM": "Toque para mudar de equipa",
		"SELECT_TEAM": "SELECIONAR EQUIPA", "SEARCH_TEAM": "Pesquisar equipa..."
	},
	"ITA": {
		"TEAM_SELECTION": "SELEZIONE SQUADRA", "SETTINGS": "IMPOSTAZIONI",
		"HOME": "CASA", "AWAY": "TRASFERTA", "SEARCH": "Cerca Squadra...",
		"START_MATCH": "INIZIA PARTITA", "LANG_BTN": "ITA", "CLOSE": "CHIUDI", "SAVE": "SALVA",
		"LBL_MASTER": "VOLUME GENERALE", "LBL_MENU_MUSIC": "MUSICA MENU", "LBL_STADIUM": "STADIO", "LBL_MUSIC": "MUSICA GOL",
		"LBL_THEME": "TEMA", "LBL_SHAKE": "VIBRAZIONE SCHERMO", "LBL_VIBRATION": "VIBRAZIONE", "LBL_SPEED": "DURATA PARTITA",
		"SEC_THEME": "TEMA", "SEC_GAME": "IMPOSTAZIONI DI GIOCO", "SEC_AUDIO": "AUDIO",
		"STATS_TITLE": "STATISTICHE", "SHOP_TITLE": "NEGOZIO",
		"STATS_NO_DATA": "Nessuna partita giocata.\nGioca una partita e le tue statistiche appariranno qui!",
		"STATS_RECENT": "Partite Recenti", "STATS_TOTAL": "Partite Totali",
		"STATS_HOME_W": "Vittorie (Casa)", "STATS_AWAY_W": "Vittorie (Trasf.)",
		"STATS_DRAW": "Pareggi", "STATS_MOST_GOALS": "Più Gol", "STATS_BIGGEST_WIN": "Miglior Vittoria",
		"SHOP_COSMETICS": "COSMETICI", "SHOP_BALL_SKINS": "Aspetti Pallone",
		"SHOP_BUY": "0.99€ — ACQUISTA ORA", "SHOP_CANCEL": "ANNULLA",
		"SHOP_PRO_DESC": "Sblocca tutti i temi, palloni, corone e rimuovi le pubblicità",
		"REPLAY_ASK": "Sei sicuro di voler rigiocare la stessa partita?",
		"RANDOM": "CASUALE",
		"SHOP_WATCH_AD": "GUARDA VIDEO (+50 Monete)", "SHOP_EQUIPPED": "IN USO", "SHOP_EQUIP": "USA",
		"SKIN_CLASSIC": "Classico", "SKIN_GOLD": "Oro", "SKIN_NEON": "Neon", 
		"SKIN_CHROME": "Cromo", "SKIN_LAVA": "Lava", "SKIN_ICE": "Ghiaccio",
		"FAV_YOURS": "La Tua Preferita", "FAV_MAKE": "Imposta Preferita",
		"FAV_CONFIRM_TITLE": "Cambia Squadra Preferita",
		"FAV_CONFIRM_DESC": "Sei sicuro di voler cambiare la tua squadra preferita in \"%s\"?",
		"CONFIRM_YES": "CONFERMA",
		"CURRENCY": "Monete",
		"FAV_STATS_PLAYED": "Partite Giocate",
		"FAV_STATS_WINRATE": "Percentuale Vittorie",
		"FAV_STATS_GOALS_FOR": "Gol (Fatti / Subiti)",
		"FAV_STATS_GOALS_AGAINST": "Gol Subiti",
		"FAV_STATS_BIGGEST_WIN": "Miglior Vittoria",
		"FAV_STATS_BIGGEST_LOSS": "Peggior Sconfitta",
		"FAV_STATS_CARDS": "Cartellini",
		"ON": "ATTIVO", "OFF": "DISATTIVO",
		"STATS_GENERAL": "STATISTICHE GENERALI", "STATS_TEAM": "STATISTICHE DI %s",
		"GOALS_DIFF_LABEL": "Diff: %+d",
		"FAV_STATS_YELLOW_CARDS": "Cartellini Gialli", "FAV_STATS_RED_CARDS": "Cartellini Rossi",
		"PLAYER_LIST_TITLE": "ROSA", "PLAYER_LIST_BTN": "Rosa Giocatori",
		"NO_FAV_TEAM_WARN": "Nessuna Squadra Preferita",
		"MAX_CHAR_WARN": "Massimo 20 caratteri!", "ADD_PLAYER": "+ AGGIUNGI GIOCATORE",
		"PRO_ACTIVE": "PRO ATTIVO", "RESTORE_PURCHASES": "Ripristina Acquisti",
		"PRIVACY_POLICY": "Informativa sulla Privacy", "PRIVACY_TITLE": "INFORMATIVA SULLA PRIVACY",
		"RESTORE_CHECK": "Verifica acquisti...", "RESTORE_SUCCESS": "Acquisti ripristinati!",
		"EXIT_CONFIRM": "Sei sicuro di voler uscire?", "EXIT_TITLE": "ESCI", "SEC_ACCOUNT": "ACCOUNT E PRIVACY",
		"SHOP_HATS": "Corone e Accessori", "HAT_KINGS_CROWN": "Corona del Re", "HAT_QUEENS_CROWN": "Corona della Regina",
		"HAT_VIKING": "Elmo Vichingo", "HAT_MAGIC": "Cappello Magico",
		"HAT_NONE": "Nessuna Corona", "HAT_FAV_NOTICE": "Le corone appaiono solo sul pallone della squadra preferita.",
		"SHOP_UNEQUIP": "RIMUOVI", "NEED_MORE_COINS": "Monete insufficienti!",
		"ACHIEVEMENTS_BTN": "Obiettivi Google Play", "AD_PREPARING": "Annuncio in preparazione, riprova tra qualche secondo...",
		"DAILY_QUESTS_TITLE": "MISSIONI GIORNALIERE", "DAILY_QUESTS_BTN": "Missioni Giornaliere",
		"QUEST_CLAIM": "RISCATTA", "QUEST_CLAIMED": "RISCATTATO", "QUEST_IN_PROGRESS": "In Corso",
		"LUCKY_WHEEL_TITLE": "RUOTA DELLA FORTUNA", "LUCKY_WHEEL_BTN": "Ruota della Fortuna",
		"LUCKY_WHEEL_SPIN": "GIRA", "LUCKY_WHEEL_FREE": "GIRO GRATIS", "LUCKY_WHEEL_AD": "GUARDA PUBBLICITÀ & GIRA",
		"LUCKY_WHEEL_NO_SPINS": "Nessun giro rimasto oggi! Torna domani.",
		"LEADERBOARD_TITLE": "CLASSIFICA", "LEADERBOARD_BTN": "Classifica",
		"LEADERBOARD_PLAYER": "Giocatore - Squadra", "LEADERBOARD_GOALS": "Gol Totali", "LEADERBOARD_RANK": "Posizione",
		"QUEST_PROGRESS": "Progresso", "QUEST_REWARD": "Ricompensa", "REMAINING_AD_SPINS": "Giri Pubblicitari Rimasti",
		"LEADERBOARD_OPEN": "VEDI CLASSIFICA MONDIALE", "LEADERBOARD_SYNC": "SINCRONIZZA PUNTEGGIO",
		"LEADERBOARD_HINT": "Unisciti alla classifica mondiale di Google Play Games e sfida gli altri giocatori!",
		"GOALS_SUFFIX": "Gol", "PRO_UPGRADE_TITLE": "Passa a PRO", "LEADERBOARD_LOCAL_TITLE": "La Tua Scheda Punteggio",
		"LEADERBOARD_GLOBAL_TITLE": "Classifica Globale Google Play Games",
		"LEAGUE_TURKEY": "Campionato Turco", "LEAGUE_NATIONAL": "Nazionali", "LEAGUE_ENGLAND": "Campionato Inglese", "LEAGUE_SPAIN": "Campionato Spagnolo",
		"LEAGUE_GERMANY": "Campionato Tedesco", "LEAGUE_ITALY": "Campionato Italiano", "LEAGUE_FRANCE": "Campionato Francese",
		"LEAGUE_USA": "Campionato Americano", "LEAGUE_SAUDI": "Campionato Saudita", "LEAGUE_WORLD": "Club Mondiali",
		"LEAGUE_ALL": "Tutte le Squadre", "LEAGUE_SELECT": "Seleziona Campionato...",
		"STATS_FORM": "Ultime 5 Partite", "STATS_CLEAN_SHEETS": "%d Partite con Porta Inviolata",
		"STATS_TOTAL_GOALS": "Gol Totali", "STATS_AVG_GOALS": "Media Gol a Partita",
		"STATS_SELECT_FAV_PROMPT": "Scegli la tua squadra preferita per visualizzare record e statistiche approfondite!",
		"STATS_CHOOSE_FAV_BTN": "SCEGLI SQUADRA PREFERITA",
		"DUR_SHORT": "Breve", "DUR_NORMAL": "Normale", "DUR_LONG": "Lunga",
		"EARNED_REWARD": "Hai guadagnato +%s %s!",
		"SQUAD_SUFFIX": "ROSA", "TAP_TO_SWITCH_TEAM": "Tocca per cambiare squadra",
		"SELECT_TEAM": "SELEZIONA SQUADRA", "SEARCH_TEAM": "Cerca squadra..."
	}
}


var white = Color.WHITE
var neon_green = Color8(57, 255, 20)
var glass_panel = Color8(25, 35, 55, 200)
var header_glass = Color8(20, 30, 45, 180)

var TEAM_NAMES = []
var search_bar_home: LineEdit
var search_bar_away: LineEdit
var league_dropdown_home: OptionButton
var league_dropdown_away: OptionButton
var home_list: VBoxContainer
var away_list: VBoxContainer
var home_lbl: Label
var away_lbl: Label
var home_selected: bool = false
var away_selected: bool = false
var lang_btn: Button
var settings_overlay: ColorRect
var player_list_overlay: ColorRect
var ui_labels = []
var burger_menu_overlay: Control = null
var ui_separators = []

var home_preview: Control
var away_preview: Control

var active_theme: Dictionary
var bg_grad: Gradient

var fav_h_btn: Button
var fav_a_btn: Button

var temp_settings = {}
var start_match_btn: Button
var rand_h_btn: Button
var rand_a_btn: Button
var top_stripe_panel: PanelContainer
var main_scroll: ScrollContainer

# --- TAB NAVIGATION ---
var current_tab: int = 1   # 0=Stats, 1=Home, 2=Shop
var tabs_hbox: HBoxContainer
var tab_container: Control
var nav_bar_panel: PanelContainer
var nav_bar_btns: Array = []
var swipe_start: Vector2 = Vector2.ZERO
var swipe_active: bool = false
var is_rewarded_loading: bool = false
var is_refreshing_shop: bool = false
var shop_cosmetic_category: int = 0
var swipe_threshold: float = 60.0
var shop_balls_scroll: ScrollContainer = null
var shop_hats_scroll: ScrollContainer = null
var badge_textures: Dictionary = {}  # Preloaded at _ready() for badge overlay on preview balls
var burger_btn: Button
var is_refreshing_stats: bool = false

const MENU_BANNER_ID = "ca-app-pub-7323450546679743/4717442614"
var menu_banner_ad_id: String = ""
var shop_notification_dot: Panel

var is_banner_loading: bool = false
var menu_banner_retry_count: int = 0

# ======================================================
# 3D TACTILE BUTTON STYLING HELPER
# ======================================================
func create_3d_button_style(bg_col: Color, border_bottom_col: Color = Color.TRANSPARENT, radius: int = 14, depth: int = 4, pad_x: int = 20, pad_y: int = 10) -> Dictionary:
	if border_bottom_col == Color.TRANSPARENT:
		border_bottom_col = bg_col.darkened(0.32)
	
	var norm = StyleBoxFlat.new()
	norm.bg_color = bg_col
	norm.corner_radius_top_left = radius; norm.corner_radius_top_right = radius
	norm.corner_radius_bottom_left = radius; norm.corner_radius_bottom_right = radius
	norm.border_width_bottom = depth
	norm.border_color = border_bottom_col
	norm.content_margin_top = pad_y
	norm.content_margin_bottom = pad_y
	norm.content_margin_left = pad_x
	norm.content_margin_right = pad_x
	
	var hov = norm.duplicate()
	hov.bg_color = bg_col.lightened(0.08)
	
	var pres = norm.duplicate()
	pres.border_width_bottom = 0
	pres.content_margin_top = pad_y + depth
	pres.content_margin_bottom = max(0, pad_y - depth)
	
	var dis = norm.duplicate()
	dis.bg_color = Color8(35, 45, 60, 200)
	dis.border_color = Color8(20, 25, 35, 200)
	
	return {"normal": norm, "hover": hov, "pressed": pres, "disabled": dis, "focus": norm}

func apply_3d_style_to_button(btn: Button, bg_col: Color, border_bottom_col: Color = Color.TRANSPARENT, radius: int = 14, depth: int = 4, pad_x: int = 20, pad_y: int = 10):
	var styles = create_3d_button_style(bg_col, border_bottom_col, radius, depth, pad_x, pad_y)
	btn.add_theme_stylebox_override("normal", styles["normal"])
	btn.add_theme_stylebox_override("hover", styles["hover"])
	btn.add_theme_stylebox_override("pressed", styles["pressed"])
	btn.add_theme_stylebox_override("focus", styles["focus"])
	btn.add_theme_stylebox_override("disabled", styles["disabled"])

func _ready():
	Engine.time_scale = 1.0 
	print("READY IS RUNNING")
	
	# Load progression
	Global.load_progression()
	
	# Initialize Google Play Billing
	if Engine.has_singleton("GodotGooglePlayBilling"):
		billing = BillingClient.new()
		add_child(billing)
		
		# Connect signals
		billing.connected.connect(_on_billing_connected)
		billing.disconnected.connect(_on_billing_disconnected)
		billing.connect_error.connect(_on_billing_connect_error)
		billing.on_purchase_updated.connect(_on_billing_purchases_updated_dict)
		billing.acknowledge_purchase_response.connect(_on_billing_acknowledge_purchase_response)
		billing.query_purchases_response.connect(_on_billing_query_purchases_response)
		billing.query_product_details_response.connect(_on_billing_query_product_details_response)
		
		# Start connection
		billing.start_connection()
	
	# Initialize or retrieve AdMob singleton node safely
	var admob_node = Global.init_admob()
	
	if admob_node:
		var sig_map = {
			"rewarded_ad_user_earned_reward": "_on_rewarded_video_earned",
			"rewarded_ad_loaded": "_on_rewarded_ad_loaded",
			"rewarded_ad_dismissed_full_screen_content": "_on_rewarded_dismissed",
			"rewarded_ad_failed_to_show_full_screen_content": "_on_rewarded_failed_to_show",
			"rewarded_ad_failed_to_load": "_on_rewarded_failed_to_load",
			"banner_ad_loaded": "_on_banner_loaded",
			"banner_ad_failed_to_load": "_on_banner_failed_to_load",
			"initialization_completed": "_on_admob_initialized"
		}
		for sig in sig_map:
			var method = sig_map[sig]
			if admob_node.has_signal(sig):
				for conn in admob_node.get_signal_connection_list(sig):
					var target = conn.get("callable", null)
					if target and not is_instance_valid(target.get_object()):
						admob_node.disconnect(sig, target)
				if not admob_node.is_connected(sig, Callable(self, method)):
					admob_node.connect(sig, Callable(self, method))
		
		_request_rewarded_ad()
		Global.preload_interstitial_ad()
		if not Global.is_premium:
			_ensure_menu_top_banner()
	_update_shop_notification()

	if is_instance_valid(Global.bg_music_player) and not Global.bg_music_player.playing:
		Global.bg_music_player.play()
	Global.load_stats()  # Load persisted match history from disk
	# Pre-load badge overlay textures so draw_ball_preview doesn't block per frame
	badge_textures = {
		"FB": load("res://fb1.png"),
		"FEN": load("res://fb1.png"),
		"TS": load("res://ts1.png"),
		"TRA": load("res://ts1.png"),
		"GS": load("res://gs1.png"),
		"GAL": load("res://gs1.png"),
		"BJK": load("res://bjk1.png"),
		"BAR": load("res://bar1.png"),
		"RMA": load("res://rma1.png"),
		"ATM": load("res://atm1.png"),
		"JUV": load("res://juv1.png"),
		"INT": load("res://int1.png"),
		"MIL": load("res://mil1.png"),
		"NAP": load("res://nap1.png"),
		"TOR": load("res://tor1.png"),
		"MC": load("res://mc1.png"),
		"MCI": load("res://mc1.png"),
		"MUN": load("res://mun1.png"),
		"CHE": load("res://che1.png"),
		"ARS": load("res://ars1.png"),
		"LIV": load("res://liv1.png"),
		"TUR": load("res://tur1.png"),
		"ARG": load("res://arg1.png"),
		"POR": load("res://por1.png")
	}
	
	var bg = TextureRect.new()
	bg_grad = Gradient.new()
	var grad_tex = GradientTexture2D.new()
	grad_tex.gradient = bg_grad
	grad_tex.fill_from = Vector2(0, 0)
	grad_tex.fill_to = Vector2(0, 1)
	grad_tex.width = 64 
	grad_tex.height = 64
	bg.texture = grad_tex
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	
	active_theme = Global.THEMES.get(Global.current_theme, Global.THEMES["Turkuaz"])
	bg_grad.set_color(0, active_theme.bg_top)
	bg_grad.set_color(1, active_theme.bg_bottom)
	
	await get_tree().process_frame
	# --- TAB CONTAINER SYSTEM ---
	# A clipping Control that holds 3 side-by-side pages
	tab_container = Control.new()
	tab_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	tab_container.clip_contents = true
	add_child(tab_container)

	# Horizontal strip of 3 pages, each screen-width wide
	tabs_hbox = HBoxContainer.new()
	tabs_hbox.add_theme_constant_override("separation", 0)
	tabs_hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tabs_hbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	tab_container.add_child(tabs_hbox)
	# We'll size tabs_hbox after viewport is known (call_deferred)
	call_deferred("_init_tab_sizes")

	# --- PAGE 0: STATS TAB (Lazy Loaded) ---
	var stats_placeholder = Control.new()
	stats_placeholder.name = "Stats_Placeholder"
	stats_placeholder.custom_minimum_size.x = get_viewport_rect().size.x
	stats_placeholder.size_flags_vertical = Control.SIZE_EXPAND_FILL
	tabs_hbox.add_child(stats_placeholder)

	# --- PAGE 1: HOME TAB (existing main menu UI) ---
	var main_margin = MarginContainer.new()
	main_margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	main_margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main_margin.size_flags_vertical = Control.SIZE_EXPAND_FILL
	main_margin.add_theme_constant_override("margin_top", 145)
	main_margin.add_theme_constant_override("margin_bottom", 95)
	main_margin.add_theme_constant_override("margin_left", 20)
	main_margin.add_theme_constant_override("margin_right", 20)
	tabs_hbox.add_child(main_margin)

	var main_vbox = VBoxContainer.new()
	main_vbox.alignment = BoxContainer.ALIGNMENT_BEGIN
	main_vbox.add_theme_constant_override("separation", 10)
	main_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main_vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	main_margin.add_child(main_vbox)

	# --- ÜST BAR (Dil Butonu & Menü Butonu & Başlık) ---
	var top_hbox = HBoxContainer.new()
	top_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	top_hbox.custom_minimum_size = Vector2(660, 60)
	main_vbox.add_child(top_hbox)
	
	var lang_box = HBoxContainer.new()
	lang_box.alignment = BoxContainer.ALIGNMENT_BEGIN
	lang_box.custom_minimum_size = Vector2(125, 60)
	top_hbox.add_child(lang_box)
	
	# --- DİL SEÇİMİ (Modern Cam Kapsül Buton [ 🌐 TR ]) ---
	var lang_pill_style = StyleBoxFlat.new()
	lang_pill_style.bg_color = active_theme.bg_bottom.darkened(0.2)
	lang_pill_style.corner_radius_top_left = 16; lang_pill_style.corner_radius_top_right = 16
	lang_pill_style.corner_radius_bottom_left = 16; lang_pill_style.corner_radius_bottom_right = 16
	lang_pill_style.border_width_left = 1.5; lang_pill_style.border_width_right = 1.5
	lang_pill_style.border_width_top = 1.5; lang_pill_style.border_width_bottom = 3.5
	lang_pill_style.border_color = active_theme.accent
	lang_pill_style.shadow_color = Color8(0, 0, 0, 100)
	lang_pill_style.shadow_size = 6
	lang_pill_style.content_margin_left = 14; lang_pill_style.content_margin_right = 16
	lang_pill_style.content_margin_top = 8; lang_pill_style.content_margin_bottom = 8
	
	var lang_pill_hover = lang_pill_style.duplicate()
	lang_pill_hover.bg_color = active_theme.bg_bottom.darkened(0.1)
	lang_pill_hover.border_color = active_theme.accent.lightened(0.2)
	
	var lang_pill_pressed = lang_pill_style.duplicate()
	lang_pill_pressed.border_width_bottom = 1.5
	lang_pill_pressed.content_margin_top = 10
	
	lang_btn = Button.new()
	var lang_icon = preload("res://languageicon.svg")
	lang_btn.icon = lang_icon
	lang_btn.text = " " + Global.current_lang
	lang_btn.add_theme_font_override("font", custom_font)
	lang_btn.add_theme_font_size_override("font_size", 30)
	lang_btn.add_theme_color_override("font_color", Color.WHITE)
	lang_btn.add_theme_color_override("font_shadow_color", Color8(0, 0, 0, 150))
	lang_btn.add_theme_constant_override("shadow_offset_y", 1)
	lang_btn.expand_icon = true
	lang_btn.add_theme_constant_override("icon_max_width", 30)
	lang_btn.add_theme_constant_override("h_separation", 10)
	lang_btn.custom_minimum_size = Vector2(120, 56)
	lang_btn.add_theme_stylebox_override("normal", lang_pill_style)
	lang_btn.add_theme_stylebox_override("hover", lang_pill_hover)
	lang_btn.add_theme_stylebox_override("pressed", lang_pill_pressed)
	lang_btn.add_theme_stylebox_override("focus", lang_pill_style)
	lang_box.add_child(lang_btn)
	
	ui_labels.append({"node": lang_btn, "key": "LANG_BTN", "type": "button_lang"})
	
	var lang_popup = PopupMenu.new()
	lang_popup.add_theme_font_override("font", custom_font)
	lang_popup.add_theme_font_size_override("font_size", 30)
	var popup_style = StyleBoxFlat.new()
	popup_style.bg_color = Color8(12, 22, 38, 248)
	popup_style.corner_radius_top_left = 12; popup_style.corner_radius_top_right = 12
	popup_style.corner_radius_bottom_left = 12; popup_style.corner_radius_bottom_right = 12
	popup_style.border_width_left = 1.5; popup_style.border_width_right = 1.5
	popup_style.border_width_top = 1.5; popup_style.border_width_bottom = 3.0
	popup_style.border_color = active_theme.accent
	popup_style.content_margin_left = 14; popup_style.content_margin_right = 14
	popup_style.content_margin_top = 8; popup_style.content_margin_bottom = 8
	lang_popup.add_theme_stylebox_override("panel", popup_style)
	var lang_hover = StyleBoxFlat.new()
	lang_hover.bg_color = active_theme.accent
	lang_hover.corner_radius_top_left = 8; lang_hover.corner_radius_top_right = 8
	lang_hover.corner_radius_bottom_left = 8; lang_hover.corner_radius_bottom_right = 8
	lang_hover.content_margin_left = 14; lang_hover.content_margin_right = 14
	lang_hover.content_margin_top = 6; lang_hover.content_margin_bottom = 6
	lang_popup.add_theme_stylebox_override("hover", lang_hover)
	lang_popup.add_theme_color_override("font_hover_color", Color.BLACK)
	lang_popup.add_item(" Türkçe (TR)", 0)
	lang_popup.add_item(" English (ENG)", 1)
	lang_popup.add_item(" Español (ESP)", 2)
	lang_popup.add_item(" Português (POR)", 3)
	lang_popup.add_item(" Italiano (ITA)", 4)
	add_child(lang_popup)
	
	lang_btn.pressed.connect(func():
		lang_popup.position = Vector2(lang_btn.global_position.x, lang_btn.global_position.y + 60)
		lang_popup.popup()
	)
	
	lang_popup.id_pressed.connect(func(id):
		var lang_map = {0: "TR", 1: "ENG", 2: "ESP", 3: "POR", 4: "ITA"}
		_change_language(lang_map.get(id, "TR"))
	)
	
	var spacer1 = Control.new(); spacer1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_hbox.add_child(spacer1)
	
	var title_lbl = create_label_node("TEAM_SELECTION", white, 55)
	title_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_lbl.add_theme_color_override("font_shadow_color", Color8(0,0,0,150))
	title_lbl.add_theme_constant_override("shadow_offset_y", 4)
	top_hbox.add_child(title_lbl)
	
	var spacer2 = Control.new(); spacer2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_hbox.add_child(spacer2)
	
	var burger_box = HBoxContainer.new()
	burger_box.alignment = BoxContainer.ALIGNMENT_END
	burger_box.custom_minimum_size = Vector2(125, 60)
	top_hbox.add_child(burger_box)

	burger_btn = Button.new()
	burger_btn.icon = preload("res://menuburgericon.svg")
	burger_btn.expand_icon = true
	burger_btn.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	burger_btn.add_theme_constant_override("icon_max_width", 32)
	burger_btn.custom_minimum_size = Vector2(60, 56)
	
	var burger_style = StyleBoxFlat.new()
	burger_style.bg_color = active_theme.bg_bottom.darkened(0.2)
	burger_style.corner_radius_top_left = 16; burger_style.corner_radius_top_right = 16
	burger_style.corner_radius_bottom_left = 16; burger_style.corner_radius_bottom_right = 16
	burger_style.border_width_left = 1.5; burger_style.border_width_right = 1.5
	burger_style.border_width_top = 1.5; burger_style.border_width_bottom = 3.5
	burger_style.border_color = active_theme.accent
	burger_style.shadow_color = Color8(0, 0, 0, 100)
	burger_style.shadow_size = 6
	burger_style.content_margin_left = 10; burger_style.content_margin_right = 10
	burger_style.content_margin_top = 6; burger_style.content_margin_bottom = 6
	
	var burger_hover = burger_style.duplicate()
	burger_hover.bg_color = active_theme.bg_bottom.darkened(0.1)
	burger_hover.border_color = active_theme.accent.lightened(0.2)
	
	var burger_pressed = burger_style.duplicate()
	burger_pressed.border_width_bottom = 1.5
	burger_pressed.content_margin_top = 8

	burger_btn.add_theme_stylebox_override("normal", burger_style)
	burger_btn.add_theme_stylebox_override("hover", burger_hover)
	burger_btn.add_theme_stylebox_override("pressed", burger_pressed)
	burger_btn.add_theme_stylebox_override("focus", burger_style)
	burger_btn.pressed.connect(_toggle_burger_menu)
	burger_box.add_child(burger_btn)
	
	var menu_sep = HSeparator.new()
	main_vbox.add_child(menu_sep)
	ui_separators.append(menu_sep)
	
	var list_shifter = MarginContainer.new()
	list_shifter.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	list_shifter.size_flags_vertical = Control.SIZE_EXPAND_FILL
	main_vbox.add_child(list_shifter)
	
	var list_shifter_vbox = VBoxContainer.new()
	list_shifter_vbox.alignment = BoxContainer.ALIGNMENT_BEGIN
	list_shifter_vbox.add_theme_constant_override("separation", 14)
	list_shifter_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	list_shifter_vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	list_shifter.add_child(list_shifter_vbox)
	
	# --- YENI HAVALI LISTE PANELI ---
	var list_panel = PanelContainer.new()
	var lp_style = StyleBoxFlat.new()
	lp_style.bg_color = Color(0,0,0,0)
	list_panel.add_theme_stylebox_override("panel", lp_style)
	list_panel.custom_minimum_size = Vector2(660, 0)
	list_panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	list_shifter_vbox.add_child(list_panel)
	
	var main_cols_hbox = HBoxContainer.new()
	main_cols_hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main_cols_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	main_cols_hbox.add_theme_constant_override("separation", 20)
	list_panel.add_child(main_cols_hbox)
	
	var home_col = VBoxContainer.new()
	home_col.custom_minimum_size = Vector2(320, 0)
	home_col.add_theme_constant_override("separation", 0)
	main_cols_hbox.add_child(home_col)
	
	var away_col = VBoxContainer.new()
	away_col.custom_minimum_size = Vector2(320, 0)
	away_col.add_theme_constant_override("separation", 0)
	main_cols_hbox.add_child(away_col)
	
	# --- BAŞLIKLAR & FILTRELER (Artık Sütunlara Dahil) ---
	var s_top_h = Control.new(); s_top_h.custom_minimum_size = Vector2(0, 10); home_col.add_child(s_top_h)
	var s_top_a = Control.new(); s_top_a.custom_minimum_size = Vector2(0, 10); away_col.add_child(s_top_a)
	
	# Headers with discrete margins
	home_lbl = Label.new()
	home_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	home_lbl.add_theme_color_override("font_shadow_color", Color8(0,0,0,150))
	home_lbl.add_theme_constant_override("shadow_offset_y", 4)
	home_col.add_child(home_lbl)

	away_lbl = Label.new()
	away_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	away_lbl.add_theme_color_override("font_shadow_color", Color8(0,0,0,150))
	away_lbl.add_theme_constant_override("shadow_offset_y", 4)
	away_col.add_child(away_lbl)
	
	# Spacer between HOME and preview
	var s_hp = Control.new(); s_hp.custom_minimum_size = Vector2(0, 24); home_col.add_child(s_hp)
	var s_ap = Control.new(); s_ap.custom_minimum_size = Vector2(0, 24); away_col.add_child(s_ap)
	
	# Preview Containers with discrete margins
	var h_preview_cont = CenterContainer.new()
	h_preview_cont.custom_minimum_size = Vector2(320, 110)
	home_col.add_child(h_preview_cont)
	home_preview = Control.new()
	home_preview.custom_minimum_size = Vector2(108, 108)
	home_preview.draw.connect(func(): draw_ball_preview(home_preview, true))
	h_preview_cont.add_child(home_preview)
	
	var a_preview_cont = CenterContainer.new()
	a_preview_cont.custom_minimum_size = Vector2(320, 110)
	away_col.add_child(a_preview_cont)
	away_preview = Control.new()
	away_preview.custom_minimum_size = Vector2(108, 108)
	away_preview.draw.connect(func(): draw_ball_preview(away_preview, false))
	a_preview_cont.add_child(away_preview)
	
	var s_hf_btn = Control.new(); s_hf_btn.custom_minimum_size = Vector2(0, 18); home_col.add_child(s_hf_btn)
	fav_h_btn = Button.new()
	fav_h_btn.custom_minimum_size = Vector2(250, 48)
	fav_h_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	fav_h_btn.add_theme_font_override("font", custom_font)
	fav_h_btn.add_theme_font_size_override("font_size", 24)
	var fav_style = StyleBoxEmpty.new()
	fav_h_btn.add_theme_stylebox_override("normal", fav_style)
	fav_h_btn.add_theme_stylebox_override("hover", fav_style)
	fav_h_btn.add_theme_stylebox_override("pressed", fav_style)
	fav_h_btn.add_theme_stylebox_override("disabled", fav_style)
	fav_h_btn.add_theme_stylebox_override("focus", fav_style)
	fav_h_btn.pressed.connect(func(): _set_favorite_team(true))
	home_col.add_child(fav_h_btn)
	
	var s_af_btn = Control.new(); s_af_btn.custom_minimum_size = Vector2(0, 18); away_col.add_child(s_af_btn)
	fav_a_btn = Button.new()
	fav_a_btn.custom_minimum_size = Vector2(250, 48)
	fav_a_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	fav_a_btn.add_theme_font_override("font", custom_font)
	fav_a_btn.add_theme_font_size_override("font_size", 24)
	fav_a_btn.add_theme_stylebox_override("normal", fav_style)
	fav_a_btn.add_theme_stylebox_override("hover", fav_style)
	fav_a_btn.add_theme_stylebox_override("pressed", fav_style)
	fav_a_btn.add_theme_stylebox_override("disabled", fav_style)
	fav_a_btn.add_theme_stylebox_override("focus", fav_style)
	fav_a_btn.pressed.connect(func(): _set_favorite_team(false))
	away_col.add_child(fav_a_btn)

	# Gap between balls and filters
	var s_hf2 = Control.new(); s_hf2.custom_minimum_size = Vector2(0, 22); home_col.add_child(s_hf2)
	var s_af2 = Control.new(); s_af2.custom_minimum_size = Vector2(0, 22); away_col.add_child(s_af2)
	
	var filter_style = StyleBoxFlat.new()
	filter_style.bg_color = active_theme.bg_bottom
	filter_style.corner_radius_top_left = 12; filter_style.corner_radius_top_right = 12
	filter_style.corner_radius_bottom_left = 12; filter_style.corner_radius_bottom_right = 12
	filter_style.border_width_bottom = 3
	filter_style.border_color = active_theme.accent.darkened(0.5)
	filter_style.content_margin_left = 20; filter_style.content_margin_right = 20
	
	var arrow_empty = ImageTexture.create_from_image(Image.create_empty(1, 1, false, Image.FORMAT_RGBA8))
	
	league_dropdown_home = OptionButton.new()
	league_dropdown_home.custom_minimum_size = Vector2(320, 60)
	league_dropdown_home.alignment = HORIZONTAL_ALIGNMENT_CENTER
	league_dropdown_home.add_theme_font_override("font", custom_font)
	league_dropdown_home.add_theme_font_size_override("font_size", 32)
	league_dropdown_home.add_theme_stylebox_override("normal", filter_style)
	league_dropdown_home.add_theme_stylebox_override("hover", filter_style)
	league_dropdown_home.add_theme_stylebox_override("pressed", filter_style)
	league_dropdown_home.add_theme_icon_override("arrow", arrow_empty)
	home_col.add_child(league_dropdown_home)
	league_dropdown_home.item_selected.connect(_on_filter_changed)
	
	league_dropdown_away = OptionButton.new()
	league_dropdown_away.custom_minimum_size = Vector2(320, 60)
	league_dropdown_away.alignment = HORIZONTAL_ALIGNMENT_CENTER
	league_dropdown_away.add_theme_font_override("font", custom_font)
	league_dropdown_away.add_theme_font_size_override("font_size", 32)
	league_dropdown_away.add_theme_stylebox_override("normal", filter_style)
	league_dropdown_away.add_theme_stylebox_override("hover", filter_style)
	league_dropdown_away.add_theme_stylebox_override("pressed", filter_style)
	league_dropdown_away.add_theme_icon_override("arrow", arrow_empty)
	away_col.add_child(league_dropdown_away)
	league_dropdown_away.item_selected.connect(_on_filter_changed)
	
	# Gap between league dropdown and search bar
	var s_gap_h = Control.new(); s_gap_h.custom_minimum_size = Vector2(0, 14); home_col.add_child(s_gap_h)
	var s_gap_a = Control.new(); s_gap_a.custom_minimum_size = Vector2(0, 14); away_col.add_child(s_gap_a)
	
	search_bar_home = LineEdit.new()
	search_bar_home.custom_minimum_size = Vector2(320, 60)
	search_bar_home.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	search_bar_home.alignment = HORIZONTAL_ALIGNMENT_CENTER
	search_bar_home.clear_button_enabled = true
	search_bar_home.add_theme_font_override("font", custom_font)
	search_bar_home.add_theme_font_size_override("font_size", 32)
	search_bar_home.add_theme_stylebox_override("normal", filter_style)
	search_bar_home.add_theme_stylebox_override("focus", filter_style)
	search_bar_home.text_changed.connect(_on_filter_changed)
	ui_labels.append({"node": search_bar_home, "key": "SEARCH", "type": "placeholder"})
	home_col.add_child(search_bar_home)
	
	search_bar_away = LineEdit.new()
	search_bar_away.custom_minimum_size = Vector2(320, 60)
	search_bar_away.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	search_bar_away.alignment = HORIZONTAL_ALIGNMENT_CENTER
	search_bar_away.clear_button_enabled = true
	search_bar_away.add_theme_font_override("font", custom_font)
	search_bar_away.add_theme_font_size_override("font_size", 32)
	search_bar_away.add_theme_stylebox_override("normal", filter_style)
	search_bar_away.add_theme_stylebox_override("focus", filter_style)
	search_bar_away.text_changed.connect(_on_filter_changed)
	ui_labels.append({"node": search_bar_away, "key": "SEARCH", "type": "placeholder"})
	away_col.add_child(search_bar_away)
	
	setup_filters()
	
	# Spacer between Search and Randomizer
	var s_gap_rand_h = Control.new(); s_gap_rand_h.custom_minimum_size = Vector2(0, 16); home_col.add_child(s_gap_rand_h)
	var s_gap_rand_a = Control.new(); s_gap_rand_a.custom_minimum_size = Vector2(0, 16); away_col.add_child(s_gap_rand_a)

	# Random buttons with discrete margins and 3D tactile feedback
	var rand_style = StyleBoxFlat.new()
	rand_style.bg_color = Color8(10, 18, 32, 230)
	rand_style.corner_radius_top_left = 12; rand_style.corner_radius_top_right = 12
	rand_style.corner_radius_bottom_left = 12; rand_style.corner_radius_bottom_right = 12
	rand_style.border_width_bottom = 3
	rand_style.border_color = active_theme.accent
	rand_style.shadow_color = Color8(0, 0, 0, 150)
	rand_style.shadow_size = 6
	rand_style.shadow_offset = Vector2(0, 4)
	rand_style.content_margin_top = 4
	rand_style.content_margin_bottom = 4

	var rand_hover = rand_style.duplicate()
	rand_hover.bg_color = Color8(18, 30, 52, 240)
	rand_hover.border_color = active_theme.accent.lightened(0.2)

	var rand_pressed = rand_style.duplicate()
	rand_pressed.border_width_bottom = 0
	rand_pressed.content_margin_top = 7
	rand_pressed.content_margin_bottom = 1
	rand_pressed.shadow_offset = Vector2(0, 1)
	rand_pressed.shadow_size = 2

	rand_h_btn = Button.new()
	rand_h_btn.text = LANG[Global.current_lang]["RANDOM"]
	rand_h_btn.custom_minimum_size = Vector2(320, 60)
	rand_h_btn.add_theme_font_override("font", custom_font)
	rand_h_btn.add_theme_font_size_override("font_size", 32)
	rand_h_btn.add_theme_stylebox_override("normal", rand_style)
	rand_h_btn.add_theme_stylebox_override("hover", rand_hover)
	rand_h_btn.add_theme_stylebox_override("pressed", rand_pressed)
	rand_h_btn.add_theme_stylebox_override("focus", rand_style)
	rand_h_btn.add_theme_color_override("font_color", Color.WHITE)
	rand_h_btn.add_theme_color_override("font_hover_color", Color.WHITE)
	rand_h_btn.add_theme_color_override("font_pressed_color", Color.WHITE)
	rand_h_btn.add_theme_color_override("font_shadow_color", Color8(0, 0, 0, 150))
	rand_h_btn.add_theme_color_override("font_hover_shadow_color", Color8(0, 0, 0, 150))
	rand_h_btn.add_theme_color_override("font_pressed_shadow_color", Color8(0, 0, 0, 150))
	rand_h_btn.add_theme_color_override("font_focus_shadow_color", Color8(0, 0, 0, 150))
	rand_h_btn.add_theme_constant_override("shadow_offset_y", 4)
	rand_h_btn.pressed.connect(func(): _on_random_team_pressed(true))
	home_col.add_child(rand_h_btn)
	ui_labels.append({"node": rand_h_btn, "key": "RANDOM", "type": "button"})
	
	rand_a_btn = Button.new()
	rand_a_btn.text = LANG[Global.current_lang]["RANDOM"]
	rand_a_btn.custom_minimum_size = Vector2(320, 60)
	rand_a_btn.add_theme_font_override("font", custom_font)
	rand_a_btn.add_theme_font_size_override("font_size", 32)
	rand_a_btn.add_theme_stylebox_override("normal", rand_style)
	rand_a_btn.add_theme_stylebox_override("hover", rand_hover)
	rand_a_btn.add_theme_stylebox_override("pressed", rand_pressed)
	rand_a_btn.add_theme_stylebox_override("focus", rand_style)
	rand_a_btn.add_theme_color_override("font_color", Color.WHITE)
	rand_a_btn.add_theme_color_override("font_hover_color", Color.WHITE)
	rand_a_btn.add_theme_color_override("font_pressed_color", Color.WHITE)
	rand_a_btn.add_theme_color_override("font_shadow_color", Color8(0, 0, 0, 150))
	rand_a_btn.add_theme_color_override("font_hover_shadow_color", Color8(0, 0, 0, 150))
	rand_a_btn.add_theme_color_override("font_pressed_shadow_color", Color8(0, 0, 0, 150))
	rand_a_btn.add_theme_color_override("font_focus_shadow_color", Color8(0, 0, 0, 150))
	rand_a_btn.add_theme_constant_override("shadow_offset_y", 4)
	rand_a_btn.pressed.connect(func(): _on_random_team_pressed(false))
	away_col.add_child(rand_a_btn)
	ui_labels.append({"node": rand_a_btn, "key": "RANDOM", "type": "button"})
	
	var scroll_both = ScrollContainer.new()
	scroll_both.name = "ScrollContainer"
	scroll_both.custom_minimum_size = Vector2(660, 580)
	scroll_both.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	scroll_both.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	scroll_both.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll_both.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	var v_sc = scroll_both.get_v_scroll_bar()
	v_sc.custom_minimum_size.x = 0
	
	var sb_style = StyleBoxFlat.new(); sb_style.bg_color = Color.TRANSPARENT
	var gb_style = StyleBoxFlat.new(); gb_style.bg_color = active_theme.accent.darkened(0.2)
	gb_style.corner_radius_top_left = 8; gb_style.corner_radius_top_right = 8
	gb_style.corner_radius_bottom_left = 8; gb_style.corner_radius_bottom_right = 8
	v_sc.add_theme_stylebox_override("scroll", sb_style)
	v_sc.add_theme_stylebox_override("grabber", gb_style)
	v_sc.add_theme_stylebox_override("grabber_highlight", gb_style)
	v_sc.add_theme_stylebox_override("grabber_pressed", gb_style)
	
	list_shifter_vbox.add_child(scroll_both)
	main_scroll = scroll_both
	
	var lists_hbox = HBoxContainer.new()
	lists_hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lists_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	lists_hbox.add_theme_constant_override("separation", 20) # Match header columns gap
	scroll_both.add_child(lists_hbox)
	
	home_list = VBoxContainer.new()
	home_list.mouse_filter = Control.MOUSE_FILTER_PASS
	home_list.custom_minimum_size = Vector2(320, 0)
	home_list.add_theme_constant_override("separation", 8)
	lists_hbox.add_child(home_list)
	
	away_list = VBoxContainer.new()
	away_list.mouse_filter = Control.MOUSE_FILTER_PASS
	away_list.custom_minimum_size = Vector2(320, 0)
	away_list.add_theme_constant_override("separation", 8)
	lists_hbox.add_child(away_list)
	
	TEAM_NAMES = Global.TEAMS.keys()
	home_selected = Global.home_selected
	away_selected = Global.away_selected
	populate_teams()
	
	# --- BAŞLA BUTONU (3D Tactile Push Sensation) ---
	var start_btn = Button.new()
	start_btn.name = "StartMatchButton"
	start_btn.custom_minimum_size = Vector2(660, 85)
	start_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	
	var start_lbl = Label.new()
	start_lbl.name = "ButtonLabel"
	start_lbl.text = LANG[Global.current_lang]["START_MATCH"]
	start_lbl.add_theme_font_override("font", custom_font)
	start_lbl.add_theme_font_size_override("font_size", 48)
	start_lbl.set_anchors_preset(Control.PRESET_FULL_RECT)
	start_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	start_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	start_lbl.add_theme_color_override("font_shadow_color", Color8(0,0,0,180))
	start_lbl.add_theme_constant_override("shadow_offset_x", 0)
	start_lbl.add_theme_constant_override("shadow_offset_y", 4)
	start_btn.add_child(start_lbl)
	
	apply_3d_style_to_button(start_btn, active_theme.bg_top, active_theme.bg_top.darkened(0.35), 18, 5, 20, 10)
	
	start_btn.pressed.connect(_on_start_match)
	list_shifter_vbox.add_child(start_btn)
	ui_labels.append({"node": start_lbl, "key": "START_MATCH", "type": "label"})
	start_match_btn = start_btn
	
	temp_settings["master_vol"] = Global.master_vol
	temp_settings["vol_settings"] = Global.vol_settings.duplicate()
	temp_settings["shake_enabled"] = Global.shake_enabled
	temp_settings["vibration_enabled"] = Global.vibration_enabled
	temp_settings["match_duration"] = Global.match_duration
	temp_settings["current_theme"] = Global.current_theme
	
	setup_settings_overlay()
	update_theme_visuals()

	# --- PAGE 2: SHOP TAB (Lazy Loaded) ---
	var shop_placeholder = Control.new()
	shop_placeholder.name = "Shop_Placeholder"
	shop_placeholder.custom_minimum_size.x = get_viewport_rect().size.x
	shop_placeholder.size_flags_vertical = Control.SIZE_EXPAND_FILL
	tabs_hbox.add_child(shop_placeholder)

	# --- BOTTOM NAVIGATION BAR ---
	_build_bottom_nav()

	# Start on Home (tab index 1), instantly, no tween
	_switch_tab(1, true)
	
	_setup_admob()
	
	_connect_all_buttons(self)
	
	if Global.login_method == "guest" and Global.matches_played_since_prompt >= 3:
		call_deferred("show_google_play_prompt")

func _connect_all_buttons(node: Node):
	if node is Button:
		node.pressed.connect(Global.play_click)
	for child in node.get_children():
		_connect_all_buttons(child)

func show_google_play_prompt():
	# Dimmed background overlay
	var bg_overlay = ColorRect.new()
	bg_overlay.color = Color8(0, 0, 0, 180)
	bg_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg_overlay)
	
	var dlg = PanelContainer.new()
	var dlg_style = StyleBoxFlat.new()
	dlg_style.bg_color = active_theme.bg_bottom
	dlg_style.corner_radius_top_left = 20; dlg_style.corner_radius_top_right = 20
	dlg_style.corner_radius_bottom_left = 20; dlg_style.corner_radius_bottom_right = 20
	dlg_style.border_width_top = 3; dlg_style.border_width_bottom = 3
	dlg_style.border_width_left = 3; dlg_style.border_width_right = 3
	dlg_style.border_color = active_theme.accent
	dlg_style.shadow_color = Color8(0, 0, 0, 180)
	dlg_style.shadow_size = 30
	dlg_style.content_margin_left = 40; dlg_style.content_margin_right = 40
	dlg_style.content_margin_top = 35; dlg_style.content_margin_bottom = 35
	dlg.add_theme_stylebox_override("panel", dlg_style)
	dlg.custom_minimum_size = Vector2(600, 0)

	var dlg_center = CenterContainer.new()
	dlg_center.set_anchors_preset(Control.PRESET_FULL_RECT)
	dlg_center.add_child(dlg)
	bg_overlay.add_child(dlg_center)

	var dlg_vbox = VBoxContainer.new()
	dlg_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	dlg_vbox.add_theme_constant_override("separation", 25)
	dlg.add_child(dlg_vbox)

	var lang = Global.current_lang
	
	# Translations for prompt:
	var titles = {"TR": "Google Play Bağlantısı", "ENG": "Google Play Connection", "ESP": "Conexión a Google Play", "POR": "Conexão Google Play"}
	var descs = {"TR": "Maç istatistiklerinizi kaydetmek ve liderlik tablolarına katılmak için Google Play hesabınızı bağlamak ister misiniz?",
				 "ENG": "Would you like to connect your Google Play account to save stats and join leaderboards?",
				 "ESP": "¿Te gustaría conectar tu cuenta de Google Play para guardar estadísticas y unirte a las tablas de classificação?",
				 "POR": "Gostaria de ligar a sua conta Google Play para guardar estatísticas e juntar-se às tabelas de classificação?"}
	var yes_texts = {"TR": "BAĞLAN", "ENG": "CONNECT", "ESP": "CONECTAR", "POR": "CONECTAR"}
	var no_texts = {"TR": "DAHA SONRA", "ENG": "LATER", "ESP": "MÁS TARDE", "POR": "MAIS TARDE"}

	var dlg_title = Label.new()
	dlg_title.text = titles.get(lang, titles["TR"])
	dlg_title.add_theme_font_override("font", custom_font)
	dlg_title.add_theme_font_size_override("font_size", 40)
	dlg_title.add_theme_color_override("font_color", active_theme.accent)
	dlg_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	dlg_vbox.add_child(dlg_title)

	var dlg_desc = Label.new()
	dlg_desc.text = descs.get(lang, descs["TR"])
	dlg_desc.add_theme_font_override("font", custom_font)
	dlg_desc.add_theme_font_size_override("font_size", 26)
	dlg_desc.add_theme_color_override("font_color", Color.WHITE)
	dlg_desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	dlg_desc.autowrap_mode = TextServer.AUTOWRAP_WORD
	dlg_vbox.add_child(dlg_desc)

	var dlg_hbox = HBoxContainer.new()
	dlg_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	dlg_hbox.add_theme_constant_override("separation", 20)
	dlg_vbox.add_child(dlg_hbox)

	var cancel_btn = Button.new()
	cancel_btn.text = no_texts.get(lang, no_texts["TR"])
	cancel_btn.add_theme_font_override("font", custom_font)
	cancel_btn.add_theme_font_size_override("font_size", 28)
	var cancel_style = StyleBoxFlat.new()
	cancel_style.bg_color = Color8(60, 60, 80, 220)
	cancel_style.corner_radius_top_left = 12; cancel_style.corner_radius_top_right = 12
	cancel_style.corner_radius_bottom_left = 12; cancel_style.corner_radius_bottom_right = 12
	cancel_btn.add_theme_stylebox_override("normal", cancel_style)
	cancel_btn.add_theme_stylebox_override("hover", cancel_style)
	cancel_btn.add_theme_stylebox_override("pressed", cancel_style)
	cancel_btn.add_theme_stylebox_override("focus", cancel_style)
	cancel_btn.custom_minimum_size = Vector2(200, 65)
	cancel_btn.pressed.connect(func():
		Global.play_click()
		Global.matches_played_since_prompt = 0
		Global.save_progression()
		bg_overlay.queue_free()
	)
	dlg_hbox.add_child(cancel_btn)

	var confirm_btn = Button.new()
	confirm_btn.text = yes_texts.get(lang, yes_texts["TR"])
	confirm_btn.add_theme_font_override("font", custom_font)
	confirm_btn.add_theme_font_size_override("font_size", 28)
	confirm_btn.add_theme_color_override("font_color", Color.WHITE)
	var confirm_style = StyleBoxFlat.new()
	confirm_style.bg_color = active_theme.accent
	confirm_style.corner_radius_top_left = 12; confirm_style.corner_radius_top_right = 12
	confirm_style.corner_radius_bottom_left = 12; confirm_style.corner_radius_bottom_right = 12
	confirm_btn.add_theme_stylebox_override("normal", confirm_style)
	confirm_btn.add_theme_stylebox_override("hover", confirm_style)
	confirm_btn.add_theme_stylebox_override("pressed", confirm_style)
	confirm_btn.add_theme_stylebox_override("focus", confirm_style)
	confirm_btn.custom_minimum_size = Vector2(200, 65)
	confirm_btn.pressed.connect(func():
		Global.play_click()
		# Reset counter and go to login
		Global.matches_played_since_prompt = 0
		Global.save_progression()
		bg_overlay.queue_free()
		# Go to welcome screen and auto-login
		Global.login_method = "google" # set this to force auto-login on welcome screen
		get_tree().change_scene_to_file("res://welcome_screen.tscn")
	)
	dlg_hbox.add_child(confirm_btn)

# ======================================================
# GOOGLE PLAY BILLING CALLBACKS
# ======================================================
func _on_billing_connected():
	print("Billing connected!")
	if billing:
		billing.query_product_details(PackedStringArray(["premium_unlock"]), BillingClient.ProductType.INAPP)
		billing.query_purchases(BillingClient.ProductType.INAPP)

func _on_billing_query_product_details_response(response: Dictionary):
	print("Billing query product details response: ", response)
	var response_code = response.get("response_code", -1)
	if response_code == 0:
		var product_details = response.get("product_details", [])
		print("Found product details: ", product_details)
		for p in product_details:
			var p_id = p.get("productId", p.get("product_id", ""))
			if p_id == "premium_unlock":
				var price_str = ""
				if p.has("formattedPrice"):
					price_str = str(p.get("formattedPrice"))
				elif p.has("formatted_price"):
					price_str = str(p.get("formatted_price"))
				elif p.has("oneTimePurchaseOfferDetails"):
					var ot = p.get("oneTimePurchaseOfferDetails")
					if ot is Dictionary:
						price_str = str(ot.get("formattedPrice", ot.get("formatted_price", "")))
				elif p.has("one_time_purchase_offer_details"):
					var ot = p.get("one_time_purchase_offer_details")
					if ot is Dictionary:
						price_str = str(ot.get("formattedPrice", ot.get("formatted_price", "")))
				
				if price_str != "":
					Global.premium_price_formatted = price_str
					print("[Billing] Loaded dynamic regional price: ", price_str)
					_refresh_shop_tab()
	else:
		print("Product details query returned code: ", response_code, " msg: ", response.get("debug_message", ""))

func _on_billing_disconnected():
	print("Billing disconnected.")

func _on_billing_connect_error(response_code, debug_message):
	print("Billing connect error: ", response_code, " msg: ", debug_message)

func _on_billing_purchases_updated_dict(response: Dictionary):
	print("Billing purchases updated dict: ", response)
	var response_code = response.get("response_code", -1)
	if response_code == 0: # OK
		if response.has("purchases"):
			_on_billing_purchases_updated(response.purchases)
	else:
		_on_billing_purchase_error(response_code, response.get("debug_message", ""))

func _on_billing_purchases_updated(purchases):
	print("Billing purchases updated: ", purchases)
	for purchase in purchases:
		var product_id = ""
		if purchase.has("sku"):
			product_id = purchase.sku
		elif purchase.has("products") and purchase.products is Array and purchase.products.size() > 0:
			product_id = purchase.products[0]
			
		if product_id == "premium_unlock":
			if purchase.purchase_state == 1: # PURCHASED = 1
				if not purchase.is_acknowledged:
					billing.acknowledge_purchase(purchase.purchase_token)
				else:
					Global.is_premium = true
					Global.save_progression()
					_refresh_shop_tab()

func _on_billing_query_purchases_response(query_result):
	var response_code = query_result.get("response_code", -1)
	if response_code == 0 and query_result.has("purchases"): # OK
		_on_billing_purchases_updated(query_result.purchases)

func _on_billing_purchase_acknowledged(purchase_token):
	print("Billing purchase acknowledged! Token: ", purchase_token)
	Global.is_premium = true
	Global.save_progression()
	_refresh_shop_tab()
	_show_toast(LANG.get(Global.current_lang, LANG["ENG"]).get("PRO_ACTIVE", "PRO AKTİF!"))

func _on_billing_acknowledge_purchase_response(response: Dictionary):
	var response_code = response.get("response_code", -1)
	if response_code == 0: # OK
		var purchase_token = response.get("purchase_token", "")
		_on_billing_purchase_acknowledged(purchase_token)
	else:
		_on_billing_purchase_acknowledgement_error(response_code, response.get("debug_message", ""))

func _on_billing_purchase_acknowledgement_error(response_code, debug_message):
	print("Billing acknowledgement error: ", response_code, " msg: ", debug_message)

func _on_billing_purchase_error(response_code, debug_message):
	print("Billing purchase error: ", response_code, " msg: ", debug_message)

func update_theme_visuals():
	active_theme = Global.THEMES.get(Global.current_theme, Global.THEMES["Turkuaz"])
	bg_grad.set_color(0, active_theme.bg_top)
	bg_grad.set_color(1, active_theme.bg_bottom)
	
	if is_instance_valid(lang_btn):
		var lp_style = lang_btn.get_theme_stylebox("normal")
		if lp_style is StyleBoxFlat:
			lp_style.bg_color = active_theme.bg_bottom.darkened(0.2)
			lp_style.border_color = active_theme.accent
			lang_btn.add_theme_stylebox_override("normal", lp_style)
			lang_btn.add_theme_stylebox_override("focus", lp_style)

	if is_instance_valid(burger_btn):
		var b_btn_style = burger_btn.get_theme_stylebox("normal")
		if b_btn_style is StyleBoxFlat:
			b_btn_style.bg_color = active_theme.bg_bottom.darkened(0.2)
			b_btn_style.border_color = active_theme.accent
			burger_btn.add_theme_stylebox_override("normal", b_btn_style)
			burger_btn.add_theme_stylebox_override("focus", b_btn_style)
		var b_hover = burger_btn.get_theme_stylebox("hover")
		if b_hover is StyleBoxFlat:
			b_hover.bg_color = active_theme.bg_bottom.darkened(0.1)
			b_hover.border_color = active_theme.accent.lightened(0.2)
			burger_btn.add_theme_stylebox_override("hover", b_hover)
		var b_pressed = burger_btn.get_theme_stylebox("pressed")
		if b_pressed is StyleBoxFlat:
			b_pressed.bg_color = active_theme.bg_bottom.darkened(0.2)
			b_pressed.border_color = active_theme.accent
			burger_btn.add_theme_stylebox_override("pressed", b_pressed)

	if is_instance_valid(burger_menu_overlay):
		burger_menu_overlay.queue_free()
		burger_menu_overlay = null

	if is_instance_valid(nav_bar_panel):
		var nb_style = nav_bar_panel.get_theme_stylebox("panel")
		if nb_style is StyleBoxFlat:
			nb_style.bg_color = active_theme.bg_top
			nb_style.bg_color.a = 0.97
			nb_style.border_color = active_theme.accent.darkened(0.4)
			nav_bar_panel.add_theme_stylebox_override("panel", nb_style)
	# Refresh indicator colors
	for btn_data in nav_bar_btns:
		var ind: Control = btn_data["indicator"]
		ind.queue_redraw()

	var filter_style = StyleBoxFlat.new()
	filter_style.bg_color = active_theme.bg_bottom
	filter_style.corner_radius_top_left = 12; filter_style.corner_radius_top_right = 12
	filter_style.corner_radius_bottom_left = 12; filter_style.corner_radius_bottom_right = 12
	filter_style.border_width_bottom = 3
	filter_style.border_color = active_theme.accent.darkened(0.5)
	filter_style.content_margin_left = 20; filter_style.content_margin_right = 20
	
	if league_dropdown_home:
		league_dropdown_home.add_theme_stylebox_override("normal", filter_style)
		league_dropdown_home.add_theme_stylebox_override("hover", filter_style)
		league_dropdown_home.add_theme_stylebox_override("pressed", filter_style)
		league_dropdown_home.add_theme_stylebox_override("focus", filter_style)
	if league_dropdown_away:
		league_dropdown_away.add_theme_stylebox_override("normal", filter_style)
		league_dropdown_away.add_theme_stylebox_override("hover", filter_style)
		league_dropdown_away.add_theme_stylebox_override("pressed", filter_style)
		league_dropdown_away.add_theme_stylebox_override("focus", filter_style)
	if search_bar_home:
		search_bar_home.add_theme_stylebox_override("normal", filter_style)
		search_bar_home.add_theme_stylebox_override("focus", filter_style)
	if search_bar_away:
		search_bar_away.add_theme_stylebox_override("normal", filter_style)
		search_bar_away.add_theme_stylebox_override("focus", filter_style)
	
	if is_instance_valid(start_match_btn):
		apply_3d_style_to_button(start_match_btn, active_theme.bg_top, active_theme.bg_top.darkened(0.35), 20, 6, 20, 12)
		var btn_lbl = start_match_btn.get_node_or_null("ButtonLabel")
		if btn_lbl:
			var btn_bg = active_theme.bg_top
			var lum = 0.299 * btn_bg.r + 0.587 * btn_bg.g + 0.114 * btn_bg.b
			if lum > 0.65 or Global.current_theme == "Buz":
				btn_lbl.add_theme_color_override("font_color", Color8(15, 25, 35))
				btn_lbl.add_theme_color_override("font_shadow_color", Color(1, 1, 1, 0.4))
				btn_lbl.add_theme_constant_override("shadow_offset_x", 0)
				btn_lbl.add_theme_constant_override("shadow_offset_y", 2)
			else:
				btn_lbl.add_theme_color_override("font_color", Color.WHITE)
				btn_lbl.add_theme_color_override("font_shadow_color", Color8(0, 0, 0, 160))
				btn_lbl.add_theme_constant_override("shadow_offset_x", 0)
				btn_lbl.add_theme_constant_override("shadow_offset_y", 3)

	if is_instance_valid(rand_h_btn):
		var rh_style = rand_h_btn.get_theme_stylebox("normal")
		if rh_style is StyleBoxFlat:
			rh_style.bg_color = Color8(10, 18, 32, 230)
			rh_style.border_color = active_theme.accent
			rand_h_btn.add_theme_stylebox_override("normal", rh_style)
			rand_h_btn.add_theme_stylebox_override("focus", rh_style)
		var rh_hover = rand_h_btn.get_theme_stylebox("hover")
		if rh_hover is StyleBoxFlat:
			rh_hover.bg_color = Color8(18, 30, 52, 240)
			rh_hover.border_color = active_theme.accent.lightened(0.2)
			rand_h_btn.add_theme_stylebox_override("hover", rh_hover)
		var rh_pressed = rand_h_btn.get_theme_stylebox("pressed")
		if rh_pressed is StyleBoxFlat:
			rh_pressed.border_color = active_theme.accent
			rand_h_btn.add_theme_stylebox_override("pressed", rh_pressed)
			
	if is_instance_valid(rand_a_btn):
		var ra_style = rand_a_btn.get_theme_stylebox("normal")
		if ra_style is StyleBoxFlat:
			ra_style.bg_color = Color8(10, 18, 32, 230)
			ra_style.border_color = active_theme.accent
			rand_a_btn.add_theme_stylebox_override("normal", ra_style)
			rand_a_btn.add_theme_stylebox_override("focus", ra_style)
		var ra_hover = rand_a_btn.get_theme_stylebox("hover")
		if ra_hover is StyleBoxFlat:
			ra_hover.bg_color = Color8(18, 30, 52, 240)
			ra_hover.border_color = active_theme.accent.lightened(0.2)
			rand_a_btn.add_theme_stylebox_override("hover", ra_hover)
		var ra_pressed = rand_a_btn.get_theme_stylebox("pressed")
		if ra_pressed is StyleBoxFlat:
			ra_pressed.border_color = active_theme.accent
			rand_a_btn.add_theme_stylebox_override("pressed", ra_pressed)

	# Buz (light blue) theme: force dark text on background elements, remove outline
	var buz_active = (Global.current_theme == "Buz")
	var buz_text_color = Color.BLACK
	
	# Update separators
	var sep_style = StyleBoxLine.new()
	sep_style.color = active_theme.bg_bottom
	sep_style.thickness = 3
	for sep in ui_separators:
		if is_instance_valid(sep):
			sep.add_theme_stylebox_override("separator", sep_style)

	# Update stats panel accents if they exist
	for node in get_tree().get_nodes_in_group("ThemeStatValueNodes"):
		node.add_theme_color_override("font_color", active_theme.accent)
		node.add_theme_color_override("font_shadow_color", active_theme.accent.darkened(0.5))

	for entry in ui_labels:
		if not is_instance_valid(entry["node"]): continue
		var t = entry.get("type", "label")
		var on_bg = entry.get("on_bg", false)
		# Update language text
		var lang = Global.current_lang
		if t == "button_lang" and entry["node"] is Button:
			entry["node"].text = " " + Global.current_lang
		elif t == "currency_val" and entry["node"] is Label:
			entry["node"].text = str(Global.ad_credits)
		elif t == "currency" and entry["node"] is Label:
			entry["node"].text = str(Global.ad_credits) + " " + LANG[lang]["CURRENCY"]
		elif t == "button_buy_premium" and entry["node"] is Button:
			if Global.is_premium:
				entry["node"].text = " " + LANG[lang].get("PRO_ACTIVE", "PRO AKTİF")
			else:
				var price_str = Global.get_formatted_premium_price()
				if lang == "TR":
					entry["node"].text = price_str + " — SATIN AL"
				elif lang == "ESP" or lang == "POR":
					entry["node"].text = price_str + " — COMPRAR"
				else:
					entry["node"].text = price_str + " — BUY NOW"
		elif LANG[lang].has(entry["key"]):
			var txt = LANG[lang][entry["key"]]
			if t == "label" and entry["node"] is Label:
				entry["node"].text = txt.replace("I", "I")
			elif t == "label_upper" and entry["node"] is Label:
				entry["node"].text = txt.to_upper().replace("I", "I")
			elif t == "label_team_stats" and entry["node"] is Label:
				entry["node"].text = (txt % Global.favorite_team).to_upper().replace("I", "I")
			elif t == "button" and entry["node"] is Button:
				entry["node"].text = txt.replace("I", "I")
			elif t == "placeholder" and entry["node"] is LineEdit:
				entry["node"].placeholder_text = txt.replace("I", "I")
		# Buz: recolor only labels that are ON the gradient background (on_bg:true)
		# and the lang button, and remove text outline
		if buz_active and (on_bg or t == "button"):
			if entry["node"] is Label:
				entry["node"].add_theme_color_override("font_color", buz_text_color)
				entry["node"].add_theme_constant_override("outline_size", 0)
				entry["node"].remove_theme_color_override("font_shadow_color")
			elif entry["node"] is Button:
				if entry["node"] != start_match_btn:
					entry["node"].add_theme_color_override("font_color", buz_text_color)
					entry["node"].remove_theme_color_override("font_shadow_color")
			elif t == "placeholder" and entry["node"] is LineEdit:
				entry["node"].add_theme_color_override("font_placeholder_color", buz_text_color)
		elif not buz_active and (on_bg or t == "button"):
			if entry["node"] is Label:
				entry["node"].add_theme_color_override("font_color", Color.WHITE)
				entry["node"].remove_theme_constant_override("outline_size")
				# Standard title shadow
				entry["node"].add_theme_color_override("font_shadow_color", Color8(0,0,0,150))
				entry["node"].add_theme_constant_override("shadow_offset_y", 4)
			elif entry["node"] is Button:
				if entry["node"] != start_match_btn:
					entry["node"].add_theme_color_override("font_color", Color.WHITE)
					entry["node"].add_theme_color_override("font_shadow_color", Color8(0,0,0,150))
					entry["node"].add_theme_constant_override("shadow_offset_y", 4)
			elif t == "placeholder" and entry["node"] is LineEdit:
				entry["node"].add_theme_color_override("font_placeholder_color", Color.WHITE)

	if is_instance_valid(main_scroll):
		var v_sc = main_scroll.get_v_scroll_bar()
		var gb_style = v_sc.get_theme_stylebox("grabber")
		if gb_style is StyleBoxFlat:
			gb_style.bg_color = active_theme.accent.darkened(0.2)
			v_sc.add_theme_stylebox_override("grabber", gb_style)
			v_sc.add_theme_stylebox_override("grabber_highlight", gb_style)
			v_sc.add_theme_stylebox_override("grabber_pressed", gb_style)
	
	if league_dropdown_home: style_popup_menu(league_dropdown_home.get_popup())
	if league_dropdown_away: style_popup_menu(league_dropdown_away.get_popup())

	if home_list != null and away_list != null:
		populate_teams()

	ui_labels = ui_labels.filter(func(e): return is_instance_valid(e.get("node")))

	if not is_refreshing_shop:
		is_refreshing_shop = true
		_refresh_shop_tab()
		is_refreshing_shop = false

	if not is_refreshing_stats:
		is_refreshing_stats = true
		_refresh_stats_tab()
		is_refreshing_stats = false

func style_popup_menu(popup: PopupMenu):
	if not popup: return
	var popup_style = StyleBoxFlat.new()
	popup_style.bg_color = active_theme.bg_bottom
	popup_style.corner_radius_top_left = 12
	popup_style.corner_radius_top_right = 12
	popup_style.corner_radius_bottom_left = 12
	popup_style.corner_radius_bottom_right = 12
	popup_style.border_width_left = 3
	popup_style.border_width_right = 3
	popup_style.border_width_top = 3
	popup_style.border_width_bottom = 3
	popup_style.border_color = active_theme.accent
	popup_style.content_margin_left = 15
	popup_style.content_margin_right = 15
	popup_style.content_margin_top = 10
	popup_style.content_margin_bottom = 10

	var hover_style = StyleBoxFlat.new()
	hover_style.bg_color = active_theme.accent
	hover_style.corner_radius_top_left = 8
	hover_style.corner_radius_top_right = 8
	hover_style.corner_radius_bottom_left = 8
	hover_style.corner_radius_bottom_right = 8
	hover_style.content_margin_left = 15
	hover_style.content_margin_right = 15
	hover_style.content_margin_top = 8
	hover_style.content_margin_bottom = 8

	popup.add_theme_stylebox_override("panel", popup_style)
	popup.add_theme_stylebox_override("hover", hover_style)
	popup.add_theme_font_override("font", custom_font)
	popup.add_theme_font_size_override("font_size", 32)
	popup.add_theme_color_override("font_color", Color.WHITE)
	popup.add_theme_color_override("font_hover_color", Color.BLACK)

func _toggle_burger_menu():
	if is_instance_valid(burger_menu_overlay):
		burger_menu_overlay.queue_free()
		burger_menu_overlay = null
		return
		
	Global.play_click()
	var sw = get_viewport_rect().size.x
	var sh = get_viewport_rect().size.y
	
	burger_menu_overlay = Control.new()
	burger_menu_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	burger_menu_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	burger_menu_overlay.gui_input.connect(func(event):
		if event is InputEventMouseButton and event.pressed:
			if is_instance_valid(burger_menu_overlay):
				burger_menu_overlay.queue_free()
				burger_menu_overlay = null
	)
	add_child(burger_menu_overlay)
	
	var pop_panel = PanelContainer.new()
	var pp_style = StyleBoxFlat.new()
	pp_style.bg_color = active_theme.bg_bottom.darkened(0.24)
	pp_style.corner_radius_top_left = 18; pp_style.corner_radius_top_right = 18
	pp_style.corner_radius_bottom_left = 18; pp_style.corner_radius_bottom_right = 18
	pp_style.border_width_left = 2; pp_style.border_width_right = 2
	pp_style.border_width_top = 2; pp_style.border_width_bottom = 4
	pp_style.border_color = active_theme.accent
	pp_style.shadow_color = Color8(0, 0, 0, 180)
	pp_style.shadow_size = 28
	pp_style.content_margin_left = 12; pp_style.content_margin_right = 12
	pp_style.content_margin_top = 12; pp_style.content_margin_bottom = 12
	pop_panel.add_theme_stylebox_override("panel", pp_style)
	pop_panel.custom_minimum_size = Vector2(290, 0)
	
	var btn_pos = burger_btn.global_position
	var panel_w = 290.0
	var px = clamp(btn_pos.x + burger_btn.size.x - panel_w, 16.0, sw - panel_w - 16.0)
	var py = btn_pos.y + burger_btn.size.y + 10.0
	pop_panel.position = Vector2(px, py)
	burger_menu_overlay.add_child(pop_panel)
	
	var vb = VBoxContainer.new()
	vb.add_theme_constant_override("separation", 8)
	pop_panel.add_child(vb)
	
	var menu_items = [
		{"icon": "res://settingsicon.svg", "key": "SETTINGS", "fallback": "Ayarlar", "action": _open_settings},
		{"icon": "res://squad_icon.svg", "key": "PLAYER_LIST_BTN", "fallback": "Oyuncu Kadrosu", "action": _open_player_list},
		{"icon": "res://quest_icon.svg", "key": "DAILY_QUESTS_BTN", "fallback": "Günlük Görevler", "action": _open_daily_quests},
		{"icon": "res://wheel_icon.svg", "key": "LUCKY_WHEEL_BTN", "fallback": "Şans Çarkı", "action": _open_lucky_wheel},
		{"icon": "res://trophy_icon.svg", "key": "LEADERBOARD_BTN", "fallback": "Liderlik Tablosu", "action": _open_leaderboard}
	]
	
	for item in menu_items:
		var btn = Button.new()
		btn.custom_minimum_size = Vector2(266, 54)
		apply_3d_style_to_button(btn, active_theme.bg_bottom.darkened(0.32), active_theme.bg_bottom.darkened(0.52), 12, 3, 10, 6)
		
		var hb = HBoxContainer.new()
		hb.set_anchors_preset(Control.PRESET_FULL_RECT)
		hb.mouse_filter = Control.MOUSE_FILTER_IGNORE
		hb.add_theme_constant_override("separation", 14)
		
		var m_left = MarginContainer.new()
		m_left.mouse_filter = Control.MOUSE_FILTER_IGNORE
		m_left.add_theme_constant_override("margin_left", 8)
		hb.add_child(m_left)
		
		var ic = TextureRect.new()
		ic.texture = load(item["icon"])
		ic.custom_minimum_size = Vector2(28, 28)
		ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		ic.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		ic.mouse_filter = Control.MOUSE_FILTER_IGNORE
		hb.add_child(ic)
		
		var lbl = Label.new()
		lbl.text = LANG.get(Global.current_lang, LANG["ENG"]).get(item["key"], item["fallback"])
		lbl.add_theme_font_override("font", custom_font)
		lbl.add_theme_font_size_override("font_size", 24)
		lbl.add_theme_color_override("font_color", Color.WHITE)
		lbl.add_theme_color_override("font_shadow_color", Color8(0, 0, 0, 160))
		lbl.add_theme_constant_override("shadow_offset_y", 2)
		lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		hb.add_child(lbl)
		
		btn.add_child(hb)
		
		var act = item["action"]
		btn.pressed.connect(func():
			if is_instance_valid(burger_menu_overlay):
				burger_menu_overlay.queue_free()
				burger_menu_overlay = null
			act.call()
		)
		vb.add_child(btn)

func _open_settings():
	temp_settings["master_vol"] = Global.master_vol
	temp_settings["vol_settings"] = Global.vol_settings.duplicate()
	temp_settings["shake_enabled"] = Global.shake_enabled
	temp_settings["vibration_enabled"] = Global.vibration_enabled
	temp_settings["match_duration"] = Global.match_duration
	temp_settings["current_theme"] = Global.current_theme
	temp_settings["original_theme"] = Global.current_theme
	
	if is_instance_valid(settings_overlay):
		settings_overlay.queue_free()
	
	setup_settings_overlay()
	settings_overlay.visible = true

# --- AYARLAR EKRANI (660px Genişliğe Sabitlendi) ---
func setup_settings_overlay():
	settings_overlay = ColorRect.new()
	settings_overlay.color = Color8(0, 0, 0, 0) 
	settings_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	settings_overlay.visible = false
	add_child(settings_overlay)
	
	var center_container = CenterContainer.new()
	center_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	center_container.position.y += 30.0 # Shifted settings down by 30 pixels
	settings_overlay.add_child(center_container)
	
	var panel = PanelContainer.new()
	panel.custom_minimum_size = Vector2(660, 0) # TAKIM LISTESIYLE AYNI GENIŞLIK
	var p_style = StyleBoxFlat.new()
	p_style.bg_color = active_theme.bg_bottom.darkened(0.2)
	p_style.corner_radius_top_left = 25; p_style.corner_radius_top_right = 25
	p_style.corner_radius_bottom_left = 25; p_style.corner_radius_bottom_right = 25
	p_style.shadow_color = Color8(0, 0, 0, 200)
	p_style.shadow_size = 40
	p_style.border_width_top = 4; p_style.border_width_bottom = 4
	p_style.border_width_left = 4; p_style.border_width_right = 4
	p_style.border_color = active_theme.accent
	p_style.content_margin_left = 30; p_style.content_margin_right = 30
	p_style.content_margin_top = 30; p_style.content_margin_bottom = 40
	panel.add_theme_stylebox_override("panel", p_style)
	center_container.add_child(panel)
	
	var s_vbox = VBoxContainer.new()
	s_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	s_vbox.add_theme_constant_override("separation", 20)
	panel.add_child(s_vbox)
	
	# Make a distinct top bar for AYARLAR inside the window
	var window_title_bg = PanelContainer.new()
	var wtb_style = StyleBoxFlat.new()
	wtb_style.bg_color = active_theme.bg_bottom.darkened(0.1)
	wtb_style.corner_radius_top_left = 20; wtb_style.corner_radius_top_right = 20
	wtb_style.corner_radius_bottom_left = 20; wtb_style.corner_radius_bottom_right = 20
	wtb_style.content_margin_top = 15; wtb_style.content_margin_bottom = 15
	window_title_bg.add_theme_stylebox_override("panel", wtb_style)
	s_vbox.add_child(window_title_bg)
	
	var s_title = create_label_node("SETTINGS", white, 55)
	s_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	window_title_bg.add_child(s_title)
	
	var scroll = ScrollContainer.new()
	var screen_h = get_viewport_rect().size.y
	scroll.custom_minimum_size = Vector2(600, min(800.0, screen_h * 0.65)) 
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER 
	s_vbox.add_child(scroll)
	
	var scroll_vbox = VBoxContainer.new()
	scroll_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll_vbox.add_theme_constant_override("separation", 40)
	scroll.add_child(scroll_vbox)
	
	# SECTION 1: TEMA
	add_section_header(scroll_vbox, "SEC_THEME")
	var theme_grid = GridContainer.new()
	theme_grid.columns = 6
	theme_grid.add_theme_constant_override("h_separation", 20)
	theme_grid.add_theme_constant_override("v_separation", 25)
	scroll_vbox.add_child(theme_grid)
	
	for theme_name in Global.THEMES.keys():
		var t_color = Global.THEMES[theme_name].pitch_1
		var t_color2 = Global.THEMES[theme_name].pitch_2
		var t_btn = Button.new()
		var t_style = StyleBoxFlat.new()
		t_style.bg_color = t_color
		t_style.border_width_left = 8; t_style.border_width_right = 8
		t_style.border_width_top = 8; t_style.border_width_bottom = 8
		t_style.border_color = t_color2
		t_style.corner_radius_top_left = 10; t_style.corner_radius_top_right = 10
		t_style.corner_radius_bottom_left = 10; t_style.corner_radius_bottom_right = 10
		
		# Current theme highlight check with buffered property
		if temp_settings["current_theme"] == theme_name:
			t_style.border_color = Color.WHITE
		else:
			t_style.border_color = t_color2.lightened(0.3)
		
		t_btn.add_theme_stylebox_override("normal", t_style)
		t_btn.add_theme_stylebox_override("hover", t_style)
		t_btn.add_theme_stylebox_override("pressed", t_style)
		t_btn.custom_minimum_size = Vector2(80, 80)
		t_btn.pressed.connect(func():
			temp_settings["current_theme"] = theme_name
			Global.current_theme = theme_name
			update_theme_visuals()
			# Rebuild the overlay quickly to show selected outline update
			settings_overlay.queue_free()
			setup_settings_overlay()
			settings_overlay.visible = true
		)
		theme_grid.add_child(t_btn)
	
	# SECTION 2: OYUN AYARLARI
	add_section_header(scroll_vbox, "SEC_GAME")
	var game_vbox = VBoxContainer.new()
	game_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	game_vbox.add_theme_constant_override("separation", 30)
	scroll_vbox.add_child(game_vbox)
	add_magnetic_slider_to_vbox(game_vbox, "SPEED", "LBL_SPEED", temp_settings["match_duration"])
	add_centered_toggle_to_vbox(game_vbox, "SHAKE", "LBL_SHAKE", temp_settings["shake_enabled"])
	add_centered_toggle_to_vbox(game_vbox, "VIBRATION", "LBL_VIBRATION", temp_settings.get("vibration_enabled", true))
	
	# SECTION 3: SES
	add_section_header(scroll_vbox, "SEC_AUDIO")
	var audio_grid = GridContainer.new(); audio_grid.columns = 2
	audio_grid.add_theme_constant_override("h_separation", 20)
	audio_grid.add_theme_constant_override("v_separation", 25)
	scroll_vbox.add_child(audio_grid)
	add_slider_to_grid(audio_grid, "MASTER", "LBL_MASTER", temp_settings["master_vol"], 0.0, 1.0)
	var menu_m_vol = temp_settings["vol_settings"].get("menu_music", 0.4)
	add_slider_to_grid(audio_grid, "menu_music", "LBL_MENU_MUSIC", menu_m_vol, 0.0, 1.0)
	add_slider_to_grid(audio_grid, "stadium", "LBL_STADIUM", temp_settings["vol_settings"]["stadium"], 0.0, 1.0)
	add_slider_to_grid(audio_grid, "music", "LBL_MUSIC", temp_settings["vol_settings"]["music"], 0.0, 1.0)
	
	# SECTION 4: HESAP VE GİZLİLİK
	add_section_header(scroll_vbox, "SEC_ACCOUNT")
	var acc_vbox = VBoxContainer.new()
	acc_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	acc_vbox.add_theme_constant_override("separation", 15)
	scroll_vbox.add_child(acc_vbox)
	
	var ach_btn = Button.new()
	ach_btn.custom_minimum_size = Vector2(400, 60)
	
	var ach_hbox = HBoxContainer.new()
	ach_hbox.name = "AchHBox"
	ach_hbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	ach_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	ach_hbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ach_hbox.add_theme_constant_override("separation", 10)
	ach_btn.add_child(ach_hbox)
	
	var ach_icon = TextureRect.new()
	ach_icon.name = "AchIcon"
	if ResourceLoader.exists("res://google_play_logo.svg"):
		ach_icon.texture = load("res://google_play_logo.svg")
	ach_icon.custom_minimum_size = Vector2(26, 26)
	ach_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	ach_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	ach_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ach_hbox.add_child(ach_icon)
	
	var ach_lbl = Label.new()
	ach_lbl.name = "AchLabel"
	ach_lbl.text = LANG[Global.current_lang].get("ACHIEVEMENTS_BTN", "Google Play Başarımları")
	ach_lbl.add_theme_font_override("font", custom_font)
	ach_lbl.add_theme_font_size_override("font_size", 26)
	ach_lbl.add_theme_color_override("font_color", Color.WHITE)
	ach_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ach_hbox.add_child(ach_lbl)
	
	var ach_s = StyleBoxFlat.new()
	ach_s.bg_color = Color8(15, 60, 35, 230)
	ach_s.corner_radius_top_left = 14; ach_s.corner_radius_top_right = 14
	ach_s.corner_radius_bottom_left = 14; ach_s.corner_radius_bottom_right = 14
	ach_s.border_width_bottom = 3; ach_s.border_color = Color8(15, 157, 88)
	ach_btn.add_theme_stylebox_override("normal", ach_s)
	
	var ach_hover = ach_s.duplicate()
	ach_hover.bg_color = Color8(25, 90, 50, 240)
	ach_btn.add_theme_stylebox_override("hover", ach_hover)
	
	var ach_pressed = ach_s.duplicate()
	ach_pressed.border_width_bottom = 0
	ach_pressed.content_margin_top = 3
	ach_btn.add_theme_stylebox_override("pressed", ach_pressed)
	ach_btn.add_theme_stylebox_override("focus", ach_s)
	
	ach_btn.pressed.connect(func():
		Global.play_click()
		Global.show_achievements()
	)
	acc_vbox.add_child(ach_btn)
	ui_labels.append({"node": ach_lbl, "key": "ACHIEVEMENTS_BTN", "type": "label"})

	var rest_btn = Button.new()
	rest_btn.text = LANG[Global.current_lang].get("RESTORE_PURCHASES", "Satın Alımları Geri Yükle")
	rest_btn.add_theme_font_override("font", custom_font)
	rest_btn.add_theme_font_size_override("font_size", 26)
	rest_btn.custom_minimum_size = Vector2(400, 60)
	var rest_s = StyleBoxFlat.new()
	rest_s.bg_color = Color8(25, 45, 70, 220)
	rest_s.corner_radius_top_left = 14; rest_s.corner_radius_top_right = 14
	rest_s.corner_radius_bottom_left = 14; rest_s.corner_radius_bottom_right = 14
	rest_s.border_width_bottom = 3; rest_s.border_color = Color8(0, 180, 255)
	rest_btn.add_theme_stylebox_override("normal", rest_s)
	
	var rest_hover = rest_s.duplicate()
	rest_hover.bg_color = Color8(35, 65, 100, 230)
	rest_btn.add_theme_stylebox_override("hover", rest_hover)
	
	var rest_pressed = rest_s.duplicate()
	rest_pressed.border_width_bottom = 0
	rest_pressed.content_margin_top = 3
	rest_btn.add_theme_stylebox_override("pressed", rest_pressed)
	rest_btn.add_theme_stylebox_override("focus", rest_s)
	rest_btn.pressed.connect(_on_restore_purchases_pressed)
	acc_vbox.add_child(rest_btn)
	ui_labels.append({"node": rest_btn, "key": "RESTORE_PURCHASES", "type": "button"})
	
	var priv_btn = Button.new()
	priv_btn.text = LANG[Global.current_lang].get("PRIVACY_POLICY", "Gizlilik Politikası")
	priv_btn.add_theme_font_override("font", custom_font)
	priv_btn.add_theme_font_size_override("font_size", 24)
	priv_btn.add_theme_color_override("font_color", Color8(210, 230, 255))
	priv_btn.custom_minimum_size = Vector2(400, 55)
	var priv_s = StyleBoxFlat.new()
	priv_s.bg_color = Color8(255, 255, 255, 20)
	priv_s.corner_radius_top_left = 14; priv_s.corner_radius_top_right = 14
	priv_s.corner_radius_bottom_left = 14; priv_s.corner_radius_bottom_right = 14
	priv_s.border_width_bottom = 3; priv_s.border_color = Color8(100, 150, 200, 100)
	priv_btn.add_theme_stylebox_override("normal", priv_s)
	
	var priv_hover = priv_s.duplicate()
	priv_hover.bg_color = Color8(255, 255, 255, 35)
	priv_btn.add_theme_stylebox_override("hover", priv_hover)
	
	var priv_pressed = priv_s.duplicate()
	priv_pressed.border_width_bottom = 0
	priv_pressed.content_margin_top = 3
	priv_btn.add_theme_stylebox_override("pressed", priv_pressed)
	priv_btn.add_theme_stylebox_override("focus", priv_s)
	priv_btn.pressed.connect(func():
		Global.play_click()
		OS.shell_open("https://ebstudyo.com/gizlilik-politikasi")
	)
	acc_vbox.add_child(priv_btn)
	ui_labels.append({"node": priv_btn, "key": "PRIVACY_POLICY", "type": "button"})
	
	var web_btn = Button.new()
	web_btn.text = "ebstudyo.com ↗"
	web_btn.add_theme_font_override("font", custom_font)
	web_btn.add_theme_font_size_override("font_size", 24)
	web_btn.add_theme_color_override("font_color", Color8(120, 200, 255))
	web_btn.custom_minimum_size = Vector2(400, 55)
	var web_s = StyleBoxFlat.new()
	web_s.bg_color = Color8(255, 255, 255, 18)
	web_s.corner_radius_top_left = 14; web_s.corner_radius_top_right = 14
	web_s.corner_radius_bottom_left = 14; web_s.corner_radius_bottom_right = 14
	web_s.border_width_bottom = 3; web_s.border_color = Color8(0, 140, 220, 120)
	web_btn.add_theme_stylebox_override("normal", web_s)
	
	var web_hover = web_s.duplicate()
	web_hover.bg_color = Color8(255, 255, 255, 30)
	web_btn.add_theme_stylebox_override("hover", web_hover)
	
	var web_pressed = web_s.duplicate()
	web_pressed.border_width_bottom = 0
	web_pressed.content_margin_top = 3
	web_btn.add_theme_stylebox_override("pressed", web_pressed)
	web_btn.add_theme_stylebox_override("focus", web_s)
	web_btn.pressed.connect(func():
		Global.play_click()
		OS.shell_open("https://ebstudyo.com")
	)
	acc_vbox.add_child(web_btn)
	
	var ver_lbl = Label.new()
	ver_lbl.text = "Bol Gol Futbol v1.0.8"
	ver_lbl.add_theme_font_override("font", custom_font)
	ver_lbl.add_theme_font_size_override("font_size", 20)
	ver_lbl.add_theme_color_override("font_color", Color8(120, 130, 150))
	ver_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	acc_vbox.add_child(ver_lbl)
	
	var bot_hbox = HBoxContainer.new()
	bot_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	bot_hbox.add_theme_constant_override("separation", 20)
	bot_hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	s_vbox.add_child(bot_hbox)
	
	var c_style = StyleBoxFlat.new()
	c_style.bg_color = active_theme.bg_bottom.darkened(0.1)
	c_style.border_width_bottom = 4
	c_style.border_color = Color8(220, 50, 50, 255)
	c_style.corner_radius_top_left = 15; c_style.corner_radius_top_right = 15
	c_style.corner_radius_bottom_left = 15; c_style.corner_radius_bottom_right = 15
	
	var c_hover = c_style.duplicate()
	c_hover.bg_color = active_theme.bg_bottom
	
	var c_pressed = c_style.duplicate()
	c_pressed.border_width_bottom = 0
	c_pressed.content_margin_top = 4
	
	var close_btn = Button.new()
	close_btn.text = LANG[Global.current_lang]["CLOSE"]
	close_btn.add_theme_font_override("font", custom_font)
	close_btn.add_theme_font_size_override("font_size", 30)
	close_btn.add_theme_color_override("font_color", Color8(255, 200, 200))
	close_btn.add_theme_stylebox_override("normal", c_style)
	close_btn.add_theme_stylebox_override("hover", c_hover)
	close_btn.add_theme_stylebox_override("pressed", c_pressed)
	close_btn.add_theme_stylebox_override("focus", c_style)
	close_btn.custom_minimum_size = Vector2(250, 75)
	close_btn.pressed.connect(func():
		Global.current_theme = temp_settings.get("original_theme", Global.current_theme)
		update_theme_visuals()
		settings_overlay.visible = false
	)
	bot_hbox.add_child(close_btn)
	ui_labels.append({"node": close_btn, "key": "CLOSE", "type": "button"})

	var ok_style = StyleBoxFlat.new()
	ok_style.bg_color = active_theme.bg_bottom.darkened(0.1)
	ok_style.border_width_bottom = 4
	ok_style.border_color = active_theme.accent
	ok_style.corner_radius_top_left = 15; ok_style.corner_radius_top_right = 15
	ok_style.corner_radius_bottom_left = 15; ok_style.corner_radius_bottom_right = 15

	var ok_hover = ok_style.duplicate()
	ok_hover.bg_color = active_theme.bg_bottom
	
	var ok_pressed = ok_style.duplicate()
	ok_pressed.border_width_bottom = 0
	ok_pressed.content_margin_top = 4

	var save_btn = Button.new()
	save_btn.text = LANG[Global.current_lang]["SAVE"]
	save_btn.add_theme_font_override("font", custom_font)
	save_btn.add_theme_font_size_override("font_size", 30)
	save_btn.add_theme_color_override("font_color", Color.WHITE)
	save_btn.add_theme_stylebox_override("normal", ok_style)
	save_btn.add_theme_stylebox_override("hover", ok_hover)
	save_btn.add_theme_stylebox_override("pressed", ok_pressed)
	save_btn.add_theme_stylebox_override("focus", ok_style)
	save_btn.custom_minimum_size = Vector2(250, 75)
	save_btn.pressed.connect(func():
		Global.master_vol = temp_settings["master_vol"]
		Global.vol_settings = temp_settings["vol_settings"].duplicate()
		Global.shake_enabled = temp_settings["shake_enabled"]
		Global.vibration_enabled = temp_settings.get("vibration_enabled", true)
		Global.match_duration = temp_settings["match_duration"]
		Global.current_theme = temp_settings["current_theme"]
		temp_settings["original_theme"] = temp_settings["current_theme"]
		Global.save_progression()
		
		# Immediately update node hierarchy
		update_theme_visuals()
		Global._update_bg_music_volume()
		Global._update_goal_music_volume()
		settings_overlay.visible = false
	)
	bot_hbox.add_child(save_btn)
	ui_labels.append({"node": save_btn, "key": "SAVE", "type": "button"})

func _open_player_list():
	if is_instance_valid(player_list_overlay):
		player_list_overlay.queue_free()
	setup_player_list_overlay()
	player_list_overlay.visible = true

func setup_player_list_overlay():
	# 1. Touch Event Isolation - Stop mouse filter prevents touches bleeding through to main menu
	player_list_overlay = ColorRect.new()
	player_list_overlay.color = Color8(0, 0, 0, 180)
	player_list_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	player_list_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	player_list_overlay.visible = false
	add_child(player_list_overlay)
	
	var center_container = CenterContainer.new()
	center_container.mouse_filter = Control.MOUSE_FILTER_STOP
	center_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	center_container.position.y += 15.0
	player_list_overlay.add_child(center_container)
	
	var panel = PanelContainer.new()
	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	panel.custom_minimum_size = Vector2(700, 0)
	var p_style = StyleBoxFlat.new()
	p_style.bg_color = active_theme.bg_bottom.darkened(0.18)
	p_style.corner_radius_top_left = 24; p_style.corner_radius_top_right = 24
	p_style.corner_radius_bottom_left = 24; p_style.corner_radius_bottom_right = 24
	p_style.shadow_color = Color8(0, 0, 0, 220)
	p_style.shadow_size = 40
	p_style.border_width_top = 3; p_style.border_width_bottom = 5
	p_style.border_width_left = 3; p_style.border_width_right = 3
	p_style.border_color = active_theme.accent
	p_style.content_margin_left = 25; p_style.content_margin_right = 25
	p_style.content_margin_top = 20; p_style.content_margin_bottom = 25
	panel.add_theme_stylebox_override("panel", p_style)
	center_container.add_child(panel)
	
	var s_vbox = VBoxContainer.new()
	s_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	s_vbox.add_theme_constant_override("separation", 14)
	panel.add_child(s_vbox)
	
	# Target team state
	var target_team = Global.home_team_name
	if target_team == "" or not Global.TEAMS.has(target_team):
		target_team = Global.TEAMS.keys()[0]

	# Window title: "[TEAM] SQUAD" / "[TAKIM] KADROSU"
	var window_title_bg = PanelContainer.new()
	var wtb_style = StyleBoxFlat.new()
	wtb_style.bg_color = active_theme.bg_bottom.darkened(0.1)
	wtb_style.corner_radius_top_left = 16; wtb_style.corner_radius_top_right = 16
	wtb_style.corner_radius_bottom_left = 16; wtb_style.corner_radius_bottom_right = 16
	wtb_style.border_width_bottom = 2.5; wtb_style.border_color = active_theme.accent
	wtb_style.content_margin_top = 10; wtb_style.content_margin_bottom = 10
	wtb_style.content_margin_left = 20; wtb_style.content_margin_right = 20
	window_title_bg.add_theme_stylebox_override("panel", wtb_style)
	s_vbox.add_child(window_title_bg)
	
	var s_title = Label.new()
	s_title.text = (target_team + " " + LANG.get(Global.current_lang, LANG["ENG"]).get("SQUAD_SUFFIX", "KADROSU")).to_upper()
	s_title.add_theme_font_override("font", custom_font)
	s_title.add_theme_font_size_override("font_size", 38)
	s_title.add_theme_color_override("font_color", Color.WHITE)
	s_title.add_theme_color_override("font_shadow_color", Color8(0, 0, 0, 200))
	s_title.add_theme_constant_override("shadow_offset_y", 2)
	s_title.add_theme_color_override("font_outline_color", Color8(0, 0, 0, 240))
	s_title.add_theme_constant_override("outline_size", 3)
	s_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	window_title_bg.add_child(s_title)
	
	# Top section: Team ball preview & interactive team switcher
	var header_vbox = VBoxContainer.new()
	header_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	header_vbox.add_theme_constant_override("separation", 4)
	s_vbox.add_child(header_vbox)

	var ball_btn = Button.new()
	ball_btn.custom_minimum_size = Vector2(90, 90)
	ball_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	var bb_style = StyleBoxFlat.new()
	bb_style.bg_color = Color(0, 0, 0, 0)
	ball_btn.add_theme_stylebox_override("normal", bb_style)
	ball_btn.add_theme_stylebox_override("hover", bb_style)
	ball_btn.add_theme_stylebox_override("pressed", bb_style)
	ball_btn.add_theme_stylebox_override("focus", bb_style)

	var ball_preview = Control.new()
	ball_preview.set_anchors_preset(Control.PRESET_FULL_RECT)
	ball_preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ball_preview.draw.connect(func():
		draw_ball_preview(ball_preview, true, target_team)
	)
	ball_btn.add_child(ball_preview)
	header_vbox.add_child(ball_btn)
	
	var team_btn = Button.new()
	team_btn.text = target_team + " ▾"
	team_btn.custom_minimum_size = Vector2(0, 48)
	team_btn.add_theme_font_override("font", custom_font)
	team_btn.add_theme_font_size_override("font_size", 32)
	team_btn.add_theme_color_override("font_color", Color8(255, 215, 0))
	var tb_style = StyleBoxFlat.new()
	tb_style.bg_color = Color(0, 0, 0, 0)
	team_btn.add_theme_stylebox_override("normal", tb_style)
	team_btn.add_theme_stylebox_override("hover", tb_style)
	team_btn.add_theme_stylebox_override("pressed", tb_style)
	team_btn.add_theme_stylebox_override("focus", tb_style)
	header_vbox.add_child(team_btn)

	var switch_hint = Label.new()
	switch_hint.text = LANG.get(Global.current_lang, LANG["ENG"]).get("TAP_TO_SWITCH_TEAM", "Takım değiştirmek için dokun")
	switch_hint.add_theme_font_override("font", custom_font)
	switch_hint.add_theme_font_size_override("font_size", 18)
	switch_hint.add_theme_color_override("font_color", Color.WHITE)
	switch_hint.add_theme_color_override("font_outline_color", Color8(0, 0, 0, 180))
	switch_hint.add_theme_constant_override("outline_size", 2)
	switch_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	header_vbox.add_child(switch_hint)

	# Toast Notification Label
	var toast_lbl = Label.new()
	toast_lbl.add_theme_font_override("font", custom_font)
	toast_lbl.add_theme_font_size_override("font_size", 24)
	toast_lbl.add_theme_color_override("font_color", Color8(255, 225, 80))
	toast_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	toast_lbl.visible = false
	s_vbox.add_child(toast_lbl)
	
	var show_toast = func(msg: String):
		toast_lbl.text = msg
		toast_lbl.visible = true
		get_tree().create_timer(2.5).timeout.connect(func():
			if is_instance_valid(toast_lbl):
				toast_lbl.visible = false
		)

	# Scrollable player list (touch isolated)
	var scroll = ScrollContainer.new()
	var screen_h = get_viewport_rect().size.y
	scroll.custom_minimum_size = Vector2(650, min(screen_h * 0.46, 450))
	scroll.mouse_filter = Control.MOUSE_FILTER_STOP
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	scroll.follow_focus = true
	s_vbox.add_child(scroll)
	
	var list_vbox = VBoxContainer.new()
	list_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	list_vbox.add_theme_constant_override("separation", 10)
	scroll.add_child(list_vbox)

	# Localization maps
	var cap_badge_names = {
		"TR": "★ KAPTAN",
		"ENG": "★ CAPTAIN",
		"ESP": "★ CAPITÁN",
		"POR": "★ CAPITÃO",
		"ITA": "★ CAPITANO"
	}
	var cap_ph_map = {
		"TR": "Kaptan Adı...",
		"ENG": "Captain Name...",
		"ESP": "Nombre del Capitán...",
		"POR": "Nome do Capitão...",
		"ITA": "Nome del Capitano..."
	}
	var player_ph_map = {
		"TR": "Oyuncu Adı...",
		"ENG": "Player Name...",
		"ESP": "Nombre del Jugador...",
		"POR": "Nome do Jogador...",
		"ITA": "Nome del Giocatore..."
	}
	var add_player_text_map = {
		"TR": "+ OYUNCU EKLE",
		"ENG": "+ ADD PLAYER",
		"ESP": "+ AÑADIR JUGADOR",
		"POR": "+ ADICIONAR JOGADOR",
		"ITA": "+ AGGIUNGI GIOCATORE"
	}

	# Array to track all active player row dictionaries
	var player_rows: Array = []

	# Updates roles, styles, badges and placeholders for all rows
	var update_all_row_roles = func():
		for i in range(player_rows.size()):
			var r = player_rows[i]
			var is_cap = (i == 0)
			
			# Captain badge visibility
			if is_instance_valid(r["badge_panel"]):
				r["badge_panel"].visible = is_cap
			
			# Border and accent colors
			var num_border_col = Color8(255, 215, 0) if is_cap else active_theme.accent
			var hash_col = Color8(255, 215, 0) if is_cap else active_theme.accent
			var name_border_col = Color8(255, 215, 0, 220) if is_cap else active_theme.accent.darkened(0.3)
			
			if is_instance_valid(r["hash_lbl"]):
				r["hash_lbl"].add_theme_color_override("font_color", hash_col)
			
			if is_instance_valid(r["num_panel"]):
				var np_style = StyleBoxFlat.new()
				np_style.bg_color = active_theme.bg_bottom.darkened(0.35)
				np_style.corner_radius_top_left = 10; np_style.corner_radius_top_right = 10
				np_style.corner_radius_bottom_left = 10; np_style.corner_radius_bottom_right = 10
				np_style.border_width_left = 1.5; np_style.border_width_right = 1.5
				np_style.border_width_top = 1.5; np_style.border_width_bottom = 2.5
				np_style.border_color = num_border_col
				np_style.content_margin_left = 8; np_style.content_margin_right = 8
				r["num_panel"].add_theme_stylebox_override("panel", np_style)
			
			if is_instance_valid(r["name_edit"]):
				var ph = cap_ph_map.get(Global.current_lang, cap_ph_map["ENG"]) if is_cap else player_ph_map.get(Global.current_lang, player_ph_map["ENG"])
				r["name_edit"].placeholder_text = ph
				
				var ne_style = StyleBoxFlat.new()
				ne_style.bg_color = active_theme.bg_bottom.darkened(0.3)
				ne_style.corner_radius_top_left = 10; ne_style.corner_radius_top_right = 10
				ne_style.corner_radius_bottom_left = 10; ne_style.corner_radius_bottom_right = 10
				ne_style.border_width_left = 1.5; ne_style.border_width_right = 1.5
				ne_style.border_width_top = 1.5; ne_style.border_width_bottom = 2.5
				ne_style.border_color = name_border_col
				ne_style.content_margin_left = 12; ne_style.content_margin_right = 12
				r["name_edit"].add_theme_stylebox_override("normal", ne_style)
				r["name_edit"].add_theme_stylebox_override("focus", ne_style)

	# Helper to create a single player row
	var create_player_row = func(num_val: String, default_name: String = "") -> Dictionary:
		var row = HBoxContainer.new()
		row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_theme_constant_override("separation", 10)
		
		# 1. Number box with "#" label and editable number LineEdit
		var num_panel = PanelContainer.new()
		num_panel.custom_minimum_size = Vector2(76, 52)
		
		var num_hbox = HBoxContainer.new()
		num_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
		num_hbox.add_theme_constant_override("separation", 2)
		num_panel.add_child(num_hbox)
		
		var hash_lbl = Label.new()
		hash_lbl.text = "#"
		hash_lbl.add_theme_font_override("font", custom_font)
		hash_lbl.add_theme_font_size_override("font_size", 24)
		hash_lbl.add_theme_color_override("font_color", active_theme.accent)
		num_hbox.add_child(hash_lbl)
		
		var num_edit = LineEdit.new()
		num_edit.custom_minimum_size = Vector2(40, 48)
		num_edit.max_length = 3
		num_edit.text = num_val
		num_edit.alignment = HORIZONTAL_ALIGNMENT_CENTER
		num_edit.add_theme_font_override("font", custom_font)
		num_edit.add_theme_font_size_override("font_size", 26)
		num_edit.add_theme_color_override("font_color", Color.WHITE)
		var empty_style = StyleBoxEmpty.new()
		num_edit.add_theme_stylebox_override("normal", empty_style)
		num_edit.add_theme_stylebox_override("focus", empty_style)
		num_hbox.add_child(num_edit)
		row.add_child(num_panel)
		
		# 2. Captain Badge (Gold pill badge)
		var badge_panel = PanelContainer.new()
		var bp_style = StyleBoxFlat.new()
		bp_style.bg_color = Color8(255, 215, 0, 35)
		bp_style.border_color = Color8(255, 215, 0)
		bp_style.border_width_left = 1.5; bp_style.border_width_right = 1.5
		bp_style.border_width_top = 1.5; bp_style.border_width_bottom = 2.5
		bp_style.corner_radius_top_left = 8; bp_style.corner_radius_top_right = 8
		bp_style.corner_radius_bottom_left = 8; bp_style.corner_radius_bottom_right = 8
		bp_style.content_margin_left = 10; bp_style.content_margin_right = 10
		bp_style.content_margin_top = 4; bp_style.content_margin_bottom = 4
		badge_panel.add_theme_stylebox_override("panel", bp_style)
		badge_panel.custom_minimum_size = Vector2(100, 52)
		
		var cap_lbl = Label.new()
		cap_lbl.text = cap_badge_names.get(Global.current_lang, cap_badge_names["ENG"])
		cap_lbl.add_theme_font_override("font", custom_font)
		cap_lbl.add_theme_font_size_override("font_size", 22)
		cap_lbl.add_theme_color_override("font_color", Color8(255, 225, 60))
		cap_lbl.add_theme_color_override("font_outline_color", Color8(0, 0, 0, 220))
		cap_lbl.add_theme_constant_override("outline_size", 2)
		cap_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		cap_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		badge_panel.add_child(cap_lbl)
		badge_panel.visible = false
		row.add_child(badge_panel)
		
		# 3. LineEdit name input with 20 max length
		var name_edit = LineEdit.new()
		name_edit.custom_minimum_size = Vector2(250, 52)
		name_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		name_edit.max_length = 20
		name_edit.text = default_name
		name_edit.add_theme_font_override("font", custom_font)
		name_edit.add_theme_font_size_override("font_size", 26)
		name_edit.add_theme_color_override("font_color", Color.WHITE)
		name_edit.add_theme_color_override("font_placeholder_color", Color8(220, 220, 230, 160))
		name_edit.text_changed.connect(func(new_text: String):
			if new_text.length() >= 20:
				show_toast.call(LANG.get(Global.current_lang, LANG["ENG"]).get("MAX_CHAR_WARN", "Maksimum 20 karakter!"))
		)
		row.add_child(name_edit)
		
		# 4. Delete (✕) Button (min 48x48 touch target: 52x52)
		var del_btn = Button.new()
		del_btn.text = "✕"
		del_btn.custom_minimum_size = Vector2(52, 52)
		del_btn.add_theme_font_override("font", custom_font)
		del_btn.add_theme_font_size_override("font_size", 26)
		del_btn.add_theme_color_override("font_color", Color.WHITE)
		apply_3d_style_to_button(del_btn, Color8(220, 50, 50), Color8(150, 25, 25), 10, 3)
		row.add_child(del_btn)
		
		var entry = {
			"row": row,
			"num_panel": num_panel,
			"hash_lbl": hash_lbl,
			"num_edit": num_edit,
			"badge_panel": badge_panel,
			"name_edit": name_edit,
			"del_btn": del_btn
		}
		
		del_btn.pressed.connect(func():
			Global.play_click()
			if player_rows.size() <= 1:
				# Cannot remove the only row (Captain slot); clear text instead
				entry["name_edit"].text = ""
				return
			player_rows.erase(entry)
			row.queue_free()
			update_all_row_roles.call()
		)
		
		list_vbox.add_child(row)
		player_rows.append(entry)
		return entry

	# Dynamic loader for any selected team
	var load_team_players = func(t_name: String):
		target_team = t_name
		s_title.text = (target_team + " " + LANG.get(Global.current_lang, LANG["ENG"]).get("SQUAD_SUFFIX", "KADROSU")).to_upper()
		team_btn.text = target_team + " ▾"
		ball_preview.queue_redraw()
		
		for r in player_rows:
			if is_instance_valid(r["row"]):
				r["row"].queue_free()
		player_rows.clear()
		
		var existing_names = {}
		if Global.custom_player_names.has(target_team):
			var raw = Global.custom_player_names[target_team]
			if typeof(raw) == TYPE_DICTIONARY:
				existing_names = raw
				
		var saved_list = []
		var has_10 = false
		for k in existing_names.keys():
			if str(k) == "10":
				has_10 = true
				var p_val = String(existing_names[k]).strip_edges()
				saved_list.append({"num": "10", "name": p_val})
				break
		for k in existing_names.keys():
			var sk = str(k)
			if has_10 and sk == "10":
				continue
			var p_val = String(existing_names[k]).strip_edges()
			saved_list.append({"num": sk, "name": p_val})
		
		if saved_list.size() == 0:
			# Slot 1: Captain (#10)
			create_player_row.call("10", "")
			# Slot 2: Empty slot (#9)
			create_player_row.call("9", "")
		elif saved_list.size() == 1:
			# Slot 1: Captain (saved player)
			create_player_row.call(saved_list[0].num, saved_list[0].name)
			# Slot 2: Empty slot
			var second_num = "9" if saved_list[0].num != "9" else "10"
			create_player_row.call(second_num, "")
		else:
			# Show all saved players (first is Captain)
			for item in saved_list:
				create_player_row.call(item.num, item.name)
				
		update_all_row_roles.call()

	# Initial squad populate
	load_team_players.call(target_team)

	# Interactive Team Picker Modal
	var open_team_picker = func():
		Global.play_click()
		var p_overlay = ColorRect.new()
		p_overlay.color = Color(0, 0, 0, 0.85)
		p_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
		p_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
		player_list_overlay.add_child(p_overlay)
		
		var p_center = CenterContainer.new()
		p_center.mouse_filter = Control.MOUSE_FILTER_STOP
		p_center.set_anchors_preset(Control.PRESET_FULL_RECT)
		p_overlay.add_child(p_center)
		
		var p_panel = PanelContainer.new()
		p_panel.mouse_filter = Control.MOUSE_FILTER_STOP
		p_panel.custom_minimum_size = Vector2(660, min(screen_h * 0.82, 760))
		var pp_style = StyleBoxFlat.new()
		pp_style.bg_color = active_theme.bg_bottom.darkened(0.2)
		pp_style.corner_radius_top_left = 20; pp_style.corner_radius_top_right = 20
		pp_style.corner_radius_bottom_left = 20; pp_style.corner_radius_bottom_right = 20
		pp_style.border_width_left = 2.5; pp_style.border_width_right = 2.5
		pp_style.border_width_top = 2.5; pp_style.border_width_bottom = 4.5
		pp_style.border_color = active_theme.accent
		pp_style.content_margin_left = 20; pp_style.content_margin_right = 20
		pp_style.content_margin_top = 18; pp_style.content_margin_bottom = 20
		p_panel.add_theme_stylebox_override("panel", pp_style)
		p_center.add_child(p_panel)
		
		var p_vb = VBoxContainer.new()
		p_vb.add_theme_constant_override("separation", 14)
		p_panel.add_child(p_vb)
		
		var p_title = Label.new()
		p_title.text = LANG.get(Global.current_lang, LANG["ENG"]).get("SELECT_TEAM", "TAKIM SEÇ")
		p_title.add_theme_font_override("font", custom_font)
		p_title.add_theme_font_size_override("font_size", 36)
		p_title.add_theme_color_override("font_color", Color.WHITE)
		p_title.add_theme_color_override("font_shadow_color", Color8(0, 0, 0, 200))
		p_title.add_theme_constant_override("shadow_offset_y", 2)
		p_title.add_theme_color_override("font_outline_color", Color8(0, 0, 0, 240))
		p_title.add_theme_constant_override("outline_size", 3)
		p_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		p_vb.add_child(p_title)
		
		var search_box = LineEdit.new()
		search_box.placeholder_text = LANG.get(Global.current_lang, LANG["ENG"]).get("SEARCH_TEAM", "Takım ara...")
		search_box.custom_minimum_size = Vector2(580, 54)
		search_box.add_theme_font_override("font", custom_font)
		search_box.add_theme_font_size_override("font_size", 24)
		search_box.add_theme_color_override("font_color", Color.WHITE)
		search_box.add_theme_color_override("font_placeholder_color", Color8(220, 220, 230, 160))
		var sb_style = StyleBoxFlat.new()
		sb_style.bg_color = active_theme.bg_bottom.darkened(0.35)
		sb_style.corner_radius_top_left = 12; sb_style.corner_radius_top_right = 12
		sb_style.corner_radius_bottom_left = 12; sb_style.corner_radius_bottom_right = 12
		sb_style.border_width_bottom = 2
		sb_style.border_color = active_theme.accent.darkened(0.3)
		sb_style.content_margin_left = 14; sb_style.content_margin_right = 14
		search_box.add_theme_stylebox_override("normal", sb_style)
		search_box.add_theme_stylebox_override("focus", sb_style)
		p_vb.add_child(search_box)
		
		var t_scroll = ScrollContainer.new()
		t_scroll.custom_minimum_size = Vector2(600, min(screen_h * 0.55, 520))
		t_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
		t_scroll.mouse_filter = Control.MOUSE_FILTER_PASS
		t_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
		t_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
		p_vb.add_child(t_scroll)
		
		var t_grid = GridContainer.new()
		t_grid.columns = 2
		t_grid.add_theme_constant_override("h_separation", 10)
		t_grid.add_theme_constant_override("v_separation", 10)
		t_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		t_scroll.add_child(t_grid)
		
		var populate_team_buttons = func(query: String = ""):
			for ch in t_grid.get_children():
				ch.queue_free()
			var q = query.strip_edges().to_lower()
			for tm in Global.TEAMS.keys():
				if q != "" and not tm.to_lower().contains(q):
					continue
				var b = Button.new()
				b.text = tm
				b.custom_minimum_size = Vector2(285, 58)
				b.mouse_filter = Control.MOUSE_FILTER_PASS
				b.add_theme_font_override("font", custom_font)
				b.add_theme_font_size_override("font_size", 26)
				b.add_theme_color_override("font_color", Color.WHITE)
				if tm == target_team:
					apply_3d_style_to_button(b, active_theme.accent, active_theme.accent.darkened(0.4), 12, 3.5, 12, 8)
					b.add_theme_color_override("font_color", Color8(20, 15, 0) if active_theme.accent.get_luminance() > 0.5 else Color.WHITE)
				else:
					apply_3d_style_to_button(b, active_theme.bg_bottom.darkened(0.28), active_theme.bg_bottom.darkened(0.5), 12, 3.5, 12, 8)
				var chosen = tm
				b.pressed.connect(func():
					Global.play_click()
					load_team_players.call(chosen)
					p_overlay.queue_free()
				)
				t_grid.add_child(b)
				
		populate_team_buttons.call("")
		search_box.text_changed.connect(func(new_text: String):
			populate_team_buttons.call(new_text)
		)
		
		var p_close_btn = Button.new()
		p_close_btn.text = LANG.get(Global.current_lang, LANG["ENG"])["CLOSE"]
		p_close_btn.custom_minimum_size = Vector2(200, 56)
		p_close_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		p_close_btn.add_theme_font_override("font", custom_font)
		p_close_btn.add_theme_font_size_override("font_size", 26)
		apply_3d_style_to_button(p_close_btn, Color8(200, 45, 45), Color8(130, 25, 25), 12, 3.5, 20, 8)
		p_close_btn.add_theme_color_override("font_color", Color.WHITE)
		p_close_btn.pressed.connect(func():
			Global.play_click()
			p_overlay.queue_free()
		)
		p_vb.add_child(p_close_btn)

	ball_btn.pressed.connect(open_team_picker)
	team_btn.pressed.connect(open_team_picker)

	# --- Explicit "+ OYUNCU EKLE" / "+ ADD PLAYER" Button ---
	var add_player_btn = Button.new()
	var add_txt = add_player_text_map.get(Global.current_lang, LANG.get(Global.current_lang, {}).get("ADD_PLAYER", "+ ADD PLAYER"))
	add_player_btn.text = add_txt
	add_player_btn.custom_minimum_size = Vector2(650, 54)
	add_player_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_player_btn.add_theme_font_override("font", custom_font)
	add_player_btn.add_theme_font_size_override("font_size", 28)
	add_player_btn.add_theme_color_override("font_color", Color.WHITE)
	apply_3d_style_to_button(add_player_btn, active_theme.accent.darkened(0.15), active_theme.accent.darkened(0.45), 14, 4, 16, 8)
	
	add_player_btn.pressed.connect(func():
		Global.play_click()
		if player_rows.size() >= 23:
			show_toast.call("Maksimum 23 oyuncu ekleyebilirsiniz!")
			return
		
		# Find next unused squad number
		var pref_numbers = ["10", "9", "7", "11", "8", "6", "5", "4", "3", "2", "1", "14", "17", "19", "20", "21", "22", "23"]
		var used_nums = {}
		for r in player_rows:
			if is_instance_valid(r["num_edit"]):
				used_nums[r["num_edit"].text.strip_edges()] = true
		
		var chosen_num = ""
		for pn in pref_numbers:
			if not used_nums.has(pn):
				chosen_num = pn
				break
		if chosen_num == "":
			chosen_num = str(player_rows.size() + 1)
			
		var new_entry = create_player_row.call(chosen_num, "")
		update_all_row_roles.call()
		
		# Auto-scroll to bottom and focus new input
		get_tree().create_timer(0.05).timeout.connect(func():
			if is_instance_valid(scroll):
				scroll.scroll_vertical = int(scroll.get_v_scroll_bar().max_value)
			if is_instance_valid(new_entry["name_edit"]):
				new_entry["name_edit"].grab_focus()
		)
	)
	s_vbox.add_child(add_player_btn)
	ui_labels.append({"node": add_player_btn, "key": "ADD_PLAYER", "type": "button"})

	# Bottom buttons (CLOSE & SAVE)
	var bot_hbox = HBoxContainer.new()
	bot_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	bot_hbox.add_theme_constant_override("separation", 20)
	bot_hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	s_vbox.add_child(bot_hbox)
	
	var close_btn = Button.new()
	close_btn.text = LANG.get(Global.current_lang, LANG["ENG"]).get("CLOSE", "KAPAT")
	close_btn.add_theme_font_override("font", custom_font)
	close_btn.add_theme_font_size_override("font_size", 30)
	close_btn.custom_minimum_size = Vector2(250, 65)
	apply_3d_style_to_button(close_btn, active_theme.bg_top.lightened(0.12), active_theme.bg_bottom.darkened(0.35), 15, 4)
	close_btn.add_theme_color_override("font_color", Color.WHITE)
	close_btn.pressed.connect(func():
		Global.play_click()
		player_list_overlay.visible = false
	)
	bot_hbox.add_child(close_btn)
	ui_labels.append({"node": close_btn, "key": "CLOSE", "type": "button"})

	var save_btn = Button.new()
	save_btn.text = LANG.get(Global.current_lang, LANG["ENG"]).get("SAVE", "KAYDET")
	save_btn.add_theme_font_override("font", custom_font)
	save_btn.add_theme_font_size_override("font_size", 30)
	save_btn.custom_minimum_size = Vector2(250, 65)
	apply_3d_style_to_button(save_btn, Color8(34, 197, 94), Color8(20, 130, 60), 15, 4)
	save_btn.add_theme_color_override("font_color", Color.WHITE)
	
	save_btn.pressed.connect(func():
		if target_team != "":
			var team_saved_names = {}
			var used_saved_nums = {}
			for r in player_rows:
				if is_instance_valid(r["name_edit"]):
					var txt = r["name_edit"].text.strip_edges()
					if txt != "":
						var n_str = ""
						if is_instance_valid(r["num_edit"]):
							n_str = r["num_edit"].text.strip_edges()
						if n_str == "" or not n_str.is_valid_int():
							n_str = "10" if r == player_rows[0] else str(team_saved_names.size() + 1)
						var final_n = n_str
						var dupe_idx = 1
						while used_saved_nums.has(final_n):
							final_n = str(int(n_str) + dupe_idx)
							dupe_idx += 1
						used_saved_nums[final_n] = true
						team_saved_names[final_n] = txt
			Global.custom_player_names[target_team] = team_saved_names
			Global.save_progression()
		Global.play_click()
		player_list_overlay.visible = false
	)
	bot_hbox.add_child(save_btn)
	ui_labels.append({"node": save_btn, "key": "SAVE", "type": "button"})

func add_section_header(vbox: VBoxContainer, lang_key: String):
	var header = create_label_node(lang_key, white, 35)
	header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(header)
	var sep = HSeparator.new()
	vbox.add_child(sep)
	ui_separators.append(sep)

func create_label_node(lang_key, color, f_size) -> Label: 
	var lbl = Label.new()
	var current_dict = LANG.get(Global.current_lang, LANG["ENG"])
	lbl.text = current_dict.get(lang_key, LANG["ENG"].get(lang_key, String(lang_key)))
	lbl.add_theme_color_override("font_color", color)
	lbl.add_theme_font_size_override("font_size", f_size) 
	lbl.add_theme_font_override("font", custom_font)
	lbl.add_theme_color_override("font_shadow_color", Color8(0, 0, 0, 200))
	lbl.add_theme_constant_override("shadow_offset_y", 2)
	lbl.add_theme_color_override("font_outline_color", Color8(0, 0, 0, 220))
	lbl.add_theme_constant_override("outline_size", 3)
	ui_labels.append({"node": lbl, "key": lang_key, "type": "label", "on_bg": true})
	return lbl

func add_slider_to_grid(grid: GridContainer, id: String, lang_key: String, default_val: float, min_val: float, max_val: float):
	var lbl = create_label_node(lang_key, white, 30)
	lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.add_child(lbl)
	
	var slider = HSlider.new()
	slider.custom_minimum_size = Vector2(240, 40) # TELEFONA UYGUN KÜÇÜLTÜLDÜ
	slider.min_value = min_val
	slider.max_value = max_val
	slider.step = 0.05
	slider.value = default_val
	slider.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	slider.value_changed.connect(func(val):
		if id == "MASTER": 
			temp_settings["master_vol"] = val
			# Optional: preview the master volume bound live on menu music
			if is_instance_valid(Global.bg_music_player):
				var live_target = val * temp_settings["vol_settings"].get("menu_music", 0.4) * 1.06
				if live_target <= 0.01:
					Global.bg_music_player.volume_db = -80.0
				else:
					Global.bg_music_player.volume_db = linear_to_db(live_target)
		else: 
			temp_settings["vol_settings"][id] = val
			if id == "music":
				if is_instance_valid(Global.goal_music_player):
					var live_target = temp_settings["master_vol"] * val * 1.10
					if live_target <= 0.01:
						Global.goal_music_player.volume_db = -80.0
					else:
						Global.goal_music_player.volume_db = linear_to_db(clamp(live_target, 0.0001, 1.0))
			if id == "menu_music":
				# Live preview for menu music slider
				if is_instance_valid(Global.bg_music_player):
					var live_target = temp_settings["master_vol"] * val * 1.06
					if live_target <= 0.01:
						Global.bg_music_player.volume_db = -80.0
					else:
						Global.bg_music_player.volume_db = linear_to_db(live_target)
	)
	
	apply_modern_slider(slider)
	grid.add_child(slider)

func add_magnetic_slider_to_vbox(parent: Control, id: String, lang_key: String, default_val: float):
	var cont = VBoxContainer.new()
	cont.alignment = BoxContainer.ALIGNMENT_CENTER
	parent.add_child(cont)
	
	var lbl = create_label_node(lang_key, white, 30)
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	cont.add_child(lbl)
	
	var vst = VBoxContainer.new()
	vst.alignment = BoxContainer.ALIGNMENT_CENTER
	cont.add_child(vst)
	
	var slider = HSlider.new()
	slider.custom_minimum_size = Vector2(280, 40)
	apply_modern_slider(slider)
	slider.min_value = 0
	slider.max_value = 2
	slider.step = 1
	var def_step = 1
	if default_val < 0.9: def_step = 0
	elif default_val > 1.1: def_step = 2
	slider.value = def_step
	slider.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	slider.value_changed.connect(func(val):
		if val == 0: temp_settings["match_duration"] = 0
		elif val == 1: temp_settings["match_duration"] = 1
		elif val == 2: temp_settings["match_duration"] = 2
	)
	vst.add_child(slider)
	
	var lbl_box = HBoxContainer.new()
	var l_kisa = create_label_node("DUR_SHORT", white, 24); l_kisa.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var l_norm = create_label_node("DUR_NORMAL", white, 24); l_norm.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; l_norm.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var l_uzun = create_label_node("DUR_LONG", white, 24); l_uzun.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT; l_uzun.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lbl_box.add_child(l_kisa); lbl_box.add_child(l_norm); lbl_box.add_child(l_uzun)
	vst.add_child(lbl_box)

func apply_modern_slider(slider: HSlider):
	var slider_sb = StyleBoxFlat.new()
	slider_sb.bg_color = active_theme.bg_bottom.darkened(0.2)
	slider_sb.corner_radius_top_left = 10; slider_sb.corner_radius_top_right = 10
	slider_sb.corner_radius_bottom_left = 10; slider_sb.corner_radius_bottom_right = 10
	slider_sb.expand_margin_top = 10; slider_sb.expand_margin_bottom = 10

	var grabber_sb = StyleBoxFlat.new()
	grabber_sb.bg_color = active_theme.accent
	grabber_sb.corner_radius_top_left = 10; grabber_sb.corner_radius_top_right = 10
	grabber_sb.corner_radius_bottom_left = 10; grabber_sb.corner_radius_bottom_right = 10
	grabber_sb.expand_margin_top = 10; grabber_sb.expand_margin_bottom = 10

	slider.add_theme_stylebox_override("slider", slider_sb)
	slider.add_theme_stylebox_override("grabber_area", grabber_sb)
	slider.add_theme_stylebox_override("grabber_area_hl", grabber_sb)
	
	var img = Image.create(30, 30, false, Image.FORMAT_RGBA8)
	img.fill(Color.TRANSPARENT)
	for x in range(30):
		for y in range(30):
			if Vector2(x - 15, y - 15).length() <= 14:
				img.set_pixel(x, y, Color.WHITE)
	var tex = ImageTexture.create_from_image(img)
	slider.add_theme_icon_override("grabber", tex)
	slider.add_theme_icon_override("grabber_highlight", tex)

func add_dropdown_to_grid(grid: GridContainer, id: String, lang_key: String, options: Array, default_val: String):
	var lbl = create_label_node(lang_key, white, 30)
	lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.add_child(lbl)
	
	var drop = OptionButton.new()
	drop.add_theme_font_override("font", custom_font)
	drop.add_theme_font_size_override("font_size", 28)
	drop.custom_minimum_size = Vector2(240, 50) # TELEFONA UYGUN KÜÇÜLTÜLDÜ
	var default_idx = 0
	for i in range(options.size()):
		drop.add_item(options[i])
		if options[i] == default_val: default_idx = i
	drop.selected = default_idx
	drop.item_selected.connect(func(idx):
		if id == "THEME":
			Global.current_theme = drop.get_item_text(idx)
			update_theme_visuals()
			settings_overlay.queue_free()
			setup_settings_overlay()
	)
	grid.add_child(drop)
	style_popup_menu(drop.get_popup())

func draw_ball_preview(ctrl: Control, is_home: bool = true, team_name_override: String = ""):
	var team_name = team_name_override if team_name_override != "" else (Global.home_team_name if is_home else Global.away_team_name)
	var team_data = Global.TEAMS.get(team_name)
	
	var ctrl_size = ctrl.size if ctrl.size.x > 1.0 else ctrl.custom_minimum_size
	var center = ctrl_size / 2.0
	var radius = 54.0

	if not team_data:
		# Draw a placeholder ball (empty state)
		ctrl.draw_circle(center, radius, Color(1, 1, 1, 0.1))
		ctrl.draw_arc(center, radius, 0, TAU, 64, Color(1, 1, 1, 0.2), 1.2, true)
		return
	
	var colors = team_data["colors"]
	var short_name = team_data.get("short", "")
	
	ctrl.draw_circle(center, radius, colors[0])
	
	var stripe_w = (radius * 2.0) / 6.0
	for x in range(int(-radius), int(radius)):
		var stripe_index = int((x + radius) / stripe_w)
		if stripe_index % 2 != 0:
			var y = sqrt(max(0, radius * radius - x * x))
			ctrl.draw_line(center + Vector2(x, -y), center + Vector2(x, y), colors[1], 1.0)
			
	var skin_id = Global.equipped_ball_skin
	Global.draw_ball_skin(ctrl, center, radius, skin_id)

	# Draw team mascot badge if available
	if badge_textures.has(short_name):
		var badge_tex = badge_textures[short_name]
		if badge_tex:
			var bs = Vector2(72, 72)
			ctrl.draw_texture_rect(badge_tex, Rect2(center - bs / 2.0, bs), false)

	# Draw favorite team crown cosmetic on top of ball preview
	if (team_name == Global.favorite_team or (Global.favorite_team != "" and short_name == Global.TEAMS.get(Global.favorite_team, {}).get("short", ""))) and Global.equipped_hat != "none" and Global.HATS.has(Global.equipped_hat):
		var hat_path = Global.HATS[Global.equipped_hat]["texture_path"]
		if ResourceLoader.exists(hat_path):
			var h_tex = load(hat_path)
			if h_tex:
				var hw = 50.0
				var hh = 35.0
				var hr = Rect2(center.x - hw / 2.0, center.y - radius - hh + 12.0, hw, hh)
				ctrl.draw_texture_rect(h_tex, hr, false)

func add_centered_toggle_to_vbox(parent: Control, id: String, lang_key: String, default_val: bool):
	var cont = VBoxContainer.new()
	cont.alignment = BoxContainer.ALIGNMENT_CENTER
	cont.add_theme_constant_override("separation", 10)
	parent.add_child(cont)
	
	var lbl = create_label_node(lang_key, white, 30)
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	cont.add_child(lbl)
	
	var btn = Button.new()
	btn.custom_minimum_size = Vector2(200, 60)
	btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	btn.add_theme_font_override("font", custom_font)
	btn.add_theme_font_size_override("font_size", 30)
	
	var update_btn = func(st: bool):
		var sb = StyleBoxFlat.new()
		sb.corner_radius_top_left = 15; sb.corner_radius_top_right = 15
		sb.corner_radius_bottom_left = 15; sb.corner_radius_bottom_right = 15
		sb.content_margin_top = 10; sb.content_margin_bottom = 10
		if st:
			sb.bg_color = active_theme.accent
			btn.text = LANG[Global.current_lang]["ON"]
			btn.add_theme_color_override("font_color", Color.WHITE)
		else:
			sb.bg_color = Color8(40, 45, 55, 230)
			btn.text = LANG[Global.current_lang]["OFF"]
			btn.add_theme_color_override("font_color", Color8(180, 180, 180))
		btn.add_theme_stylebox_override("normal", sb)
		btn.add_theme_stylebox_override("hover", sb)
		btn.add_theme_stylebox_override("pressed", sb)
		
		# Trigger side-effects if needed
		if id == "SHAKE": temp_settings["shake_enabled"] = st
		elif id == "VIBRATION": temp_settings["vibration_enabled"] = st
	
	# Initial state
	update_btn.call(default_val)
	
	btn.pressed.connect(func():
		var is_on = false
		if id == "SHAKE": is_on = not temp_settings["shake_enabled"]
		elif id == "VIBRATION": is_on = not temp_settings.get("vibration_enabled", true)
		update_btn.call(is_on)
		Global.play_click()
	)
	
	cont.add_child(btn)

func populate_teams():
	if not home_list or not away_list: return
	
	for child in home_list.get_children(): 
		home_list.remove_child(child); child.queue_free()
	for child in away_list.get_children(): 
		away_list.remove_child(child); child.queue_free()
	
	var shared_btn_style = StyleBoxFlat.new()
	shared_btn_style.bg_color = active_theme.bg_bottom
	shared_btn_style.border_width_bottom = 3
	shared_btn_style.border_color = active_theme.accent.darkened(0.5)
	shared_btn_style.corner_radius_top_left = 12; shared_btn_style.corner_radius_top_right = 12
	shared_btn_style.corner_radius_bottom_left = 12; shared_btn_style.corner_radius_bottom_right = 12

	var txt_filter_home = search_bar_home.text.to_lower() if search_bar_home else ""
	var txt_filter_away = search_bar_away.text.to_lower() if search_bar_away else ""
	var lg_filter_h = "TURKEY"
	if league_dropdown_home and league_dropdown_home.item_count > 0:
		var meta = league_dropdown_home.get_item_metadata(league_dropdown_home.selected)
		lg_filter_h = meta if meta != null else league_dropdown_home.get_item_text(league_dropdown_home.selected)
	var lg_filter_a = "TURKEY"
	if league_dropdown_away and league_dropdown_away.item_count > 0:
		var meta = league_dropdown_away.get_item_metadata(league_dropdown_away.selected)
		lg_filter_a = meta if meta != null else league_dropdown_away.get_item_text(league_dropdown_away.selected)
	
	var create_team_btn = func(team: String, is_home_col: bool) -> Button:
		var btn = Button.new()
		btn.mouse_filter = Control.MOUSE_FILTER_PASS
		btn.custom_minimum_size = Vector2(320, 76)
		
		var is_active = (team == Global.home_team_name) if is_home_col else (team == Global.away_team_name)
		var btn_style = shared_btn_style
		if is_active:
			btn_style = shared_btn_style.duplicate()
			btn_style.bg_color = active_theme.bg_bottom.lightened(0.06)
			btn_style.border_color = active_theme.accent
			btn_style.border_width_left = 2
			btn_style.border_width_right = 2
			btn_style.border_width_top = 2
			btn_style.border_width_bottom = 4
			btn_style.shadow_color = active_theme.accent.darkened(0.4)
			btn_style.shadow_color.a = 0.35
			btn_style.shadow_size = 6
		
		var btn_hover = btn_style.duplicate()
		btn_hover.bg_color = btn_style.bg_color.lightened(0.05)
		
		var btn_pressed = btn_style.duplicate()
		btn_pressed.border_width_bottom = 0
		btn_pressed.content_margin_top = 3

		btn.add_theme_stylebox_override("normal", btn_style)
		btn.add_theme_stylebox_override("hover", btn_hover)
		btn.add_theme_stylebox_override("pressed", btn_pressed)
		btn.add_theme_stylebox_override("focus", btn_style)
		
		# HBox to align label and star
		var hbox = HBoxContainer.new()
		hbox.alignment = BoxContainer.ALIGNMENT_CENTER
		hbox.set_anchors_preset(Control.PRESET_FULL_RECT)
		hbox.mouse_filter = Control.MOUSE_FILTER_PASS
		btn.add_child(hbox)
		
		var lbl = Label.new()
		lbl.text = team
		lbl.add_theme_font_override("font", custom_font)
		lbl.add_theme_font_size_override("font_size", 28)
		
		if is_active:
			lbl.add_theme_color_override("font_color", active_theme.accent)
		elif team == Global.favorite_team:
			lbl.add_theme_color_override("font_color", Color8(255, 215, 0))
		else:
			lbl.add_theme_color_override("font_color", Color.WHITE)
		hbox.add_child(lbl)
			
		btn.pressed.connect(func():
			Global.play_click()
			if is_home_col:
				Global.home_team_name = team
				home_selected = true
				Global.home_selected = true
			else:
				Global.away_team_name = team
				away_selected = true
				Global.away_selected = true
			Global.save_progression()
			populate_teams()
		)
		return btn
	
	for team in TEAM_NAMES:
		var team_league = Global.TEAMS[team].get("league", "WORLD")
		
		# Home column filtering
		if (lg_filter_h == "ALL" or lg_filter_h == "SELECT" or lg_filter_h == "All Teams" or team_league == lg_filter_h) and (txt_filter_home == "" or txt_filter_home in team.to_lower()):
			home_list.add_child(create_team_btn.call(team, true))
			
		# Away column filtering
		if (lg_filter_a == "ALL" or lg_filter_a == "SELECT" or lg_filter_a == "All Teams" or team_league == lg_filter_a) and (txt_filter_away == "" or txt_filter_away in team.to_lower()):
			away_list.add_child(create_team_btn.call(team, false))
			
	if is_instance_valid(home_lbl):
		for child in home_lbl.get_children():
			child.queue_free()
		
		var text_val = Global.home_team_name
			
		home_lbl.text = ""
		var hbox = HBoxContainer.new()
		hbox.alignment = BoxContainer.ALIGNMENT_CENTER
		hbox.set_anchors_preset(Control.PRESET_FULL_RECT)
		home_lbl.add_child(hbox)
		
		var t_lbl = Label.new()
		t_lbl.text = text_val
		t_lbl.add_theme_font_override("font", custom_font)
		t_lbl.add_theme_font_size_override("font_size", 32)
		t_lbl.add_theme_color_override("font_shadow_color", Color8(0, 0, 0, 180))
		t_lbl.add_theme_constant_override("shadow_offset_y", 4)
		t_lbl.add_theme_constant_override("shadow_offset_x", 0)
		t_lbl.add_theme_constant_override("shadow_outline_size", 3)
		t_lbl.add_theme_color_override("font_outline_color", Color8(0, 0, 0, 150))
		t_lbl.add_theme_constant_override("outline_size", 3)
		if Global.home_team_name == Global.favorite_team:
			t_lbl.add_theme_color_override("font_color", Color8(255, 215, 0))
		else:
			t_lbl.add_theme_color_override("font_color", Color.WHITE)
		hbox.add_child(t_lbl)
			
	if is_instance_valid(away_lbl):
		for child in away_lbl.get_children():
			child.queue_free()
		
		var text_val = Global.away_team_name
			
		away_lbl.text = ""
		var hbox = HBoxContainer.new()
		hbox.alignment = BoxContainer.ALIGNMENT_CENTER
		hbox.set_anchors_preset(Control.PRESET_FULL_RECT)
		away_lbl.add_child(hbox)
		
		var t_lbl = Label.new()
		t_lbl.text = text_val
		t_lbl.add_theme_font_override("font", custom_font)
		t_lbl.add_theme_font_size_override("font_size", 32)
		t_lbl.add_theme_color_override("font_shadow_color", Color8(0, 0, 0, 180))
		t_lbl.add_theme_constant_override("shadow_offset_y", 4)
		t_lbl.add_theme_constant_override("shadow_offset_x", 0)
		t_lbl.add_theme_constant_override("shadow_outline_size", 3)
		t_lbl.add_theme_color_override("font_outline_color", Color8(0, 0, 0, 150))
		t_lbl.add_theme_constant_override("outline_size", 3)
		if away_selected and Global.away_team_name == Global.favorite_team:
			t_lbl.add_theme_color_override("font_color", Color8(255, 215, 0))
		else:
			t_lbl.add_theme_color_override("font_color", Color.WHITE)
		hbox.add_child(t_lbl)
			
	if home_preview: home_preview.queue_redraw()
	if away_preview: away_preview.queue_redraw()
	_update_fav_buttons()

func _set_favorite_team(is_home: bool):
	Global.play_click()
	var target_team = Global.home_team_name if is_home else Global.away_team_name
	
	if Global.favorite_team != "" and Global.favorite_team != target_team:
		show_fav_change_confirmation(target_team)
	else:
		_execute_favorite_team_change(target_team)

func show_fav_change_confirmation(target_team: String):
	# Dimmed background overlay
	var bg_overlay = ColorRect.new()
	bg_overlay.color = Color8(0, 0, 0, 180)
	bg_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg_overlay)
	
	var dlg = PanelContainer.new()
	var dlg_style = StyleBoxFlat.new()
	dlg_style.bg_color = active_theme.bg_bottom
	dlg_style.corner_radius_top_left = 20; dlg_style.corner_radius_top_right = 20
	dlg_style.corner_radius_bottom_left = 20; dlg_style.corner_radius_bottom_right = 20
	dlg_style.border_width_top = 3; dlg_style.border_width_bottom = 3
	dlg_style.border_width_left = 3; dlg_style.border_width_right = 3
	dlg_style.border_color = active_theme.accent
	dlg_style.shadow_color = Color8(0, 0, 0, 180)
	dlg_style.shadow_size = 30
	dlg_style.content_margin_left = 40; dlg_style.content_margin_right = 40
	dlg_style.content_margin_top = 35; dlg_style.content_margin_bottom = 35
	dlg.add_theme_stylebox_override("panel", dlg_style)
	dlg.custom_minimum_size = Vector2(600, 0)

	var dlg_center = CenterContainer.new()
	dlg_center.set_anchors_preset(Control.PRESET_FULL_RECT)
	dlg_center.add_child(dlg)
	bg_overlay.add_child(dlg_center)

	var dlg_vbox = VBoxContainer.new()
	dlg_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	dlg_vbox.add_theme_constant_override("separation", 25)
	dlg.add_child(dlg_vbox)

	var lang = Global.current_lang
	
	var dlg_title = Label.new()
	dlg_title.text = LANG[lang]["FAV_CONFIRM_TITLE"]
	dlg_title.add_theme_font_override("font", custom_font)
	dlg_title.add_theme_font_size_override("font_size", 44)
	dlg_title.add_theme_color_override("font_color", active_theme.accent)
	dlg_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	dlg_vbox.add_child(dlg_title)

	var dlg_desc = Label.new()
	dlg_desc.text = LANG[lang]["FAV_CONFIRM_DESC"] % target_team
	dlg_desc.add_theme_font_override("font", custom_font)
	dlg_desc.add_theme_font_size_override("font_size", 28)
	dlg_desc.add_theme_color_override("font_color", Color.WHITE)
	dlg_desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	dlg_desc.autowrap_mode = TextServer.AUTOWRAP_WORD
	dlg_vbox.add_child(dlg_desc)

	var dlg_hbox = HBoxContainer.new()
	dlg_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	dlg_hbox.add_theme_constant_override("separation", 20)
	dlg_vbox.add_child(dlg_hbox)

	var cancel_btn = Button.new()
	cancel_btn.text = LANG[lang]["SHOP_CANCEL"]
	cancel_btn.add_theme_font_override("font", custom_font)
	cancel_btn.add_theme_font_size_override("font_size", 28)
	var cancel_style = StyleBoxFlat.new()
	cancel_style.bg_color = Color8(60, 60, 80, 220)
	cancel_style.corner_radius_top_left = 12; cancel_style.corner_radius_top_right = 12
	cancel_style.corner_radius_bottom_left = 12; cancel_style.corner_radius_bottom_right = 12
	cancel_btn.add_theme_stylebox_override("normal", cancel_style)
	cancel_btn.add_theme_stylebox_override("hover", cancel_style)
	cancel_btn.add_theme_stylebox_override("pressed", cancel_style)
	cancel_btn.add_theme_stylebox_override("focus", cancel_style)
	cancel_btn.custom_minimum_size = Vector2(200, 65)
	cancel_btn.pressed.connect(func():
		Global.play_click()
		bg_overlay.queue_free()
	)
	dlg_hbox.add_child(cancel_btn)

	var confirm_btn = Button.new()
	confirm_btn.text = LANG[lang]["CONFIRM_YES"]
	confirm_btn.add_theme_font_override("font", custom_font)
	confirm_btn.add_theme_font_size_override("font_size", 28)
	confirm_btn.add_theme_color_override("font_color", Color.WHITE)
	var confirm_style = StyleBoxFlat.new()
	confirm_style.bg_color = active_theme.accent
	confirm_style.corner_radius_top_left = 12; confirm_style.corner_radius_top_right = 12
	confirm_style.corner_radius_bottom_left = 12; confirm_style.corner_radius_bottom_right = 12
	confirm_btn.add_theme_stylebox_override("normal", confirm_style)
	confirm_btn.add_theme_stylebox_override("hover", confirm_style)
	confirm_btn.add_theme_stylebox_override("pressed", confirm_style)
	confirm_btn.add_theme_stylebox_override("focus", confirm_style)
	confirm_btn.custom_minimum_size = Vector2(200, 65)
	confirm_btn.pressed.connect(func():
		Global.play_click()
		_execute_favorite_team_change(target_team)
		bg_overlay.queue_free()
	)
	dlg_hbox.add_child(confirm_btn)

func _execute_favorite_team_change(target_team: String):
	Global.favorite_team = target_team
	Global.save_progression()
	populate_teams()
	_refresh_stats_tab()

func _refresh_stats_tab():
	if not is_instance_valid(tabs_hbox) or tabs_hbox.get_child_count() == 0: return
	var stats_node = tabs_hbox.get_child(0)
	if stats_node and not stats_node.name.ends_with("_Placeholder"):
		var sw = get_viewport_rect().size.x
		var sh = get_viewport_rect().size.y
		tabs_hbox.remove_child(stats_node)
		stats_node.queue_free()
		var new_stats = _build_stats_tab()
		new_stats.custom_minimum_size = Vector2(sw, sh)
		new_stats.size_flags_vertical = Control.SIZE_EXPAND_FILL
		tabs_hbox.add_child(new_stats)
		tabs_hbox.move_child(new_stats, 0)
		_connect_all_buttons(new_stats)

func _update_fav_buttons():
	if not is_instance_valid(fav_h_btn) or not is_instance_valid(fav_a_btn): return
	
	var lang = Global.current_lang
	
	var style_fav_btn = func(btn: Button, text_val: String, is_disabled: bool, is_gold: bool):
		for child in btn.get_children():
			child.queue_free()
		btn.text = ""
		btn.disabled = is_disabled
		btn.custom_minimum_size = Vector2(210, 48)
		btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		
		# Sleek rounded pill StyleBox
		var p_style = StyleBoxFlat.new()
		p_style.corner_radius_top_left = 24; p_style.corner_radius_top_right = 24
		p_style.corner_radius_bottom_left = 24; p_style.corner_radius_bottom_right = 24
		p_style.content_margin_left = 14; p_style.content_margin_right = 14
		p_style.content_margin_top = 4; p_style.content_margin_bottom = 4
		
		if is_gold:
			p_style.bg_color = Color8(40, 32, 5, 235) # Warm dark gold
			p_style.border_width_left = 2; p_style.border_width_right = 2
			p_style.border_width_top = 2; p_style.border_width_bottom = 3
			p_style.border_color = Color8(255, 215, 0, 240) # Bright gold border
			p_style.shadow_color = Color8(255, 215, 0, 70)
			p_style.shadow_size = 10
		else:
			p_style.bg_color = Color8(0, 20, 45, 175) # Navy glass
			p_style.border_width_left = 1; p_style.border_width_right = 1
			p_style.border_width_top = 1; p_style.border_width_bottom = 2
			p_style.border_color = Color8(255, 255, 255, 65)
			p_style.shadow_color = Color8(0, 0, 0, 90)
			p_style.shadow_size = 6
			
		var p_hover = p_style.duplicate()
		if not is_gold:
			p_hover.bg_color = Color8(0, 35, 75, 210)
			p_hover.border_color = active_theme.accent
		
		var p_pressed = p_style.duplicate()
		p_pressed.border_width_bottom = 1
		p_pressed.content_margin_top = 6
		
		btn.add_theme_stylebox_override("normal", p_style)
		btn.add_theme_stylebox_override("hover", p_hover)
		btn.add_theme_stylebox_override("pressed", p_pressed)
		btn.add_theme_stylebox_override("disabled", p_style)
		btn.add_theme_stylebox_override("focus", p_style)
		
		var hbox = HBoxContainer.new()
		hbox.alignment = BoxContainer.ALIGNMENT_CENTER
		hbox.set_anchors_preset(Control.PRESET_FULL_RECT)
		hbox.mouse_filter = Control.MOUSE_FILTER_PASS
		hbox.add_theme_constant_override("separation", 8)
		btn.add_child(hbox)
		
		var lbl = Label.new()
		lbl.text = text_val
		lbl.add_theme_font_override("font", custom_font)
		lbl.add_theme_font_size_override("font_size", 22)
		if is_gold:
			lbl.add_theme_color_override("font_color", Color8(255, 215, 0))
		else:
			lbl.add_theme_color_override("font_color", Color8(240, 245, 255))
		lbl.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		hbox.add_child(lbl)
		
	if Global.favorite_team == Global.home_team_name:
		style_fav_btn.call(fav_h_btn, LANG[lang]["FAV_YOURS"], true, true)
	else:
		style_fav_btn.call(fav_h_btn, LANG[lang]["FAV_MAKE"], false, false)
		
	if Global.favorite_team == Global.away_team_name:
		style_fav_btn.call(fav_a_btn, LANG[lang]["FAV_YOURS"], true, true)
	else:
		style_fav_btn.call(fav_a_btn, LANG[lang]["FAV_MAKE"], false, false)

const LEAGUE_FILTER_CONFIG = [
	{"key": "LEAGUE_SELECT", "id": "SELECT"},
	{"key": "LEAGUE_TURKEY", "id": "TURKEY"},
	{"key": "LEAGUE_NATIONAL", "id": "NATIONAL"},
	{"key": "LEAGUE_ENGLAND", "id": "ENGLAND"},
	{"key": "LEAGUE_SPAIN", "id": "SPAIN"},
	{"key": "LEAGUE_GERMANY", "id": "GERMANY"},
	{"key": "LEAGUE_ITALY", "id": "ITALY"},
	{"key": "LEAGUE_FRANCE", "id": "FRANCE"},
	{"key": "LEAGUE_USA", "id": "USA"},
	{"key": "LEAGUE_SAUDI", "id": "SAUDI"},
	{"key": "LEAGUE_WORLD", "id": "WORLD"},
	{"key": "LEAGUE_ALL", "id": "ALL"}
]

func setup_filters():
	var lang = Global.current_lang
	if league_dropdown_home:
		var prev_sel_h = league_dropdown_home.selected if league_dropdown_home.item_count > 0 else 1
		league_dropdown_home.clear()
		league_dropdown_home.alignment = HORIZONTAL_ALIGNMENT_CENTER
		league_dropdown_home.add_theme_font_override("font", custom_font)
		league_dropdown_home.add_theme_font_size_override("font_size", 32)
		for i in range(LEAGUE_FILTER_CONFIG.size()):
			var item = LEAGUE_FILTER_CONFIG[i]
			var text_val = LANG[lang].get(item.key, item.id)
			league_dropdown_home.add_item(text_val)
			league_dropdown_home.set_item_metadata(i, item.id)
		league_dropdown_home.select(prev_sel_h if prev_sel_h >= 0 and prev_sel_h < league_dropdown_home.item_count else 1)
		style_popup_menu(league_dropdown_home.get_popup())
			
	if league_dropdown_away:
		var prev_sel_a = league_dropdown_away.selected if league_dropdown_away.item_count > 0 else 1
		league_dropdown_away.clear()
		league_dropdown_away.alignment = HORIZONTAL_ALIGNMENT_CENTER
		league_dropdown_away.add_theme_font_override("font", custom_font)
		league_dropdown_away.add_theme_font_size_override("font_size", 32)
		for i in range(LEAGUE_FILTER_CONFIG.size()):
			var item = LEAGUE_FILTER_CONFIG[i]
			var text_val = LANG[lang].get(item.key, item.id)
			league_dropdown_away.add_item(text_val)
			league_dropdown_away.set_item_metadata(i, item.id)
		league_dropdown_away.select(prev_sel_a if prev_sel_a >= 0 and prev_sel_a < league_dropdown_away.item_count else 1)
		style_popup_menu(league_dropdown_away.get_popup())
		
	if search_bar_home:
		search_bar_home.placeholder_text = LANG[Global.current_lang]["SEARCH"]
		search_bar_home.add_theme_font_override("font", custom_font)
		search_bar_home.add_theme_font_size_override("font_size", 25)
		
	if search_bar_away:
		search_bar_away.placeholder_text = LANG[Global.current_lang]["SEARCH"]
		search_bar_away.add_theme_font_override("font", custom_font)
		search_bar_away.add_theme_font_size_override("font_size", 25)

func _on_filter_changed(_arg = null):
	populate_teams()

func _change_language(lang_code: String):
	Global.current_lang = lang_code
	if is_instance_valid(lang_btn):
		lang_btn.text = " " + Global.current_lang
	
	update_theme_visuals()
	setup_filters()
	populate_teams()
	_update_fav_buttons()
	_refresh_stats_tab()
	_refresh_shop_tab()
	
	if is_instance_valid(tabs_hbox):
		var sw = get_viewport_rect().size.x
		tabs_hbox.position.x = -current_tab * sw
	
	if is_instance_valid(burger_menu_overlay):
		burger_menu_overlay.queue_free()
		burger_menu_overlay = null

func _on_lang_dropdown_selected(idx: int):
	var lang_map = {0: "TR", 1: "ENG", 2: "ESP", 3: "POR", 4: "ITA"}
	_change_language(lang_map.get(idx, "TR"))

func _on_start_match():
	if is_instance_valid(Global.bg_music_player):
		Global.bg_music_player.stop()
	Global.remove_all_banners()
	menu_banner_ad_id = ""
	get_tree().change_scene_to_file("res://pitch.tscn")

func _on_random_team_pressed(is_home: bool):
	Global.play_click()
	var teams = Global.TEAMS.keys()
	if teams.is_empty(): return
	var rand_team = teams[randi() % teams.size()]
	if is_home:
		Global.home_team_name = rand_team
		home_selected = true
		Global.home_selected = true
	else:
		Global.away_team_name = rand_team
		away_selected = true
		Global.away_selected = true
	Global.save_progression()
	populate_teams()

# ======================================================
# TAB NAVIGATION HELPERS
# ======================================================

func _init_tab_sizes():
	# Set each page's minimum width and height to screen dimensions
	var sw = get_viewport_rect().size.x
	var sh = get_viewport_rect().size.y
	tabs_hbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	for child in tabs_hbox.get_children():
		child.custom_minimum_size = Vector2(sw, sh)
		child.size_flags_vertical = Control.SIZE_EXPAND_FILL

func _switch_tab(idx: int, instant: bool = false):
	var sw = get_viewport_rect().size.x
	var sh = get_viewport_rect().size.y
	
	# Lazy Load check
	if tabs_hbox and tabs_hbox.get_child_count() > idx:
		var target_node = tabs_hbox.get_child(idx)
		if target_node.name.ends_with("_Placeholder"):
			var real_page: Control = null
			if idx == 0:
				real_page = _build_stats_tab()
			elif idx == 2:
				real_page = _build_shop_tab()
			
			if real_page:
				real_page.custom_minimum_size = Vector2(sw, sh)
				real_page.size_flags_vertical = Control.SIZE_EXPAND_FILL
				tabs_hbox.remove_child(target_node)
				target_node.queue_free()
				tabs_hbox.add_child(real_page)
				tabs_hbox.move_child(real_page, idx)
				_connect_all_buttons(real_page)
				update_theme_visuals()

	current_tab = idx
	var target_x = -idx * sw
	if is_instance_valid(tabs_hbox):
		if instant:
			tabs_hbox.position.x = target_x
		else:
			var tw = create_tween()
			tw.set_ease(Tween.EASE_OUT)
			tw.set_trans(Tween.TRANS_CUBIC)
			tw.tween_property(tabs_hbox, "position:x", target_x, 0.28)
	# Update nav button visuals
	for i in range(nav_bar_btns.size()):
		var btn_data = nav_bar_btns[i]
		var is_active = (i == idx)
		var btn: Button = btn_data["btn"]
		var indicator: Control = btn_data["indicator"]
		if is_active:
			btn.modulate = Color.WHITE
			indicator.visible = true
		else:
			btn.modulate = Color(1, 1, 1, 0.45)
			indicator.visible = false

func _build_bottom_nav():
	var sw = get_viewport_rect().size.x
	nav_bar_panel = PanelContainer.new()
	var nb_style = StyleBoxFlat.new()
	nb_style.bg_color = active_theme.bg_top
	nb_style.bg_color.a = 0.97
	nb_style.corner_radius_top_left = 22; nb_style.corner_radius_top_right = 22
	nb_style.shadow_color = Color8(0, 0, 0, 120)
	nb_style.shadow_size = 18
	nb_style.shadow_offset = Vector2(0, -4)
	nb_style.border_width_top = 2
	nb_style.border_color = active_theme.accent.darkened(0.4)
	nb_style.content_margin_left = 0
	nb_style.content_margin_right = 0
	nb_style.content_margin_top = 15
	nb_style.content_margin_bottom = 20
	nav_bar_panel.add_theme_stylebox_override("panel", nb_style)
	nav_bar_panel.custom_minimum_size = Vector2(sw, 90)
	nav_bar_panel.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	nav_bar_panel.grow_vertical = Control.GROW_DIRECTION_BEGIN
	add_child(nav_bar_panel)

	var nav_hbox = HBoxContainer.new()
	nav_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	nav_hbox.add_theme_constant_override("separation", 0)
	nav_hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	nav_hbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	nav_bar_panel.add_child(nav_hbox)

	var icons = [
		preload("res://statsicon.svg"),
		preload("res://homeicon.svg"),
		preload("res://shoppingcarticon.svg")
	]

	var sep_style = StyleBoxFlat.new()
	sep_style.bg_color = active_theme.accent.darkened(0.55)

	for i in range(3):
		# Thin separator before 2nd and 3rd buttons
		if i > 0:
			var sep = VSeparator.new()
			sep.add_theme_stylebox_override("separator", sep_style)
			sep.custom_minimum_size = Vector2(2, 50)
			sep.size_flags_vertical = Control.SIZE_SHRINK_CENTER
			nav_hbox.add_child(sep)

		# Container per button for indicator line
		var btn_vbox = VBoxContainer.new()
		btn_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
		btn_vbox.add_theme_constant_override("separation", 2)
		btn_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn_vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
		nav_hbox.add_child(btn_vbox)

		# The button itself
		var n_btn = Button.new()
		n_btn.icon = icons[i]
		n_btn.expand_icon = true
		n_btn.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		n_btn.custom_minimum_size = Vector2(0, 56)
		n_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		# 3D look: gradient shadow stylebox
		var n_style_normal = StyleBoxFlat.new()
		n_style_normal.bg_color = Color(0, 0, 0, 0)
		n_style_normal.shadow_color = Color8(0, 0, 0, 60)
		n_style_normal.shadow_size = 4
		n_style_normal.shadow_offset = Vector2(0, 2)
		n_btn.add_theme_stylebox_override("normal", n_style_normal)
		n_btn.add_theme_stylebox_override("hover", n_style_normal)
		n_btn.add_theme_stylebox_override("focus", n_style_normal)

		var n_style_pressed = StyleBoxFlat.new()
		n_style_pressed.bg_color = active_theme.accent.darkened(0.6)
		n_style_pressed.bg_color.a = 0.25
		n_style_pressed.corner_radius_top_left = 10; n_style_pressed.corner_radius_top_right = 10
		n_style_pressed.corner_radius_bottom_left = 10; n_style_pressed.corner_radius_bottom_right = 10
		n_btn.add_theme_stylebox_override("pressed", n_style_pressed)

		n_btn.add_theme_constant_override("icon_max_width", 40)
		btn_vbox.add_child(n_btn)
		
		if i == 2:
			shop_notification_dot = Panel.new()
			var dot_style = StyleBoxFlat.new()
			dot_style.bg_color = Color8(245, 60, 60)
			dot_style.corner_radius_top_left = 12
			dot_style.corner_radius_top_right = 12
			dot_style.corner_radius_bottom_left = 12
			dot_style.corner_radius_bottom_right = 12
			dot_style.border_width_left = 2; dot_style.border_width_top = 2; dot_style.border_width_right = 2; dot_style.border_width_bottom = 2
			dot_style.border_color = Color8(10, 15, 25)
			shop_notification_dot.add_theme_stylebox_override("panel", dot_style)
			shop_notification_dot.custom_minimum_size = Vector2(14, 14)
			shop_notification_dot.mouse_filter = Control.MOUSE_FILTER_IGNORE
			shop_notification_dot.anchor_left = 0.5
			shop_notification_dot.anchor_right = 0.5
			shop_notification_dot.anchor_top = 0.5
			shop_notification_dot.anchor_bottom = 0.5
			shop_notification_dot.offset_left = 8
			shop_notification_dot.offset_top = -22
			shop_notification_dot.offset_right = 22
			shop_notification_dot.offset_bottom = -8
			n_btn.add_child(shop_notification_dot)

		# Accent indicator line under active button
		var indicator = Control.new()
		indicator.custom_minimum_size = Vector2(40, 3)
		indicator.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		var ind_draw_target = indicator
		var accent_col = active_theme.accent
		ind_draw_target.draw.connect(func():
			ind_draw_target.draw_rect(Rect2(Vector2.ZERO, ind_draw_target.size), accent_col, true, -1.0)
		)
		indicator.visible = false
		btn_vbox.add_child(indicator)

		# Connect
		var tab_idx = i
		n_btn.pressed.connect(func(): _switch_tab(tab_idx))

		nav_bar_btns.append({"btn": n_btn, "indicator": indicator})

# ======================================================
# STATS TAB (Rich, Balanced & Highly Legible Sports Dashboard)
# ======================================================
func _build_stats_tab() -> Control:
	var sw = get_viewport_rect().size.x
	var sh = get_viewport_rect().size.y
	var page = Control.new()
	page.custom_minimum_size = Vector2(sw, sh)
	page.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	page.size_flags_vertical = Control.SIZE_EXPAND_FILL

	var margin = MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	margin.add_theme_constant_override("margin_left", 20)
	margin.add_theme_constant_override("margin_right", 20)
	margin.add_theme_constant_override("margin_top", 145)
	margin.add_theme_constant_override("margin_bottom", 90)
	page.add_child(margin)

	var main_vbox = VBoxContainer.new()
	main_vbox.alignment = BoxContainer.ALIGNMENT_BEGIN
	main_vbox.add_theme_constant_override("separation", 10)
	main_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main_vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_child(main_vbox)

	# --- Header Row (Matches Main Menu Top Bar Exactly: 660x60, separation 10) ---
	var top_hbox = HBoxContainer.new()
	top_hbox.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	top_hbox.custom_minimum_size = Vector2(660, 60)
	top_hbox.add_theme_constant_override("separation", 10)
	main_vbox.add_child(top_hbox)

	var left_box = Control.new()
	left_box.custom_minimum_size = Vector2(125, 60)
	top_hbox.add_child(left_box)

	var sp1 = Control.new(); sp1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_hbox.add_child(sp1)

	var title = create_label_node("STATS_TITLE", white, 55)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_color_override("font_shadow_color", Color8(0, 0, 0, 150))
	title.add_theme_constant_override("shadow_offset_y", 4)
	top_hbox.add_child(title)

	var sp2 = Control.new(); sp2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_hbox.add_child(sp2)

	var lead_box = HBoxContainer.new()
	lead_box.alignment = BoxContainer.ALIGNMENT_END
	lead_box.custom_minimum_size = Vector2(125, 60)
	top_hbox.add_child(lead_box)
	
	var lead_btn = Button.new()
	lead_btn.icon = preload("res://trophy_icon.svg")
	lead_btn.expand_icon = true
	lead_btn.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lead_btn.add_theme_constant_override("icon_max_width", 32)
	lead_btn.custom_minimum_size = Vector2(60, 56)
	lead_btn.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	
	var lb_style = StyleBoxFlat.new()
	lb_style.bg_color = active_theme.bg_bottom.darkened(0.2)
	lb_style.corner_radius_top_left = 16; lb_style.corner_radius_top_right = 16
	lb_style.corner_radius_bottom_left = 16; lb_style.corner_radius_bottom_right = 16
	lb_style.border_width_left = 1.5; lb_style.border_width_right = 1.5
	lb_style.border_width_top = 1.5; lb_style.border_width_bottom = 3.5
	lb_style.border_color = active_theme.accent
	lb_style.shadow_color = Color8(0, 0, 0, 100)
	lb_style.shadow_size = 6
	lb_style.content_margin_left = 10; lb_style.content_margin_right = 10
	lb_style.content_margin_top = 6; lb_style.content_margin_bottom = 6
	
	var lb_hover = lb_style.duplicate()
	lb_hover.bg_color = active_theme.bg_bottom.darkened(0.1)
	lb_hover.border_color = active_theme.accent.lightened(0.2)
	
	var lb_pressed = lb_style.duplicate()
	lb_pressed.border_width_bottom = 1.5
	lb_pressed.content_margin_top = 8
	
	lead_btn.add_theme_stylebox_override("normal", lb_style)
	lead_btn.add_theme_stylebox_override("hover", lb_hover)
	lead_btn.add_theme_stylebox_override("pressed", lb_pressed)
	lead_btn.add_theme_stylebox_override("focus", lb_style)
	lead_btn.pressed.connect(_open_leaderboard)
	lead_box.add_child(lead_btn)

	# Main Menu Style Horizontal Separator Line
	var stats_sep = HSeparator.new()
	main_vbox.add_child(stats_sep)
	ui_separators.append(stats_sep)

	# --- Scroll Container for Cards ---
	var scroll = ScrollContainer.new()
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	main_vbox.add_child(scroll)

	var vbox = VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_BEGIN
	vbox.add_theme_constant_override("separation", 12)
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(vbox)

	var history = Global.match_history
	var lang = Global.current_lang
	var is_buz = (Global.current_theme == "Buz")

	# Helper to create theme-harmonized styled card panels
	var create_card_panel = func() -> PanelContainer:
		var card = PanelContainer.new()
		var cs = StyleBoxFlat.new()
		var card_bg = active_theme.bg_bottom.darkened(0.65) if is_buz else active_theme.bg_bottom.darkened(0.18)
		cs.bg_color = Color(card_bg.r, card_bg.g, card_bg.b, 0.95)
		cs.corner_radius_top_left = 18; cs.corner_radius_top_right = 18
		cs.corner_radius_bottom_left = 18; cs.corner_radius_bottom_right = 18
		cs.border_width_left = 1.5; cs.border_width_right = 1.5
		cs.border_width_top = 1.5; cs.border_width_bottom = 4.0
		cs.border_color = active_theme.accent.darkened(0.25)
		cs.shadow_color = Color8(0, 0, 0, 80)
		cs.shadow_size = 8
		cs.shadow_offset = Vector2(0, 4)
		cs.content_margin_left = 16; cs.content_margin_right = 16
		cs.content_margin_top = 10; cs.content_margin_bottom = 10
		card.add_theme_stylebox_override("panel", cs)
		return card

	# Helper to create large, readable stat tile
	var create_stat_tile = func(label_key: String, val_str: String, sub_str: String = "", sub_color: Color = Color.WHITE, icon_tex: Texture2D = null) -> PanelContainer:
		var p = PanelContainer.new()
		var ps = StyleBoxFlat.new()
		var cell_bg = active_theme.bg_bottom.darkened(0.75) if is_buz else active_theme.bg_bottom.darkened(0.38)
		ps.bg_color = Color(cell_bg.r, cell_bg.g, cell_bg.b, 0.94)
		ps.corner_radius_top_left = 12; ps.corner_radius_top_right = 12
		ps.corner_radius_bottom_left = 12; ps.corner_radius_bottom_right = 12
		ps.border_width_left = 1.0; ps.border_width_right = 1.0
		ps.border_width_top = 1.0; ps.border_width_bottom = 2.5
		ps.border_color = active_theme.accent.darkened(0.4)
		ps.content_margin_left = 12; ps.content_margin_right = 12
		ps.content_margin_top = 8; ps.content_margin_bottom = 8
		p.add_theme_stylebox_override("panel", ps)
		p.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		var inner_vb = VBoxContainer.new()
		inner_vb.alignment = BoxContainer.ALIGNMENT_CENTER
		inner_vb.add_theme_constant_override("separation", 2)
		p.add_child(inner_vb)

		var top_hb = HBoxContainer.new()
		top_hb.alignment = BoxContainer.ALIGNMENT_CENTER
		top_hb.add_theme_constant_override("separation", 6)
		inner_vb.add_child(top_hb)

		if icon_tex != null:
			var ic = TextureRect.new()
			ic.texture = icon_tex
			ic.custom_minimum_size = Vector2(20, 20)
			ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			ic.size_flags_vertical = Control.SIZE_SHRINK_CENTER
			top_hb.add_child(ic)

		var l = Label.new()
		l.text = LANG[lang].get(label_key, label_key)
		l.add_theme_font_override("font", custom_font)
		l.add_theme_font_size_override("font_size", 22)
		l.add_theme_color_override("font_color", Color.WHITE)
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		ui_labels.append({"node": l, "key": label_key, "type": "label"})
		top_hb.add_child(l)

		var v = Label.new()
		v.text = val_str
		v.add_theme_font_override("font", custom_font)
		v.add_theme_font_size_override("font_size", 30)
		v.add_theme_color_override("font_color", active_theme.accent)
		v.add_theme_color_override("font_shadow_color", active_theme.accent.darkened(0.55))
		v.add_to_group("ThemeStatValueNodes")
		v.add_theme_constant_override("shadow_offset_y", 1)
		v.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		inner_vb.add_child(v)

		if sub_str != "":
			var sub_lbl = Label.new()
			sub_lbl.text = sub_str
			sub_lbl.add_theme_font_override("font", custom_font)
			sub_lbl.add_theme_font_size_override("font_size", 18)
			sub_lbl.add_theme_color_override("font_color", sub_color)
			sub_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			inner_vb.add_child(sub_lbl)

		return p

	# Helper to create clean vertical win/loss cards (Zero-Overflow Layout)
	var create_win_loss_box = func(title_key: String, score_str: String, opp_str: String, is_win: bool) -> PanelContainer:
		var p = PanelContainer.new()
		var ps = StyleBoxFlat.new()
		var cell_bg = active_theme.bg_bottom.darkened(0.75) if is_buz else active_theme.bg_bottom.darkened(0.38)
		ps.bg_color = Color(cell_bg.r, cell_bg.g, cell_bg.b, 0.94)
		ps.corner_radius_top_left = 12; ps.corner_radius_top_right = 12
		ps.corner_radius_bottom_left = 12; ps.corner_radius_bottom_right = 12
		ps.border_width_left = 1.0; ps.border_width_right = 1.0
		ps.border_width_top = 1.0; ps.border_width_bottom = 2.5
		ps.border_color = (Color8(50, 225, 110) if is_win else Color8(255, 85, 95)).darkened(0.3)
		ps.content_margin_left = 12; ps.content_margin_right = 12
		ps.content_margin_top = 8; ps.content_margin_bottom = 8
		p.add_theme_stylebox_override("panel", ps)
		p.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		var inner_vbox = VBoxContainer.new()
		inner_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
		inner_vbox.add_theme_constant_override("separation", 2)
		p.add_child(inner_vbox)

		var hdr_lbl = Label.new()
		hdr_lbl.text = LANG[lang].get(title_key, title_key)
		hdr_lbl.add_theme_font_override("font", custom_font)
		hdr_lbl.add_theme_font_size_override("font_size", 20)
		hdr_lbl.add_theme_color_override("font_color", Color.WHITE)
		hdr_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		ui_labels.append({"node": hdr_lbl, "key": title_key, "type": "label"})
		inner_vbox.add_child(hdr_lbl)

		var val_lbl = Label.new()
		val_lbl.text = score_str
		val_lbl.add_theme_font_override("font", custom_font)
		val_lbl.add_theme_font_size_override("font_size", 28)
		if score_str == "-":
			val_lbl.add_theme_color_override("font_color", Color.WHITE)
		elif is_win:
			val_lbl.add_theme_color_override("font_color", Color8(50, 235, 115))
			val_lbl.add_theme_color_override("font_shadow_color", Color8(0, 80, 20, 180))
		else:
			val_lbl.add_theme_color_override("font_color", Color8(255, 95, 105))
			val_lbl.add_theme_color_override("font_shadow_color", Color8(100, 10, 20, 180))
		val_lbl.add_theme_constant_override("shadow_offset_y", 1)
		val_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		inner_vbox.add_child(val_lbl)

		if opp_str != "":
			var opp_lbl = Label.new()
			opp_lbl.text = opp_str
			opp_lbl.add_theme_font_override("font", custom_font)
			opp_lbl.add_theme_font_size_override("font_size", 18)
			opp_lbl.add_theme_color_override("font_color", Color.WHITE)
			opp_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			inner_vbox.add_child(opp_lbl)

		return p

	# --- 1. FAVORITE TEAM SPOTLIGHT CARD (or Selection Prompt if not set) ---
	if Global.favorite_team != "":
		var f_played = 0; var f_wins = 0; var f_draws = 0; var f_losses = 0
		var f_goals_f = 0; var f_goals_a = 0
		var f_clean_sheets = 0
		var f_yellow = 0; var f_red = 0
		var f_biggest_win_score = "-"
		var f_biggest_win_opp = ""
		var f_biggest_diff = -1
		var f_biggest_loss_score = "-"
		var f_biggest_loss_opp = ""
		var f_biggest_loss_diff = -1
		var fav_recent_results = []

		for i in range(history.size() - 1, -1, -1):
			var m = history[i]
			var m_home = m.get("home", "")
			var m_away = m.get("away", "")
			var m_h_score = int(m.get("home_score", m.get("score_h", 0)))
			var m_a_score = int(m.get("away_score", m.get("score_a", 0)))

			var is_h = Global.is_team_match(m_home, Global.favorite_team)
			var is_a = Global.is_team_match(m_away, Global.favorite_team)

			if is_h or is_a:
				var fav_s = m_h_score if is_h else m_a_score
				var opp_s = m_a_score if is_h else m_h_score
				var opp_name = m_away if is_h else m_home

				f_played += 1
				f_goals_f += fav_s
				f_goals_a += opp_s
				f_yellow += int(m.get("home_yellow" if is_h else "away_yellow", 0))
				f_red += int(m.get("home_red" if is_h else "away_red", 0))
				if opp_s == 0:
					f_clean_sheets += 1

				if fav_s > opp_s:
					f_wins += 1
					var d = fav_s - opp_s
					if d > f_biggest_diff:
						f_biggest_diff = d
						f_biggest_win_score = "%d - %d" % [fav_s, opp_s]
						f_biggest_win_opp = "vs " + opp_name
					if fav_recent_results.size() < 5:
						var c = "G" if lang == "TR" else ("W" if lang == "ENG" else "V")
						fav_recent_results.append({"char": c, "col": Color8(34, 160, 75)})
				elif opp_s > fav_s:
					f_losses += 1
					var d = opp_s - fav_s
					if d > f_biggest_loss_diff:
						f_biggest_loss_diff = d
						f_biggest_loss_score = "%d - %d" % [fav_s, opp_s]
						f_biggest_loss_opp = "vs " + opp_name
					if fav_recent_results.size() < 5:
						var c = "M" if lang == "TR" else ("L" if lang == "ENG" else "D")
						fav_recent_results.append({"char": c, "col": Color8(200, 45, 50)})
				else:
					f_draws += 1
					if fav_recent_results.size() < 5:
						var c = "B" if lang == "TR" else ("D" if lang == "ENG" else "E")
						fav_recent_results.append({"char": c, "col": Color8(210, 150, 20)})

		fav_recent_results.reverse() # Chronological: oldest to newest
		var win_rate = int((float(f_wins) / float(f_played)) * 100.0) if f_played > 0 else 0

		var fav_card = create_card_panel.call()
		var fav_vbox = VBoxContainer.new()
		fav_vbox.add_theme_constant_override("separation", 8)
		fav_card.add_child(fav_vbox)

		# Hero Title Header Row with Badge & Form
		var fav_header_hbox = HBoxContainer.new()
		fav_header_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
		fav_header_hbox.add_theme_constant_override("separation", 10)
		fav_vbox.add_child(fav_header_hbox)

		var f_title = Label.new()
		var f_template = LANG[lang]["STATS_TEAM"]
		f_title.text = (f_template % Global.favorite_team).to_upper()
		f_title.add_theme_font_override("font", custom_font)
		f_title.add_theme_font_size_override("font_size", 30)
		f_title.add_theme_color_override("font_color", Color.WHITE)
		f_title.add_theme_color_override("font_shadow_color", Color8(0, 0, 0, 180))
		f_title.add_theme_constant_override("shadow_offset_y", 2)
		f_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		ui_labels.append({"node": f_title, "key": "STATS_TEAM", "type": "label_team_stats"})
		fav_header_hbox.add_child(f_title)

		# Form Guide Badges Row (Last 5 Matches)
		if fav_recent_results.size() > 0:
			var form_hbox = HBoxContainer.new()
			form_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
			form_hbox.add_theme_constant_override("separation", 8)
			fav_vbox.add_child(form_hbox)

			var form_title = Label.new()
			form_title.text = LANG[lang].get("STATS_FORM", "Son 5 Maç") + ":"
			form_title.add_theme_font_override("font", custom_font)
			form_title.add_theme_font_size_override("font_size", 20)
			form_title.add_theme_color_override("font_color", Color8(195, 215, 240))
			form_title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			ui_labels.append({"node": form_title, "key": "STATS_FORM", "type": "label"})
			form_hbox.add_child(form_title)

			for r in fav_recent_results:
				var fb_panel = PanelContainer.new()
				var fbs = StyleBoxFlat.new()
				fbs.bg_color = r["col"]
				fbs.corner_radius_top_left = 6; fbs.corner_radius_top_right = 6
				fbs.corner_radius_bottom_left = 6; fbs.corner_radius_bottom_right = 6
				fbs.content_margin_left = 5; fbs.content_margin_right = 5
				fbs.content_margin_top = 2; fbs.content_margin_bottom = 2
				fb_panel.add_theme_stylebox_override("panel", fbs)
				fb_panel.custom_minimum_size = Vector2(24, 24)
				fb_panel.size_flags_vertical = Control.SIZE_SHRINK_CENTER

				var fbl = Label.new()
				fbl.text = r["char"]
				fbl.add_theme_font_override("font", custom_font)
				fbl.add_theme_font_size_override("font_size", 16)
				fbl.add_theme_color_override("font_color", Color.WHITE)
				fbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
				fbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
				fb_panel.add_child(fbl)
				form_hbox.add_child(fb_panel)

		# 2-column Grid for stats (Row 1 & Row 2)
		var fav_grid = GridContainer.new()
		fav_grid.columns = 2
		fav_grid.add_theme_constant_override("h_separation", 10)
		fav_grid.add_theme_constant_override("v_separation", 6)
		fav_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		fav_vbox.add_child(fav_grid)

		# Cell 1: Matches Played & Wins Breakdown
		var wins_sub_str = "%dG • %dB • %dM" % [f_wins, f_draws, f_losses] if lang == "TR" else ("%dW • %dD • %dL" % [f_wins, f_draws, f_losses])
		fav_grid.add_child(create_stat_tile.call("FAV_STATS_PLAYED", str(f_played), wins_sub_str))

		# Cell 2: Win Rate with Progress Bar
		var wr_cell = PanelContainer.new()
		var wr_cs = StyleBoxFlat.new()
		var cell_bg = active_theme.bg_bottom.darkened(0.75) if is_buz else active_theme.bg_bottom.darkened(0.38)
		wr_cs.bg_color = Color(cell_bg.r, cell_bg.g, cell_bg.b, 0.94)
		wr_cs.corner_radius_top_left = 12; wr_cs.corner_radius_top_right = 12
		wr_cs.corner_radius_bottom_left = 12; wr_cs.corner_radius_bottom_right = 12
		wr_cs.border_width_left = 1.0; wr_cs.border_width_right = 1.0
		wr_cs.border_width_top = 1.0; wr_cs.border_width_bottom = 2.5
		wr_cs.border_color = active_theme.accent.darkened(0.4)
		wr_cs.content_margin_left = 12; wr_cs.content_margin_right = 12
		wr_cs.content_margin_top = 8; wr_cs.content_margin_bottom = 8
		wr_cell.add_theme_stylebox_override("panel", wr_cs)
		wr_cell.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		var wr_inner_vb = VBoxContainer.new()
		wr_inner_vb.alignment = BoxContainer.ALIGNMENT_CENTER
		wr_inner_vb.add_theme_constant_override("separation", 2)
		wr_cell.add_child(wr_inner_vb)

		var wr_lbl = Label.new()
		wr_lbl.text = LANG[lang].get("FAV_STATS_WINRATE", "Galibiyet Oranı")
		wr_lbl.add_theme_font_override("font", custom_font)
		wr_lbl.add_theme_font_size_override("font_size", 22)
		wr_lbl.add_theme_color_override("font_color", Color.WHITE)
		wr_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		ui_labels.append({"node": wr_lbl, "key": "FAV_STATS_WINRATE", "type": "label"})
		wr_inner_vb.add_child(wr_lbl)

		var wr_v = Label.new()
		wr_v.text = "%" + str(win_rate)
		wr_v.add_theme_font_override("font", custom_font)
		wr_v.add_theme_font_size_override("font_size", 30)
		wr_v.add_theme_color_override("font_color", active_theme.accent)
		wr_v.add_theme_color_override("font_shadow_color", active_theme.accent.darkened(0.55))
		wr_v.add_to_group("ThemeStatValueNodes")
		wr_v.add_theme_constant_override("shadow_offset_y", 1)
		wr_v.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		wr_inner_vb.add_child(wr_v)

		var mini_prog = Control.new()
		mini_prog.custom_minimum_size = Vector2(80, 6)
		mini_prog.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		var wr_ratio = clamp(float(win_rate) / 100.0, 0.0, 1.0)
		var bar_acc = active_theme.accent
		mini_prog.draw.connect(func():
			var sz = mini_prog.size
			mini_prog.draw_rect(Rect2(0, 0, sz.x, sz.y), Color8(15, 25, 45, 220), true)
			if wr_ratio > 0.0:
				var fill_col = Color8(34, 197, 94) if wr_ratio >= 0.5 else bar_acc
				mini_prog.draw_rect(Rect2(0, 0, max(sz.x * wr_ratio, 4.0), sz.y), fill_col, true)
		)
		wr_inner_vb.add_child(mini_prog)
		fav_grid.add_child(wr_cell)

		# Cell 3: Goals For / Against (Atılan / Yenilen) with Color-Coded Averaj
		var goal_diff_val = f_goals_f - f_goals_a
		var goal_diff_str = (LANG[lang].get("GOALS_DIFF_LABEL", "Diff: %+d") % goal_diff_val)
		var diff_color = Color8(75, 235, 130) if goal_diff_val > 0 else (Color8(255, 110, 110) if goal_diff_val < 0 else Color.WHITE)
		fav_grid.add_child(create_stat_tile.call("FAV_STATS_GOALS_FOR", "%d / %d" % [int(f_goals_f), int(f_goals_a)], goal_diff_str, diff_color))

		# Cell 4: Yellow & Red Cards & Clean Sheets (Kartlar & Gol Yememe)
		var y_icon = preload("res://yellow_card_icon.svg") if ResourceLoader.exists("res://yellow_card_icon.svg") else null
		var r_icon = preload("res://red_card_icon.svg") if ResourceLoader.exists("res://red_card_icon.svg") else null
		var card_cell = PanelContainer.new()
		var card_cs = StyleBoxFlat.new()
		card_cs.bg_color = Color(cell_bg.r, cell_bg.g, cell_bg.b, 0.94)
		card_cs.corner_radius_top_left = 12; card_cs.corner_radius_top_right = 12
		card_cs.corner_radius_bottom_left = 12; card_cs.corner_radius_bottom_right = 12
		card_cs.border_width_left = 1.0; card_cs.border_width_right = 1.0
		card_cs.border_width_top = 1.0; card_cs.border_width_bottom = 2.5
		card_cs.border_color = active_theme.accent.darkened(0.4)
		card_cs.content_margin_left = 12; card_cs.content_margin_right = 12
		card_cs.content_margin_top = 8; card_cs.content_margin_bottom = 8
		card_cell.add_theme_stylebox_override("panel", card_cs)
		card_cell.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		var card_inner_vb = VBoxContainer.new()
		card_inner_vb.alignment = BoxContainer.ALIGNMENT_CENTER
		card_inner_vb.add_theme_constant_override("separation", 3)
		card_cell.add_child(card_inner_vb)

		var cards_title_lbl = Label.new()
		cards_title_lbl.text = LANG[lang].get("FAV_STATS_CARDS", "Kartlar")
		cards_title_lbl.add_theme_font_override("font", custom_font)
		cards_title_lbl.add_theme_font_size_override("font_size", 22)
		cards_title_lbl.add_theme_color_override("font_color", Color.WHITE)
		cards_title_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		ui_labels.append({"node": cards_title_lbl, "key": "FAV_STATS_CARDS", "type": "label"})
		card_inner_vb.add_child(cards_title_lbl)

		var card_chips_hb = HBoxContainer.new()
		card_chips_hb.alignment = BoxContainer.ALIGNMENT_CENTER
		card_chips_hb.add_theme_constant_override("separation", 12)
		card_inner_vb.add_child(card_chips_hb)

		# Yellow chip
		var y_hb = HBoxContainer.new()
		y_hb.alignment = BoxContainer.ALIGNMENT_CENTER
		y_hb.add_theme_constant_override("separation", 4)
		if y_icon:
			var yic = TextureRect.new(); yic.texture = y_icon
			yic.custom_minimum_size = Vector2(18, 18)
			yic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			yic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			y_hb.add_child(yic)
		var yv = Label.new()
		yv.text = str(int(f_yellow))
		yv.add_theme_font_override("font", custom_font)
		yv.add_theme_font_size_override("font_size", 26)
		yv.add_theme_color_override("font_color", Color8(255, 230, 80))
		y_hb.add_child(yv)
		card_chips_hb.add_child(y_hb)

		# Red chip
		var r_hb = HBoxContainer.new()
		r_hb.alignment = BoxContainer.ALIGNMENT_CENTER
		r_hb.add_theme_constant_override("separation", 4)
		if r_icon:
			var ric = TextureRect.new(); ric.texture = r_icon
			ric.custom_minimum_size = Vector2(18, 18)
			ric.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			ric.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			r_hb.add_child(ric)
		var rv = Label.new()
		rv.text = str(int(f_red))
		rv.add_theme_font_override("font", custom_font)
		rv.add_theme_font_size_override("font_size", 26)
		rv.add_theme_color_override("font_color", Color8(255, 90, 90))
		r_hb.add_child(rv)
		card_chips_hb.add_child(r_hb)

		# Clean Sheet Subtitle
		var cs_lbl = Label.new()
		cs_lbl.text = LANG[lang].get("STATS_CLEAN_SHEETS", "%d Maç Gol Yemedi") % f_clean_sheets
		cs_lbl.add_theme_font_override("font", custom_font)
		cs_lbl.add_theme_font_size_override("font_size", 17)
		cs_lbl.add_theme_color_override("font_color", Color.WHITE)
		cs_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		card_inner_vb.add_child(cs_lbl)

		fav_grid.add_child(card_cell)

		# Row 3 (2 columns): Biggest Win & Biggest Defeat (Vertical Layout - Zero Overflow!)
		var win_loss_grid = GridContainer.new()
		win_loss_grid.columns = 2
		win_loss_grid.add_theme_constant_override("h_separation", 10)
		win_loss_grid.add_theme_constant_override("v_separation", 6)
		win_loss_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		fav_vbox.add_child(win_loss_grid)

		win_loss_grid.add_child(create_win_loss_box.call("FAV_STATS_BIGGEST_WIN", f_biggest_win_score, f_biggest_win_opp, true))
		win_loss_grid.add_child(create_win_loss_box.call("FAV_STATS_BIGGEST_LOSS", f_biggest_loss_score, f_biggest_loss_opp, false))

		vbox.add_child(fav_card)
	else:
		# Call-to-action Card: Prompt player to select a favorite team!
		var cta_card = create_card_panel.call()
		var cta_vbox = VBoxContainer.new()
		cta_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
		cta_vbox.add_theme_constant_override("separation", 12)
		cta_card.add_child(cta_vbox)

		var cta_header = HBoxContainer.new()
		cta_header.alignment = BoxContainer.ALIGNMENT_CENTER
		cta_header.add_theme_constant_override("separation", 8)
		cta_vbox.add_child(cta_header)

		var star_ic = TextureRect.new()
		star_ic.texture = preload("res://star_gold.svg") if ResourceLoader.exists("res://star_gold.svg") else null
		if star_ic.texture:
			star_ic.custom_minimum_size = Vector2(26, 26)
			star_ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			star_ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			cta_header.add_child(star_ic)

		var cta_title = Label.new()
		cta_title.text = LANG[lang].get("FAV_CONFIRM_TITLE", "Favori Takımı Belirle")
		cta_title.add_theme_font_override("font", custom_font)
		cta_title.add_theme_font_size_override("font_size", 28)
		cta_title.add_theme_color_override("font_color", Color.WHITE)
		cta_title.add_theme_color_override("font_shadow_color", Color8(0, 0, 0, 180))
		cta_title.add_theme_constant_override("shadow_offset_y", 2)
		cta_header.add_child(cta_title)

		var cta_desc = Label.new()
		cta_desc.text = LANG[lang].get("STATS_SELECT_FAV_PROMPT", "Takımına özel rekorları ve detaylı istatistikleri görmek için favori takımını seç!")
		cta_desc.add_theme_font_override("font", custom_font)
		cta_desc.add_theme_font_size_override("font_size", 22)
		cta_desc.add_theme_color_override("font_color", Color.WHITE)
		cta_desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		cta_desc.autowrap_mode = TextServer.AUTOWRAP_WORD
		cta_vbox.add_child(cta_desc)

		var cta_btn = Button.new()
		cta_btn.text = LANG[lang].get("STATS_CHOOSE_FAV_BTN", "FAVORİ TAKIM SEÇ")
		cta_btn.add_theme_font_override("font", custom_font)
		cta_btn.add_theme_font_size_override("font_size", 24)
		cta_btn.custom_minimum_size = Vector2(220, 52)
		cta_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		apply_3d_style_to_button(cta_btn, active_theme.accent, active_theme.accent.darkened(0.35), 14, 4, 20, 10)
		cta_btn.pressed.connect(func():
			Global.play_click()
			_switch_tab(1)
		)
		cta_vbox.add_child(cta_btn)

		vbox.add_child(cta_card)

	# --- 2. GENERAL STATS & RECENT MATCHES ---
	if history.is_empty():
		var empty_card = create_card_panel.call()
		var empty_vbox = VBoxContainer.new()
		empty_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
		empty_vbox.add_theme_constant_override("separation", 16)
		empty_card.add_child(empty_vbox)

		var ball_icon = TextureRect.new()
		if ResourceLoader.exists("res://soccer_ball_icon.svg"):
			ball_icon.texture = load("res://soccer_ball_icon.svg")
		if ball_icon.texture:
			ball_icon.custom_minimum_size = Vector2(64, 64)
			ball_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			ball_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			ball_icon.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
			empty_vbox.add_child(ball_icon)

		var no_data_lbl = Label.new()
		no_data_lbl.text = LANG[lang]["STATS_NO_DATA"]
		no_data_lbl.add_theme_font_override("font", custom_font)
		no_data_lbl.add_theme_font_size_override("font_size", 28)
		no_data_lbl.add_theme_color_override("font_color", Color.WHITE)
		no_data_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		no_data_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD
		ui_labels.append({"node": no_data_lbl, "key": "STATS_NO_DATA", "type": "label"})
		empty_vbox.add_child(no_data_lbl)

		var start_btn = Button.new()
		start_btn.text = LANG[lang].get("START_MATCH", "MAÇI BAŞLAT")
		start_btn.add_theme_font_override("font", custom_font)
		start_btn.add_theme_font_size_override("font_size", 26)
		start_btn.custom_minimum_size = Vector2(220, 58)
		start_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		apply_3d_style_to_button(start_btn, active_theme.accent, active_theme.accent.darkened(0.35), 14, 4, 24, 12)
		start_btn.pressed.connect(func():
			Global.play_click()
			_switch_tab(1)
		)
		empty_vbox.add_child(start_btn)

		vbox.add_child(empty_card)
	else:
		# Compute General Tournament Stats
		var total = history.size()
		var most_goals_match = history[0]
		var most_diff_match = history[0]
		var most_diff_val = 0
		var home_wins = 0; var away_wins = 0; var draws = 0
		var total_goals_tournament = 0

		for m in history:
			var h_score = int(m.get("home_score", m.get("score_h", 0)))
			var a_score = int(m.get("away_score", m.get("score_a", 0)))
			var goals = h_score + a_score
			total_goals_tournament += goals
			var diff = abs(h_score - a_score)

			var mg_h = int(most_goals_match.get("home_score", most_goals_match.get("score_h", 0)))
			var mg_a = int(most_goals_match.get("away_score", most_goals_match.get("score_a", 0)))
			if goals > (mg_h + mg_a):
				most_goals_match = m

			if diff > most_diff_val:
				most_diff_val = diff
				most_diff_match = m

			if h_score > a_score: home_wins += 1
			elif a_score > h_score: away_wins += 1
			else: draws += 1

		# General Stats Card
		var gen_card = create_card_panel.call()
		var gen_vbox = VBoxContainer.new()
		gen_vbox.add_theme_constant_override("separation", 8)
		gen_card.add_child(gen_vbox)

		var gen_title = Label.new()
		gen_title.text = LANG[lang]["STATS_GENERAL"].to_upper()
		gen_title.add_theme_font_override("font", custom_font)
		gen_title.add_theme_font_size_override("font_size", 30)
		gen_title.add_theme_color_override("font_color", Color.WHITE)
		gen_title.add_theme_color_override("font_shadow_color", Color8(0, 0, 0, 180))
		gen_title.add_theme_constant_override("shadow_offset_y", 2)
		gen_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		ui_labels.append({"node": gen_title, "key": "STATS_GENERAL", "type": "label_upper"})
		gen_vbox.add_child(gen_title)

		# 4 Mini KPI boxes in 4 columns with Percentage Subtitles
		var kpi_grid = GridContainer.new()
		kpi_grid.columns = 4
		kpi_grid.add_theme_constant_override("h_separation", 6)
		kpi_grid.add_theme_constant_override("v_separation", 4)
		kpi_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		gen_vbox.add_child(kpi_grid)

		var add_kpi = func(k_key: String, k_val: String, sub_str: String = ""):
			var kp = PanelContainer.new()
			var kps = StyleBoxFlat.new()
			var cell_bg = active_theme.bg_bottom.darkened(0.75) if is_buz else active_theme.bg_bottom.darkened(0.4)
			kps.bg_color = Color(cell_bg.r, cell_bg.g, cell_bg.b, 0.94)
			kps.corner_radius_top_left = 10; kps.corner_radius_top_right = 10
			kps.corner_radius_bottom_left = 10; kps.corner_radius_bottom_right = 10
			kps.border_width_left = 1.0; kps.border_width_right = 1.0
			kps.border_width_top = 1.0; kps.border_width_bottom = 2.5
			kps.border_color = active_theme.accent.darkened(0.45)
			kps.content_margin_left = 4; kps.content_margin_right = 4
			kps.content_margin_top = 6; kps.content_margin_bottom = 6
			kp.add_theme_stylebox_override("panel", kps)
			kp.size_flags_horizontal = Control.SIZE_EXPAND_FILL

			var kvbox = VBoxContainer.new()
			kvbox.alignment = BoxContainer.ALIGNMENT_CENTER
			kvbox.add_theme_constant_override("separation", 2)
			kp.add_child(kvbox)

			var kl = Label.new()
			kl.text = LANG[lang].get(k_key, k_key)
			kl.add_theme_font_override("font", custom_font)
			kl.add_theme_font_size_override("font_size", 18)
			kl.add_theme_color_override("font_color", Color8(195, 215, 240))
			kl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			ui_labels.append({"node": kl, "key": k_key, "type": "label"})
			kvbox.add_child(kl)

			var kv = Label.new()
			kv.text = k_val
			kv.add_theme_font_override("font", custom_font)
			kv.add_theme_font_size_override("font_size", 28)
			kv.add_theme_color_override("font_color", active_theme.accent)
			kv.add_theme_color_override("font_shadow_color", active_theme.accent.darkened(0.55))
			kv.add_to_group("ThemeStatValueNodes")
			kv.add_theme_constant_override("shadow_offset_y", 1)
			kv.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			kvbox.add_child(kv)

			if sub_str != "":
				var ksub = Label.new()
				ksub.text = sub_str
				ksub.add_theme_font_override("font", custom_font)
				ksub.add_theme_font_size_override("font_size", 16)
				ksub.add_theme_color_override("font_color", Color8(170, 195, 225))
				ksub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
				kvbox.add_child(ksub)

			kpi_grid.add_child(kp)

		var hw_pct = "%d%%" % int((float(home_wins) / float(total)) * 100.0) if total > 0 else "0%"
		var aw_pct = "%d%%" % int((float(away_wins) / float(total)) * 100.0) if total > 0 else "0%"
		var dr_pct = "%d%%" % int((float(draws) / float(total)) * 100.0) if total > 0 else "0%"

		add_kpi.call("STATS_TOTAL", str(total), "")
		add_kpi.call("STATS_HOME_W", str(home_wins), hw_pct)
		add_kpi.call("STATS_AWAY_W", str(away_wins), aw_pct)
		add_kpi.call("STATS_DRAW", str(draws), dr_pct)

		# 2-Column Grid for Tournament Goals & Average Goals per match
		var goals_grid = GridContainer.new()
		goals_grid.columns = 2
		goals_grid.add_theme_constant_override("h_separation", 10)
		goals_grid.add_theme_constant_override("v_separation", 4)
		goals_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		gen_vbox.add_child(goals_grid)

		var avg_goals_val = (float(total_goals_tournament) / float(total)) if total > 0 else 0.0
		var avg_goals_str = "%.1f" % avg_goals_val

		goals_grid.add_child(create_stat_tile.call("STATS_TOTAL_GOALS", str(total_goals_tournament), LANG[lang].get("GOALS_SUFFIX", "Gol")))
		goals_grid.add_child(create_stat_tile.call("STATS_AVG_GOALS", avg_goals_str, LANG[lang].get("GOALS_SUFFIX", "Gol") + " / " + (LANG[lang].get("STATS_TOTAL", "Maç")).to_lower()))

		# Highlight Record Rows
		var mg = most_goals_match
		var mg_h = int(mg.get("home_score", mg.get("score_h", 0)))
		var mg_a = int(mg.get("away_score", mg.get("score_a", 0)))
		var mg_total = mg_h + mg_a
		gen_vbox.add_child(create_stat_tile.call("STATS_MOST_GOALS", "%s %d - %d %s" % [mg.get("home", ""), mg_h, mg_a, mg.get("away", "")], "(%d %s)" % [int(mg_total), LANG[lang].get("GOALS_SUFFIX", "Gol")]))

		if most_diff_val > 0:
			var md = most_diff_match
			var md_h = int(md.get("home_score", md.get("score_h", 0)))
			var md_a = int(md.get("away_score", md.get("score_a", 0)))
			gen_vbox.add_child(create_stat_tile.call("STATS_BIGGEST_WIN", "%s %d - %d %s" % [md.get("home", ""), md_h, md_a, md.get("away", "")]))
		else:
			gen_vbox.add_child(create_stat_tile.call("STATS_BIGGEST_WIN", "-"))

		vbox.add_child(gen_card)

		# --- 3. RECENT MATCHES CARD ---
		var rec_card = create_card_panel.call()
		var rec_vbox = VBoxContainer.new()
		rec_vbox.add_theme_constant_override("separation", 6)
		rec_card.add_child(rec_vbox)

		var recent_title = Label.new()
		recent_title.text = LANG[lang]["STATS_RECENT"].to_upper().replace("I", "I")
		recent_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		recent_title.add_theme_font_override("font", custom_font)
		recent_title.add_theme_font_size_override("font_size", 30)
		recent_title.add_theme_color_override("font_color", Color.WHITE)
		recent_title.add_theme_color_override("font_shadow_color", Color8(0, 0, 0, 180))
		recent_title.add_theme_constant_override("shadow_offset_y", 2)
		ui_labels.append({"node": recent_title, "key": "STATS_RECENT", "type": "label_upper"})
		rec_vbox.add_child(recent_title)

		# Show up to last 5 matches for clean screen utilization
		var shown = min(history.size(), 5)
		for i in range(history.size() - 1, history.size() - 1 - shown, -1):
			var m = history[i]
			var m_home = m.get("home", "")
			var m_away = m.get("away", "")
			var m_h_score = int(m.get("home_score", m.get("score_h", 0)))
			var m_a_score = int(m.get("away_score", m.get("score_a", 0)))

			var m_panel = PanelContainer.new()
			var m_style = StyleBoxFlat.new()
			var match_bg = active_theme.bg_bottom.darkened(0.75) if is_buz else active_theme.bg_bottom.darkened(0.38)
			m_style.bg_color = Color(match_bg.r, match_bg.g, match_bg.b, 0.94)
			m_style.corner_radius_top_left = 12; m_style.corner_radius_top_right = 12
			m_style.corner_radius_bottom_left = 12; m_style.corner_radius_bottom_right = 12
			m_style.border_width_left = 1.0; m_style.border_width_right = 1.0
			m_style.border_width_top = 1.0; m_style.border_width_bottom = 2.5
			m_style.border_color = active_theme.accent.darkened(0.45)
			m_style.content_margin_left = 12; m_style.content_margin_right = 12
			m_style.content_margin_top = 5; m_style.content_margin_bottom = 5
			m_panel.add_theme_stylebox_override("panel", m_style)
			m_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL

			var m_hbox = HBoxContainer.new()
			m_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
			m_hbox.add_theme_constant_override("separation", 10)
			m_panel.add_child(m_hbox)

			# Result Badge
			var badge_char = "B"
			var badge_bg_col = Color8(210, 150, 20)
			var fav = Global.favorite_team

			if fav != "" and (m_home == fav or m_away == fav):
				var fav_won = (m_home == fav and m_h_score > m_a_score) or (m_away == fav and m_a_score > m_h_score)
				var fav_lost = (m_home == fav and m_h_score < m_a_score) or (m_away == fav and m_a_score < m_h_score)
				if fav_won:
					badge_bg_col = Color8(34, 160, 75)
					badge_char = "G" if lang == "TR" else ("W" if lang == "ENG" else "V")
				elif fav_lost:
					badge_bg_col = Color8(200, 45, 50)
					badge_char = "M" if lang == "TR" else ("L" if lang == "ENG" else "D")
				else:
					badge_bg_col = Color8(210, 150, 20)
					badge_char = "B" if lang == "TR" else ("D" if lang == "ENG" else "E")
			else:
				if m_h_score > m_a_score:
					badge_bg_col = Color8(34, 160, 75)
					badge_char = "G" if lang == "TR" else ("W" if lang == "ENG" else "V")
				elif m_a_score > m_h_score:
					badge_bg_col = Color8(34, 160, 75)
					badge_char = "G" if lang == "TR" else ("W" if lang == "ENG" else "V")
				else:
					badge_bg_col = Color8(210, 150, 20)
					badge_char = "B" if lang == "TR" else ("D" if lang == "ENG" else "E")

			var badge_p = PanelContainer.new()
			var bps = StyleBoxFlat.new()
			bps.bg_color = badge_bg_col
			bps.corner_radius_top_left = 6; bps.corner_radius_top_right = 6
			bps.corner_radius_bottom_left = 6; bps.corner_radius_bottom_right = 6
			bps.content_margin_left = 6; bps.content_margin_right = 6
			bps.content_margin_top = 2; bps.content_margin_bottom = 2
			badge_p.add_theme_stylebox_override("panel", bps)
			badge_p.custom_minimum_size = Vector2(26, 26)
			badge_p.size_flags_vertical = Control.SIZE_SHRINK_CENTER

			var bl = Label.new()
			bl.text = badge_char
			bl.add_theme_font_override("font", custom_font)
			bl.add_theme_font_size_override("font_size", 18)
			bl.add_theme_color_override("font_color", Color.WHITE)
			bl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			bl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			badge_p.add_child(bl)
			m_hbox.add_child(badge_p)

			# Home team (overflow protected + ellipsis)
			var hl = Label.new()
			hl.text = m_home
			hl.add_theme_font_override("font", custom_font)
			hl.add_theme_font_size_override("font_size", 21)
			if fav != "" and m_home == fav:
				hl.add_theme_color_override("font_color", active_theme.accent)
			else:
				hl.add_theme_color_override("font_color", Color.WHITE)
			hl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
			hl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			hl.size_flags_vertical = Control.SIZE_SHRINK_CENTER
			hl.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
			hl.clip_text = true
			m_hbox.add_child(hl)

			# Score Pill
			var sc_p = PanelContainer.new()
			var sc_s = StyleBoxFlat.new()
			var sc_bg = active_theme.bg_bottom.darkened(0.85) if is_buz else active_theme.bg_bottom.darkened(0.55)
			sc_s.bg_color = Color(sc_bg.r, sc_bg.g, sc_bg.b, 0.95)
			sc_s.corner_radius_top_left = 8; sc_s.corner_radius_top_right = 8
			sc_s.corner_radius_bottom_left = 8; sc_s.corner_radius_bottom_right = 8
			sc_s.border_width_bottom = 1.5
			sc_s.border_color = active_theme.accent.darkened(0.3)
			sc_s.content_margin_left = 10; sc_s.content_margin_right = 10
			sc_s.content_margin_top = 3; sc_s.content_margin_bottom = 3
			sc_p.add_theme_stylebox_override("panel", sc_s)
			sc_p.custom_minimum_size = Vector2(70, 30)
			sc_p.size_flags_vertical = Control.SIZE_SHRINK_CENTER

			var scl = Label.new()
			scl.text = "%d - %d" % [m_h_score, m_a_score]
			scl.add_theme_font_override("font", custom_font)
			scl.add_theme_font_size_override("font_size", 24)
			scl.add_theme_color_override("font_color", Color8(255, 220, 70))
			scl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			scl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			sc_p.add_child(scl)
			m_hbox.add_child(sc_p)

			# Away team (overflow protected + ellipsis)
			var al = Label.new()
			al.text = m_away
			al.add_theme_font_override("font", custom_font)
			al.add_theme_font_size_override("font_size", 21)
			if fav != "" and m_away == fav:
				al.add_theme_color_override("font_color", active_theme.accent)
			else:
				al.add_theme_color_override("font_color", Color.WHITE)
			al.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
			al.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			al.size_flags_vertical = Control.SIZE_SHRINK_CENTER
			al.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
			al.clip_text = true
			m_hbox.add_child(al)

			rec_vbox.add_child(m_panel)

		vbox.add_child(rec_card)

	# Bottom spacer for comfortable scrolling above navigation bar
	var sp_bot = Control.new()
	sp_bot.custom_minimum_size = Vector2(0, 120)
	vbox.add_child(sp_bot)

	return page

# ======================================================
# SHOP TAB
# ======================================================
func _build_shop_tab() -> Control:
	var sw = get_viewport_rect().size.x
	var sh = get_viewport_rect().size.y
	var page = Control.new()
	page.custom_minimum_size = Vector2(sw, sh)
	page.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	page.size_flags_vertical = Control.SIZE_EXPAND_FILL

	var margin = MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_top", 130)
	margin.add_theme_constant_override("margin_bottom", 95)
	margin.add_theme_constant_override("margin_left", 16)
	margin.add_theme_constant_override("margin_right", 16)
	page.add_child(margin)

	var shop_scroll = ScrollContainer.new()
	shop_scroll.set_anchors_preset(Control.PRESET_FULL_RECT)
	shop_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	shop_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	margin.add_child(shop_scroll)

	var vbox = VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.alignment = BoxContainer.ALIGNMENT_BEGIN
	vbox.add_theme_constant_override("separation", 18)
	shop_scroll.add_child(vbox)

	# --- 1. SHOP TITLE & BALANCED CREDITS HEADER ---
	var top_hbox = HBoxContainer.new()
	top_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	top_hbox.custom_minimum_size = Vector2(660, 50)
	vbox.add_child(top_hbox)

	# Left: Jeton Sayaç Kapsülü ([ 🪙 300 (+) ]) - Modern M3 Tactile Pill with Action Badge
	var cred_box = HBoxContainer.new()
	cred_box.alignment = BoxContainer.ALIGNMENT_BEGIN
	cred_box.custom_minimum_size = Vector2(185, 60)
	
	var cred_btn = Button.new()
	cred_btn.custom_minimum_size = Vector2(185, 54)
	cred_btn.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	
	var cp_style = StyleBoxFlat.new()
	cp_style.bg_color = active_theme.bg_bottom.darkened(0.28)
	cp_style.corner_radius_top_left = 27; cp_style.corner_radius_top_right = 27
	cp_style.corner_radius_bottom_left = 27; cp_style.corner_radius_bottom_right = 27
	cp_style.border_width_left = 1.5; cp_style.border_width_right = 1.5
	cp_style.border_width_top = 1.5; cp_style.border_width_bottom = 3.5
	cp_style.border_color = Color8(255, 215, 0, 210)
	cp_style.shadow_color = Color8(0, 0, 0, 110)
	cp_style.shadow_size = 6
	cp_style.shadow_offset = Vector2(0, 3)
	
	var cp_hover = cp_style.duplicate()
	cp_hover.bg_color = active_theme.bg_bottom.darkened(0.18)
	cp_hover.border_color = Color8(255, 230, 80, 255)
	
	var cp_pressed = cp_style.duplicate()
	cp_pressed.border_width_bottom = 1.5
	cp_pressed.content_margin_top = 2
	
	cred_btn.add_theme_stylebox_override("normal", cp_style)
	cred_btn.add_theme_stylebox_override("hover", cp_hover)
	cred_btn.add_theme_stylebox_override("pressed", cp_pressed)
	cred_btn.add_theme_stylebox_override("focus", cp_style)
	cred_btn.pressed.connect(_show_admob_rewarded)
	
	# Layout Fix: Margin container anchored to full rect of button
	var cred_margin = MarginContainer.new()
	cred_margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	cred_margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cred_margin.add_theme_constant_override("margin_left", 8)
	cred_margin.add_theme_constant_override("margin_right", 8)
	cred_btn.add_child(cred_margin)
	
	var cred_inner = HBoxContainer.new()
	cred_inner.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cred_inner.alignment = BoxContainer.ALIGNMENT_CENTER
	cred_inner.add_theme_constant_override("separation", 8)
	cred_margin.add_child(cred_inner)
	
	# 1. 3D Gold Coin Icon
	var coin_icon = TextureRect.new()
	coin_icon.texture = preload("res://jeton_icon.svg")
	coin_icon.custom_minimum_size = Vector2(34, 34)
	coin_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	coin_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	coin_icon.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	coin_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cred_inner.add_child(coin_icon)
	
	# 2. Token Counter Value
	var cred_lbl = Label.new()
	cred_lbl.name = "AdCreditsLabel"
	cred_lbl.text = str(Global.ad_credits)
	cred_lbl.add_theme_font_override("font", custom_font)
	cred_lbl.add_theme_font_size_override("font_size", 32)
	cred_lbl.add_theme_color_override("font_color", Color8(255, 225, 60))
	cred_lbl.add_theme_color_override("font_shadow_color", Color8(0, 0, 0, 200))
	cred_lbl.add_theme_constant_override("shadow_offset_y", 2)
	cred_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cred_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	cred_lbl.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	cred_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cred_inner.add_child(cred_lbl)
	ui_labels.append({"node": cred_lbl, "key": "CURRENCY_VAL", "type": "currency_val"})
	
	# 3. Dedicated Tactile (+) Action Badge
	var plus_badge = PanelContainer.new()
	plus_badge.custom_minimum_size = Vector2(28, 28)
	plus_badge.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	plus_badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var pb_style = StyleBoxFlat.new()
	pb_style.bg_color = Color8(34, 197, 94)
	pb_style.corner_radius_top_left = 14; pb_style.corner_radius_top_right = 14
	pb_style.corner_radius_bottom_left = 14; pb_style.corner_radius_bottom_right = 14
	pb_style.border_width_bottom = 2.0
	pb_style.border_color = Color8(20, 130, 60)
	plus_badge.add_theme_stylebox_override("panel", pb_style)
	
	var plus_ic = TextureRect.new()
	plus_ic.texture = preload("res://plus_icon.svg")
	plus_ic.custom_minimum_size = Vector2(16, 16)
	plus_ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	plus_ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	plus_ic.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	plus_ic.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	plus_ic.mouse_filter = Control.MOUSE_FILTER_IGNORE
	plus_badge.add_child(plus_ic)
	cred_inner.add_child(plus_badge)
	
	cred_box.add_child(cred_btn)
	top_hbox.add_child(cred_box)

	var sp1 = Control.new(); sp1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_hbox.add_child(sp1)

	# Center Title: Exact 55px matching Home and Stats!
	var title = create_label_node("SHOP_TITLE", white, 55)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_color_override("font_shadow_color", Color8(0, 0, 0, 150))
	title.add_theme_constant_override("shadow_offset_y", 4)
	top_hbox.add_child(title)

	var sp2 = Control.new(); sp2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_hbox.add_child(sp2)

	# Right dummy balancer
	var right_box = Control.new()
	right_box.custom_minimum_size = Vector2(185, 60)
	top_hbox.add_child(right_box)

	# --- 2. QUICK REWARDS & FEATURES ROW (3 Buttons) ---
	var rewards_hbox = HBoxContainer.new()
	rewards_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	rewards_hbox.add_theme_constant_override("separation", 10)
	rewards_hbox.custom_minimum_size = Vector2(0, 54)
	rewards_hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.add_child(rewards_hbox)

	var ad_btn = Button.new()
	ad_btn.text = LANG[Global.current_lang]["SHOP_WATCH_AD"]
	ad_btn.icon = load("res://video.svg")
	ad_btn.expand_icon = true
	ad_btn.add_theme_constant_override("icon_max_width", 28)
	ad_btn.add_theme_constant_override("h_separation", 8)
	ui_labels.append({"node": ad_btn, "key": "SHOP_WATCH_AD", "type": "button"})
	ad_btn.add_theme_font_override("font", custom_font)
	ad_btn.add_theme_font_size_override("font_size", 25)
	ad_btn.add_theme_color_override("font_color", Color.WHITE)
	ad_btn.add_theme_color_override("font_shadow_color", Color8(0, 0, 0, 180))
	ad_btn.add_theme_constant_override("shadow_offset_y", 2)
	apply_3d_style_to_button(ad_btn, Color8(245, 155, 20), Color8(175, 90, 10), 14, 3.5, 12, 8)
	ad_btn.custom_minimum_size = Vector2(210, 58)
	ad_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ad_btn.pressed.connect(_show_admob_rewarded)
	rewards_hbox.add_child(ad_btn)

	var wheel_btn = Button.new()
	wheel_btn.text = LANG[Global.current_lang]["LUCKY_WHEEL_BTN"]
	wheel_btn.add_theme_font_override("font", custom_font)
	wheel_btn.add_theme_font_size_override("font_size", 25)
	wheel_btn.add_theme_color_override("font_color", Color.WHITE)
	wheel_btn.add_theme_color_override("font_shadow_color", Color8(0, 0, 0, 160))
	wheel_btn.add_theme_constant_override("shadow_offset_y", 2)
	apply_3d_style_to_button(wheel_btn, active_theme.accent, active_theme.accent.darkened(0.35), 14, 3.5, 10, 8)
	wheel_btn.custom_minimum_size = Vector2(170, 58)
	wheel_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	wheel_btn.pressed.connect(_open_lucky_wheel)
	rewards_hbox.add_child(wheel_btn)

	var quests_btn = Button.new()
	quests_btn.text = LANG[Global.current_lang]["DAILY_QUESTS_BTN"]
	quests_btn.add_theme_font_override("font", custom_font)
	quests_btn.add_theme_font_size_override("font_size", 25)
	quests_btn.add_theme_color_override("font_color", Color.WHITE)
	quests_btn.add_theme_color_override("font_shadow_color", Color8(0, 0, 0, 160))
	quests_btn.add_theme_constant_override("shadow_offset_y", 2)
	apply_3d_style_to_button(quests_btn, active_theme.bg_top.lightened(0.18), active_theme.bg_bottom.darkened(0.3), 14, 3.5, 10, 8)
	quests_btn.custom_minimum_size = Vector2(170, 58)
	quests_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	quests_btn.pressed.connect(_open_daily_quests)
	rewards_hbox.add_child(quests_btn)

	# --- 3. PRO PASS SHOWCASE BANNER (Thick & Luxurious) ---
	var prem_panel = PanelContainer.new()
	var prem_style = StyleBoxFlat.new()
	prem_style.bg_color = Color8(25, 14, 42, 250)
	prem_style.corner_radius_top_left = 18; prem_style.corner_radius_top_right = 18
	prem_style.corner_radius_bottom_left = 18; prem_style.corner_radius_bottom_right = 18
	prem_style.border_width_top = 2.0; prem_style.border_width_bottom = 4.5
	prem_style.border_width_left = 2.0; prem_style.border_width_right = 2.0
	prem_style.border_color = Color8(255, 210, 60, 230)
	prem_style.shadow_color = Color8(255, 180, 0, 40)
	prem_style.shadow_size = 16
	prem_style.content_margin_left = 18; prem_style.content_margin_right = 18
	prem_style.content_margin_top = 14; prem_style.content_margin_bottom = 14
	prem_panel.add_theme_stylebox_override("panel", prem_style)
	vbox.add_child(prem_panel)

	var prem_hbox = HBoxContainer.new()
	prem_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	prem_hbox.add_theme_constant_override("separation", 16)
	prem_panel.add_child(prem_hbox)

	var prem_left_vb = VBoxContainer.new()
	prem_left_vb.alignment = BoxContainer.ALIGNMENT_CENTER
	prem_left_vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	prem_left_vb.add_theme_constant_override("separation", 2)
	prem_hbox.add_child(prem_left_vb)

	var prem_title_hb = HBoxContainer.new()
	prem_title_hb.alignment = BoxContainer.ALIGNMENT_BEGIN
	prem_title_hb.add_theme_constant_override("separation", 8)
	prem_left_vb.add_child(prem_title_hb)

	var crown_icon = TextureRect.new()
	crown_icon.texture = preload("res://crownicon.svg")
	crown_icon.custom_minimum_size = Vector2(36, 36)
	crown_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	crown_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	crown_icon.modulate = Color8(255, 215, 0)
	prem_title_hb.add_child(crown_icon)

	var prem_icon_lbl = Label.new()
	prem_icon_lbl.text = "PRO PASS"
	prem_icon_lbl.add_theme_font_override("font", custom_font)
	prem_icon_lbl.add_theme_font_size_override("font_size", 38)
	prem_icon_lbl.add_theme_color_override("font_color", Color8(255, 235, 140))
	prem_icon_lbl.add_theme_color_override("font_shadow_color", Color8(180, 100, 0, 200))
	prem_icon_lbl.add_theme_constant_override("shadow_offset_y", 2)
	prem_title_hb.add_child(prem_icon_lbl)

	var prem_desc = Label.new()
	prem_desc.text = LANG[Global.current_lang]["SHOP_PRO_DESC"]
	prem_desc.add_theme_font_override("font", custom_font)
	prem_desc.add_theme_font_size_override("font_size", 22)
	prem_desc.add_theme_color_override("font_color", Color8(230, 220, 245))
	prem_desc.autowrap_mode = TextServer.AUTOWRAP_WORD
	ui_labels.append({"node": prem_desc, "key": "SHOP_PRO_DESC", "type": "label"})
	prem_left_vb.add_child(prem_desc)

	var prem_right_vb = VBoxContainer.new()
	prem_right_vb.alignment = BoxContainer.ALIGNMENT_CENTER
	prem_right_vb.add_theme_constant_override("separation", 6)
	prem_hbox.add_child(prem_right_vb)

	var buy_btn = Button.new()
	if Global.is_premium:
		buy_btn.text = " " + LANG[Global.current_lang].get("PRO_ACTIVE", "PRO AKTİF")
		if ResourceLoader.exists("res://checkmark_icon.svg"):
			buy_btn.icon = load("res://checkmark_icon.svg")
			buy_btn.expand_icon = true
			buy_btn.add_theme_constant_override("icon_max_width", 22)
			buy_btn.add_theme_constant_override("h_separation", 6)
		buy_btn.disabled = true
		apply_3d_style_to_button(buy_btn, Color8(34, 140, 60, 230), Color8(18, 75, 30), 14, 3.5, 18, 10)
		buy_btn.add_theme_color_override("font_disabled_color", Color.WHITE)
	else:
		var price_str = Global.get_formatted_premium_price()
		var buy_text = ""
		var lang = Global.current_lang
		if lang == "TR":
			buy_text = price_str + " — SATIN AL"
		elif lang == "ESP" or lang == "POR":
			buy_text = price_str + " — COMPRAR"
		else:
			buy_text = price_str + " — BUY NOW"
		buy_btn.text = buy_text
		ui_labels.append({"node": buy_btn, "key": "SHOP_BUY", "type": "button_buy_premium"})
		apply_3d_style_to_button(buy_btn, Color8(255, 185, 0), Color8(185, 100, 0), 14, 4.5, 16, 10)
		buy_btn.add_theme_color_override("font_color", Color8(20, 10, 0))
		buy_btn.pressed.connect(_on_buy_premium_pressed)
	buy_btn.add_theme_font_override("font", custom_font)
	buy_btn.add_theme_font_size_override("font_size", 23)
	buy_btn.custom_minimum_size = Vector2(215, 58)
	prem_right_vb.add_child(buy_btn)

	var rest_shop_btn = Button.new()
	rest_shop_btn.text = LANG[Global.current_lang].get("RESTORE_PURCHASES", "Satın Alımları Geri Yükle")
	rest_shop_btn.add_theme_font_override("font", custom_font)
	rest_shop_btn.add_theme_font_size_override("font_size", 18)
	rest_shop_btn.add_theme_color_override("font_color", Color8(230, 220, 245))
	rest_shop_btn.custom_minimum_size = Vector2(215, 48)
	var rest_shop_style = StyleBoxFlat.new()
	rest_shop_style.bg_color = Color(0, 0, 0, 0)
	rest_shop_btn.add_theme_stylebox_override("normal", rest_shop_style)
	rest_shop_btn.pressed.connect(_on_restore_purchases_pressed)
	prem_right_vb.add_child(rest_shop_btn)

	# --- 4. SECTION A: BALL SKINS CAROUSEL ---
	var balls_panel = PanelContainer.new()
	var balls_p_style = StyleBoxFlat.new()
	var balls_bg = active_theme.bg_bottom.darkened(0.18)
	balls_p_style.bg_color = Color(balls_bg.r, balls_bg.g, balls_bg.b, 0.95)
	balls_p_style.corner_radius_top_left = 18; balls_p_style.corner_radius_top_right = 18
	balls_p_style.corner_radius_bottom_left = 18; balls_p_style.corner_radius_bottom_right = 18
	balls_p_style.border_width_left = 1.5; balls_p_style.border_width_right = 1.5
	balls_p_style.border_width_top = 1.5; balls_p_style.border_width_bottom = 4.0
	balls_p_style.border_color = active_theme.accent.darkened(0.25)
	balls_p_style.content_margin_left = 14; balls_p_style.content_margin_right = 14
	balls_p_style.content_margin_top = 16; balls_p_style.content_margin_bottom = 16
	balls_panel.add_theme_stylebox_override("panel", balls_p_style)
	balls_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.add_child(balls_panel)

	var balls_vbox = VBoxContainer.new()
	balls_vbox.alignment = BoxContainer.ALIGNMENT_BEGIN
	balls_vbox.add_theme_constant_override("separation", 10)
	balls_panel.add_child(balls_vbox)

	var balls_title = Label.new()
	balls_title.text = LANG[Global.current_lang]["SHOP_BALL_SKINS"]
	balls_title.add_theme_font_override("font", custom_font)
	balls_title.add_theme_font_size_override("font_size", 30)
	balls_title.add_theme_color_override("font_color", Color.WHITE)
	balls_title.add_theme_color_override("font_shadow_color", Color8(0, 0, 0, 160))
	balls_title.add_theme_constant_override("shadow_offset_y", 2)
	ui_labels.append({"node": balls_title, "key": "SHOP_BALL_SKINS", "type": "label"})
	balls_vbox.add_child(balls_title)

	var balls_scroll = ScrollContainer.new()
	balls_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	balls_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	balls_scroll.custom_minimum_size = Vector2(0, 310)
	balls_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	balls_vbox.add_child(balls_scroll)
	shop_balls_scroll = balls_scroll

	var balls_hbox = HBoxContainer.new()
	balls_hbox.add_theme_constant_override("separation", 14)
	balls_scroll.add_child(balls_hbox)

	var ball_skin_names = [
		{"id": "default", "name_key": "SKIN_CLASSIC", "price": 0, "color": Color.WHITE},
		{"id": "gold", "name_key": "SKIN_GOLD", "price": 100, "color": Color8(255,190,0)},
		{"id": "neon", "name_key": "SKIN_NEON", "price": 300, "color": Color8(90,255,50)},
		{"id": "chrome", "name_key": "SKIN_CHROME", "price": 400, "color": Color8(255,255,255)},
		{"id": "lava", "name_key": "SKIN_LAVA", "price": 500, "color": Color8(255,80,20)},
		{"id": "ice", "name_key": "SKIN_ICE", "price": 500, "color": Color8(100,230,255)}
	]

	for skin_data in ball_skin_names:
		var s_id = skin_data["id"]
		var s_name_key = skin_data["name_key"]
		var price = skin_data["price"]
		var bcolor = skin_data["color"]

		var card = PanelContainer.new()
		card.mouse_filter = Control.MOUSE_FILTER_PASS
		var card_style = StyleBoxFlat.new()
		card_style.bg_color = active_theme.bg_bottom.darkened(0.35)
		card_style.corner_radius_top_left = 16; card_style.corner_radius_top_right = 16
		card_style.corner_radius_bottom_left = 16; card_style.corner_radius_bottom_right = 16
		card_style.border_width_bottom = 4.0
		card_style.border_width_top = 1.5; card_style.border_width_left = 1.5; card_style.border_width_right = 1.5
		var bcolor_dark = bcolor.darkened(0.2) if s_id != "chrome" else Color8(180, 190, 210)
		card_style.border_color = bcolor_dark
		card_style.content_margin_top = 12; card_style.content_margin_bottom = 12
		card_style.content_margin_left = 12; card_style.content_margin_right = 12
		card.add_theme_stylebox_override("panel", card_style)
		card.custom_minimum_size = Vector2(215, 290)

		var card_vbox = VBoxContainer.new()
		card_vbox.mouse_filter = Control.MOUSE_FILTER_PASS
		card_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
		card_vbox.add_theme_constant_override("separation", 8)
		card.add_child(card_vbox)

		var ball_preview = Control.new()
		ball_preview.mouse_filter = Control.MOUSE_FILTER_PASS
		ball_preview.custom_minimum_size = Vector2(110, 110)
		ball_preview.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		ball_preview.draw.connect(func():
			var c = ball_preview.size / 2.0
			var r = 46.0
			ball_preview.draw_circle(c, r, Color.WHITE)
			Global.draw_ball_skin(ball_preview, c, r, s_id)
		)
		card_vbox.add_child(ball_preview)

		var name_lbl = create_label_node(s_name_key, Color.WHITE, 28)
		name_lbl.mouse_filter = Control.MOUSE_FILTER_PASS
		name_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		card_vbox.add_child(name_lbl)

		var action_btn = Button.new()
		action_btn.add_theme_font_override("font", custom_font)
		action_btn.add_theme_font_size_override("font_size", 26)
		action_btn.add_theme_color_override("font_shadow_color", Color8(0, 0, 0, 200))
		action_btn.add_theme_constant_override("shadow_offset_y", 2)
		action_btn.custom_minimum_size = Vector2(185, 54)
		action_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER

		if Global.is_skin_unlocked(s_id):
			if Global.equipped_ball_skin == s_id:
				action_btn.text = LANG[Global.current_lang]["SHOP_EQUIPPED"]
				ui_labels.append({"node": action_btn, "key": "SHOP_EQUIPPED", "type": "button"})
				action_btn.add_theme_color_override("font_color", Color8(100, 255, 120))
				apply_3d_style_to_button(action_btn, Color8(30, 80, 40, 220), Color8(15, 50, 25), 12, 3.0, 10, 6)
			else:
				action_btn.text = LANG[Global.current_lang]["SHOP_EQUIP"]
				ui_labels.append({"node": action_btn, "key": "SHOP_EQUIP", "type": "button"})
				action_btn.add_theme_color_override("font_color", Color.WHITE)
				apply_3d_style_to_button(action_btn, active_theme.bg_top.lightened(0.15), active_theme.bg_bottom.darkened(0.25), 12, 3.0, 10, 6)
				action_btn.pressed.connect(func():
					Global.play_click()
					Global.equipped_ball_skin = s_id
					Global.save_progression()
					_refresh_shop_tab()
				)
		else:
			action_btn.text = " " + str(price)
			if ResourceLoader.exists("res://jeton_icon.svg"):
				action_btn.icon = load("res://jeton_icon.svg")
				action_btn.expand_icon = true
				action_btn.add_theme_constant_override("icon_max_width", 24)
				action_btn.add_theme_constant_override("h_separation", 8)
			action_btn.add_theme_color_override("font_color", Color.WHITE)
			apply_3d_style_to_button(action_btn, active_theme.accent, active_theme.accent.darkened(0.35), 12, 3.5, 10, 6)
			action_btn.pressed.connect(func():
				Global.play_click()
				if Global.ad_credits >= price:
					Global.ad_credits -= price
					Global.unlocked_ball_skins.append(s_id)
					Global.equipped_ball_skin = s_id
					Global.save_progression()
					if Global.unlocked_ball_skins.size() >= 3:
						Global.unlock_achievement("COLLECTOR")
					_refresh_shop_tab()
					_show_toast(LANG[Global.current_lang][s_name_key] + " " + LANG[Global.current_lang]["SHOP_EQUIPPED"] + "!")
				else:
					_show_toast(LANG[Global.current_lang].get("NEED_MORE_COINS", "Yetersiz Jeton!"))
			)
		card_vbox.add_child(action_btn)
		balls_hbox.add_child(card)

	# --- 5. SECTION B: CROWNS & ACCESSORIES CAROUSEL ---
	var hats_panel = PanelContainer.new()
	var hats_p_style = StyleBoxFlat.new()
	var hats_bg = active_theme.bg_bottom.darkened(0.18)
	hats_p_style.bg_color = Color(hats_bg.r, hats_bg.g, hats_bg.b, 0.95)
	hats_p_style.corner_radius_top_left = 18; hats_p_style.corner_radius_top_right = 18
	hats_p_style.corner_radius_bottom_left = 18; hats_p_style.corner_radius_bottom_right = 18
	hats_p_style.border_width_left = 1.5; hats_p_style.border_width_right = 1.5
	hats_p_style.border_width_top = 1.5; hats_p_style.border_width_bottom = 4.0
	hats_p_style.border_color = active_theme.accent.darkened(0.25)
	hats_p_style.content_margin_left = 14; hats_p_style.content_margin_right = 14
	hats_p_style.content_margin_top = 16; hats_p_style.content_margin_bottom = 16
	hats_panel.add_theme_stylebox_override("panel", hats_p_style)
	hats_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.add_child(hats_panel)

	var hats_vbox = VBoxContainer.new()
	hats_vbox.alignment = BoxContainer.ALIGNMENT_BEGIN
	hats_vbox.add_theme_constant_override("separation", 10)
	hats_panel.add_child(hats_vbox)

	var hats_title = Label.new()
	hats_title.text = LANG[Global.current_lang]["SHOP_HATS"]
	hats_title.add_theme_font_override("font", custom_font)
	hats_title.add_theme_font_size_override("font_size", 30)
	hats_title.add_theme_color_override("font_color", Color.WHITE)
	hats_title.add_theme_color_override("font_shadow_color", Color8(0, 0, 0, 160))
	hats_title.add_theme_constant_override("shadow_offset_y", 2)
	ui_labels.append({"node": hats_title, "key": "SHOP_HATS", "type": "label"})
	hats_vbox.add_child(hats_title)

	var hats_scroll = ScrollContainer.new()
	hats_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	hats_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	hats_scroll.custom_minimum_size = Vector2(0, 310)
	hats_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hats_vbox.add_child(hats_scroll)
	shop_hats_scroll = hats_scroll

	var hats_hbox = HBoxContainer.new()
	hats_hbox.add_theme_constant_override("separation", 14)
	hats_scroll.add_child(hats_hbox)

	var hat_list = [
		{"id": "none", "name_key": "HAT_NONE", "price": 0, "icon": null},
		{"id": "kings_crown", "name_key": "HAT_KINGS_CROWN", "price": 500, "icon": preload("res://hat_kings_crown.png")},
		{"id": "queens_crown", "name_key": "HAT_QUEENS_CROWN", "price": 500, "icon": preload("res://hat_queens_crown.png")},
		{"id": "viking_helmet", "name_key": "HAT_VIKING", "price": 1250, "icon": preload("res://hat_viking.png")},
		{"id": "magic_hat", "name_key": "HAT_MAGIC", "price": 1500, "icon": preload("res://hat_magic.png")}
	]

	for h_data in hat_list:
		var h_id = h_data["id"]
		var h_name_key = h_data["name_key"]
		var h_price = h_data["price"]
		var h_icon = h_data["icon"]

		var card = PanelContainer.new()
		card.mouse_filter = Control.MOUSE_FILTER_PASS
		var card_style = StyleBoxFlat.new()
		card_style.bg_color = active_theme.bg_bottom.darkened(0.35)
		card_style.corner_radius_top_left = 16; card_style.corner_radius_top_right = 16
		card_style.corner_radius_bottom_left = 16; card_style.corner_radius_bottom_right = 16
		card_style.border_width_bottom = 4.0
		card_style.border_width_top = 1.5; card_style.border_width_left = 1.5; card_style.border_width_right = 1.5
		card_style.border_color = active_theme.accent.darkened(0.15) if h_id != "none" else active_theme.bg_top.lightened(0.1)
		card_style.content_margin_top = 12; card_style.content_margin_bottom = 12
		card_style.content_margin_left = 12; card_style.content_margin_right = 12
		card.add_theme_stylebox_override("panel", card_style)
		card.custom_minimum_size = Vector2(215, 290)

		var card_vbox = VBoxContainer.new()
		card_vbox.mouse_filter = Control.MOUSE_FILTER_PASS
		card_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
		card_vbox.add_theme_constant_override("separation", 8)
		card.add_child(card_vbox)

		var preview_box = Control.new()
		preview_box.mouse_filter = Control.MOUSE_FILTER_PASS
		preview_box.custom_minimum_size = Vector2(110, 110)
		preview_box.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		preview_box.draw.connect(func():
			var c = Vector2(preview_box.size.x / 2.0, preview_box.size.y / 2.0 + 12.0)
			var r = 34.0
			preview_box.draw_circle(c, r, Color.WHITE)
			preview_box.draw_arc(c, r, 0, TAU, 32, active_theme.accent, 2.8, true)
			if h_icon != null:
				var cr_w = 54.0
				var cr_h = 38.0
				var cr_rect = Rect2(c.x - cr_w / 2.0, c.y - r - cr_h + 8.0, cr_w, cr_h)
				preview_box.draw_texture_rect(h_icon, cr_rect, false)
			else:
				preview_box.draw_line(Vector2(c.x - 14, c.y - 14), Vector2(c.x + 14, c.y + 14), Color8(220, 50, 50), 3.0)
		)
		card_vbox.add_child(preview_box)

		var name_lbl = create_label_node(h_name_key, Color.WHITE, 28)
		name_lbl.mouse_filter = Control.MOUSE_FILTER_PASS
		name_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		card_vbox.add_child(name_lbl)

		var action_btn = Button.new()
		action_btn.add_theme_font_override("font", custom_font)
		action_btn.add_theme_font_size_override("font_size", 26)
		action_btn.add_theme_color_override("font_shadow_color", Color8(0, 0, 0, 200))
		action_btn.add_theme_constant_override("shadow_offset_y", 2)
		action_btn.custom_minimum_size = Vector2(185, 54)
		action_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER

		if Global.is_hat_unlocked(h_id):
			if Global.equipped_hat == h_id:
				action_btn.text = LANG[Global.current_lang]["SHOP_EQUIPPED"]
				ui_labels.append({"node": action_btn, "key": "SHOP_EQUIPPED", "type": "button"})
				action_btn.add_theme_color_override("font_color", Color8(100, 255, 120))
				apply_3d_style_to_button(action_btn, Color8(30, 80, 40, 220), Color8(15, 50, 25), 12, 3.0, 10, 6)
			else:
				action_btn.text = LANG[Global.current_lang]["SHOP_EQUIP"] if h_id != "none" else LANG[Global.current_lang]["SHOP_UNEQUIP"]
				action_btn.add_theme_color_override("font_color", Color.WHITE)
				apply_3d_style_to_button(action_btn, active_theme.bg_top.lightened(0.15), active_theme.bg_bottom.darkened(0.25), 12, 3.0, 10, 6)
				action_btn.pressed.connect(func():
					Global.play_click()
					Global.equipped_hat = h_id
					Global.save_progression()
					if h_id != "none":
						Global.unlock_achievement("ROYALTY")
					_refresh_shop_tab()
				)
		else:
			action_btn.text = " " + str(h_price)
			if ResourceLoader.exists("res://jeton_icon.svg"):
				action_btn.icon = load("res://jeton_icon.svg")
				action_btn.expand_icon = true
				action_btn.add_theme_constant_override("icon_max_width", 24)
				action_btn.add_theme_constant_override("h_separation", 8)
			action_btn.add_theme_color_override("font_color", Color.WHITE)
			apply_3d_style_to_button(action_btn, active_theme.accent, active_theme.accent.darkened(0.35), 12, 3.5, 10, 6)
			action_btn.pressed.connect(func():
				Global.play_click()
				if Global.ad_credits >= h_price:
					Global.ad_credits -= h_price
					Global.unlocked_hats.append(h_id)
					Global.equipped_hat = h_id
					Global.save_progression()
					Global.unlock_achievement("ROYALTY")
					_refresh_shop_tab()
					_show_toast(LANG[Global.current_lang][h_name_key] + " " + LANG[Global.current_lang]["SHOP_EQUIPPED"] + "!")
				else:
					_show_toast(LANG[Global.current_lang].get("NEED_MORE_COINS", "Yetersiz Jeton!"))
			)
		card_vbox.add_child(action_btn)
		hats_hbox.add_child(card)

	# --- 5. EXPOSED DAILY QUESTS SECTION (Detailed, Broad & Theme-Harmonized) ---
	var quests_panel = PanelContainer.new()
	var qp_style = StyleBoxFlat.new()
	qp_style.bg_color = active_theme.bg_bottom.darkened(0.12)
	qp_style.corner_radius_top_left = 18; qp_style.corner_radius_top_right = 18
	qp_style.corner_radius_bottom_left = 18; qp_style.corner_radius_bottom_right = 18
	qp_style.border_width_left = 2; qp_style.border_width_right = 2
	qp_style.border_width_top = 2; qp_style.border_width_bottom = 4
	qp_style.border_color = active_theme.accent
	qp_style.shadow_color = Color8(0, 0, 0, 140)
	qp_style.shadow_size = 16
	qp_style.content_margin_left = 20; qp_style.content_margin_right = 20
	qp_style.content_margin_top = 18; qp_style.content_margin_bottom = 18
	quests_panel.add_theme_stylebox_override("panel", qp_style)
	vbox.add_child(quests_panel)

	var qp_vbox = VBoxContainer.new()
	qp_vbox.add_theme_constant_override("separation", 14)
	quests_panel.add_child(qp_vbox)

	# Quests Section Header
	var q_header_hbox = HBoxContainer.new()
	q_header_hbox.alignment = BoxContainer.ALIGNMENT_BEGIN
	q_header_hbox.add_theme_constant_override("separation", 10)
	qp_vbox.add_child(q_header_hbox)

	if ResourceLoader.exists("res://quest_icon.svg"):
		var q_ic = TextureRect.new()
		q_ic.texture = load("res://quest_icon.svg")
		q_ic.custom_minimum_size = Vector2(28, 28)
		q_ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		q_ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		q_ic.modulate = active_theme.accent
		q_header_hbox.add_child(q_ic)

	var q_title_lbl = Label.new()
	q_title_lbl.text = LANG.get(Global.current_lang, LANG["ENG"]).get("DAILY_QUESTS_TITLE", "GÜNLÜK GÖREVLER")
	q_title_lbl.add_theme_font_override("font", custom_font)
	q_title_lbl.add_theme_font_size_override("font_size", 28)
	q_title_lbl.add_theme_color_override("font_color", Color.WHITE)
	q_header_hbox.add_child(q_title_lbl)

	var q_spacer = Control.new()
	q_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	q_header_hbox.add_child(q_spacer)

	var q_date_lbl = Label.new()
	q_date_lbl.text = Global.daily_date
	q_date_lbl.add_theme_font_override("font", custom_font)
	q_date_lbl.add_theme_font_size_override("font_size", 18)
	q_date_lbl.add_theme_color_override("font_color", active_theme.accent)
	q_header_hbox.add_child(q_date_lbl)

	# Quests Cards List
	for q in Global.daily_quests:
		var q_card = PanelContainer.new()
		var qc_style = StyleBoxFlat.new()
		qc_style.bg_color = active_theme.bg_top.darkened(0.15)
		qc_style.corner_radius_top_left = 12; qc_style.corner_radius_top_right = 12
		qc_style.corner_radius_bottom_left = 12; qc_style.corner_radius_bottom_right = 12
		qc_style.border_width_bottom = 2.5; qc_style.border_color = active_theme.bg_bottom.darkened(0.35)
		qc_style.content_margin_left = 14; qc_style.content_margin_right = 14
		qc_style.content_margin_top = 10; qc_style.content_margin_bottom = 10
		q_card.add_theme_stylebox_override("panel", qc_style)
		qp_vbox.add_child(q_card)

		var q_row = HBoxContainer.new()
		q_row.alignment = BoxContainer.ALIGNMENT_CENTER
		q_row.add_theme_constant_override("separation", 12)
		q_card.add_child(q_row)

		var text_col = VBoxContainer.new()
		text_col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		text_col.add_theme_constant_override("separation", 4)
		q_row.add_child(text_col)

		var desc_lbl = Label.new()
		var desc_dict = q.get("desc", {})
		desc_lbl.text = desc_dict.get(Global.current_lang, desc_dict.get("ENG", "Görev"))
		desc_lbl.add_theme_font_override("font", custom_font)
		desc_lbl.add_theme_font_size_override("font_size", 20)
		desc_lbl.add_theme_color_override("font_color", Color.WHITE)
		desc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD
		text_col.add_child(desc_lbl)

		# Progress bar and details
		var cur_p = int(q.get("progress", 0))
		var tgt_p = max(1, int(q.get("target", 1)))
		var r_amount = int(q.get("reward", 30))
		var is_claimed = bool(q.get("claimed", false))
		var is_ready = cur_p >= tgt_p

		var prog_hbox = HBoxContainer.new()
		prog_hbox.add_theme_constant_override("separation", 8)
		text_col.add_child(prog_hbox)

		var pbar = ProgressBar.new()
		pbar.custom_minimum_size = Vector2(160, 14)
		pbar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		pbar.min_value = 0
		pbar.max_value = tgt_p
		pbar.value = cur_p
		pbar.show_percentage = false
		var pb_bg = StyleBoxFlat.new()
		pb_bg.bg_color = Color8(20, 25, 35, 200)
		pb_bg.corner_radius_top_left = 6; pb_bg.corner_radius_top_right = 6
		pb_bg.corner_radius_bottom_left = 6; pb_bg.corner_radius_bottom_right = 6
		pbar.add_theme_stylebox_override("background", pb_bg)
		var pb_fill = StyleBoxFlat.new()
		pb_fill.bg_color = Color8(34, 197, 94) if is_ready else active_theme.accent
		pb_fill.corner_radius_top_left = 6; pb_fill.corner_radius_top_right = 6
		pb_fill.corner_radius_bottom_left = 6; pb_fill.corner_radius_bottom_right = 6
		pbar.add_theme_stylebox_override("fill", pb_fill)
		prog_hbox.add_child(pbar)

		var p_txt_lbl = Label.new()
		p_txt_lbl.text = str(cur_p) + "/" + str(tgt_p) + "  •  +" + str(r_amount) + " " + LANG.get(Global.current_lang, LANG["ENG"]).get("CURRENCY", "Jeton")
		p_txt_lbl.add_theme_font_override("font", custom_font)
		p_txt_lbl.add_theme_font_size_override("font_size", 16)
		p_txt_lbl.add_theme_color_override("font_color", Color8(255, 215, 0))
		prog_hbox.add_child(p_txt_lbl)

		# Action / Claim button
		var claim_btn = Button.new()
		claim_btn.add_theme_font_override("font", custom_font)
		claim_btn.add_theme_font_size_override("font_size", 20)
		claim_btn.custom_minimum_size = Vector2(140, 48)
		claim_btn.size_flags_vertical = Control.SIZE_SHRINK_CENTER

		if is_claimed:
			claim_btn.text = " " + LANG.get(Global.current_lang, LANG["ENG"]).get("QUEST_CLAIMED", "ALINDI")
			if ResourceLoader.exists("res://checkmark_icon.svg"):
				claim_btn.icon = load("res://checkmark_icon.svg")
				claim_btn.expand_icon = true
				claim_btn.add_theme_constant_override("icon_max_width", 18)
				claim_btn.add_theme_constant_override("h_separation", 6)
			claim_btn.disabled = true
			apply_3d_style_to_button(claim_btn, Color8(30, 80, 40, 200), Color8(15, 50, 25), 10, 2)
			claim_btn.add_theme_color_override("font_disabled_color", Color8(100, 255, 120))
		elif is_ready:
			claim_btn.text = LANG.get(Global.current_lang, LANG["ENG"]).get("QUEST_CLAIM", "ÖDÜLÜ AL")
			apply_3d_style_to_button(claim_btn, active_theme.accent, active_theme.accent.darkened(0.35), 10, 3)
			claim_btn.add_theme_color_override("font_color", Color.WHITE)
			var q_id = q["id"]
			claim_btn.pressed.connect(func():
				Global.play_click()
				var earned = Global.claim_quest_reward(q_id)
				if earned > 0:
					var rew_fmt = LANG.get(Global.current_lang, LANG["ENG"]).get("EARNED_REWARD", "+%s %s")
					_show_toast(rew_fmt % [str(earned), LANG.get(Global.current_lang, LANG["ENG"]).get("CURRENCY", "Jeton")])
					_refresh_shop_tab()
			)
		else:
			claim_btn.text = LANG.get(Global.current_lang, LANG["ENG"]).get("QUEST_IN_PROGRESS", "DEVAM EDİYOR")
			claim_btn.disabled = true
			apply_3d_style_to_button(claim_btn, Color8(45, 55, 75, 180), Color8(25, 30, 45), 10, 2)
			claim_btn.add_theme_color_override("font_disabled_color", Color8(150, 160, 180))

		q_row.add_child(claim_btn)

	# Bottom spacing for comfortable vertical scroll above bottom nav bar
	var sp_bottom = Control.new()
	sp_bottom.custom_minimum_size = Vector2(0, 140)
	vbox.add_child(sp_bottom)

	return page

func _on_buy_premium_pressed():
	var bg_overlay = ColorRect.new()
	bg_overlay.color = Color(0, 0, 0, 0.75)
	bg_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg_overlay)

	var dlg = PanelContainer.new()
	var dlg_style = StyleBoxFlat.new()
	dlg_style.bg_color = active_theme.bg_bottom.darkened(0.15)
	dlg_style.corner_radius_top_left = 22; dlg_style.corner_radius_top_right = 22
	dlg_style.corner_radius_bottom_left = 22; dlg_style.corner_radius_bottom_right = 22
	dlg_style.border_width_top = 2.5; dlg_style.border_width_bottom = 4.5
	dlg_style.border_width_left = 2.5; dlg_style.border_width_right = 2.5
	dlg_style.border_color = active_theme.accent
	dlg_style.shadow_color = Color8(0, 0, 0, 180)
	dlg_style.shadow_size = 30
	dlg_style.content_margin_left = 36; dlg_style.content_margin_right = 36
	dlg_style.content_margin_top = 30; dlg_style.content_margin_bottom = 30
	dlg.add_theme_stylebox_override("panel", dlg_style)
	dlg.custom_minimum_size = Vector2(min(get_viewport_rect().size.x * 0.92, 580), 0)

	var dlg_center = CenterContainer.new()
	dlg_center.set_anchors_preset(Control.PRESET_FULL_RECT)
	dlg_center.add_child(dlg)
	bg_overlay.add_child(dlg_center)

	var dlg_vbox = VBoxContainer.new()
	dlg_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	dlg_vbox.add_theme_constant_override("separation", 22)
	dlg.add_child(dlg_vbox)

	var lang = Global.current_lang
	
	var titles = {
		"TR": "PRO'ya Yükselt",
		"ENG": "Upgrade to PRO",
		"ESP": "Mejorar a PRO",
		"POR": "Melhorar para PRO"
	}
	
	var p_price = Global.get_formatted_premium_price()
	var desc_dict = {
		"TR": "%s karşılığında tüm premium özelliklere kalıcı erişim elde et. Bu satın alım Google Play üzerinden gerçekleşir." % p_price,
		"ENG": "Get permanent access to all premium features for %s. This purchase goes through Google Play." % p_price,
		"ESP": "Obtén acceso permanente a todas las funciones premium por %s. Esta compra se realiza a través de Google Play." % p_price,
		"POR": "Obtenha acesso permanente a todos os recursos premium por %s. Esta compra é feita através do Google Play." % p_price
	}

	var dlg_title = Label.new()
	dlg_title.text = titles.get(lang, titles["TR"])
	dlg_title.add_theme_font_override("font", custom_font)
	dlg_title.add_theme_font_size_override("font_size", 40)
	dlg_title.add_theme_color_override("font_color", Color.WHITE)
	dlg_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	dlg_vbox.add_child(dlg_title)

	var dlg_desc = Label.new()
	dlg_desc.text = desc_dict.get(lang, desc_dict["TR"])
	dlg_desc.add_theme_font_override("font", custom_font)
	dlg_desc.add_theme_font_size_override("font_size", 26)
	dlg_desc.add_theme_color_override("font_color", Color8(235, 240, 255))
	dlg_desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	dlg_desc.autowrap_mode = TextServer.AUTOWRAP_WORD
	dlg_vbox.add_child(dlg_desc)

	var dlg_hbox = HBoxContainer.new()
	dlg_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	dlg_hbox.add_theme_constant_override("separation", 20)
	dlg_vbox.add_child(dlg_hbox)

	var cancel_btn = Button.new()
	cancel_btn.text = LANG[Global.current_lang].get("SHOP_CANCEL", "VAZGEÇ")
	cancel_btn.add_theme_font_override("font", custom_font)
	cancel_btn.add_theme_font_size_override("font_size", 26)
	cancel_btn.custom_minimum_size = Vector2(190, 58)
	apply_3d_style_to_button(cancel_btn, active_theme.bg_top.lightened(0.15), active_theme.bg_bottom.darkened(0.3), 12, 3)
	cancel_btn.pressed.connect(func():
		Global.play_click()
		bg_overlay.queue_free()
	)
	dlg_hbox.add_child(cancel_btn)

	var confirm_btn = Button.new()
	confirm_btn.text = LANG[Global.current_lang].get("CONFIRM_YES", "SATIN AL")
	confirm_btn.add_theme_font_override("font", custom_font)
	confirm_btn.add_theme_font_size_override("font_size", 26)
	confirm_btn.add_theme_color_override("font_color", Color8(10, 10, 10))
	confirm_btn.custom_minimum_size = Vector2(190, 58)
	apply_3d_style_to_button(confirm_btn, Color8(255, 190, 0), Color8(190, 110, 0), 12, 4)
	confirm_btn.pressed.connect(func():
		Global.play_click()
		bg_overlay.queue_free()
		if billing:
			if not billing.is_ready():
				_show_toast(LANG[Global.current_lang].get("AD_PREPARING", "Lütfen birkaç saniye sonra tekrar deneyin..."))
				billing.start_connection()
				return
			
			var response = billing.purchase("premium_unlock")
			print("Billing purchase started: ", response)
			var r_code = response.get("response_code", -1)
			if r_code == BillingClient.BillingResponseCode.ITEM_ALREADY_OWNED:
				Global.is_premium = true
				Global.save_progression()
				_refresh_shop_tab()
				_show_toast(LANG[Global.current_lang].get("PRO_ACTIVE", "PRO AKTİF!"))
			elif r_code != BillingClient.BillingResponseCode.OK and r_code != -1:
				print("Billing error response code: ", r_code, " debug: ", response.get("debug_message", ""))
				billing.query_product_details(PackedStringArray(["premium_unlock"]), BillingClient.ProductType.INAPP)
		else:
			print("Mocking successful premium purchase on PC")
			Global.is_premium = true
			Global.save_progression()
			_refresh_shop_tab()
			_show_toast(LANG[Global.current_lang].get("PRO_ACTIVE", "PRO AKTİF!"))
	)
	dlg_hbox.add_child(confirm_btn)

# ======================================================
# SWIPE INPUT
# ======================================================
func _is_pos_in_shop_carousels(pos: Vector2) -> bool:
	if current_tab != 2:
		return false
	if is_instance_valid(shop_balls_scroll) and shop_balls_scroll.is_visible_in_tree():
		if shop_balls_scroll.get_global_rect().has_point(pos):
			return true
	if is_instance_valid(shop_hats_scroll) and shop_hats_scroll.is_visible_in_tree():
		if shop_hats_scroll.get_global_rect().has_point(pos):
			return true
	return false

func _input(event: InputEvent):
	if settings_overlay != null and settings_overlay.visible:
		return
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_RIGHT and current_tab < 2:
			_switch_tab(current_tab + 1)
		elif event.keycode == KEY_LEFT and current_tab > 0:
			_switch_tab(current_tab - 1)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if _is_pos_in_shop_carousels(event.position):
					swipe_active = false
				else:
					swipe_start = event.position
					swipe_active = true
			else:
				swipe_active = false
	elif event is InputEventScreenTouch:
		if event.pressed:
			if _is_pos_in_shop_carousels(event.position):
				swipe_active = false
			else:
				swipe_start = event.position
				swipe_active = true
		else:
			swipe_active = false
	elif swipe_active and (event is InputEventMouseMotion or event is InputEventScreenDrag):
		var pos = event.position
		var delta_x = pos.x - swipe_start.x
		var delta_y = abs(pos.y - swipe_start.y)
		if abs(delta_x) > swipe_threshold and abs(delta_x) > delta_y * 1.5:
			swipe_active = false
			if delta_x < 0 and current_tab < 2:
				_switch_tab(current_tab + 1)
			elif delta_x > 0 and current_tab > 0:
				_switch_tab(current_tab - 1)

# ======================================================
# ADMOB & SHOP LOGIC
# ======================================================
func _update_shop_notification():
	if not is_instance_valid(shop_notification_dot): return
	var has_notif = false
	Global.check_daily_reset()
	for q in Global.daily_quests:
		if not q.get("claimed", false) and int(q.get("progress", 0)) >= int(q.get("target", 1)):
			has_notif = true
			break
	if Global.lucky_wheel_free_spins_used < 1: has_notif = true
	if Global.lucky_wheel_pending_ad_spins > 0: has_notif = true
	if Global.lucky_wheel_ad_spins_used < 3: has_notif = true
	shop_notification_dot.visible = has_notif

func _refresh_shop_tab():
	_update_shop_notification()
	# 1. Update all currency labels across all UI elements
	for item in ui_labels:
		if is_instance_valid(item.get("node")):
			var t = item.get("type")
			if t == "currency_val" and item.node is Label:
				item.node.text = str(Global.ad_credits)
			elif t == "currency" and item.node is Label:
				item.node.text = str(Global.ad_credits) + " " + LANG[Global.current_lang]["CURRENCY"]
				
	# 2. If shop tab is currently built at index 2, cleanly rebuild it without displacing tab containers
	if tabs_hbox and tabs_hbox.get_child_count() > 2:
		var current_shop = tabs_hbox.get_child(2)
		if current_shop and current_shop.name != "Shop_Placeholder":
			var sw = get_viewport_rect().size.x
			tabs_hbox.remove_child(current_shop)
			current_shop.queue_free()
			var sh = get_viewport_rect().size.y
			var new_shop = _build_shop_tab()
			new_shop.custom_minimum_size = Vector2(sw, sh)
			new_shop.size_flags_vertical = Control.SIZE_EXPAND_FILL
			tabs_hbox.add_child(new_shop)
			tabs_hbox.move_child(new_shop, 2)
			_connect_all_buttons(new_shop)
			# Lock position firmly to current tab
			tabs_hbox.position.x = -current_tab * sw

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		if is_instance_valid(settings_overlay) and settings_overlay.visible:
			settings_overlay.visible = false
			return
		if is_instance_valid(player_list_overlay) and player_list_overlay.visible:
			player_list_overlay.visible = false
			return
		_show_exit_confirmation()

func _show_exit_confirmation():
	var overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 0.75)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(overlay)
	
	var center = CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.add_child(center)
	
	var p = PanelContainer.new()
	var p_s = StyleBoxFlat.new()
	p_s.bg_color = active_theme.bg_bottom.darkened(0.15)
	p_s.corner_radius_top_left = 22; p_s.corner_radius_top_right = 22
	p_s.corner_radius_bottom_left = 22; p_s.corner_radius_bottom_right = 22
	p_s.border_width_left = 2.5; p_s.border_width_right = 2.5
	p_s.border_width_top = 2.5; p_s.border_width_bottom = 4.5
	p_s.border_color = active_theme.accent
	p_s.shadow_color = Color8(0, 0, 0, 180)
	p_s.shadow_size = 25
	p_s.content_margin_left = 32; p_s.content_margin_right = 32
	p_s.content_margin_top = 26; p_s.content_margin_bottom = 26
	p.add_theme_stylebox_override("panel", p_s)
	p.custom_minimum_size = Vector2(500, 0)
	center.add_child(p)
	
	var vb = VBoxContainer.new()
	vb.alignment = BoxContainer.ALIGNMENT_CENTER
	vb.add_theme_constant_override("separation", 25)
	p.add_child(vb)
	
	var lbl = Label.new()
	lbl.text = LANG[Global.current_lang].get("EXIT_CONFIRM", "Oyundan çıkmak istiyor musunuz?")
	lbl.add_theme_font_override("font", custom_font)
	lbl.add_theme_font_size_override("font_size", 30)
	lbl.add_theme_color_override("font_color", Color.WHITE)
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl.autowrap_mode = TextServer.AUTOWRAP_WORD
	vb.add_child(lbl)
	
	var hb = HBoxContainer.new()
	hb.alignment = BoxContainer.ALIGNMENT_CENTER
	hb.add_theme_constant_override("separation", 24)
	vb.add_child(hb)
	
	var no_b = Button.new()
	no_b.text = LANG[Global.current_lang]["CLOSE"]
	no_b.add_theme_font_override("font", custom_font)
	no_b.add_theme_font_size_override("font_size", 26)
	no_b.custom_minimum_size = Vector2(160, 55)
	apply_3d_style_to_button(no_b, active_theme.bg_top.lightened(0.15), active_theme.bg_bottom.darkened(0.3), 12, 3)
	no_b.pressed.connect(func(): Global.play_click(); overlay.queue_free())
	hb.add_child(no_b)
	
	var yes_b = Button.new()
	yes_b.text = LANG[Global.current_lang]["CONFIRM_YES"]
	yes_b.add_theme_font_override("font", custom_font)
	yes_b.add_theme_font_size_override("font_size", 26)
	yes_b.add_theme_color_override("font_color", Color.WHITE)
	yes_b.custom_minimum_size = Vector2(160, 55)
	apply_3d_style_to_button(yes_b, active_theme.accent, active_theme.accent.darkened(0.35), 12, 4)
	yes_b.pressed.connect(func():
		Global.play_click()
		get_tree().quit()
	)
	hb.add_child(yes_b)

func _open_privacy_policy_modal():
	Global.play_click()
	var lang = Global.current_lang
	
	var overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 0.75)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(overlay)
	
	var center = CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.add_child(center)
	
	var p_panel = PanelContainer.new()
	var p_style = StyleBoxFlat.new()
	p_style.bg_color = active_theme.bg_bottom.darkened(0.15)
	p_style.corner_radius_top_left = 24; p_style.corner_radius_top_right = 24
	p_style.corner_radius_bottom_left = 24; p_style.corner_radius_bottom_right = 24
	p_style.border_width_left = 2.5; p_style.border_width_right = 2.5
	p_style.border_width_top = 2.5; p_style.border_width_bottom = 4.5
	p_style.border_color = active_theme.accent
	p_style.shadow_color = Color8(0, 0, 0, 180)
	p_style.shadow_size = 25
	p_style.content_margin_left = 30; p_style.content_margin_right = 30
	p_style.content_margin_top = 30; p_style.content_margin_bottom = 30
	p_panel.add_theme_stylebox_override("panel", p_style)
	p_panel.custom_minimum_size = Vector2(min(get_viewport_rect().size.x * 0.9, 650), 0)
	center.add_child(p_panel)
	
	var pvbox = VBoxContainer.new()
	pvbox.alignment = BoxContainer.ALIGNMENT_CENTER
	pvbox.add_theme_constant_override("separation", 18)
	p_panel.add_child(pvbox)
	
	var p_title = Label.new()
	p_title.text = LANG[lang].get("PRIVACY_TITLE", "GİZLİLİK POLİTİKASI")
	p_title.add_theme_font_override("font", custom_font)
	p_title.add_theme_font_size_override("font_size", 34)
	p_title.add_theme_color_override("font_color", active_theme.accent)
	p_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	pvbox.add_child(p_title)
	
	var policy_texts = {
		"TR": "Bol Gol Futbol, kullanıcı gizliliğine tam saygı duyar. Uygulamamız kişisel veri toplamaz veya satmaz. Oyun içi reklamlar (Google AdMob), uygulama içi satın alımlar (Google Play Billing) ve oturum (Play Games) Google'ın standart güvenli altyapısıyla çalışır.",
		"ENG": "Bol Gol Futbol respects your privacy. We do not collect or sell personal data. In-game ads (Google AdMob), purchases (Google Play Billing), and sign-in (Play Games) operate under Google's standard secure privacy framework.",
		"ESP": "Bol Gol Futbol respeta su privacidad. No recopilamos ni vendemos datos personales. Los anuncios (AdMob), compras (Google Play Billing) e inicio de sesión funcionan bajo los estándares de privacidad de Google.",
		"POR": "Bol Gol Futbol respeita a sua privacidade. Não coletamos nem vendemos dados pessoais. Anúncios (AdMob), compras (Google Play Billing) e login funcionam sob os padrões de privacidade da Google."
	}
	
	var p_body = Label.new()
	p_body.text = policy_texts.get(lang, policy_texts["ENG"])
	p_body.add_theme_font_override("font", custom_font)
	p_body.add_theme_font_size_override("font_size", 22)
	p_body.add_theme_color_override("font_color", Color.WHITE)
	p_body.autowrap_mode = TextServer.AUTOWRAP_WORD
	p_body.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	pvbox.add_child(p_body)
	
	var close_btn = Button.new()
	close_btn.text = LANG[lang]["CLOSE"]
	close_btn.add_theme_font_override("font", custom_font)
	close_btn.add_theme_font_size_override("font_size", 24)
	close_btn.custom_minimum_size = Vector2(180, 55)
	close_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	apply_3d_style_to_button(close_btn, active_theme.accent, active_theme.accent.darkened(0.35), 12, 3)
	close_btn.pressed.connect(func():
		Global.play_click()
		overlay.queue_free()
	)
	pvbox.add_child(close_btn)

func _on_restore_purchases_pressed():
	Global.play_click()
	if billing:
		billing.query_purchases(BillingClient.ProductType.INAPP)
		_show_toast(LANG[Global.current_lang].get("RESTORE_CHECK", "Satın alımlarınız kontrol ediliyor..."))
	else:
		_show_toast(LANG[Global.current_lang].get("RESTORE_SUCCESS", "Satın alımlar güncellendi!"))

func _show_toast(msg: String):
	var toast = PanelContainer.new()
	var t_style = StyleBoxFlat.new()
	t_style.bg_color = active_theme.bg_bottom.darkened(0.12)
	t_style.corner_radius_top_left = 22; t_style.corner_radius_top_right = 22
	t_style.corner_radius_bottom_left = 22; t_style.corner_radius_bottom_right = 22
	t_style.border_width_left = 2; t_style.border_width_right = 2
	t_style.border_width_top = 2; t_style.border_width_bottom = 3
	t_style.border_color = active_theme.accent
	t_style.shadow_color = Color8(0, 0, 0, 180)
	t_style.shadow_size = 20
	t_style.shadow_offset = Vector2(0, 6)
	t_style.content_margin_left = 28; t_style.content_margin_right = 28
	t_style.content_margin_top = 14; t_style.content_margin_bottom = 14
	toast.add_theme_stylebox_override("panel", t_style)
	toast.custom_minimum_size = Vector2(min(get_viewport_rect().size.x * 0.88, 540), 0)
	
	var lbl = Label.new()
	lbl.text = msg
	lbl.add_theme_font_override("font", custom_font)
	lbl.add_theme_font_size_override("font_size", 26)
	lbl.add_theme_color_override("font_color", Color.WHITE)
	lbl.add_theme_color_override("font_shadow_color", Color8(0, 0, 0, 180))
	lbl.add_theme_constant_override("shadow_offset_y", 2)
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	toast.add_child(lbl)
	
	var center = CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_TOP_WIDE)
	center.position.y = 150.0
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	toast.mouse_filter = Control.MOUSE_FILTER_IGNORE
	center.add_child(toast)
	add_child(center)
	
	toast.modulate.a = 0.0
	toast.scale = Vector2(0.9, 0.9)
	toast.pivot_offset = toast.size / 2.0
	
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(toast, "modulate:a", 1.0, 0.35)
	tween.tween_property(toast, "scale", Vector2(1.0, 1.0), 0.35)
	tween.tween_property(center, "position:y", 160.0, 0.35).from(130.0)
	
	var fade_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	fade_tween.tween_interval(2.5)
	fade_tween.tween_property(toast, "modulate:a", 0.0, 0.3)
	fade_tween.tween_callback(center.queue_free)

func _get_menu_banner_id() -> String:
	var admob_node = Global.get_admob()
	if admob_node:
		if not admob_node.is_real:
			if OS.has_feature("ios"):
				if admob_node.ios_debug_banner_id != "":
					return admob_node.ios_debug_banner_id
				return "ca-app-pub-3940256099942544/2934735716"
			else:
				if admob_node.android_debug_banner_id != "":
					return admob_node.android_debug_banner_id
				return "ca-app-pub-3940256099942544/2014213617"
		else:
			if admob_node.android_real_banner_id != "":
				return admob_node.android_real_banner_id
	return MENU_BANNER_ID

func _ensure_menu_top_banner():
	if Global.is_premium:
		var admob_node = Global.get_admob()
		if admob_node:
			if admob_node.has_method("remove_banner_ad"):
				admob_node.remove_banner_ad()
			elif admob_node.has_method("hide_banner_ad"):
				admob_node.hide_banner_ad()
		menu_banner_ad_id = ""
		return
	
	var admob_node = Global.get_admob()
	if not admob_node: return

	# If already loaded and active for menu, ensure it is shown
	if menu_banner_ad_id != "":
		if admob_node.has_method("show_banner_ad"):
			admob_node.show_banner_ad(menu_banner_ad_id)
		return
	
	if is_banner_loading:
		return
	
	var is_inited = admob_node.get("is_initialization_completed") == true
	if not is_inited:
		if not admob_node.is_connected("initialization_completed", Callable(self, "_on_admob_initialized")):
			admob_node.connect("initialization_completed", Callable(self, "_on_admob_initialized"), CONNECT_ONE_SHOT)
		return

	is_banner_loading = true
	await get_tree().process_frame
	if not is_inside_tree() or Global.is_premium or menu_banner_ad_id != "":
		is_banner_loading = false
		return

	var target_ad_unit = _get_menu_banner_id()
	if target_ad_unit == "":
		is_banner_loading = false
		return
	
	if admob_node.has_method("set_banner_position"):
		admob_node.set_banner_position(LoadAdRequest.AdPosition.TOP)
	if admob_node.has_method("set_banner_size"):
		admob_node.set_banner_size(LoadAdRequest.RequestedAdSize.ADAPTIVE)
	if admob_node.has_method("set_banner_collapsible_position"):
		admob_node.set_banner_collapsible_position(LoadAdRequest.CollapsiblePosition.DISABLED)
	if admob_node.has_method("set_banner_anchor_to_safe_area"):
		admob_node.set_banner_anchor_to_safe_area(false)
	
	if admob_node.has_method("create_banner_ad_request") and admob_node.has_method("load_banner_ad"):
		get_tree().create_timer(12.0).timeout.connect(func():
			if is_banner_loading and menu_banner_ad_id == "":
				is_banner_loading = false
		)
		var req = admob_node.create_banner_ad_request()
		req.set_ad_unit_id(target_ad_unit)
		req.set_ad_position(LoadAdRequest.AdPosition.TOP)
		req.set_ad_size(LoadAdRequest.RequestedAdSize.BANNER)
		if req.has_method("set_collapsible_position"):
			req.set_collapsible_position(LoadAdRequest.CollapsiblePosition.DISABLED)
		if req.has_method("set_anchor_to_safe_area"):
			req.set_anchor_to_safe_area(false)
		admob_node.load_banner_ad(req)
	elif admob_node.has_method("show_banner_ad"):
		is_banner_loading = false
		admob_node.show_banner_ad()

func _request_rewarded_ad():
	if is_rewarded_loading: return
	var admob_node = Global.get_admob()
	if admob_node and admob_node.has_method("load_rewarded_ad"):
		if admob_node.has_method("is_rewarded_ad_loaded") and admob_node.is_rewarded_ad_loaded():
			return
		is_rewarded_loading = true
		admob_node.load_rewarded_ad()

var active_reward_purpose: String = "general"
var wheel_on_reward_callback: Callable = Callable()

func _show_admob_rewarded():
	Global.play_click()
	active_reward_purpose = "general"
	var admob_node = Global.get_admob()
	if admob_node and admob_node.has_method("show_rewarded_ad"):
		if admob_node.has_method("is_rewarded_ad_loaded") and admob_node.is_rewarded_ad_loaded():
			admob_node.show_rewarded_ad()
		else:
			_show_toast(LANG.get(Global.current_lang, LANG["ENG"]).get("AD_PREPARING", "Reklam hazırlanıyor, lütfen birkaç saniye sonra tekrar deneyin..."))
			_request_rewarded_ad()
	else:
		# Fallback for testing on PC without plugin
		print("AdMob plugin not loaded. Mocking reward +50 credits.")
		_on_rewarded_video_earned(null, null)

func _show_prize_dialog(title_txt: String, amount_txt: String, sub_txt: String = ""):
	Global.play_goal_music()
	var overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 0.88)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(overlay)
	
	var center = CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.add_child(center)
	
	var panel = PanelContainer.new()
	var p_style = StyleBoxFlat.new()
	p_style.bg_color = active_theme.bg_bottom.darkened(0.25)
	p_style.corner_radius_top_left = 26; p_style.corner_radius_top_right = 26
	p_style.corner_radius_bottom_left = 26; p_style.corner_radius_bottom_right = 26
	p_style.border_width_left = 2.0; p_style.border_width_right = 2.0
	p_style.border_width_top = 2.5; p_style.border_width_bottom = 6.0
	p_style.border_color = Color8(255, 215, 0, 230) # Gold specular border
	p_style.shadow_color = Color8(0, 0, 0, 220)
	p_style.shadow_size = 45
	p_style.content_margin_left = 38; p_style.content_margin_right = 38
	p_style.content_margin_top = 32; p_style.content_margin_bottom = 30
	panel.add_theme_stylebox_override("panel", p_style)
	panel.custom_minimum_size = Vector2(min(get_viewport_rect().size.x * 0.92, 500), 0)
	panel.pivot_offset = Vector2(min(get_viewport_rect().size.x * 0.92, 500) / 2.0, 200)
	center.add_child(panel)
	
	# Pop-in scale bounce animation
	panel.scale = Vector2(0.8, 0.8)
	panel.modulate.a = 0.0
	var pop_tw = create_tween().set_parallel(true).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	pop_tw.tween_property(panel, "scale", Vector2.ONE, 0.45)
	pop_tw.tween_property(panel, "modulate:a", 1.0, 0.35)
	
	var vbox = VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 16)
	panel.add_child(vbox)
	
	var t_lbl = Label.new()
	t_lbl.text = title_txt
	t_lbl.add_theme_font_override("font", custom_font)
	t_lbl.add_theme_font_size_override("font_size", 44)
	t_lbl.add_theme_color_override("font_color", Color8(255, 235, 140))
	t_lbl.add_theme_color_override("font_shadow_color", Color8(180, 100, 0, 200))
	t_lbl.add_theme_constant_override("shadow_offset_y", 3)
	t_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(t_lbl)
	
	# Coin Showcase Container with Glowing Aura Backdrop
	var coin_box = CenterContainer.new()
	coin_box.custom_minimum_size = Vector2(130, 130)
	vbox.add_child(coin_box)
	
	var aura = Control.new()
	aura.custom_minimum_size = Vector2(130, 130)
	aura.draw.connect(func():
		var c = aura.size / 2.0
		# Multi-layered golden sunburst glow
		aura.draw_circle(c, 58.0, Color8(255, 215, 0, 45))
		aura.draw_circle(c, 44.0, Color8(255, 255, 200, 60))
		# Radiating sparkle glints
		var num_rays = 8
		for k in range(num_rays):
			var a = k * (TAU / float(num_rays))
			var r_end = c + Vector2(cos(a), sin(a)) * 62.0
			aura.draw_line(c, r_end, Color8(255, 235, 100, 80), 2.0)
	)
	coin_box.add_child(aura)
	
	var coin_img = TextureRect.new()
	coin_img.texture = preload("res://jeton_icon.svg")
	coin_img.custom_minimum_size = Vector2(96, 96)
	coin_img.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	coin_img.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	coin_img.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	coin_img.pivot_offset = Vector2(48, 48)
	coin_box.add_child(coin_img)
	
	# Gentle living coin pulse
	var c_tw = create_tween().set_loops().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	c_tw.tween_property(coin_img, "scale", Vector2(1.06, 1.06), 1.2)
	c_tw.tween_property(coin_img, "scale", Vector2(0.96, 0.96), 1.2)
	
	var amt_lbl = Label.new()
	amt_lbl.text = amount_txt
	amt_lbl.add_theme_font_override("font", custom_font)
	amt_lbl.add_theme_font_size_override("font_size", 58)
	amt_lbl.add_theme_color_override("font_color", Color8(255, 225, 40))
	amt_lbl.add_theme_color_override("font_shadow_color", Color8(0, 0, 0, 220))
	amt_lbl.add_theme_constant_override("shadow_offset_y", 4)
	amt_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(amt_lbl)
	
	if sub_txt != "":
		var sub_panel = PanelContainer.new()
		var sp_style = StyleBoxFlat.new()
		sp_style.bg_color = active_theme.bg_bottom.darkened(0.4)
		sp_style.corner_radius_top_left = 14; sp_style.corner_radius_top_right = 14
		sp_style.corner_radius_bottom_left = 14; sp_style.corner_radius_bottom_right = 14
		sp_style.border_width_left = 1; sp_style.border_width_right = 1
		sp_style.border_width_top = 1; sp_style.border_width_bottom = 1
		sp_style.border_color = Color8(255, 215, 0, 100)
		sp_style.content_margin_left = 16; sp_style.content_margin_right = 16
		sp_style.content_margin_top = 6; sp_style.content_margin_bottom = 6
		sub_panel.add_theme_stylebox_override("panel", sp_style)
		sub_panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		vbox.add_child(sub_panel)
		
		var s_lbl = Label.new()
		s_lbl.text = sub_txt
		s_lbl.add_theme_font_override("font", custom_font)
		s_lbl.add_theme_font_size_override("font_size", 24)
		s_lbl.add_theme_color_override("font_color", Color8(220, 235, 255))
		s_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		sub_panel.add_child(s_lbl)
		
	var ok_btn = Button.new()
	var ok_txt = "HARİKA!"
	if Global.current_lang == "ENG": ok_txt = "AWESOME!"
	elif Global.current_lang == "ESP": ok_txt = "¡GENIAL!"
	elif Global.current_lang == "POR": ok_txt = "ÓTIMO!"
	ok_btn.text = ok_txt
	ok_btn.add_theme_font_override("font", custom_font)
	ok_btn.add_theme_font_size_override("font_size", 30)
	ok_btn.add_theme_color_override("font_color", Color.WHITE)
	apply_3d_style_to_button(ok_btn, Color8(40, 155, 75), Color8(20, 90, 40), 16, 4.5, 36, 12)
	ok_btn.custom_minimum_size = Vector2(230, 62)
	ok_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	ok_btn.pressed.connect(func():
		Global.play_click()
		overlay.queue_free()
	)
	vbox.add_child(ok_btn)

func _on_rewarded_video_earned(_ad_info = null, _reward_data = null):
	is_rewarded_loading = false
	if active_reward_purpose == "wheel":
		active_reward_purpose = "general"
		Global.lucky_wheel_pending_ad_spins += 1
		Global.save_progression()
		if wheel_on_reward_callback.is_valid():
			var cb = wheel_on_reward_callback
			wheel_on_reward_callback = Callable()
			cb.call()
		_request_rewarded_ad()
		return
	
	Global.ad_credits += 50
	Global.save_progression()
	_refresh_shop_tab()
	
	var title_txt = "TEBRİKLER!"
	var bal_prefix = "Güncel Bakiye: "
	if Global.current_lang == "ENG":
		title_txt = "CONGRATULATIONS!"
		bal_prefix = "Current Balance: "
	elif Global.current_lang == "ESP":
		title_txt = "¡FELICITACIONES!"
		bal_prefix = "Saldo Actual: "
	elif Global.current_lang == "POR":
		title_txt = "PARABÉNS!"
		bal_prefix = "Saldo Atual: "
		
	var curr_name = LANG.get(Global.current_lang, LANG["ENG"]).get("CURRENCY", "Jeton")
	_show_prize_dialog(title_txt, "+50 " + curr_name, bal_prefix + str(Global.ad_credits) + " " + curr_name)
	_request_rewarded_ad()

func _setup_admob():
	var admob_node = Global.get_admob()
	if not admob_node: return
	
	var is_inited = admob_node.get("is_initialization_completed") == true
	if not is_inited:
		if not admob_node.is_connected("initialization_completed", Callable(self, "_on_admob_initialized")):
			admob_node.connect("initialization_completed", Callable(self, "_on_admob_initialized"), CONNECT_ONE_SHOT)
		return

	_connect_admob_signals(admob_node)
	_request_rewarded_ad()
	Global.preload_interstitial_ad()
	
	if not Global.is_premium:
		_ensure_menu_top_banner()

func _on_admob_initialized(_status = null):
	var admob_node = Global.get_admob()
	if admob_node:
		_connect_admob_signals(admob_node)
		_request_rewarded_ad()
		Global.preload_interstitial_ad()
		if not Global.is_premium:
			_ensure_menu_top_banner()
	_update_shop_notification()

func _connect_admob_signals(admob_node: Node):
	if not admob_node: return
	if not admob_node.is_connected("rewarded_ad_loaded", Callable(self, "_on_rewarded_ad_loaded")):
		admob_node.connect("rewarded_ad_loaded", Callable(self, "_on_rewarded_ad_loaded"))
	if not admob_node.is_connected("rewarded_ad_dismissed_full_screen_content", Callable(self, "_on_rewarded_dismissed")):
		admob_node.connect("rewarded_ad_dismissed_full_screen_content", Callable(self, "_on_rewarded_dismissed"))
	if not admob_node.is_connected("rewarded_ad_failed_to_show_full_screen_content", Callable(self, "_on_rewarded_failed_to_show")):
		admob_node.connect("rewarded_ad_failed_to_show_full_screen_content", Callable(self, "_on_rewarded_failed_to_show"))
	if not admob_node.is_connected("rewarded_ad_failed_to_load", Callable(self, "_on_rewarded_failed_to_load")):
		admob_node.connect("rewarded_ad_failed_to_load", Callable(self, "_on_rewarded_failed_to_load"))
	if not admob_node.is_connected("rewarded_ad_user_earned_reward", Callable(self, "_on_rewarded_video_earned")):
		admob_node.connect("rewarded_ad_user_earned_reward", Callable(self, "_on_rewarded_video_earned"))
	if not admob_node.is_connected("banner_ad_loaded", Callable(self, "_on_banner_loaded")):
		admob_node.connect("banner_ad_loaded", Callable(self, "_on_banner_loaded"))
	if not admob_node.is_connected("banner_ad_failed_to_load", Callable(self, "_on_banner_failed_to_load")):
		admob_node.connect("banner_ad_failed_to_load", Callable(self, "_on_banner_failed_to_load"))

func _exit_tree():
	var admob_node = Global.get_admob()
	if admob_node:
		if admob_node.is_connected("banner_ad_loaded", Callable(self, "_on_banner_loaded")):
			admob_node.disconnect("banner_ad_loaded", Callable(self, "_on_banner_loaded"))
		if admob_node.is_connected("banner_ad_failed_to_load", Callable(self, "_on_banner_failed_to_load")):
			admob_node.disconnect("banner_ad_failed_to_load", Callable(self, "_on_banner_failed_to_load"))
		if admob_node.is_connected("rewarded_ad_loaded", Callable(self, "_on_rewarded_ad_loaded")):
			admob_node.disconnect("rewarded_ad_loaded", Callable(self, "_on_rewarded_ad_loaded"))
		if admob_node.is_connected("rewarded_ad_dismissed_full_screen_content", Callable(self, "_on_rewarded_dismissed")):
			admob_node.disconnect("rewarded_ad_dismissed_full_screen_content", Callable(self, "_on_rewarded_dismissed"))
		if admob_node.is_connected("rewarded_ad_failed_to_show_full_screen_content", Callable(self, "_on_rewarded_failed_to_show")):
			admob_node.disconnect("rewarded_ad_failed_to_show_full_screen_content", Callable(self, "_on_rewarded_failed_to_show"))
		if admob_node.is_connected("rewarded_ad_failed_to_load", Callable(self, "_on_rewarded_failed_to_load")):
			admob_node.disconnect("rewarded_ad_failed_to_load", Callable(self, "_on_rewarded_failed_to_load"))
		if admob_node.is_connected("rewarded_ad_user_earned_reward", Callable(self, "_on_rewarded_video_earned")):
			admob_node.disconnect("rewarded_ad_user_earned_reward", Callable(self, "_on_rewarded_video_earned"))

func _on_rewarded_ad_loaded(_ad_info = null, _response_info = null):
	is_rewarded_loading = false
	print("[AdMob] Rewarded ad loaded and ready.")

func _on_rewarded_dismissed(_ad_info = null):
	is_rewarded_loading = false
	if active_reward_purpose == "wheel":
		active_reward_purpose = "general"
		if Global.lucky_wheel_pending_ad_spins == 0:
			Global.lucky_wheel_pending_ad_spins += 1
			Global.save_progression()
		if wheel_on_reward_callback.is_valid():
			var cb = wheel_on_reward_callback
			wheel_on_reward_callback = Callable()
			cb.call()
	_request_rewarded_ad()

func _on_rewarded_failed_to_show(_ad_info = null, _error_data = null):
	is_rewarded_loading = false
	print("[AdMob] Rewarded ad failed to show.")
	_request_rewarded_ad()

func _on_banner_loaded(ad_info, _response_info = null):
	is_banner_loading = false
	menu_banner_retry_count = 0
	if Global.is_premium: return
	var ad_id = ad_info.get_ad_id() if ad_info else ""
	menu_banner_ad_id = ad_id
	print("[AdMob] Unified Menu Banner loaded. (ad_id: ", ad_id, ")")
	
	var admob_node = Global.get_admob()
	if admob_node and admob_node.has_method("show_banner_ad"):
		if ad_id != "":
			admob_node.show_banner_ad(ad_id)
		else:
			admob_node.show_banner_ad()

func _on_banner_failed_to_load(ad_info, error_data):
	is_banner_loading = false
	var err_code = error_data.get_code() if error_data and error_data.has_method("get_code") else -1
	var err_msg = error_data.get_message() if error_data and error_data.has_method("get_message") else ""
	print("[AdMob] Unified Menu Banner failed to load. Code: ", err_code, " Message: ", err_msg)
	if not is_inside_tree() or Global.is_premium: return
	
	menu_banner_retry_count += 1
	var delay = min(25.0 + float(menu_banner_retry_count * 15), 60.0)
	print("[AdMob] Scheduling menu banner retry #", menu_banner_retry_count, " in ", delay, " seconds...")
	await get_tree().create_timer(delay).timeout
	if is_inside_tree() and not Global.is_premium and menu_banner_ad_id == "":
		print("[AdMob] Retrying Unified Menu Banner now...")
		_ensure_menu_top_banner()

func _on_rewarded_failed_to_load(ad_info, error_data):
	is_rewarded_loading = false
	print("[AdMob] Rewarded ad failed to load. Code: ", error_data.get_code(), " Message: ", error_data.get_message())
	# Backoff retry
	await get_tree().create_timer(10.0).timeout
	if not Global.is_premium:
		_request_rewarded_ad()

# ======================================================
# DAILY QUESTS MODAL
# ======================================================
func _open_daily_quests():
	Global.play_click()
	Global.check_daily_reset()
	
	var overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 0.85)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(overlay)
	
	var center = CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.add_child(center)
	
	var panel = PanelContainer.new()
	var p_style = StyleBoxFlat.new()
	p_style.bg_color = active_theme.bg_bottom.darkened(0.15)
	p_style.corner_radius_top_left = 22; p_style.corner_radius_top_right = 22
	p_style.corner_radius_bottom_left = 22; p_style.corner_radius_bottom_right = 22
	p_style.border_width_left = 3; p_style.border_width_right = 3
	p_style.border_width_top = 3; p_style.border_width_bottom = 5
	p_style.border_color = active_theme.accent
	p_style.shadow_color = Color8(0, 0, 0, 180)
	p_style.shadow_size = 30
	p_style.content_margin_left = 26; p_style.content_margin_right = 26
	p_style.content_margin_top = 24; p_style.content_margin_bottom = 24
	panel.add_theme_stylebox_override("panel", p_style)
	panel.custom_minimum_size = Vector2(min(get_viewport_rect().size.x * 0.94, 650), 0)
	center.add_child(panel)
	
	var vbox = VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 16)
	panel.add_child(vbox)
	
	var title_lbl = Label.new()
	title_lbl.text = LANG.get(Global.current_lang, LANG["ENG"]).get("DAILY_QUESTS_TITLE", "GÜNLÜK GÖREVLER")
	title_lbl.add_theme_font_override("font", custom_font)
	title_lbl.add_theme_font_size_override("font_size", 38)
	title_lbl.add_theme_color_override("font_color", Color.WHITE)
	title_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title_lbl)
	
	var date_lbl = Label.new()
	date_lbl.text = Global.daily_date
	date_lbl.add_theme_font_override("font", custom_font)
	date_lbl.add_theme_font_size_override("font_size", 20)
	date_lbl.add_theme_color_override("font_color", active_theme.accent)
	date_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(date_lbl)
	
	var scroll = ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(0, 320)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	vbox.add_child(scroll)
	
	var quests_vbox = VBoxContainer.new()
	quests_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	quests_vbox.add_theme_constant_override("separation", 14)
	scroll.add_child(quests_vbox)
	
	for q in Global.daily_quests:
		var q_card = PanelContainer.new()
		var qc_style = StyleBoxFlat.new()
		qc_style.bg_color = active_theme.bg_top.darkened(0.12)
		qc_style.corner_radius_top_left = 14; qc_style.corner_radius_top_right = 14
		qc_style.corner_radius_bottom_left = 14; qc_style.corner_radius_bottom_right = 14
		qc_style.border_width_bottom = 3; qc_style.border_color = active_theme.bg_bottom.darkened(0.3)
		qc_style.content_margin_left = 16; qc_style.content_margin_right = 16
		qc_style.content_margin_top = 12; qc_style.content_margin_bottom = 12
		q_card.add_theme_stylebox_override("panel", qc_style)
		quests_vbox.add_child(q_card)
		
		var q_hbox = HBoxContainer.new()
		q_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
		q_hbox.add_theme_constant_override("separation", 12)
		q_card.add_child(q_hbox)
		
		var text_vbox = VBoxContainer.new()
		text_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		text_vbox.add_theme_constant_override("separation", 4)
		q_hbox.add_child(text_vbox)
		
		var desc_lbl = Label.new()
		var desc_dict = q.get("desc", {})
		desc_lbl.text = desc_dict.get(Global.current_lang, desc_dict.get("ENG", "Görev"))
		desc_lbl.add_theme_font_override("font", custom_font)
		desc_lbl.add_theme_font_size_override("font_size", 22)
		desc_lbl.add_theme_color_override("font_color", Color.WHITE)
		desc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD
		text_vbox.add_child(desc_lbl)
		
		var prog_lbl = Label.new()
		var p_label_str = LANG.get(Global.current_lang, LANG["ENG"]).get("QUEST_PROGRESS", "İlerleme")
		var r_label_str = LANG.get(Global.current_lang, LANG["ENG"]).get("QUEST_REWARD", "Ödül")
		prog_lbl.text = p_label_str + ": " + str(int(q.get("progress", 0))) + " / " + str(int(q.get("target", 1))) + "  •  " + r_label_str + ": +" + str(int(q.get("reward", 30))) + " " + LANG.get(Global.current_lang, LANG["ENG"])["CURRENCY"]
		prog_lbl.add_theme_font_override("font", custom_font)
		prog_lbl.add_theme_font_size_override("font_size", 18)
		prog_lbl.add_theme_color_override("font_color", Color8(255, 215, 0))
		text_vbox.add_child(prog_lbl)
		
		var claim_btn = Button.new()
		claim_btn.add_theme_font_override("font", custom_font)
		claim_btn.add_theme_font_size_override("font_size", 20)
		claim_btn.custom_minimum_size = Vector2(130, 48)
		claim_btn.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		
		var is_claimed = bool(q.get("claimed", false))
		var is_ready = int(q.get("progress", 0)) >= int(q.get("target", 1))
		
		if is_claimed:
			claim_btn.text = " " + LANG.get(Global.current_lang, LANG["ENG"]).get("QUEST_CLAIMED", "ALINDI")
			if ResourceLoader.exists("res://checkmark_icon.svg"):
				claim_btn.icon = load("res://checkmark_icon.svg")
				claim_btn.expand_icon = true
				claim_btn.add_theme_constant_override("icon_max_width", 18)
				claim_btn.add_theme_constant_override("h_separation", 6)
			claim_btn.disabled = true
			apply_3d_style_to_button(claim_btn, Color8(30, 80, 40, 200), Color8(15, 50, 25), 10, 2)
			claim_btn.add_theme_color_override("font_disabled_color", Color8(100, 255, 120))
		elif is_ready:
			claim_btn.text = LANG.get(Global.current_lang, LANG["ENG"]).get("QUEST_CLAIM", "ÖDÜLÜ AL")
			apply_3d_style_to_button(claim_btn, active_theme.accent, active_theme.accent.darkened(0.35), 10, 3)
			claim_btn.add_theme_color_override("font_color", Color.WHITE)
			var q_id = q["id"]
			claim_btn.pressed.connect(func():
				Global.play_click()
				var earned = Global.claim_quest_reward(q_id)
				if earned > 0:
					var rew_fmt = LANG.get(Global.current_lang, LANG["ENG"]).get("EARNED_REWARD", "+%s %s")
					var curr_str = LANG.get(Global.current_lang, LANG["ENG"]).get("CURRENCY", "Jeton")
					_show_toast(rew_fmt % [str(earned), curr_str])
					overlay.queue_free()
					_refresh_shop_tab()
					_open_daily_quests()
			)
		else:
			claim_btn.text = LANG.get(Global.current_lang, LANG["ENG"]).get("QUEST_IN_PROGRESS", "Devam Ediyor")
			claim_btn.disabled = true
			apply_3d_style_to_button(claim_btn, active_theme.bg_top.lightened(0.1), active_theme.bg_bottom.darkened(0.3), 10, 2)
			claim_btn.add_theme_color_override("font_disabled_color", Color8(160, 180, 200))
			
		q_hbox.add_child(claim_btn)
	
	var close_btn = Button.new()
	close_btn.text = LANG.get(Global.current_lang, LANG["ENG"])["CLOSE"]
	close_btn.add_theme_font_override("font", custom_font)
	close_btn.add_theme_font_size_override("font_size", 24)
	close_btn.custom_minimum_size = Vector2(160, 52)
	close_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	apply_3d_style_to_button(close_btn, active_theme.accent, active_theme.accent.darkened(0.35), 12, 4)
	close_btn.add_theme_color_override("font_color", Color.WHITE)
	close_btn.pressed.connect(func():
		Global.play_click()
		overlay.queue_free()
	)
	vbox.add_child(close_btn)

# ======================================================
# LUCKY WHEEL MODAL
# ======================================================
func _open_lucky_wheel():
	Global.play_click()
	Global.check_daily_reset()
	
	var coin_tex = preload("res://jeton_icon.svg")
	
	var overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 0.85)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(overlay)
	
	var center = CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.add_child(center)
	
	var panel = PanelContainer.new()
	var p_style = StyleBoxFlat.new()
	p_style.bg_color = active_theme.bg_bottom.darkened(0.15)
	p_style.corner_radius_top_left = 24; p_style.corner_radius_top_right = 24
	p_style.corner_radius_bottom_left = 24; p_style.corner_radius_bottom_right = 24
	p_style.border_width_left = 3; p_style.border_width_right = 3
	p_style.border_width_top = 3; p_style.border_width_bottom = 5
	p_style.border_color = active_theme.accent
	p_style.shadow_color = Color8(0, 0, 0, 180)
	p_style.shadow_size = 30
	p_style.content_margin_left = 20; p_style.content_margin_right = 20
	p_style.content_margin_top = 18; p_style.content_margin_bottom = 18
	panel.add_theme_stylebox_override("panel", p_style)
	panel.custom_minimum_size = Vector2(min(get_viewport_rect().size.x * 0.96, 720), 0)
	center.add_child(panel)
	
	var vbox = VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 10)
	panel.add_child(vbox)
	
	var title_lbl = Label.new()
	title_lbl.text = LANG.get(Global.current_lang, LANG["ENG"]).get("LUCKY_WHEEL_TITLE", "ŞANS ÇARKI")
	title_lbl.add_theme_font_override("font", custom_font)
	title_lbl.add_theme_font_size_override("font_size", 44)
	title_lbl.add_theme_color_override("font_color", Color.WHITE)
	title_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title_lbl)
	
	var status_lbl = Label.new()
	status_lbl.add_theme_font_override("font", custom_font)
	status_lbl.add_theme_font_size_override("font_size", 25)
	status_lbl.add_theme_color_override("font_color", active_theme.accent)
	status_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(status_lbl)
	
	var timer_lbl = Label.new()
	timer_lbl.add_theme_font_override("font", custom_font)
	timer_lbl.add_theme_font_size_override("font_size", 20)
	timer_lbl.add_theme_color_override("font_color", Color8(200, 220, 245))
	timer_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(timer_lbl)
	
	# ENLARGED WHEEL CONTAINER WITH POINTER
	var wheel_box = CenterContainer.new()
	wheel_box.custom_minimum_size = Vector2(430, 430)
	vbox.add_child(wheel_box)
	
	var wheel_view = Control.new()
	wheel_view.custom_minimum_size = Vector2(410, 410)
	wheel_box.add_child(wheel_view)
	
	var cur_rotation = {"angle": 0.0}
	
	wheel_view.draw.connect(func():
		var c = wheel_view.size / 2.0
		var r = 182.0
		var num_segs = Global.WHEEL_SEGMENTS.size()
		var seg_angle = TAU / float(num_segs)
		
		# Outer Bezel Glow & Metallic Rings
		wheel_view.draw_arc(c, r + 13.0, 0, TAU, 64, Color8(255, 215, 0, 55), 10.0, true)
		wheel_view.draw_arc(c, r + 7.0, 0, TAU, 64, Color8(255, 215, 0), 6.0, true)
		wheel_view.draw_arc(c, r + 2.0, 0, TAU, 64, Color8(15, 25, 45), 4.0, true)
		
		# Embedded lights around the bezel ring
		var num_lights = 18
		for k in range(num_lights):
			var l_a = k * (TAU / float(num_lights))
			var l_pos = c + Vector2(cos(l_a), sin(l_a)) * (r + 7.0)
			var l_col = Color8(255, 255, 255, 240) if k % 2 == 0 else Color8(255, 215, 0, 240)
			wheel_view.draw_circle(l_pos, 3.5, l_col)

		# Draw wedges
		for i in range(num_segs):
			var seg_col = Global.WHEEL_SEGMENTS[i]["color"]
			var a_start = cur_rotation["angle"] + i * seg_angle
			var a_end = a_start + seg_angle
			
			var pts = PackedVector2Array([c])
			var steps = 18
			for s in range(steps + 1):
				var a = a_start + (a_end - a_start) * (float(s) / float(steps))
				pts.append(c + Vector2(cos(a), sin(a)) * r)
			wheel_view.draw_colored_polygon(pts, seg_col)
			
			# Segment line separator (Crisp white/gold)
			wheel_view.draw_line(c, c + Vector2(cos(a_start), sin(a_start)) * r, Color8(255, 255, 255, 190), 2.0)
			
			# Draw number + coin icon for supreme visual appeal
			var mid_a = (a_start + a_end) / 2.0
			var coins_str = str(int(Global.WHEEL_SEGMENTS[i]["coins"]))
			var str_sz = custom_font.get_string_size(coins_str, HORIZONTAL_ALIGNMENT_LEFT, -1, 28)
			var coin_sz = 24.0
			var total_w = str_sz.x + 4.0 + coin_sz
			
			var item_pos = c + Vector2(cos(mid_a), sin(mid_a)) * (r * 0.68)
			var text_pos = item_pos - Vector2(total_w / 2.0, -str_sz.y / 3.0)
			var icon_pos = item_pos + Vector2(total_w / 2.0 - coin_sz, -coin_sz / 2.0)
			
			# Shadow for text
			wheel_view.draw_string(custom_font, text_pos + Vector2(1.5, 2.0), coins_str, HORIZONTAL_ALIGNMENT_LEFT, -1, 28, Color8(0, 0, 0, 220))
			# Text
			wheel_view.draw_string(custom_font, text_pos, coins_str, HORIZONTAL_ALIGNMENT_LEFT, -1, 28, Color.WHITE)
			
			# Coin icon shadow & texture
			if coin_tex:
				wheel_view.draw_texture_rect(coin_tex, Rect2(icon_pos + Vector2(1.5, 2.0), Vector2(coin_sz, coin_sz)), false, Color8(0, 0, 0, 180))
				wheel_view.draw_texture_rect(coin_tex, Rect2(icon_pos, Vector2(coin_sz, coin_sz)), false)
			else:
				var coin_c = icon_pos + Vector2(coin_sz, coin_sz) / 2.0
				wheel_view.draw_circle(coin_c + Vector2(1, 1), coin_sz / 2.0, Color8(0, 0, 0, 150))
				wheel_view.draw_circle(coin_c, coin_sz / 2.0, Color8(255, 215, 0))
				wheel_view.draw_arc(coin_c, coin_sz / 2.0 - 1.5, 0, TAU, 16, Color8(255, 255, 200), 1.0)
			
		# Inner Rim
		wheel_view.draw_arc(c, r, 0, TAU, 64, Color8(255, 255, 255, 140), 2.0, true)

		# Center Metallic Disc Hub
		wheel_view.draw_circle(c, 36.0, Color8(10, 18, 32, 250))
		wheel_view.draw_arc(c, 36.0, 0, TAU, 48, Color8(255, 215, 0), 4.0, true)
		wheel_view.draw_circle(c, 25.0, active_theme.accent)
		wheel_view.draw_arc(c, 25.0, 0, TAU, 36, Color8(255, 255, 255, 170), 2.0, true)
		wheel_view.draw_circle(c, 7.0, Color.WHITE)
		
		# Modern Downward Pointer at Top
		var p_top_y = c.y - r - 4.0
		var p_shadow_pts = PackedVector2Array([
			Vector2(c.x - 17, p_top_y - 17),
			Vector2(c.x + 17, p_top_y - 17),
			Vector2(c.x, p_top_y + 17)
		])
		wheel_view.draw_colored_polygon(p_shadow_pts, Color8(0, 0, 0, 120))

		var p_pts = PackedVector2Array([
			Vector2(c.x - 16, p_top_y - 19),
			Vector2(c.x + 16, p_top_y - 19),
			Vector2(c.x, p_top_y + 15)
		])
		wheel_view.draw_colored_polygon(p_pts, Color8(255, 215, 0))
		wheel_view.draw_polyline(p_pts, Color8(20, 15, 5), 2.5)
		# Pointer top pivot pin
		wheel_view.draw_circle(Vector2(c.x, p_top_y - 16), 5.5, Color.WHITE)
	)
	
	var spin_btn = Button.new()
	spin_btn.add_theme_font_override("font", custom_font)
	spin_btn.add_theme_font_size_override("font_size", 30)
	spin_btn.custom_minimum_size = Vector2(380, 66)
	spin_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	vbox.add_child(spin_btn)
	
	var is_spinning = false
	
	var update_wheel_status = func():
		var free_avail = (Global.lucky_wheel_free_spins_used < 1)
		var pending_ad = (Global.lucky_wheel_pending_ad_spins > 0)
		var ad_avail = (Global.lucky_wheel_ad_spins_used < 3)
		
		var now_dict = Time.get_datetime_dict_from_system()
		var cur_secs = now_dict["hour"] * 3600 + now_dict["minute"] * 60 + now_dict["second"]
		var secs_left = 86400 - cur_secs
		var h = int(secs_left / 3600)
		var m = int((secs_left % 3600) / 60)
		var s = int(secs_left % 60)
		var time_str = "%02d:%02d:%02d" % [h, m, s]
		
		if free_avail:
			status_lbl.text = "1 " + LANG.get(Global.current_lang, LANG["ENG"]).get("LUCKY_WHEEL_FREE", "Ücretsiz Çevirme") + " Hazır!"
			status_lbl.add_theme_color_override("font_color", Color8(100, 255, 120))
			
			var ready_txt = "Ücretsiz çevirme hakkınız hazır!"
			if Global.current_lang == "ENG": ready_txt = "Free spin is available!"
			elif Global.current_lang == "ESP": ready_txt = "¡Giro gratis disponible!"
			elif Global.current_lang == "POR": ready_txt = "Rodada grátis disponível!"
			timer_lbl.text = ready_txt
			timer_lbl.add_theme_color_override("font_color", Color8(120, 255, 140))
			
			spin_btn.text = LANG.get(Global.current_lang, LANG["ENG"]).get("LUCKY_WHEEL_FREE", "ÜCRETSİZ ÇEVİR")
			spin_btn.disabled = false
			apply_3d_style_to_button(spin_btn, Color8(40, 155, 75), Color8(20, 90, 40), 16, 4.5, 30, 10)
			spin_btn.add_theme_color_override("font_color", Color.WHITE)
		elif pending_ad:
			status_lbl.text = "1 " + LANG.get(Global.current_lang, LANG["ENG"]).get("LUCKY_WHEEL_FREE", "Çevirme Hakkı") + " Hazır!"
			status_lbl.add_theme_color_override("font_color", Color8(100, 255, 120))
			
			var next_spin_prefix = "Sonraki Ücretsiz Çevirme: "
			if Global.current_lang == "ENG": next_spin_prefix = "Next Free Spin in: "
			elif Global.current_lang == "ESP": next_spin_prefix = "Próximo giro gratis en: "
			elif Global.current_lang == "POR": next_spin_prefix = "Próxima rodada grátis em: "
			timer_lbl.text = next_spin_prefix + time_str
			timer_lbl.add_theme_color_override("font_color", Color8(200, 220, 245))
			
			var spin_now_txt = "ŞİMDİ ÇEVİR!"
			if Global.current_lang == "ENG": spin_now_txt = "SPIN NOW!"
			elif Global.current_lang == "ESP": spin_now_txt = "¡GIRAR AHORA!"
			elif Global.current_lang == "POR": spin_now_txt = "RODAR AGORA!"
			spin_btn.text = spin_now_txt
			spin_btn.disabled = false
			apply_3d_style_to_button(spin_btn, Color8(40, 155, 75), Color8(20, 90, 40), 16, 4.5, 30, 10)
			spin_btn.add_theme_color_override("font_color", Color.WHITE)
		elif ad_avail:
			var left_ads = 3 - Global.lucky_wheel_ad_spins_used
			var ad_spins_lbl = LANG.get(Global.current_lang, LANG["ENG"]).get("REMAINING_AD_SPINS", "Kalan Reklamlı Çevirme")
			status_lbl.text = ad_spins_lbl + ": " + str(left_ads) + " / 3"
			status_lbl.add_theme_color_override("font_color", Color8(255, 215, 0))
			
			var next_spin_prefix = "Sonraki Ücretsiz Çevirme: "
			if Global.current_lang == "ENG": next_spin_prefix = "Next Free Spin in: "
			elif Global.current_lang == "ESP": next_spin_prefix = "Próximo giro gratis en: "
			elif Global.current_lang == "POR": next_spin_prefix = "Próxima rodada grátis em: "
			timer_lbl.text = next_spin_prefix + time_str
			timer_lbl.add_theme_color_override("font_color", Color8(200, 220, 245))
			
			spin_btn.text = LANG.get(Global.current_lang, LANG["ENG"]).get("LUCKY_WHEEL_AD", "REKLAM İZLE & ÇEVİR")
			spin_btn.disabled = false
			apply_3d_style_to_button(spin_btn, active_theme.accent, active_theme.accent.darkened(0.35), 16, 4.5, 30, 10)
			spin_btn.add_theme_color_override("font_color", Color.WHITE)
		else:
			status_lbl.text = LANG.get(Global.current_lang, LANG["ENG"]).get("LUCKY_WHEEL_NO_SPINS", "Bugünkü hakların bitti! Yarın tekrar gel.")
			status_lbl.add_theme_color_override("font_color", Color.WHITE)
			
			var next_spin_prefix = "Sonraki Ücretsiz Çevirme: "
			if Global.current_lang == "ENG": next_spin_prefix = "Next Free Spin in: "
			elif Global.current_lang == "ESP": next_spin_prefix = "Próximo giro gratis en: "
			elif Global.current_lang == "POR": next_spin_prefix = "Próxima rodada grátis em: "
			timer_lbl.text = next_spin_prefix + time_str
			timer_lbl.add_theme_color_override("font_color", Color8(255, 215, 0))
			
			spin_btn.text = LANG.get(Global.current_lang, LANG["ENG"])["CLOSE"]
			spin_btn.disabled = false
			apply_3d_style_to_button(spin_btn, active_theme.bg_top.lightened(0.1), active_theme.bg_bottom.darkened(0.3), 16, 4.5, 30, 10)
			spin_btn.add_theme_color_override("font_color", Color.WHITE)
	
	update_wheel_status.call()
	
	var live_clock_timer = Timer.new()
	live_clock_timer.wait_time = 1.0
	live_clock_timer.autostart = true
	overlay.add_child(live_clock_timer)
	live_clock_timer.timeout.connect(func():
		if not is_instance_valid(overlay): return
		Global.check_daily_reset()
		if not is_spinning:
			update_wheel_status.call()
	)
	
	var perform_spin = func(is_ad: bool):
		if is_spinning: return
		is_spinning = true
		spin_btn.disabled = true
		
		if is_ad:
			Global.lucky_wheel_ad_spins_used += 1
		else:
			Global.lucky_wheel_free_spins_used += 1
		Global.save_progression()
		update_wheel_status.call()
			
		var res = Global.spin_lucky_wheel()
		var chosen_idx = int(res.get("index", 0))
		var coins_won = int(res.get("coins", 10))
		
		# Wheel geometry: Pointer points at top (angle -PI/2).
		var num_segs = Global.WHEEL_SEGMENTS.size()
		var seg_w = TAU / float(num_segs)
		var target_seg_mid = chosen_idx * seg_w + seg_w / 2.0
		# Align target_seg_mid to -PI/2 (top)
		var desired_final_angle = -PI/2.0 - target_seg_mid
		
		var full_rotations = TAU * 5.0
		var final_rot = cur_rotation["angle"] + full_rotations + fposmod(desired_final_angle - cur_rotation["angle"], TAU)
		
		var tw = create_tween()
		tw.set_trans(Tween.TRANS_CUBIC)
		tw.set_ease(Tween.EASE_OUT)
		tw.tween_method(func(val):
			cur_rotation["angle"] = val
			wheel_view.queue_redraw()
		, cur_rotation["angle"], final_rot, 3.5)
		
		tw.finished.connect(func():
			is_spinning = false
			var title_txt = "ŞANS ÇARKI ÖDÜLÜ"
			var bal_prefix = "Güncel Bakiye: "
			if Global.current_lang == "ENG":
				title_txt = "LUCKY WHEEL PRIZE"
				bal_prefix = "Current Balance: "
			elif Global.current_lang == "ESP":
				title_txt = "PREMIO DE LA RULETA"
				bal_prefix = "Saldo Actual: "
			elif Global.current_lang == "POR":
				title_txt = "PRÉMIO DA RODA"
				bal_prefix = "Saldo Atual: "
			var curr_name = LANG.get(Global.current_lang, LANG["ENG"]).get("CURRENCY", "Jeton")
			_show_prize_dialog(title_txt, "+" + str(coins_won) + " " + curr_name, bal_prefix + str(Global.ad_credits) + " " + curr_name)
			update_wheel_status.call()
			_refresh_shop_tab()
		)
	
	spin_btn.pressed.connect(func():
		Global.play_click()
		if is_spinning: return
		
		var free_avail = (Global.lucky_wheel_free_spins_used < 1)
		var pending_ad = (Global.lucky_wheel_pending_ad_spins > 0)
		var ad_avail = (Global.lucky_wheel_ad_spins_used < 3)
		
		if free_avail:
			perform_spin.call(false)
		elif pending_ad:
			Global.lucky_wheel_pending_ad_spins -= 1
			Global.save_progression()
			perform_spin.call(true)
		elif ad_avail:
			_show_admob_rewarded_for_wheel(func():
				update_wheel_status.call()
				var toast_txt = "Çevirme hakkı hazır! Çarkı şimdi çevirebilirsiniz."
				if Global.current_lang == "ENG": toast_txt = "Spin ready! You can now spin the wheel."
				elif Global.current_lang == "ESP": toast_txt = "¡Giro listo! Ahora puedes girar la ruleta."
				elif Global.current_lang == "POR": toast_txt = "Giro pronto! Agora você pode girar a roda."
				_show_toast(toast_txt)
			)
		else:
			overlay.queue_free()
	)
	
	var close_btn = Button.new()
	close_btn.text = LANG.get(Global.current_lang, LANG["ENG"])["CLOSE"]
	close_btn.add_theme_font_override("font", custom_font)
	close_btn.add_theme_font_size_override("font_size", 22)
	close_btn.custom_minimum_size = Vector2(160, 48)
	close_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	var cl_s = StyleBoxFlat.new()
	cl_s.bg_color = Color(0, 0, 0, 0)
	close_btn.add_theme_stylebox_override("normal", cl_s)
	close_btn.add_theme_color_override("font_color", Color.WHITE)
	close_btn.pressed.connect(func():
		Global.play_click()
		overlay.queue_free()
	)
	vbox.add_child(close_btn)

func _show_admob_rewarded_for_wheel(on_reward_callback: Callable):
	active_reward_purpose = "wheel"
	wheel_on_reward_callback = on_reward_callback
	var admob_node = Global.get_admob()
	if admob_node and admob_node.has_method("show_rewarded_ad"):
		if admob_node.has_method("is_rewarded_ad_loaded") and admob_node.is_rewarded_ad_loaded():
			admob_node.show_rewarded_ad()
		else:
			_show_toast(LANG.get(Global.current_lang, LANG["ENG"]).get("AD_PREPARING", "Reklam hazırlanıyor, lütfen birkaç saniye sonra tekrar deneyin..."))
			_request_rewarded_ad()
	else:
		# Fallback / editor test mode: trigger wheel reward callback immediately!
		print("[AdMob] Rewarded ad fallback for Lucky Wheel...")
		_on_rewarded_video_earned()

# ======================================================
# LEADERBOARD MODAL
# ======================================================
func _open_leaderboard():
	Global.play_click()
	
	var overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 0.85)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(overlay)
	
	var center = CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.add_child(center)
	
	var panel = PanelContainer.new()
	var p_style = StyleBoxFlat.new()
	p_style.bg_color = active_theme.bg_bottom.darkened(0.15)
	p_style.corner_radius_top_left = 22; p_style.corner_radius_top_right = 22
	p_style.corner_radius_bottom_left = 22; p_style.corner_radius_bottom_right = 22
	p_style.border_width_left = 3; p_style.border_width_right = 3
	p_style.border_width_top = 3; p_style.border_width_bottom = 5
	p_style.border_color = active_theme.accent
	p_style.shadow_color = Color8(0, 0, 0, 180)
	p_style.shadow_size = 30
	p_style.content_margin_left = 24; p_style.content_margin_right = 24
	p_style.content_margin_top = 22; p_style.content_margin_bottom = 22
	panel.add_theme_stylebox_override("panel", p_style)
	panel.custom_minimum_size = Vector2(min(get_viewport_rect().size.x * 0.94, 620), 0)
	center.add_child(panel)
	
	var vbox = VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 18)
	panel.add_child(vbox)
	
	var title_lbl = Label.new()
	title_lbl.text = LANG.get(Global.current_lang, LANG["ENG"]).get("LEADERBOARD_TITLE", "LİDERLİK TABLOSU")
	title_lbl.add_theme_font_override("font", custom_font)
	title_lbl.add_theme_font_size_override("font_size", 38)
	title_lbl.add_theme_color_override("font_color", Color.WHITE)
	title_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title_lbl)
	
	var p_name = Global.get_active_custom_player_name()
	var fav_t = Global.favorite_team if Global.favorite_team != "" else Global.home_team_name
	
	# Current Player Local Card (Theme Harmonized & Legible)
	var my_card = PanelContainer.new()
	var mc_style = StyleBoxFlat.new()
	mc_style.bg_color = active_theme.bg_bottom.darkened(0.28)
	mc_style.corner_radius_top_left = 14; mc_style.corner_radius_top_right = 14
	mc_style.corner_radius_bottom_left = 14; mc_style.corner_radius_bottom_right = 14
	mc_style.border_width_left = 2; mc_style.border_width_right = 2
	mc_style.border_width_top = 2; mc_style.border_width_bottom = 4
	mc_style.border_color = active_theme.accent
	mc_style.content_margin_left = 18; mc_style.content_margin_right = 18
	mc_style.content_margin_top = 14; mc_style.content_margin_bottom = 14
	my_card.add_theme_stylebox_override("panel", mc_style)
	vbox.add_child(my_card)
	
	var my_vbox = VBoxContainer.new()
	my_vbox.add_theme_constant_override("separation", 6)
	my_card.add_child(my_vbox)
	
	var my_title_hdr = Label.new()
	my_title_hdr.text = LANG.get(Global.current_lang, LANG["ENG"]).get("LEADERBOARD_LOCAL_TITLE", "Kişisel Skor Kartın")
	my_title_hdr.add_theme_font_override("font", custom_font)
	my_title_hdr.add_theme_font_size_override("font_size", 20)
	my_title_hdr.add_theme_color_override("font_color", active_theme.accent)
	my_vbox.add_child(my_title_hdr)
	
	var my_hbox = HBoxContainer.new()
	my_vbox.add_child(my_hbox)
	
	var my_name_lbl = Label.new()
	my_name_lbl.text = p_name + " - " + fav_t
	my_name_lbl.add_theme_font_override("font", custom_font)
	my_name_lbl.add_theme_font_size_override("font_size", 26)
	my_name_lbl.add_theme_color_override("font_color", Color.WHITE)
	my_name_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	my_hbox.add_child(my_name_lbl)
	
	var goals_suffix_str = LANG.get(Global.current_lang, LANG["ENG"]).get("GOALS_SUFFIX", "Gol")
	var my_score_lbl = Label.new()
	my_score_lbl.text = str(int(Global.favorite_team_goals_scored)) + " " + goals_suffix_str
	my_score_lbl.add_theme_font_override("font", custom_font)
	my_score_lbl.add_theme_font_size_override("font_size", 26)
	my_score_lbl.add_theme_color_override("font_color", Color8(255, 215, 0))
	my_hbox.add_child(my_score_lbl)
	
	# Global Leaderboard info card
	var global_card = PanelContainer.new()
	var gc_style = StyleBoxFlat.new()
	gc_style.bg_color = active_theme.bg_bottom.darkened(0.35)
	gc_style.corner_radius_top_left = 16; gc_style.corner_radius_top_right = 16
	gc_style.corner_radius_bottom_left = 16; gc_style.corner_radius_bottom_right = 16
	gc_style.border_width_left = 1.5; gc_style.border_width_right = 1.5
	gc_style.border_width_top = 1.5; gc_style.border_width_bottom = 3.5
	gc_style.border_color = active_theme.accent.darkened(0.35)
	gc_style.content_margin_left = 20; gc_style.content_margin_right = 20
	gc_style.content_margin_top = 18; gc_style.content_margin_bottom = 18
	global_card.add_theme_stylebox_override("panel", gc_style)
	vbox.add_child(global_card)
	
	var global_vbox = VBoxContainer.new()
	global_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	global_vbox.add_theme_constant_override("separation", 14)
	global_card.add_child(global_vbox)
	
	var g_title = Label.new()
	g_title.text = LANG.get(Global.current_lang, LANG["ENG"]).get("LEADERBOARD_GLOBAL_TITLE", "Google Play Games Küresel Sıralama")
	g_title.add_theme_font_override("font", custom_font)
	g_title.add_theme_font_size_override("font_size", 24)
	g_title.add_theme_color_override("font_color", active_theme.accent)
	g_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	global_vbox.add_child(g_title)
	
	var g_desc = Label.new()
	g_desc.text = LANG.get(Global.current_lang, LANG["ENG"]).get("LEADERBOARD_HINT", "Google Play Games ile küresel sıralamada yerini al ve diğer oyuncularla yarış!")
	g_desc.add_theme_font_override("font", custom_font)
	g_desc.add_theme_font_size_override("font_size", 20)
	g_desc.add_theme_color_override("font_color", Color8(220, 230, 245))
	g_desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	g_desc.autowrap_mode = TextServer.AUTOWRAP_WORD
	global_vbox.add_child(g_desc)
	
	var sync_btn = Button.new()
	sync_btn.text = LANG.get(Global.current_lang, LANG["ENG"]).get("LEADERBOARD_SYNC", "SKORU SENKRONİZE ET")
	sync_btn.add_theme_font_override("font", custom_font)
	sync_btn.add_theme_font_size_override("font_size", 22)
	sync_btn.custom_minimum_size = Vector2(320, 52)
	sync_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	apply_3d_style_to_button(sync_btn, active_theme.accent, active_theme.accent.darkened(0.4), 14, 4.5, 20, 10)
	sync_btn.add_theme_color_override("font_color", Color8(20, 15, 0) if active_theme.accent.get_luminance() > 0.5 else Color.WHITE)
	sync_btn.pressed.connect(func():
		Global.play_click()
		Global.submit_score(int(Global.favorite_team_goals_scored))
		_show_toast(LANG.get(Global.current_lang, LANG["ENG"]).get("LEADERBOARD_SYNC", "SKORU SENKRONİZE ET"))
	)
	global_vbox.add_child(sync_btn)
	
	var open_lead_btn = Button.new()
	open_lead_btn.text = LANG.get(Global.current_lang, LANG["ENG"]).get("LEADERBOARD_OPEN", "LİDERLİK SIRALAMASINI GÖR")
	open_lead_btn.add_theme_font_override("font", custom_font)
	open_lead_btn.add_theme_font_size_override("font_size", 22)
	open_lead_btn.custom_minimum_size = Vector2(320, 52)
	open_lead_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	apply_3d_style_to_button(open_lead_btn, active_theme.bg_bottom.darkened(0.12), active_theme.bg_bottom.darkened(0.45), 14, 4.5, 20, 10)
	open_lead_btn.add_theme_color_override("font_color", Color.WHITE)
	open_lead_btn.pressed.connect(func():
		Global.play_click()
		Global.show_leaderboards()
	)
	global_vbox.add_child(open_lead_btn)
		
	var close_btn = Button.new()
	close_btn.text = LANG.get(Global.current_lang, LANG["ENG"])["CLOSE"]
	close_btn.add_theme_font_override("font", custom_font)
	close_btn.add_theme_font_size_override("font_size", 24)
	close_btn.custom_minimum_size = Vector2(180, 52)
	close_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	apply_3d_style_to_button(close_btn, Color8(200, 45, 45), Color8(130, 25, 25), 14, 4.5, 24, 10)
	close_btn.add_theme_color_override("font_color", Color.WHITE)
	close_btn.pressed.connect(func():
		Global.play_click()
		overlay.queue_free()
	)
	vbox.add_child(close_btn)
