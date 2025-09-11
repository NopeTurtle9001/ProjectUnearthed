-- ReplicatedStorage/Modules/DataSchemas.lua
export type SkillDef = {
    Id: string,
    Name: string,
    Cooldown: number,
    ExecuteServer: (context: any) -> (),
    ExecuteClient: (context: any) -> (),
    Description: string?,
    Icon: string?,
}

export type CharacterDef = {
    Id: string,
    DisplayName: string,
    BaseStats: {
        Health: number,
        Regen: number,
        Damage: number,
        MoveSpeed: number,
        Armor: number,
        Jump: number,
    },
    Skills: {
        Primary: string,
        Secondary: string,
        Utility: string,
        Special: string,
        Variants: { [string]: string }?,
    },
    Skins: { string }, -- skin ids
    Assets: {
        Model: string?,
        Animations: { [string]: string }?,
        Sounds: { [string]: string }?,
        UI: { [string]: string }?,
    },
}

export type ItemDef = {
    Id: string,
    Tier: "Common" | "Uncommon" | "Legendary" | "Boss" | "Lunar" | "Void",
    Stacks: boolean,
    OnPickup: (player: Player, svc: any) -> (),
    OnStatCalc: (player: Player, stacks: number, stats: any) -> (),
}

export type ArtifactDef = {
    Id: string,
    Name: string,
    Description: string,
    ApplyRunModifiers: (run: any) -> (),
}

return {}