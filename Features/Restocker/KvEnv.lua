---@class KvLibEnvModule
---@field isClassic boolean
---@field isTBC boolean
---@field haveTBC boolean
---@field isWotLK boolean
---@field haveWotLK boolean
---@field isCata boolean
---@field haveCata boolean
local envModule = { }

---@class CrsKvModuleManager
---@field envModule KvLibEnvModule
CrsKvModuleManager = {
  envModule = envModule,
}

function envModule:DetectVersions()
  self.isCata = WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC
  self.haveCata = self.isCata

  self.isWotLK = WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC
  self.haveWotLK = self.isWotLK or self.isCata

  self.isTBC = WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC
  self.haveTBC = self.isWotLK or self.isTBC or self.isCata

  self.isClassic = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC
end
