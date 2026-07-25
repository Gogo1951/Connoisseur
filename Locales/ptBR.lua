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
	"Parece que você encontrou um bug! %s (%s) não pode ser usado em %s > %s (%s). Por favor, reporte isso para que possamos consertar. Obrigado! https://discord.gg/eh8hKq992Q"
L["MSG_NO_ITEM"] = "Nenhum %s adequado encontrado em suas bolsas."
L["MSG_MACRO_SLOTS_FULL"] =
	"Algumas macros do Connoisseur não puderam ser criadas porque seus espaços para macros estão cheios. Libere um espaço excluindo macros que você não usa mais ou desative as macros do Connoisseur de que você não precisa em Opções > AddOns > Connoisseur."

L["CHAT_LOADED"] =
	"Versão %s. As configurações (incluindo a opção de desativar esta mensagem) podem ser encontradas em Opções > AddOns > Connoisseur. Gostando do addon? Conte para um amigo! (="

--------------------------------------------------------------------------------
-- Ready Check
--------------------------------------------------------------------------------

--[[
    The ready-check self-audit, printed as one line: either the missing list or
    the all-clear, then a segment per tracked buff. Item names come from the
    LABEL_ keys below, so a consumable is named the same here as it is in
    MSG_NO_ITEM.
]]

L["READY_ALL_CLEAR"] = "Tudo pronto"
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
L["MENU_BUFF_FOOD"] = "Comida com Buff"
L["MENU_BUFF_FOOD_DESCRIPTION"] = 'Prioriza comida que concede o buff "Bem Alimentado", quando o buff estiver faltando.'
L["MENU_SCROLL_BUFFS"] = "Buffs de Pergaminho"
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
L["OPTIONS_REAPPLY_THRESHOLD"] = "Tratar como expirado quando"
L["REAPPLY_THRESHOLD_ONE"] = "< 1 minuto restante"
L["REAPPLY_THRESHOLD_N"] = "< %d minutos restantes"

-- Ready Check
L["OPTIONS_READY_CHECK_HEADER"] = "Verificação de Prontidão"
L["OPTIONS_READY_CHECK"] = "Relatar prontidão na verificação"
L["OPTIONS_READY_CHECK_DESCRIPTION"] =
	"Mostra o que está faltando e quanto tempo resta nos buffs monitorados sempre que uma verificação de prontidão começa; só você vê."

-- Buff Food
L["OPTIONS_BUFF_FOOD_HEADER"] = "Comida com Buff"
L["OPTIONS_BUFF_FOOD"] = "Priorizar Comida com Buff"
L["OPTIONS_BUFF_FOOD_DESCRIPTION"] =
	'Prioriza comida que concede o buff "Bem Alimentado", quando o buff estiver faltando. Desativado nas Arenas.'
L["OPTIONS_BUFF_FOOD_DETAIL"] =
	"Dica pro: Ter a si mesmo como alvo sempre faz a macro de Comida pular comida com buff e pergaminhos."

-- Scroll Buffs
L["OPTIONS_SCROLL_HEADER"] = "Buffs de Pergaminho"
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
L["OPTIONS_DRUID_RETURN_FORM"] = "Após Consumível, Mudar para"
L["DRUID_FORM_BEAR"] = "Urso"
L["DRUID_FORM_CAT"] = "Gato"

-- Night Elves
L["OPTIONS_NIGHTELF_HEADER"] = "Elfos Noturnos"
L["OPTIONS_SHADOWMELD_DRINKING"] = "Ativar furtividade ao beber"
L["OPTIONS_SHADOWMELD_DRINKING_DESCRIPTION"] =
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

-- Restocker. The section header reuses RESTOCKER_WINDOW_TITLE.
L["OPTIONS_RESTOCKER_DESCRIPTION"] =
	"Mantém suas bolsas abastecidas a partir de uma lista de reabastecimento por personagem. Compra automaticamente dos vendedores e move itens entre as bolsas e o banco. Digite /crs para abrir a lista."
L["OPTIONS_RESTOCKER_OPEN_BANK"] = "Abrir no banco"
L["OPTIONS_RESTOCKER_OPEN_BANK_DESCRIPTION"] = "Abre a janela do Restocker ao visitar o banco."
L["OPTIONS_RESTOCKER_OPEN_MERCHANT"] = "Abrir no vendedor"
L["OPTIONS_RESTOCKER_OPEN_MERCHANT_DESCRIPTION"] = "Abre a janela do Restocker ao visitar um vendedor."
L["OPTIONS_RESTOCKER_DEBUG"] = "Ativar mensagens de depuração do Restocker"
L["OPTIONS_RESTOCKER_DEBUG_DESCRIPTION"] =
	"Imprime no chat as decisões de reabastecimento do Restocker passo a passo (banco e vendedor). Verboso; permanece ativo entre sessões até ser desligado."

-- /Commands. The command literals stay in code; these are the descriptions.
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMANDS_FOODIE_DETAIL"] = "Abre a interface de opções do Connoisseur."
L["OPTIONS_COMMANDS_CRS_DETAIL"] = "Abre a janela do Restocker para gerenciar sua lista de reabastecimento."

-- Enable Macros
L["OPTIONS_ENABLE_MACROS_HEADER"] = "Ativar Macros"
L["OPTIONS_ENABLE_MACROS_DESCRIPTION"] =
	"Alterne quais macros o Connoisseur cria e mantém. Desativar uma macro também a removerá."

-- Feedback & Support
L["OPTIONS_COMMUNITY_HEADER"] = "Feedback e Suporte"

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
L["RESTOCKER_FINISHED_RESTOCKING"] = "Reabastecimento finalizado (compras: %d)."

-- /crs help lines. The command literals stay in code; these are the descriptions.
L["RESTOCKER_HELP_SHOW"] = "Mostra a janela do Restocker."
L["RESTOCKER_HELP_PROFILE_ADD"] = "Adiciona um perfil com esse nome."
L["RESTOCKER_HELP_PROFILE_DELETE"] = "Exclui o perfil com esse nome."
L["RESTOCKER_HELP_PROFILE_RENAME"] = "Renomeia o perfil atual para esse nome."
L["RESTOCKER_HELP_PROFILE_COPY"] = "Copia esse perfil para o perfil atual."
L["RESTOCKER_HELP_PROFILE_USE"] = "Troca o perfil ativo para esse nome."

-- Restocker window UI.
L["RESTOCKER_WINDOW_TITLE"] = "Connoisseur Restocker"
L["RESTOCKER_FILTER_PLACEHOLDER"] = "Filtrar itens..."
L["RESTOCKER_ADD_BUTTON"] = "Adicionar"
L["RESTOCKER_ADD_TOOLTIP_TITLE"] = "Adicionar um item"
L["RESTOCKER_ADD_TOOLTIP_BODY"] = "Solte um item das suas bolsas ou digite um ID de item numérico."
L["RESTOCKER_PROFILE_LABEL"] = "Perfil:"
L["RESTOCKER_RENAME_LABEL"] = "Renomear:"
L["RESTOCKER_NEW_PROFILE"] = "Novo perfil"
L["RESTOCKER_COPY_PROFILE"] = "Copiar"
L["RESTOCKER_COPY_PROFILE_TOOLTIP"] = "Clona este perfil em um novo."
-- %s becomes "<profile name> Copy"; numbered if that name is taken.
L["RESTOCKER_PROFILE_COPY_NAME"] = "%s Cópia"
L["RESTOCKER_DELETE_PROFILE"] = "Excluir"
L["RESTOCKER_DELETE_PROFILE_TOOLTIP"] = "Exclui este perfil."
-- %s is the profile name, colored at the call site. |n are line breaks.
L["RESTOCKER_DELETE_PROFILE_CONFIRM"] =
	"Tem certeza de que deseja excluir este perfil?|n|n%s|n|nIsso não pode ser desfeito."
L["RESTOCKER_GROUP_OTHER"] = "Outros"
L["RESTOCKER_REMOVE_TOOLTIP"] = "Remove este item da lista de reabastecimento."
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
-- { standing label, discount percent }
L["RESTOCKER_REPUTATION_DISCOUNT_FORMAT"] = "%s  (%d%% de desconto)"
L["RESTOCKER_REPUTATION_ANY"] = "Qualquer"
L["RESTOCKER_REPUTATION_FRIENDLY"] = "Amistoso"
L["RESTOCKER_REPUTATION_HONORED"] = "Honrado"
L["RESTOCKER_REPUTATION_REVERED"] = "Reverenciado"
L["RESTOCKER_REPUTATION_EXALTED"] = "Exaltado"
L["RESTOCKER_REPUTATION_TOOLTIP_TITLE"] = "Reputação exigida com o vendedor"
L["RESTOCKER_REPUTATION_TOOLTIP_STANDING"] =
	"Só compra de vendedores com os quais você tenha ao menos essa reputação."
L["RESTOCKER_REPUTATION_TOOLTIP_DISCOUNTS"] =
	"Reputação mais alta também significa preços menores (Amistoso 5%, Honrado 10%, Reverenciado 15%, Exaltado 20%)."
L["RESTOCKER_REPUTATION_TOOLTIP_CLICK"] = "Clique para escolher uma reputação."
