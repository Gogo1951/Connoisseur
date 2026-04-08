local L = LibStub("AceLocale-3.0"):NewLocale("Connoisseur", "ptBR")
if not L then return end

-- [[ BRAZILIAN PORTUGUESE (ptBR) ]] --
L["BRAND"] = "Connoisseur"

-- Macro Names Can't Exceed 16 Total Characters
L["MACRO_BANDAGE"] = "- Bandagem"
L["MACRO_FOOD"]    = "- Comida"
L["MACRO_HPOT"]    = "- Poção de Cura"
L["MACRO_HS"]      = "- Pedra de Vida"
L["MACRO_MGEM"]    = "- Gema de Mana"
L["MACRO_MPOT"]    = "- Poção de Mana"
L["MACRO_SS"]      = "- Pedra de Alma"
L["MACRO_WATER"]   = "- Água"
L["MACRO_FEED_PET"]= "- Alim. Ajudante"

L["ERR_ZONE"] = "Você não pode usar isso aqui."
L["RANK"]     = "Grau"

L["MSG_BUG_REPORT"] = "Parece que você encontrou um bug! %s (%s) não pode ser usado em %s > %s (%s). Por favor, reporte isso para que possamos consertar. Obrigado! https://discord.gg/eh8hKq992Q"
L["MSG_NO_ITEM"]    = "Nenhum %s adequado encontrado em suas bolsas."

L["MENU_BUFF_FOOD"]      = "Priorizar Comida com Buff"
L["MENU_BUFF_FOOD_DESC"] = "Prioriza comida que concede o buff \"Bem Alimentado\", quando o buff estiver faltando."
L["MENU_CLEAR_IGNORE"]   = "Limpar Lista de Ignorados"
L["MENU_IGNORE"]         = "Ignorar"
L["MENU_RESET"]          = "Redefinir"
L["MENU_SCAN"]           = "Forçar Varredura"
L["MENU_TITLE"]          = "Consumíveis"

L["MENU_SCROLL_BUFFS"]      = "Buffs de Pergaminho"
L["MENU_SCROLL_BUFFS_DESC"] = "Usa pergaminhos de atributos como parte da sua macro de Comida quando o buff do pergaminho estiver faltando."
L["MENU_OPTIONS_HINT"]      = "Configurações adicionais podem ser encontradas em Opções > AddOns > Connoisseur."

L["PREFIX_HUNTER"]  = "Atenção Caçadores"
L["PREFIX_MAGE"]    = "Atenção Magos"
L["PREFIX_WARLOCK"] = "Atenção Bruxos"

L["TIP_DOWNRANK"]        = "Selecionar um jogador de nível mais baixo fará com que a macro conjure itens apropriados para o nível dele."
L["TIP_HUNTER_FEED_PET"] = "Alimentar Ajudante é um botão tudo-em-um! Clique para Chamar, Alimentar ou Reviver automaticamente seu ajudante. Clique com o botão direito ou use em combate para lançar Curar Ajudante. Segure Shift para forçar Reviver, ou Ctrl para Dispensar."
L["TIP_MAGE_CONJURE"]    = "Clique com o botão direito nas suas macros de Comida ou Água para Criar Comida ou Água."
L["TIP_MAGE_GEM"]        = "Clique com o botão direito na sua macro de Gema de Mana para conjurar uma nova gema. Clique com o botão direito novamente para conjurar uma reserva de grau inferior."
L["TIP_MAGE_TABLE"]      = "Clique com o botão do meio para lançar Ritual do Refresco."
L["TIP_WARLOCK_CONJURE"] = "Clique com o botão direito nas suas macros de Pedra de Vida ou Pedra de Alma para criar uma Pedra de Vida ou Pedra de Alma."
L["TIP_WARLOCK_SOUL"]    = "Clique com o botão do meio para lançar Ritual das Almas."

L["UI_BEST_FOOD"]    = "Melhor Comida Atual"
L["UI_BEST_PET_FOOD"]= "Comida de Ajudante"
L["UI_DISABLED"]     = "Desativado"
L["UI_ENABLED"]      = "Ativado"
L["UI_IGNORE_LIST"]  = "Lista de Ignorados"
L["UI_LEFT_CLICK"]   = "Clique Esquerdo"
L["UI_MIDDLE_CLICK"] = "Clique do Meio"
L["UI_RIGHT_CLICK"]  = "Clique Direito"
L["UI_SHIFT_LEFT"]   = "Shift + Clique Esquerdo"
L["UI_TOGGLE"]       = "Alternar"

L["MODE_ALWAYS"] = "Sempre"
L["MODE_PARTY"]  = "Apenas em grupo"
L["MODE_RAID"]   = "Apenas em raide"

-- Options Panel
L["OPTIONS_DESC"] = "Cria macros que se atualizam automaticamente para seus melhores consumíveis, rastreando buffs para manter você com o melhor desempenho. Possui um Feed-O-Matic tudo-em-um para Caçadores e conjuração inteligente com clique direito para Magos e Bruxos que se adapta ao nível do seu alvo."
L["OPTIONS_BUFF_FOOD"]         = "Priorizar Comida com Buff"
L["OPTIONS_BUFF_FOOD_DESC"]    = "Prioriza comida que concede o buff \"Bem Alimentado\", quando o buff estiver faltando."
L["OPTIONS_SCROLL_HEADER"]     = "Buffs de Pergaminho"
L["OPTIONS_USE_SCROLLS"]       = "Incluir Buffs de Pergaminho"
L["OPTIONS_USE_SCROLLS_DESC"]  = "Usa pergaminhos, quando o buff do pergaminho estiver faltando, como parte da sua macro de Comida."
L["OPTIONS_SCROLL_TYPES"]      = "Incluir Tipos de Pergaminho na Verificação"
L["OPTIONS_SCROLL_AGILITY"]    = "Agilidade"
L["OPTIONS_SCROLL_INTELLECT"]  = "Intelecto"
L["OPTIONS_SCROLL_PROTECTION"] = "Proteção"
L["OPTIONS_SCROLL_SPIRIT"]     = "Espírito"
L["OPTIONS_SCROLL_STAMINA"]    = "Vigor"
L["OPTIONS_SCROLL_STRENGTH"]   = "Força"

L["OPTIONS_PET_HEADER"]        = "Buffs de Comida de Ajudante"
L["OPTIONS_USE_PET_BUFFS"]     = "Usar Buffs de Comida de Ajudante"
L["OPTIONS_USE_PET_BUFFS_DESC"]= "Usa Comida de Ajudante, como parte da sua macro de Comida, quando o buff \"Bem Alimentado\" estiver faltando no seu ajudante."
L["OPTIONS_PET_BUFF_TYPES"]    = "Incluir Tipos de Comida de Ajudante na Verificação"
L["OPTIONS_PET_BUFF_KIBLERS"]  = "Petiscos do Kibler"
L["OPTIONS_PET_BUFF_SPORELING"]= "Lanchinho de Esporino"

L["OPTIONS_NIGHTELF_HEADER"]           = "Elfos Noturnos"
L["OPTIONS_SHADOWMELD_DRINKING"]      = "Beber com Fusão Espiritual"
L["OPTIONS_SHADOWMELD_DRINKING_DESC"] = "Anexa Fusão Espiritual à sua macro de Água para que você entre em furtividade enquanto bebe."

L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMANDS_DESC"]   = "/foodie"
L["OPTIONS_COMMANDS_DETAIL"] = "Abre a interface de opções do Connoisseur."

L["OPTIONS_RESET_HEADER"]         = "Redefinir"
L["OPTIONS_RESET_IGNORE_DESC"]    = "Remover todos os itens da lista de ignorados."
L["OPTIONS_RESET_IGNORE_CONFIRM"] = "Tem certeza de que deseja limpar a lista de ignorados?"
L["OPTIONS_COMMUNITY_HEADER"]     = "Feedback e Suporte"