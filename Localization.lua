local addonName = ...
local SAdCore = LibStub("SAdCore-1")
local addon = SAdCore:GetAddon(addonName)

addon.locale = {}

-- English
addon.locale.enEN = {
    arenaTitle = "Arena",
    battlegroundTitle = "Battleground",
    dungeonTitle = "Dungeon",
    raidTitle = "Raid",
    worldTitle = "World",    
    showMinimap = "Show Minimap",
    showMinimapTooltip = "Show or hide the minimap cluster in this zone.",    
    showMicroMenu = "Show Micro Menu",
    showMicroMenuTooltip = "Show or hide the micro menu bar in this zone.",    
    showBagsBar = "Show Bags Bar",
    showBagsBarTooltip = "Show or hide the bags bar in this zone.",    
    showQuestFrame = "Show Quest Tracker",
    showQuestFrameTooltip = "Show or hide the objective tracker frame in this zone.",    
    showZoneMap = "Show Zone Map",
    showZoneMapTooltip = "Show or hide the battlefield map frame in this zone.",    
    showStatusBar = "Show Status Bar",
    showStatusBarTooltip = "Show or hide the main status tracking bars in this zone.",
}

-- Spanish
addon.locale.esES = {
    arenaTitle = "Arena",
    battlegroundTitle = "Campo de Batalla",
    dungeonTitle = "Mazmorra",
    raidTitle = "Banda",
    worldTitle = "Mundo",    
    showMinimap = "Mostrar Minimapa",
    showMinimapTooltip = "Mostrar u ocultar el minimapa en esta zona.",    
    showMicroMenu = "Mostrar Micro Menú",
    showMicroMenuTooltip = "Mostrar u ocultar la barra de micro menú en esta zona.",    
    showBagsBar = "Mostrar Barra de Bolsas",
    showBagsBarTooltip = "Mostrar u ocultar la barra de bolsas en esta zona.",    
    showQuestFrame = "Mostrar Rastreador de Misiones",
    showQuestFrameTooltip = "Mostrar u ocultar el rastreador de objetivos en esta zona.",    
    showZoneMap = "Mostrar Mapa de Zona",
    showZoneMapTooltip = "Mostrar u ocultar el mapa del campo de batalla en esta zona.",    
    showStatusBar = "Mostrar Barra de Estado",
    showStatusBarTooltip = "Mostrar u ocultar las barras de seguimiento de estado en esta zona.",
}

addon.locale.esMX = addon.locale.esES

-- Portuguese
addon.locale.ptBR = {
    arenaTitle = "Arena",
    battlegroundTitle = "Campo de Batalha",
    dungeonTitle = "Masmorra",
    raidTitle = "Raide",
    worldTitle = "Mundo",    
    showMinimap = "Mostrar Minimapa",
    showMinimapTooltip = "Mostrar ou ocultar o minimapa nesta zona.",    
    showMicroMenu = "Mostrar Micro Menu",
    showMicroMenuTooltip = "Mostrar ou ocultar a barra de micro menu nesta zona.",    
    showBagsBar = "Mostrar Barra de Bolsas",
    showBagsBarTooltip = "Mostrar ou ocultar a barra de bolsas nesta zona.",    
    showQuestFrame = "Mostrar Rastreador de Missões",
    showQuestFrameTooltip = "Mostrar ou ocultar o rastreador de objetivos nesta zona.",    
    showZoneMap = "Mostrar Mapa da Zona",
    showZoneMapTooltip = "Mostrar ou ocultar o mapa do campo de batalha nesta zona.",    
    showStatusBar = "Mostrar Barra de Status",
    showStatusBarTooltip = "Mostrar ou ocultar as barras de rastreamento de status nesta zona.",
}

-- French
addon.locale.frFR = {
    arenaTitle = "Arène",
    battlegroundTitle = "Champ de Bataille",
    dungeonTitle = "Donjon",
    raidTitle = "Raid",
    worldTitle = "Monde",    
    showMinimap = "Afficher la Minicarte",
    showMinimapTooltip = "Afficher ou masquer la minicarte dans cette zone.",    
    showMicroMenu = "Afficher le Micro Menu",
    showMicroMenuTooltip = "Afficher ou masquer la barre de micro menu dans cette zone.",    
    showBagsBar = "Afficher la Barre de Sacs",
    showBagsBarTooltip = "Afficher ou masquer la barre de sacs dans cette zone.",    
    showQuestFrame = "Afficher le Suivi de Quêtes",
    showQuestFrameTooltip = "Afficher ou masquer le cadre de suivi des objectifs dans cette zone.",    
    showZoneMap = "Afficher la Carte de Zone",
    showZoneMapTooltip = "Afficher ou masquer la carte du champ de bataille dans cette zone.",    
    showStatusBar = "Afficher la Barre de Statut",
    showStatusBarTooltip = "Afficher ou masquer les barres de suivi de statut dans cette zone.",
}

-- German
addon.locale.deDE = {
    arenaTitle = "Arena",
    battlegroundTitle = "Schlachtfeld",
    dungeonTitle = "Dungeon",
    raidTitle = "Schlachtzug",
    worldTitle = "Welt",    
    showMinimap = "Minikarte Anzeigen",
    showMinimapTooltip = "Minikarte in dieser Zone anzeigen oder ausblenden.",    
    showMicroMenu = "Mikromenü Anzeigen",
    showMicroMenuTooltip = "Mikromenüleiste in dieser Zone anzeigen oder ausblenden.",    
    showBagsBar = "Taschenleiste Anzeigen",
    showBagsBarTooltip = "Taschenleiste in dieser Zone anzeigen oder ausblenden.",    
    showQuestFrame = "Quest-Tracker Anzeigen",
    showQuestFrameTooltip = "Zielverfolgungsrahmen in dieser Zone anzeigen oder ausblenden.",    
    showZoneMap = "Zonenkarte Anzeigen",
    showZoneMapTooltip = "Schlachtfeldkarte in dieser Zone anzeigen oder ausblenden.",    
    showStatusBar = "Statusleiste Anzeigen",
    showStatusBarTooltip = "Status-Tracking-Leisten in dieser Zone anzeigen oder ausblenden.",
}

-- Russian
addon.locale.ruRU = {
    arenaTitle = "Арена",
    battlegroundTitle = "Поле Боя",
    dungeonTitle = "Подземелье",
    raidTitle = "Рейд",
    worldTitle = "Мир",    
    showMinimap = "Показать Миникарту",
    showMinimapTooltip = "Показать или скрыть миникарту в этой зоне.",    
    showMicroMenu = "Показать Микроменю",
    showMicroMenuTooltip = "Показать или скрыть панель микроменю в этой зоне.",    
    showBagsBar = "Показать Панель Сумок",
    showBagsBarTooltip = "Показать или скрыть панель сумок в этой зоне.",    
    showQuestFrame = "Показать Трекер Заданий",
    showQuestFrameTooltip = "Показать или скрыть окно отслеживания целей в этой зоне.",    
    showZoneMap = "Показать Карту Зоны",
    showZoneMapTooltip = "Показать или скрыть карту поля боя в этой зоне.",    
    showStatusBar = "Показать Строку Состояния",
    showStatusBarTooltip = "Показать или скрыть панели отслеживания статуса в этой зоне.",
}
