local L = LibStub("AceLocale-3.0"):NewLocale("Connoisseur", "ptBR")
if not L then
	return
end

-- [[ BRAZILIAN PORTUGUESE (ptBR) ]] --

--------------------------------------------------------------------------------
-- Brand
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Connoisseur"

--------------------------------------------------------------------------------
-- Macro Names
--------------------------------------------------------------------------------

-- Macro names cannot exceed 16 total characters.

L["MACRO_BANDAGE"] = "- Bandagem"
L["MACRO_EXPLOSIVES"] = "- Explosivos"
L["MACRO_FEED_PET"] = "- Alim. Ajudante"
L["MACRO_FOOD"] = "- Comida"
L["MACRO_HEALTH_POTION"] = "- Poção de Cura"
L["MACRO_HEALTHSTONE"] = "- Pedra de Vida"
L["MACRO_MANA_GEM"] = "- Gema de Mana"
L["MACRO_MANA_POTION"] = "- Poção de Mana"
L["MACRO_POISONS"] = "- Venenos"
L["MACRO_SOULSTONE"] = "- Pedra de Alma"
L["MACRO_WATER"] = "- Água"

--------------------------------------------------------------------------------
-- Common
--------------------------------------------------------------------------------

L["RANK"] = "Grau"

--------------------------------------------------------------------------------
-- Pet Diets
--------------------------------------------------------------------------------

-- Diet names as returned by GetPetFoodTypes(), which is localized. These
-- values MUST match the client's strings exactly (verify in-game with
-- /dump GetPetFoodTypes() while a pet is out). Used to build
-- ns.PetDietMap in Data/Pet-Foods.lua.

L["DIET_BREAD"] = "Pão"
L["DIET_CHEESE"] = "Queijo"
L["DIET_FISH"] = "Peixe"
L["DIET_FRUIT"] = "Fruta"
L["DIET_FUNGUS"] = "Fungo"
L["DIET_MEAT"] = "Carne"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

L["MSG_BUG_REPORT"] =
	"Parece que você encontrou um bug! %s (%s) não pode ser usado em %s > %s (%s). Por favor, reporte isso para que possamos consertar. Obrigado! %s"
L["MSG_NO_ITEM"] = "Nenhum %s adequado encontrado em suas bolsas."
L["MSG_MACRO_SLOTS_FULL"] =
	"Algumas macros do Connoisseur não puderam ser criadas porque seus espaços para macros estão cheios. Libere um espaço excluindo macros que você não usa mais ou desative as macros do Connoisseur de que você não precisa em Opções > AddOns > Connoisseur."

L["CHAT_LOADED"] =
	"Versão %s. As configurações (incluindo a opção de desativar esta mensagem) podem ser encontradas em Opções > AddOns > Connoisseur. Gostando do addon? Conte para um amigo! (="

L["CHAT_OPTIONS_IN_COMBAT"] = "Por segurança, a interface de opções não pode ser aberta durante o combate."

--------------------------------------------------------------------------------
-- Ready Check
--------------------------------------------------------------------------------

--[[
    The ready-check self-audit, printed as one line: either the missing list or
    the all-clear, then a segment per tracked buff. Item names come from the
    LABEL_ keys below, so a consumable is named the same here as it is in
    MSG_NO_ITEM.
]]

L["READY_ALL_CLEAR"] = "Tudo pronto!"
-- %s is the comma-separated list of what the character is missing.
L["READY_MISSING"] = "Faltando: %s"

L["READY_WELL_FED"] = "Bem Alimentado"
L["READY_SCROLLS"] = "Pergaminhos"
L["READY_PET_FED"] = "Ajudante Alimentado"

-- { buff label, whole minutes left }
L["READY_TIME_MINUTES"] = "%s %d min"
-- %s is the buff label; used when under a minute is left.
L["READY_TIME_EXPIRING"] = "%s menos de 1 min"

--------------------------------------------------------------------------------
-- ConnTip Messages
--------------------------------------------------------------------------------

-- Printed in chat by macro bodies via /run ConnTip("key"). See Features/Macros/Runtime.lua.

L["TIP_PET_NO_FOOD"] = "Atualmente você não tem nenhuma comida útil para o seu ajudante."
L["TIP_PET_NO_SKILLS"] =
	"Atualmente você não sabe Chamar Ajudante, Dispensar Ajudante, Alimentar Ajudante ou Reviver Ajudante."
L["TIP_PET_NO_MEND"] = "Atualmente você não sabe Curar Ajudante."
L["TIP_NO_HAND_POISON"] = "Você está sem o veneno escolhido para esta arma."

-- %s is the localized spell name, resolved at print time.
L["TIP_DONT_KNOW_SPELL"] = "Atualmente você não sabe %s."

--------------------------------------------------------------------------------
-- Minimap Tooltip
--------------------------------------------------------------------------------

-- Feature toggles shown in the minimap tooltip, each with a description line.
L["FEATURE_BUFF_FOOD"] = "Comida com Buff"
L["MENU_BUFF_FOOD_DESCRIPTION"] = 'Prioriza comida que concede o buff "Bem Alimentado", quando o buff estiver faltando.'
L["FEATURE_SCROLL_BUFFS"] = "Buffs de Pergaminho"
L["MENU_SCROLL_BUFFS_DESCRIPTION"] =
	"Transforma sua macro de Comida em um aplicador de pergaminhos quando faltarem buffs de pergaminhos."

-- Section titles and ignore-list actions in the minimap tooltip.
L["UI_BEST_FOOD"] = "Comida Atual"
L["UI_BEST_PET_FOOD"] = "Comida de Ajudante Atual"
-- Weapon-slot titles over the rogue's resolved poison, inside the Poisons block.
L["UI_MAIN_HAND"] = "Mão Principal"
L["UI_OFF_HAND"] = "Mão Secundária"
L["UI_IGNORE_LIST"] = "Lista de Ignorados"
L["MENU_IGNORE"] = "Ignorar"
L["MENU_CLEAR_IGNORE"] = "Limpar Lista de Ignorados"

--[[
    Restocker Report block in the minimap tooltip: how many restocking orders
    are still outstanding, never the items themselves. An order is one row of
    the Restock List, so the count is of rows below target and not of missing
    units -- nine outstanding orders can be nine single juices or nine full
    stacks. The header above supplies the "restocking", so the lines under it
    only need the noun.

    Separate singular and plural strings rather than a composed "%d order(s)",
    so every locale can phrase the count its own way.
]]
L["UI_RESTOCKER_REPORT"] = "Relatório de reabastecimento"
L["UI_RESTOCKER_NEEDED_ONE"] = "1 pedido pendente"
L["UI_RESTOCKER_NEEDED"] = "%d pedidos pendentes"
L["UI_RESTOCKER_STOCKED"] = "Parabéns, seu estoque está completo!"

-- Options entry at the bottom of the minimap tooltip.
L["MENU_OPTIONS"] = "Opções do Connoisseur"
L["MENU_OPTIONS_KEYBIND"] = "Shift + Clique do Meio"

--------------------------------------------------------------------------------
-- Class Announcements
--------------------------------------------------------------------------------

-- Class-colored headers and conjure/pet tips shown in the minimap tooltip for
-- the player's class.

L["PREFIX_HUNTER"] = "Atenção Caçadores"
L["PREFIX_MAGE"] = "Atenção Magos"
L["PREFIX_ROGUE"] = "Atenção Ladinos"
L["PREFIX_WARLOCK"] = "Atenção Bruxos"

--[[
    Subtitle under each class header, naming the macros the tips below apply
    to. Each tip below is one instruction, rendered on its own line, and every
    tip names the macro it belongs to — the blocks cover more than one macro,
    and a bare "Right-Click" would be ambiguous.

    The verb tracks the real spell names, which differ by class: mages get
    Conjure Food / Conjure Water, warlocks get Create Healthstone / Create
    Soulstone.
]]
L["TIP_HUNTER_MACROS"] = "Sobre sua macro de Alimentar Ajudante..."
L["TIP_MAGE_MACROS"] = "Sobre suas macros de Comida, Água e Gema de Mana..."
L["TIP_ROGUE_MACROS"] = "Sobre sua macro de Venenos..."
L["TIP_WARLOCK_MACROS"] = "Sobre suas macros de Pedra de Vida e Pedra de Alma..."

L["TIP_HUNTER_ALL_IN_ONE"] = "Alimentar Ajudante é um botão tudo-em-um para o ajudante!"
L["TIP_HUNTER_CALL"] = "Clique esquerdo para chamar, alimentar ou reviver seu ajudante automaticamente."
L["TIP_HUNTER_MEND"] = "Clique direito ou espere o combate para lançar Curar Ajudante."
L["TIP_HUNTER_MODIFIERS"] = "Segure Shift para forçar Reviver, ou Ctrl para Dispensar."

--[[
    Target downranking is per-macro, not block-wide: it applies only to the
    mage's Food and Water and the warlock's Healthstone. Mana Gems, Soulstones,
    and both rituals ignore the target (ignoreTarget in the resolvers), so each
    line names what it actually affects rather than saying "the macro."
]]
L["TIP_MAGE_CONJURE"] = "Clique com o botão direito nas suas macros de Comida ou Água para Criar Comida ou Água."
L["TIP_MAGE_DOWNRANK"] =
	"Ter como alvo um jogador de nível mais baixo conjurará Comida ou Água apropriada para o nível dele."
L["TIP_MAGE_TABLE"] = "Clique com o botão do meio nas suas macros de Comida ou Água para lançar Ritual do Refresco."
L["TIP_MAGE_GEM"] =
	"Clique com o botão direito na sua macro de Gema de Mana para conjurar uma nova gema. Clique com o botão direito novamente para conjurar uma reserva de grau inferior."

L["TIP_WARLOCK_HEALTHSTONE"] =
	"Clique com o botão direito na sua macro de Pedra de Vida para criar uma Pedra de Vida. Clique com o botão direito novamente para conjurar uma reserva de grau inferior."
L["TIP_WARLOCK_DOWNRANK"] =
	"Ter como alvo um jogador de nível mais baixo criará uma Pedra de Vida apropriada para o nível dele."
L["TIP_WARLOCK_SOULSTONE"] = "Clique com o botão direito na sua macro de Pedra de Alma para criar uma Pedra de Alma."
L["TIP_WARLOCK_SOUL"] = "Clique com o botão do meio na sua macro de Pedra de Vida para lançar Ritual das Almas."

L["TIP_ROGUE_OFF_HAND"] = "Clique esquerdo aplica o veneno da sua mão secundária."
L["TIP_ROGUE_MAIN_HAND"] = "Clique direito aplica o veneno da sua mão principal."
L["TIP_ROGUE_REPLACE"] = "Venenos existentes são substituídos automaticamente."
L["TIP_ROGUE_WINDOW"] = "Clique do meio abre a janela de Venenos."

--------------------------------------------------------------------------------
-- Item Labels
--------------------------------------------------------------------------------

-- Labels that get plugged into MSG_NO_ITEM ("No suitable %s found...").
-- One per macro type (resolved via ns.Config in ConnNoItem), plus Pet Food.

L["LABEL_BANDAGE"] = "Bandagem"
L["LABEL_EXPLOSIVE"] = "Explosivo"
L["LABEL_FOOD"] = "Comida"
L["LABEL_HEALTH_POTION"] = "Poção de Cura"
L["LABEL_HEALTHSTONE"] = "Pedra de Vida"
L["LABEL_MANA_GEM"] = "Gema de Mana"
L["LABEL_MANA_POTION"] = "Poção de Mana"
L["LABEL_PET_FOOD"] = "Comida de Ajudante"
L["LABEL_POISONS"] = "Veneno"
L["LABEL_SOULSTONE"] = "Pedra de Alma"
L["LABEL_WATER"] = "Água"

--------------------------------------------------------------------------------
-- UI Labels
--------------------------------------------------------------------------------

-- Generic labels reused across the minimap tooltip and options panel.

L["UI_ENABLED"] = "Ativado"
L["UI_DISABLED"] = "Desativado"
L["UI_TOGGLE"] = "Alternar"
L["UI_LEFT_CLICK"] = "Clique Esquerdo"
L["UI_RIGHT_CLICK"] = "Clique Direito"
L["UI_MIDDLE_CLICK"] = "Clique do Meio"
L["UI_SHIFT_LEFT"] = "Shift + Clique Esquerdo"

--------------------------------------------------------------------------------
-- Mode Values
--------------------------------------------------------------------------------

L["MODE_ALWAYS"] = "Sempre"
L["MODE_PARTY"] = "Apenas em grupo ou raide"
L["MODE_RAID"] = "Apenas em raide"

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Macros de atualização automática para sua melhor comida, comida com buff, água, poções, pedras de vida, pergaminhos, pedras de alma, bandagens, venenos e explosivos. Conjuração com um clique, Alimentar Ajudante inteligente, reabastecimento automático em vendedores e no banco. Nutrição ideal, desempenho máximo."

-- Welcome Message
L["OPTIONS_WELCOME_MESSAGE"] = "Ativar Mensagem de Boas-vindas"
L["OPTIONS_WELCOME_MESSAGE_DESCRIPTION"] = "Imprime uma mensagem de boas-vindas no chat ao entrar."

-- Minimap Button
L["OPTIONS_MINIMAP_BUTTON"] = "Ativar Botão do Minimapa"
L["OPTIONS_MINIMAP_BUTTON_DESCRIPTION"] = "Mostra o botão do minimapa."

-- Macro Names on Buttons
L["OPTIONS_MACRO_NAMES"] = "Ativar Nomes de Macro nos Botões"
L["OPTIONS_MACRO_NAMES_DESCRIPTION"] =
	"Mostra o texto do nome da macro nos botões da sua barra de ação. Desativado por padrão, o que oculta os nomes que a Blizzard voltou a mostrar recentemente."

-- Potions & Healthstones
L["OPTIONS_POTIONS_HEADER"] = "Poções e Pedras de Vida"
L["OPTIONS_POTIONS_DESCRIPTION"] =
	"As macros não podem ser alteradas durante o combate (isso é uma restrição da Blizzard), então cada macro de Poção e Pedra de Vida é pré-construída com seu melhor item mais até duas alternativas. Em lutas mais longas, o ícone e a dica de interface podem ficar desatualizados e mostrar o item errado, mas clicar na macro sempre usará o melhor item que você realmente tem nas suas bolsas."
L["OPTIONS_COMBINE_HEALTHSTONES"] = "Combinar Pedras de Vida na Macro de Poção de Cura"
L["OPTIONS_COMBINE_HEALTHSTONES_DESCRIPTION"] =
	"Adiciona sua melhor Pedra de Vida ao final da macro de Poção de Cura, para que um clique use uma poção e uma Pedra de Vida."

-- Buff Re-Application
L["OPTIONS_REAPPLY_HEADER"] = "Reaplicação de Buffs"
L["OPTIONS_REAPPLY"] = "Reaplicar Buffs Prestes a Expirar"
L["OPTIONS_REAPPLY_DESCRIPTION"] =
	"As lutas costumam durar mais do que o tempo restante dos seus buffs. Buffs com menos tempo restante que o limite contam como expirados, então suas macros oferecem um novo antes do combate. Vale para Comida com Buff, Buffs de Pergaminho e Buffs de Comida de Ajudante."
--[[
    Threshold dropdown, shown beside the Re-Apply toggle. The values carry the
    "when" themselves, so the row reads as one sentence and needs no caption.
]]
L["REAPPLY_THRESHOLD_ONE"] = "Quando restar < 1 minuto"
L["REAPPLY_THRESHOLD_N"] = "Quando restarem < %d minutos"

-- Ready Check
L["OPTIONS_READY_CHECK_HEADER"] = "Verificação de Prontidão"
L["OPTIONS_READY_CHECK"] = "Relatar prontidão na verificação"
L["OPTIONS_READY_CHECK_DESCRIPTION"] =
	"Mostra o que está faltando e quanto tempo resta nos buffs monitorados sempre que uma verificação de prontidão começa; só você vê."

-- Buff Food. The section header reuses FEATURE_BUFF_FOOD.
L["OPTIONS_BUFF_FOOD"] = "Priorizar Comida com Buff"
L["OPTIONS_BUFF_FOOD_DESCRIPTION"] =
	'Prioriza comida que concede o buff "Bem Alimentado", quando o buff estiver faltando. Desativado nas Arenas.'
L["OPTIONS_BUFF_FOOD_DETAIL"] =
	"Dica pro: Ter a si mesmo como alvo sempre faz a macro de Comida pular comida com buff e pergaminhos."

-- Scroll Buffs. The section header reuses FEATURE_SCROLL_BUFFS.
L["OPTIONS_USE_SCROLLS"] = "Incluir Buffs de Pergaminho"
L["OPTIONS_USE_SCROLLS_DESCRIPTION"] =
	"Toque uma vez para aplicar os pergaminhos que faltam, novamente para comer. Os pergaminhos não ativam o GCD e têm você como alvo; ter um jogador amigável como alvo os ignora. Desativado nas Arenas."
L["OPTIONS_SCROLL_TYPES"] = "Incluir Tipos de Pergaminho na Verificação"
L["OPTIONS_SCROLL_AGILITY"] = "Agilidade"
L["OPTIONS_SCROLL_INTELLECT"] = "Intelecto"
L["OPTIONS_SCROLL_PROTECTION"] = "Proteção"
L["OPTIONS_SCROLL_SPIRIT"] = "Espírito"
L["OPTIONS_SCROLL_STAMINA"] = "Vigor"
L["OPTIONS_SCROLL_STRENGTH"] = "Força"

-- Explosives
L["OPTIONS_EXPLOSIVES_HEADER"] = "Explosivos"
L["OPTIONS_EXPLOSIVES_DESCRIPTION"] =
	"A opção @player pula o retículo de mira e detona o explosivo aos seus pés. Ideal quando o alvo está no corpo a corpo."
L["EXPLOSIVES_MODE_ATPLAYER"] = "Clique Esquerdo @player, Clique Direito Arremessar"
L["EXPLOSIVES_MODE_TOSS"] = "Clique Esquerdo Arremessar, Clique Direito @player"

--[[
    Ignore List. The rows are items, so the only copy here is the add box and
    the placeholder shown while the client is still resolving an item's name.
    The section header and the clear-all button reuse UI_IGNORE_LIST and
    MENU_CLEAR_IGNORE, which the mini-map tooltip already carries.
]]
L["OPTIONS_IGNORE_DESCRIPTION"] =
	"Itens que o Connoisseur nunca vai escolher, por melhores que sejam. Clique com o botão direito no botão do minimapa para ignorar a comida que ele está oferecendo no momento, ou adicione um item abaixo."
L["OPTIONS_IGNORE_ADD_ID"] = "Adicionar por ID do item"
L["OPTIONS_IGNORE_ADD_ID_DESCRIPTION"] =
	"Digite um ID de item, ou dê Shift + Clique em um link de item no chat enquanto este campo estiver ativo."
L["OPTIONS_IGNORE_ADD_ID_INVALID"] = "Digite um ID de item, ou dê Shift + Clique em um link de item no chat."
L["OPTIONS_IGNORE_REMOVE"] = "Remover"
L["OPTIONS_IGNORE_EMPTY"] = "Esta lista está vazia."
L["OPTIONS_IGNORE_CLEAR_CONFIRM"] = "Remover todos os itens da sua Lista de Ignorados?"
-- %d is the item ID, shown while the client is still resolving the item.
L["LOADING_ITEM"] = "Carregando ID: %d"

-- Pet Food Buffs
L["OPTIONS_PET_HEADER"] = "Buffs de Comida de Ajudante"
L["OPTIONS_USE_PET_BUFFS"] = "Usar Buffs de Comida de Ajudante"
L["OPTIONS_USE_PET_BUFFS_DESCRIPTION"] =
	'Adiciona Comida de Ajudante à sua macro de Comida quando o buff "Bem Alimentado" estiver faltando no seu ajudante. Desativado nas Arenas.'
L["OPTIONS_PET_BUFF_TYPES"] = "Incluir Tipos de Comida de Ajudante na Verificação"
L["OPTIONS_PET_BUFF_KIBLERS"] = "Petiscos do Kibler"
L["OPTIONS_PET_BUFF_SPORELING"] = "Lanchinho de Esporino"

-- Druids
L["OPTIONS_DRUIDS_HEADER"] = "Druidas"
L["OPTIONS_DRUID_MACRO_HELPER"] = "Ativar Integração do DruidMacroHelper"
L["OPTIONS_DRUID_MACRO_HELPER_DESCRIPTION"] =
	"Cria macros de mudança de forma para Poções de Cura, Poções de Mana e Pedras de Vida usando o DruidMacroHelper (/dmh)."
--[[
    Return-form dropdown, shown beside the DruidMacroHelper toggle. The macro
    powershifts out of form, uses the consumable, then returns to this one, so
    the values name that return and the row needs no caption.
]]
L["DRUID_FORM_BEAR"] = "Voltar para Urso"
L["DRUID_FORM_CAT"] = "Voltar para Gato"

-- Night Elves
L["OPTIONS_NIGHTELF_HEADER"] = "Elfos Noturnos"
L["OPTIONS_STEALTH_DRINKING"] = "Ativar furtividade ao beber"
L["OPTIONS_STEALTH_DRINKING_DESCRIPTION"] =
	"Anexa Fusão Espiritual à sua macro de Água para que você entre em furtividade enquanto bebe."
L["OPTIONS_STEALTH_EATING_NIGHTELF_DESCRIPTION"] =
	"Anexa Fusão Espiritual à sua macro de Comida para que você entre em furtividade enquanto come."
L["OPTIONS_STEALTH_PICK_ONE"] =
	"Dica pro: Escolha um. Você pode comer e beber ao mesmo tempo, mas comer ou beber depois de entrar em furtividade quebrará sua furtividade."

-- Rogues
L["OPTIONS_ROGUES_HEADER"] = "Ladinos"
L["OPTIONS_POISONS_DESCRIPTION"] =
	"Mantém a macro de Venenos carregada com o melhor rank utilizável de cada tipo de veneno: clique esquerdo aplica na mão secundária, clique direito na mão principal, e venenos existentes são substituídos automaticamente."
L["OPTIONS_POISON_MAIN_HAND"] = "Tipo de veneno da mão principal"
L["OPTIONS_POISON_OFF_HAND"] = "Tipo de veneno da mão secundária"
L["OPTIONS_STEALTH_EATING"] = "Ativar furtividade ao comer"
L["OPTIONS_STEALTH_EATING_ROGUE_DESCRIPTION"] =
	"Anexa Furtividade à sua macro de Comida para que você entre em furtividade enquanto come."

-- Restocker options panel. The tree label stays "Restocker" in every locale
-- (brand fragment, localization allowlist); the panel header reuses
-- RESTOCKER_WINDOW_TITLE.
L["OPTIONS_RESTOCKER_TAB"] = "Restocker"
L["OPTIONS_RESTOCKER_DESCRIPTION"] =
	"Mantém suas bolsas abastecidas a partir de uma lista de reabastecimento por personagem. Compra automaticamente dos vendedores e move itens entre as bolsas e o banco. Digite %s para abrir a lista."
L["OPTIONS_RESTOCKER_OPEN_BANK"] = "Abrir no banco"
L["OPTIONS_RESTOCKER_OPEN_BANK_DESCRIPTION"] = "Abre a janela do Restocker ao visitar o banco."
L["OPTIONS_RESTOCKER_OPEN_MERCHANT"] = "Abrir no vendedor"
L["OPTIONS_RESTOCKER_OPEN_MERCHANT_DESCRIPTION"] = "Abre a janela do Restocker ao visitar um vendedor."
L["OPTIONS_RESTOCKER_REMIND"] = "Ativar lembretes de reabastecimento na cidade"
L["OPTIONS_RESTOCKER_REMIND_DESCRIPTION"] =
	"Exibe um lembrete no chat quando você chega a uma taverna ou cidade e falta algo na sua lista de reabastecimento."
L["OPTIONS_RESTOCKER_MERCHANT_REMIND"] = "Ativar lembretes de reabastecimento no vendedor"
L["OPTIONS_RESTOCKER_MERCHANT_REMIND_DESCRIPTION"] =
	"Informa os pedidos de reabastecimento pendentes quando você fecha a janela do vendedor. Fica em silêncio quando não há nenhum."
L["OPTIONS_RESTOCKER_BANK_REMIND"] = "Ativar lembretes de reabastecimento no banco"
L["OPTIONS_RESTOCKER_BANK_REMIND_DESCRIPTION"] =
	"Informa os pedidos de reabastecimento pendentes quando você fecha o banco. Fica em silêncio quando não há nenhum."

--[[
    The starter List Builder pop-up. This toggle and the pop-up's own "Don't
    show this again" box are the same per-character choice read from opposite
    ends, which is why one ships on and the other off: a settings row reads
    naturally as "enable", a dismissal reads naturally as "stop".
]]
L["OPTIONS_RESTOCKER_STARTER_LIST"] = "Ativar o assistente de lista quando a lista de reabastecimento estiver vazia"
L["OPTIONS_RESTOCKER_STARTER_LIST_DESCRIPTION"] =
	"Oferece uma lista de reabastecimento inicial no login sempre que a deste personagem estiver vazia."

--[[
    How much each reminder says. Simple is the headline alone; Verbose adds a
    line per item, showing how many you have against how many you want.

    One word each, deliberately: these sit beside toggles carrying a whole
    sentence, and every character here is one the caption beside them loses.
]]
L["OPTIONS_RESTOCKER_MODE_SIMPLE"] = "Simples"
L["OPTIONS_RESTOCKER_MODE_VERBOSE"] = "Detalhado"

L["OPTIONS_RESTOCKER_REMIND_SOUND"] = "Tocar som"
L["OPTIONS_RESTOCKER_REMIND_SOUND_DESCRIPTION"] =
	"Toca um alerta junto com o lembrete, para quando o chat está agitado."
L["OPTIONS_RESTOCKER_SOUND_PREVIEW"] = "Clique para ouvir o alerta."
L["OPTIONS_RESTOCKER_DEBUG"] = "Ativar mensagens de depuração do Restocker"
L["OPTIONS_RESTOCKER_DEBUG_DESCRIPTION"] =
	"Imprime no chat as decisões de reabastecimento do Restocker passo a passo (banco e vendedor). Verboso; permanece ativo entre sessões até ser desligado."

L["OPTIONS_RESTOCKER_WINDOW_HEADER"] = "Janela do Reabastecimento"
L["OPTIONS_RESTOCKER_ADVANCED_HEADER"] = "Avançado"

--[[
    Praise for the adopted Restocker code. The three names are proper nouns and
    stay as written in every locale (localization allowlist); the sentences
    around them translate. Matches the History section of README.md.
]]
L["OPTIONS_RESTOCKER_PRAISE_HEADER"] = "Agradecimentos"
L["OPTIONS_RESTOCKER_PRAISE"] =
	"Sempre amei o Restocker, e fico feliz que ele continue vivo dentro do Connoisseur. Muito obrigado a ChiliFajita, que escreveu o Auto Restocker original, e a kvakvs e guardycmw, que o mantiveram vivo através do Classic e de Mists of Pandaria."

--[[
    /Commands. Both halves of each line are locale keys: the literal, which stays
    identical in every locale (localization allowlist), and its description.
]]
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMAND"] = "/foodie"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Abre a interface de opções deste add-on."
L["RESTOCKER_COMMAND"] = "/crs"
L["RESTOCKER_COMMAND_DESCRIPTION"] = "Abre a janela do Restocker para gerenciar sua lista de reabastecimento."

--[[
    Macros panel. OPTIONS_MACROS_TAB is the panel's label in the settings tree
    and the title on the page; DESCRIPTION is the intro beneath it, which
    orients the player to the page's two halves -- which macros exist, then how
    each one behaves. The Enable Macros header below titles the first section.
]]
L["OPTIONS_MACROS_TAB"] = "Macros"
L["OPTIONS_MACROS_DESCRIPTION"] =
	"O Connoisseur cria uma macro por consumível e a mantém atualizada conforme suas bolsas mudam, então o botão na sua barra sempre busca o melhor item que você está carregando. Escolha abaixo quais macros criar e depois defina como cada uma escolhe seu item."
L["OPTIONS_ENABLE_MACROS_HEADER"] = "Ativar Macros"
L["OPTIONS_ENABLE_MACROS_DESCRIPTION"] =
	"Alterne quais macros o Connoisseur cria e mantém. Desativar uma macro também a removerá."

--[[
    Feedback & Support. The four service names are brand names and stay English
    in every locale (localization allowlist); VERSION_LABEL translates.
]]
L["OPTIONS_COMMUNITY_HEADER"] = "Feedback e Suporte"
L["DISCORD"] = "Discord"
L["GITHUB"] = "GitHub"
L["CURSEFORGE"] = "CurseForge"
L["WAGO"] = "Wago"
L["VERSION_LABEL"] = "Versão"

--------------------------------------------------------------------------------
-- Restocker Window & Chat
--------------------------------------------------------------------------------

-- Chat messages printed by the Restocker feature (Features/Restocker/).
L["RESTOCKER_IMPORTED_LISTS"] = "Suas listas do Restocker foram importadas."
L["RESTOCKER_PROFILE_EXISTS"] = 'Já existe um perfil chamado "%s".'
L["RESTOCKER_BANK_NOT_OPEN"] = "O banco não está aberto."
--[[
    %s is the /crs slash command, colored at the call site. Only the bank flow
    prints this, so the Shift hint names the bank; Shift is read as the window
    opens (eventsModule.OnBankOpen), not stored as a preference.
]]
L["RESTOCKER_COMPLETE"] =
	"Reabastecimento concluído. Segure Shift ao abrir o banco para pular o reabastecimento. Digite %s para editar sua lista de reabastecimento."
L["RESTOCKER_STOPPED_BOTH_FULL"] = "Reabastecimento interrompido. Suas bolsas e seu banco estão cheios."
L["RESTOCKER_STOPPED_BANK_FULL"] = "Reabastecimento interrompido. Seu banco está cheio; libere um espaço e reabra-o."
L["RESTOCKER_STOPPED_BAG_FULL"] =
	"Reabastecimento interrompido. Suas bolsas estão cheias; libere um espaço e reabra o banco."
L["RESTOCKER_STOPPED_NO_PROGRESS"] = "Reabastecimento interrompido. Nenhum progresso foi possível."
L["RESTOCKER_STOPPED_COULD_NOT_MOVE"] = "Reabastecimento interrompido. Não foi possível mover: %s"
-- { count, item name }
L["RESTOCKER_STUCK_ITEM_FORMAT"] = "%dx %s"
L["RESTOCKER_STUCK_ITEM_EXTRA_FORMAT"] = "%dx %s (excedente)"
L["RESTOCKER_STOPPED_ERROR"] = "Reabastecimento interrompido por um erro: %s"
L["RESTOCKER_BAGS_FULL_SKIP_MERCHANT"] = "Suas bolsas estão cheias. Pulando o reabastecimento no vendedor."
-- Printed on reaching an inn or a city with something left on the Grocery List.
L["RESTOCKER_TOWN_REMINDER"] = "Não esqueça de se reabastecer enquanto está na cidade!"

--[[
    Headline for the merchant and bank reminders, which report on the way out
    rather than nudging on arrival, so the count is the message. The in-town
    reminder keeps its own line above.

    The count is of restocking orders -- rows of the Restock List still below
    their target -- which is why it does not say "items". An earlier draft read
    "You're still short 9 items", and a bare object after "short" forces the
    unit reading: "short 9 apples" is nine apples missing. The number here is
    nine ROWS, each short by anything from one juice to a full stack. "Order"
    can only mean a line on a list, so the ambiguity cannot come back, and it
    is the word the code already uses (BuildPurchaseOrder, purchaseOrders).

    "Outstanding" is load-bearing, not decoration. "Restocking order" alone can
    be read as the sequence restocking happens in, and the list UI is sortable,
    so the word forcing the purchase-order sense has to stay beside the noun.
    Same job as "filled" on RESTOCKER_RESTOCKED_ONE -- never print the bare
    noun without one of them.
]]
L["RESTOCKER_STILL_SHORT_ONE"] = "1 pedido de reabastecimento pendente."
L["RESTOCKER_STILL_SHORT_MANY"] = "%d pedidos de reabastecimento pendentes."

--[[
    Level-up upgrades. The headline makes the Restock List the subject, so
    there is no item count to agree with and one string covers any number of
    swaps; the line under it is { old link, new link } and has no words at all.
    It separates the two with the house " // " rather than an arrow glyph, which
    renders as a box in some client fonts and locales.
]]
L["RESTOCKER_UPGRADED"] = "Sua lista de reabastecimento foi atualizada."
L["RESTOCKER_UPGRADED_ITEM"] = "%sx%d passa a %sx%d."

--[[
    Verbose follow-up line, one per short item: { have, wanted, item link }.
    Shared by all three reminders. Wordless on purpose -- the headline above it
    supplies the context, so there is nothing here to translate. It stays a
    locale key anyway so a locale that needs a different order can reorder it
    (same as RESTOCKER_STUCK_ITEM_FORMAT).
]]
L["RESTOCKER_REMINDER_ITEM"] = "%d/%d %s"

--[[
    Printed after buying at a vendor. Counts restocking orders FILLED -- rows
    whose whole requested amount was ordered -- not BuyMerchantItem calls and
    not vendor slots. Forty juice bought in two stacks of twenty is one order
    filled; six of a requested twenty is not one at all, and belongs to the
    partial line below.

    The claim has to be earned, which is why merchantModule:PurchaseMerchantItem
    reports whether it got the full amount instead of the caller inferring it
    from a unit count. What the vendor did not stock is deliberately not
    mentioned here: the mini-map's Restocker Report owns the outstanding state,
    this line owns the event, and neither repeats the other.
]]
L["RESTOCKER_RESTOCKED_ONE"] = "1 pedido de reabastecimento atendido."
L["RESTOCKER_RESTOCKED_MANY"] = "%d pedidos de reabastecimento atendidos."

--[[
    The vendor had some of what an order asked for but not all of it. Its own
    line rather than a clause on the one above, so the two counts stay
    independent and a mixed run needs no combined string -- both print when
    both are non-zero, and a run with no partials never mentions them.

    Without this line, a partial buy would spend gold and say nothing, since
    "filled" has to stay false for it.
]]
L["RESTOCKER_RESTOCKED_PARTIAL_ONE"] = "1 pedido de reabastecimento atendido em parte."
L["RESTOCKER_RESTOCKED_PARTIAL_MANY"] = "%d pedidos de reabastecimento atendidos em parte."

-- /crs help lines. The command literals stay in code; these are the descriptions.
L["RESTOCKER_HELP_SHOW"] = "Mostra a janela do Restocker."
L["RESTOCKER_HELP_PROFILE_ADD"] = "Adiciona um perfil com esse nome."
L["RESTOCKER_HELP_PROFILE_DELETE"] = "Exclui o perfil com esse nome."
L["RESTOCKER_HELP_PROFILE_RENAME"] = "Renomeia o perfil atual para esse nome."
L["RESTOCKER_HELP_PROFILE_COPY"] = "Copia esse perfil para o perfil atual."
L["RESTOCKER_HELP_PROFILE_USE"] = "Troca o perfil ativo para esse nome."

--[[
    Starter List pop-up: the login window that offers vendor staples when the
    Restock List is empty (Features/Restocker/StarterList.lua). Its title
    reuses RESTOCKER_WINDOW_TITLE below, and the six food staples reuse the
    DIET_ keys above, so the popup names bread whatever the pet-food tooltips
    call it.

    The intro is three short paragraphs: why the window opened, what a tick
    does, and the way back in. Joined with blank lines at the call site, so
    each reads as its own breath rather than one wall.
]]
L["STARTER_POPUP_INTRO_EMPTY"] =
	"Sua lista de reabastecimento está vazia, então vamos adicionar alguns itens para você começar."
L["STARTER_POPUP_INTRO_HOW"] =
	"Tudo o que você marcar é mantido em estoque automaticamente sempre que você abre um vendedor ou o seu banco, e os itens comuns se atualizam sozinhos conforme você sobe de nível, então você sempre terá o melhor disponível."
-- %s is the /crs slash command, colored at the call site.
L["STARTER_POPUP_COMMAND_HINT"] = "Você sempre pode ajustar esta lista, ou adicionar mais itens depois, digitando %s."
--[[
    The first section's heading names the water row it carries -- except for
    the manaless classes, whose section holds only food, so the heading says
    only that.
]]
L["STARTER_POPUP_FOOD_AND_WATER_HEADER"] = "Comida e água"
L["STARTER_POPUP_FOOD_HEADER"] = "Comida"
L["STARTER_POPUP_AMMO_HEADER"] = "Munição"
-- The two ammo staples; the Water label reuses LABEL_WATER above.
L["STARTER_POPUP_BULLETS"] = "Balas"
L["STARTER_POPUP_ARROWS"] = "Flechas"

--[[
    The Reagents & Tools section: class tools and spell reagents, at most a
    handful per class. Rogues additionally get a Poisons section of their
    own, whose note under the header reuses PREFIX_ROGUE (rogue-colored at
    the call site) to say the ingredients take care of themselves. The
    poison labels are short forms on purpose -- the section heading plus the
    tooltip's exact rank carry the rest -- and LABEL_POISONS ("Poison",
    singular) belongs to the macro's no-item message and is not reused here.
    The other reagent labels are kept inside about fifteen characters so
    they hold the popup's reagent-row label cell.
]]
L["STARTER_POPUP_REAGENTS_HEADER"] = "Componentes e ferramentas"
L["STARTER_POPUP_POISONS_HEADER"] = "Venenos"
-- %s is the rogue-colored PREFIX_ROGUE; the spaced colon is deliberate.
L["STARTER_POPUP_POISONS_NOTE"] =
	"%s : Adicione o veneno pronto à sua lista, e o Connoisseur compra os ingredientes automaticamente em qualquer vendedor que os tenha."
L["STARTER_POPUP_POISON_ANESTHETIC"] = "Anestésico"
L["STARTER_POPUP_POISON_CRIPPLING"] = "Aleijante"
L["STARTER_POPUP_POISON_DEADLY"] = "Mortal"
L["STARTER_POPUP_POISON_INSTANT"] = "Instantâneo"
L["STARTER_POPUP_POISON_MIND_NUMBING"] = "Entorpecente"
L["STARTER_POPUP_POISON_WOUND"] = "Ferimento"
L["STARTER_POPUP_REAGENT_HEARTHSTONE"] = "Pedra do Lar"
L["STARTER_POPUP_REAGENT_BLINDING_POWDER"] = "Pó Cegante"
L["STARTER_POPUP_REAGENT_FLASH_POWDER"] = "Pó de Flash"
L["STARTER_POPUP_REAGENT_THIEVES_TOOLS"] = "Gazuas"
L["STARTER_POPUP_REAGENT_CORPSE_DUST"] = "Pó de Cadáver"
L["STARTER_POPUP_REAGENT_WILDS"] = "Frutas Silvestres"
L["STARTER_POPUP_REAGENT_SEEDS"] = "Sementes"
L["STARTER_POPUP_REAGENT_ARCANE_POWDER"] = "Pó Arcano"
L["STARTER_POPUP_REAGENT_LIGHT_FEATHER"] = "Pena Leve"
L["STARTER_POPUP_REAGENT_TELEPORT_RUNES"] = "Runas de Teleporte"
L["STARTER_POPUP_REAGENT_PORTAL_RUNES"] = "Runas de Portal"
L["STARTER_POPUP_REAGENT_SYMBOL_DIVINITY"] = "Símbolo Divino"
L["STARTER_POPUP_REAGENT_SYMBOL_KINGS"] = "Símbolo dos Reis"
L["STARTER_POPUP_REAGENT_CANDLES"] = "Velas"
L["STARTER_POPUP_REAGENT_ANKH"] = "Ankh"
L["STARTER_POPUP_REAGENT_FISH_SCALES"] = "Escamas de Peixe"
L["STARTER_POPUP_REAGENT_FISH_OIL"] = "Óleo de Peixe"
L["STARTER_POPUP_REAGENT_EARTH_TOTEM"] = "Totem de Terra"
L["STARTER_POPUP_REAGENT_FIRE_TOTEM"] = "Totem de Fogo"
L["STARTER_POPUP_REAGENT_WATER_TOTEM"] = "Totem de Água"
L["STARTER_POPUP_REAGENT_AIR_TOTEM"] = "Totem de Ar"
L["STARTER_POPUP_REAGENT_FIGURINE"] = "Estatueta"
L["STARTER_POPUP_REAGENT_INFERNAL_STONE"] = "Pedra Infernal"
L["STARTER_POPUP_REAGENT_SOUL_SHARDS"] = "Fragmentos de Alma"
-- Checkbox tooltip: { item link, amount }.
L["STARTER_POPUP_ITEM_DESCRIPTION"] =
	"Adiciona %s à sua lista de reabastecimento, mantendo %d nas suas bolsas e atualizando-os conforme você sobe de nível."
L["STARTER_POPUP_ITEM_DESCRIPTION_STATIC"] = "Adiciona %s à sua lista de reabastecimento, mantendo %d nas suas bolsas."
--[[
    The stacks dropdown beside each staple. The label is unit-agnostic (a
    stack is 20 food or water, 200 ammo); the tooltip below carries the
    per-item stack size as %d.
]]
L["STARTER_POPUP_STACK_ONE"] = "1 pilha"
L["STARTER_POPUP_STACK_MANY"] = "%d pilhas"
L["STARTER_POPUP_STACKS_DESCRIPTION"] = "Quantas pilhas manter em estoque. Aqui, uma pilha é %d."
L["STARTER_POPUP_DISMISS"] = "Não mostrar novamente para este personagem."
L["STARTER_POPUP_DISMISS_DESCRIPTION"] =
	"Caso contrário, estas sugestões voltam em qualquer login que encontre sua lista de reabastecimento vazia."

-- Restocker window UI.
L["RESTOCKER_WINDOW_TITLE"] = "Connoisseur Restocker"
L["RESTOCKER_FILTER_PLACEHOLDER"] = "Filtrar itens..."
L["RESTOCKER_ADD_BUTTON"] = "Adicionar"
L["RESTOCKER_ADD_TOOLTIP_TITLE"] = "Adicionar um item"
L["RESTOCKER_ADD_TOOLTIP_BODY"] = "Solte um item das suas bolsas ou digite um ID de item numérico."
-- In-box placeholder for the add row; the tooltip above carries the detail.
L["RESTOCKER_ADD_PLACEHOLDER"] = "Solte um item aqui, ou digite seu ID..."
L["RESTOCKER_PROFILE_LABEL"] = "Perfil:"
L["RESTOCKER_RENAME_LABEL"] = "Renomear:"
L["RESTOCKER_NEW_PROFILE"] = "Novo perfil"
L["RESTOCKER_COPY_PROFILE"] = "Copiar"
--[[
    The three single-argument tooltips below (Copy, Delete, and the row's
    Remove) render in RS.SetupTooltip's TITLE slot, not its body, so they take
    no terminal punctuation -- matching every other title in the window. Don't
    "restore" the period they read as wanting.
]]
L["RESTOCKER_COPY_PROFILE_TOOLTIP"] = "Clona este perfil em um novo"
-- %s becomes "<profile name> Copy"; numbered if that name is taken.
L["RESTOCKER_PROFILE_COPY_NAME"] = "%s Cópia"
L["RESTOCKER_DELETE_PROFILE"] = "Excluir"
L["RESTOCKER_DELETE_PROFILE_TOOLTIP"] = "Exclui este perfil"
-- %s is the profile name, colored at the call site. |n are line breaks.
L["RESTOCKER_DELETE_PROFILE_CONFIRM"] =
	"Tem certeza de que deseja excluir este perfil?|n|n%s|n|nIsso não pode ser desfeito."
--[[
    Row controls in the Restocker window. UPGRADE is disabled on any item that
    is not on a ladder in Data/Consumable-Upgrade-Paths.lua, which on a real
    list is most of them.
]]
L["RESTOCKER_UPGRADE_LABEL"] = "Melhoria auto."
L["RESTOCKER_UPGRADE_TOOLTIP_TITLE"] = "Melhorar com o seu nível"
L["RESTOCKER_UPGRADE_TOOLTIP_BODY"] =
	"Comida, água, munição e poções têm caminhos de melhoria claros conforme você sobe de nível, então o Connoisseur promove este item para você. Todo o resto fica por sua conta com o tempo."

--[[
    Group captions on a row's detail line, which is hidden until the row is
    expanded. They label where the item moves from, so the buttons beside them
    can stay one word each.
]]
L["RESTOCKER_ROW_BANK"] = "Banco"
L["RESTOCKER_ROW_MERCHANT"] = "Vendedor"
L["RESTOCKER_ROW_UPGRADE"] = "Melhoria"

L["RESTOCKER_GROUP_OTHER"] = "Outros"
--[[
    Temporary group holding items added during this viewing of the window. It
    sorts above every real item type and disappears when the window closes.
]]
L["RESTOCKER_GROUP_NEW"] = "Novos"
-- Title slot, like the two profile-button tooltips above: no terminal period.
L["RESTOCKER_REMOVE_TOOLTIP"] = "Remove este item da lista de reabastecimento"
L["RESTOCKER_AMOUNT_TOOLTIP_TITLE"] = "Quantidade a manter"
L["RESTOCKER_AMOUNT_TOOLTIP_BODY"] = "Pressione Enter ao terminar de editar."
L["RESTOCKER_BUY_LABEL"] = "Comprar"
L["RESTOCKER_BUY_TOOLTIP_TITLE"] = "Comprar do vendedor"
L["RESTOCKER_BUY_TOOLTIP_BODY"] = "Compra a quantidade necessária quando a janela do vendedor estiver aberta."
L["RESTOCKER_DEPOSIT_LABEL"] = "Depositar"
L["RESTOCKER_DEPOSIT_TOOLTIP_TITLE"] = "Guardar no banco"
L["RESTOCKER_DEPOSIT_TOOLTIP_BODY"] =
	"Guarda itens excedentes no banco quando ele estiver aberto. Use 0 para guardar tudo."
L["RESTOCKER_WITHDRAW_LABEL"] = "Retirar"
L["RESTOCKER_WITHDRAW_TOOLTIP_TITLE"] = "Reabastecer do banco"
L["RESTOCKER_WITHDRAW_TOOLTIP_BODY"] = "Pega os itens necessários do banco quando ele estiver aberto."

-- Required-reputation control (per-item vendor gate).
L["RESTOCKER_REPUTATION_MENU_TITLE"] = "Reputação exigida"
--[[
    { standing label, discount percent }.

    This string IS run through string.format, so its literal percent sign is
    escaped as %%. RESTOCKER_REPUTATION_TOOLTIP_DISCOUNTS below is printed
    as-is and therefore writes bare % signs. Both are correct where they
    stand; neither may be "normalized" to match the other, in any locale.
]]
L["RESTOCKER_REPUTATION_DISCOUNT_FORMAT"] = "%s (%d%% de desconto)"
L["RESTOCKER_REPUTATION_ANY"] = "Qualquer"
L["RESTOCKER_REPUTATION_FRIENDLY"] = "Amistoso"
L["RESTOCKER_REPUTATION_HONORED"] = "Honrado"
L["RESTOCKER_REPUTATION_REVERED"] = "Reverenciado"
L["RESTOCKER_REPUTATION_EXALTED"] = "Exaltado"
--[[
    The button shows a value, not an action, which left it reading as a bare
    "Any" among four verbs. The prefix labels the control, since the window has
    no column headings to do it.
]]
L["RESTOCKER_REPUTATION_BUTTON_FORMAT"] = "Rep.: %s"

L["RESTOCKER_REPUTATION_TOOLTIP_TITLE"] = "Reputação exigida com o vendedor"
--[[
    Quotes the button's own label. That couples this line to
    RESTOCKER_REPUTATION_BUTTON_FORMAT and RESTOCKER_REPUTATION_ANY -- a locale
    that renders the button differently has to say so here too.
]]
L["RESTOCKER_REPUTATION_TOOLTIP_STANDING"] =
	'Escolha um nível de reputação e o Connoisseur pulará os vendedores com quem você não o alcançou. "Rep.: Qualquer" compra de qualquer vendedor.'
L["RESTOCKER_REPUTATION_TOOLTIP_DISCOUNTS"] =
	"A reputação também reduz o preço: Amistoso 5%, Honrado 10%, Reverenciado 15%, Exaltado 20%."
L["RESTOCKER_REPUTATION_TOOLTIP_CLICK"] = "Clique para alterar."
