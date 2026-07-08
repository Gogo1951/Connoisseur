local addonName, ns = ...
local L = LibStub("AceLocale-3.0"):NewLocale("Connoisseur", "ptBR")
if not L then return end

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

L["MSG_BUG_REPORT"] = "Parece que você encontrou um bug! %s (%s) não pode ser usado em %s > %s (%s). Por favor, reporte isso para que possamos consertar. Obrigado! https://discord.gg/eh8hKq992Q"
L["MSG_NO_ITEM"] = "Nenhum %s adequado encontrado em suas bolsas."
L["MSG_MACRO_SLOTS_FULL"] = "Algumas macros do Connoisseur não puderam ser criadas porque seus espaços para macros estão cheios. Libere um espaço excluindo macros que você não usa mais ou desative as macros do Connoisseur de que você não precisa em Opções > AddOns > Connoisseur."

L["CHAT_LOADED"] = "Versão %s. As configurações (incluindo a opção de desativar esta mensagem) podem ser encontradas em Opções > AddOns > Connoisseur. Gostando do addon? Conte para um amigo! (="

--------------------------------------------------------------------------------
-- ConnTip Messages
--------------------------------------------------------------------------------

-- Printed in chat by macro bodies via /run ConnTip("key"). See Features/Macro-Builder-General.lua.

L["TIP_PET_NO_FOOD"] = "Atualmente você não tem nenhuma comida útil para o seu ajudante."
L["TIP_PET_NO_SKILLS"] = "Atualmente você não sabe Alimentar Ajudante, Curar Ajudante ou Reviver Ajudante."
L["TIP_PET_NO_MEND"] = "Atualmente você não sabe Curar Ajudante."

-- %s is the localized spell name, resolved at print time.
L["TIP_DONT_KNOW_SPELL"] = "Atualmente você não sabe %s."

--------------------------------------------------------------------------------
-- Minimap Tooltip
--------------------------------------------------------------------------------

-- Feature toggles shown in the minimap tooltip, each with a description line.
L["MENU_BUFF_FOOD"] = "Priorizar Comida com Buff"
L["MENU_BUFF_FOOD_DESCRIPTION"] = "Prioriza comida que concede o buff \"Bem Alimentado\", quando o buff estiver faltando."
L["MENU_SCROLL_BUFFS"] = "Buffs de Pergaminho"
L["MENU_SCROLL_BUFFS_DESCRIPTION"] = "Transforma sua macro de Comida em um aplicador de pergaminhos quando faltarem buffs de pergaminhos."

-- Section titles and ignore-list actions in the minimap tooltip.
L["UI_BEST_FOOD"] = "Comida Atual"
L["UI_BEST_PET_FOOD"] = "Comida de Ajudante"
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
L["PREFIX_WARLOCK"] = "Atenção Bruxos"

L["TIP_DOWNRANK"] = "Selecionar um jogador de nível mais baixo fará com que a macro conjure itens apropriados para o nível dele."
L["TIP_HUNTER_FEED_PET"] = "Alimentar Ajudante é um botão tudo-em-um! Clique para Chamar, Alimentar ou Reviver automaticamente seu ajudante. Clique com o botão direito ou aguarde o combate para lançar Curar Ajudante. Segure Shift para forçar Reviver, ou Ctrl para Dispensar."
L["TIP_MAGE_CONJURE"] = "Clique com o botão direito nas suas macros de Comida ou Água para Criar Comida ou Água."
L["TIP_MAGE_GEM"] = "Clique com o botão direito na sua macro de Gema de Mana para conjurar uma nova gema. Clique com o botão direito novamente para conjurar uma reserva de grau inferior."
L["TIP_MAGE_TABLE"] = "Clique com o botão do meio para lançar Ritual do Refresco."
L["TIP_WARLOCK_CONJURE"] = "Clique com o botão direito nas suas macros de Pedra de Vida ou Pedra de Alma para criar uma Pedra de Vida ou Pedra de Alma. Clique com o botão direito na sua macro de Pedra de Vida novamente para conjurar uma reserva de grau inferior."
L["TIP_WARLOCK_SOUL"] = "Clique com o botão do meio para lançar Ritual das Almas."

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
L["MODE_PARTY"] = "Apenas em grupo"
L["MODE_RAID"] = "Apenas em raide"

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] = "Macros de atualização automática para sua melhor comida, comida com buff, água, pergaminhos, poções de cura e mana, pedras de vida, pedras de alma, gemas de mana e bandagens. Conjuração com um clique para Magos e Bruxos, Alimentar Ajudante inteligente para Caçadores. Nutrição ideal, desempenho máximo."

-- Welcome Message
L["OPTIONS_WELCOME_MESSAGE"] = "Ativar Mensagem de Boas-vindas"
L["OPTIONS_WELCOME_MESSAGE_DESCRIPTION"] = "Imprime uma mensagem de boas-vindas no chat ao entrar."

-- Minimap Button
L["OPTIONS_MINIMAP_BUTTON"] = "Ativar Botão do Minimapa"
L["OPTIONS_MINIMAP_BUTTON_DESCRIPTION"] = "Mostra o botão do minimapa."

-- Potions & Healthstones
L["OPTIONS_POTIONS_HEADER"] = "Poções e Pedras de Vida"
L["OPTIONS_POTIONS_DESCRIPTION"] = "As macros não podem ser alteradas durante o combate (isso é uma restrição da Blizzard), então cada macro de Poção e Pedra de Vida é pré-construída com seu melhor item mais até duas alternativas. Em lutas mais longas, o ícone e a dica de interface podem ficar desatualizados e mostrar o item errado, mas clicar na macro sempre usará o melhor item que você realmente tem nas suas bolsas."
L["OPTIONS_COMBINE_HEALTHSTONES"] = "Combinar Pedras de Vida na Macro de Poção de Cura"
L["OPTIONS_COMBINE_HEALTHSTONES_DESCRIPTION"] = "Adiciona sua melhor Pedra de Vida ao final da macro de Poção de Cura, para que um clique use uma poção e uma Pedra de Vida."

-- Buff Food
L["OPTIONS_BUFF_FOOD_HEADER"] = "Comida com Buff"
L["OPTIONS_BUFF_FOOD"] = "Priorizar Comida com Buff"
L["OPTIONS_BUFF_FOOD_DESCRIPTION"] = "Prioriza comida que concede o buff \"Bem Alimentado\", quando o buff estiver faltando."
L["OPTIONS_BUFF_FOOD_DETAIL"] = "Dica pro: Ter a si mesmo como alvo sempre faz a macro de Comida pular comida com buff e pergaminhos."

-- Scroll Buffs
L["OPTIONS_SCROLL_HEADER"] = "Buffs de Pergaminho"
L["OPTIONS_USE_SCROLLS"] = "Incluir Buffs de Pergaminho"
L["OPTIONS_USE_SCROLLS_DESCRIPTION"] = "Transforma sua macro de Comida em um aplicador de pergaminhos dedicado sempre que faltarem buffs de pergaminhos. Toque uma vez para aplicar os pergaminhos; toque novamente para comer. Os pergaminhos não ativam o GCD, têm você como alvo e a macro volta para a comida no momento em que você seleciona outro jogador amigável."
L["OPTIONS_SCROLL_TYPES"] = "Incluir Tipos de Pergaminho na Verificação"
L["OPTIONS_SCROLL_AGILITY"] = "Agilidade"
L["OPTIONS_SCROLL_INTELLECT"] = "Intelecto"
L["OPTIONS_SCROLL_PROTECTION"] = "Proteção"
L["OPTIONS_SCROLL_SPIRIT"] = "Espírito"
L["OPTIONS_SCROLL_STAMINA"] = "Vigor"
L["OPTIONS_SCROLL_STRENGTH"] = "Força"

-- Explosives
L["OPTIONS_EXPLOSIVES_HEADER"] = "Explosivos"
L["OPTIONS_EXPLOSIVES_DESCRIPTION"] = "A opção @player pula o retículo de mira e detona o explosivo aos seus pés — ideal quando o alvo está no corpo a corpo."
L["EXPLOSIVES_MODE_ATPLAYER"] = "Clique Esquerdo @Player, Clique Direito Arremessar"
L["EXPLOSIVES_MODE_TOSS"] = "Clique Esquerdo Arremessar, Clique Direito @Player"

-- Pet Food Buffs
L["OPTIONS_PET_HEADER"] = "Buffs de Comida de Ajudante"
L["OPTIONS_USE_PET_BUFFS"] = "Usar Buffs de Comida de Ajudante"
L["OPTIONS_USE_PET_BUFFS_DESCRIPTION"] = "Usa Comida de Ajudante, como parte da sua macro de Comida, quando o buff \"Bem Alimentado\" estiver faltando no seu ajudante."
L["OPTIONS_PET_BUFF_TYPES"] = "Incluir Tipos de Comida de Ajudante na Verificação"
L["OPTIONS_PET_BUFF_KIBLERS"] = "Petiscos do Kibler"
L["OPTIONS_PET_BUFF_SPORELING"] = "Lanchinho de Esporino"

-- Druids
L["OPTIONS_DRUIDS_HEADER"] = "Druidas"
L["OPTIONS_DRUID_MACRO_HELPER"] = "Ativar Integração do DruidMacroHelper"
L["OPTIONS_DRUID_MACRO_HELPER_DESCRIPTION"] = "Cria macros de mudança de forma para Poções de Cura, Poções de Mana e Pedras de Vida usando o DruidMacroHelper (/dmh)."
L["OPTIONS_DRUID_RETURN_FORM"] = "Após Consumível, Mudar para"
L["DRUID_FORM_BEAR"] = "Urso"
L["DRUID_FORM_CAT"] = "Gato"

-- Night Elves
L["OPTIONS_NIGHTELF_HEADER"] = "Elfos Noturnos"
L["OPTIONS_SHADOWMELD_DRINKING"] = "Beber com Fusão Espiritual"
L["OPTIONS_SHADOWMELD_DRINKING_DESCRIPTION"] = "Anexa Fusão Espiritual à sua macro de Água para que você entre em furtividade enquanto bebe."

-- /Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMANDS_DESCRIPTION"] = "/foodie"
L["OPTIONS_COMMANDS_DETAIL"] = "Abre a interface de opções do Connoisseur."

-- Enable Macros
L["OPTIONS_ENABLE_MACROS_HEADER"] = "Ativar Macros"
L["OPTIONS_ENABLE_MACROS_DESCRIPTION"] = "Alterne quais macros o Connoisseur cria e mantém. Desativar uma macro também a removerá."

-- Ignore List
L["OPTIONS_RESET_IGNORE_DESCRIPTION"] = "Remover todos os itens da lista de ignorados."
L["OPTIONS_RESET_IGNORE_CONFIRM"] = "Tem certeza de que deseja limpar a lista de ignorados?"

-- Profiles (Reset All Profiles -- the stock AceDBOptions widgets are not localized here)
L["OPTIONS_RESET_ALL_PROFILES"] = "Redefinir Todos os Perfis"
L["OPTIONS_RESET_ALL_PROFILES_DESCRIPTION"] = "Redefine todos os perfis desta conta para as configurações padrão."
L["OPTIONS_RESET_ALL_PROFILES_CONFIRM"] = "Isto redefinirá TODOS os perfis da sua conta para as configurações padrão — cada personagem. Não há como desfazer. Continuar?"

-- Feedback & Support
L["OPTIONS_COMMUNITY_HEADER"] = "Feedback e Suporte"
