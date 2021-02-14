-----------------------------------------------------
-- Coded by /hammyster! Command promotion in lua;
-- https://github.com/hammyster
-- Copyright © hammy 2021
-----------------------------------------------------

--[[ Configurações Promotion ]] --

-- [[ Configurações SQL ]]
TABLE_PROMOTION_PLAYER = "MEMB_INFO";
COLUMN_PROMOTION_PLAYER = "promotion";
WHERE_PROMOTION_PLAYER = "memb___id"

-- [[ Configurações do Plugin ]]
PROMOTION_COMMAND = "/promotion";
PROMOTION_ADD_COMMAND = "/addpromotion";

PROMOTION_ITEMS = {
    {Index = 1, IsSet = 1, Section = 7, ItemIndex = 1, Level = 15, Luck = 1, Skill = 0, Option = 7, Exc1 = 1, Exc2 = 1, Exc3 = 1, Exc4 = 1, Exc5 = 1, Exc6 = 1},
    {Index = 1, IsSet = 1, Section = 7, ItemIndex = 1, Level = 15, Luck = 1, Skill = 0, Option = 7, Exc1 = 1, Exc2 = 1, Exc3 = 1, Exc4 = 1, Exc5 = 1, Exc6 = 1},
    {Index = 1, IsSet = 1, Section = 7, ItemIndex = 1, Level = 15, Luck = 1, Skill = 0, Option = 7, Exc1 = 1, Exc2 = 1, Exc3 = 1, Exc4 = 1, Exc5 = 1, Exc6 = 1},
    {Index = 1, IsSet = 1, Section = 7, ItemIndex = 1, Level = 15, Luck = 1, Skill = 0, Option = 7, Exc1 = 1, Exc2 = 1, Exc3 = 1, Exc4 = 1, Exc5 = 1, Exc6 = 1},
    {Index = 0, IsSet = 0, Section = 6, ItemIndex = 0, Level = 15, Luck = 1, Skill = 0, Option = 7, Exc1 = 1, Exc2 = 1, Exc3 = 1, Exc4 = 1, Exc5 = 1, Exc6 = 1},
    {Index = 0, IsSet = 0, Section = 0, ItemIndex = 0, Level = 15, Luck = 1, Skill = 0, Option = 7, Exc1 = 1, Exc2 = 1, Exc3 = 1, Exc4 = 1, Exc5 = 1, Exc6 = 1},
    {Index = 0, IsSet = 0, Section = 12, ItemIndex = 0, Level = 15, Luck = 1, Skill = 0, Option = 7, Exc1 = 1, Exc2 = 1, Exc3 = 1, Exc4 = 1, Exc5 = 1, Exc6 = 1}
}

function DataBase.GetValue(Table, Column, Where, Name)
	local Query = string.format("SELECT %s FROM %s WHERE %s = '%s'", Column, Table, Where, Name)
	ret = DataBaseExec(Query)
	
	if ret == 0
	then
		LogAddC(2,string.format("Não foi possível executar a query: %s", Query))
		DataBaseClear()
		return -1
	end
	
	nRet = DataBaseFetch()
	if nRet == SQL_NO_DATA
	then
		LogAddC(2,string.format("Não foi possível executar a query: %s", Query))
		DataBaseClear()
		return -1
	end
	
	local val = DataBaseGetInt(Column)
	DataBaseClear()
	return val
end

Promotion = {}

function Promotion.GetPromotion(aIndex, Arguments)
    if PROMOTION_SWITCH == 0 then
        return
    end

    if DataBase.GetValue(TABLE_PROMOTION_PLAYER, COLUMN_PROMOTION_PLAYER, WHERE_PROMOTION_PLAYER,
        UserGetAccountID(aIndex)) <= 0 then
        SendMessage(string.format("[Sistema] Você não tem promocões disponíveis para resgatar!"), aIndex, 1)
        return
    end

    if PROMOTION_INVENTORY == 1 then
        for i = 12, MAX_INVENTORY_RANGE do
            if InventoryIsItem(aIndex, i) ~= 0 then
                SendMessage(string.format("[Sistema] Seu inventário precisa estar vazio!"), aIndex, 1)
                return
            end
        end
    end

    if DataBase.GetValue(TABLE_PROMOTION_PLAYER, COLUMN_PROMOTION_PLAYER, WHERE_PROMOTION_PLAYER,
        UserGetAccountID(aIndex)) == 2 then

        for i, key in ipairs(PROMOTION_ITEMS) do
            local exc = 0

            if PROMOTION_ITEMS[i].Exc1 ~= 0 then
                exc = exc + 1
            end
            if PROMOTION_ITEMS[i].Exc2 ~= 0 then
                exc = exc + 2
            end
            if PROMOTION_ITEMS[i].Exc3 ~= 0 then
                exc = exc + 4
            end
            if PROMOTION_ITEMS[i].Exc4 ~= 0 then
                exc = exc + 8
            end
            if PROMOTION_ITEMS[i].Exc5 ~= 0 then
                exc = exc + 16
            end
            if PROMOTION_ITEMS[i].Exc6 ~= 0 then
                exc = exc + 32
            end

            if PROMOTION_ITEMS[i].Index == 0 then
                if PROMOTION_ITEMS[i].IsSet == 1 then
                    for s = 7, 11 do
                        ItemSerialCreate(aIndex, 236, 0, 0, GET_ITEM(s, PROMOTION_ITEMS[i].ItemIndex),
                            PROMOTION_ITEMS[i].Level, 255, PROMOTION_ITEMS[i].Luck, PROMOTION_ITEMS[i].Skill,
                            PROMOTION_ITEMS[i].Option, exc)
                    end
                else
                    ItemSerialCreate(aIndex, 236, 0, 0,
                        GET_ITEM(PROMOTION_ITEMS[i].Section, PROMOTION_ITEMS[i].ItemIndex), PROMOTION_ITEMS[i].Level,
                        255, PROMOTION_ITEMS[i].Luck, PROMOTION_ITEMS[i].Skill, PROMOTION_ITEMS[i].Option, exc)
                end
            end
        end

        DataBase.SetValue(TABLE_PROMOTION_PLAYER, COLUMN_PROMOTION_PLAYER, 1, WHERE_PROMOTION_PLAYER,
            UserGetAccountID(aIndex))
        SendMessageGlobal(string.format(
                              "[Sistema] Pacote resgatado com sucesso, use novamente o comando para resgatar o restante!"), 1)
        return
    end

    if DataBase.GetValue(TABLE_PROMOTION_PLAYER, COLUMN_PROMOTION_PLAYER, WHERE_PROMOTION_PLAYER,
        UserGetAccountID(aIndex)) == 1 then

        for i, key in ipairs(PROMOTION_ITEMS) do
            local exc = 0

            if PROMOTION_ITEMS[i].Exc1 ~= 0 then
                exc = exc + 1
            end
            if PROMOTION_ITEMS[i].Exc2 ~= 0 then
                exc = exc + 2
            end
            if PROMOTION_ITEMS[i].Exc3 ~= 0 then
                exc = exc + 4
            end
            if PROMOTION_ITEMS[i].Exc4 ~= 0 then
                exc = exc + 8
            end
            if PROMOTION_ITEMS[i].Exc5 ~= 0 then
                exc = exc + 16
            end
            if PROMOTION_ITEMS[i].Exc6 ~= 0 then
                exc = exc + 32
            end

            if PROMOTION_ITEMS[i].Index == 0 then
                if PROMOTION_ITEMS[i].IsSet == 1 then
                    for s = 7, 11 do
                        ItemSerialCreate(aIndex, 236, 0, 0, GET_ITEM(s, PROMOTION_ITEMS[i].ItemIndex),
                            PROMOTION_ITEMS[i].Level, 255, PROMOTION_ITEMS[i].Luck, PROMOTION_ITEMS[i].Skill,
                            PROMOTION_ITEMS[i].Option, exc)
                    end
                else
                    ItemSerialCreate(aIndex, 236, 0, 0,
                        GET_ITEM(PROMOTION_ITEMS[i].Section, PROMOTION_ITEMS[i].ItemIndex), PROMOTION_ITEMS[i].Level,
                        255, PROMOTION_ITEMS[i].Luck, PROMOTION_ITEMS[i].Skill, PROMOTION_ITEMS[i].Option, exc)
                end
            end
        end

        DataBase.SetValue(TABLE_PROMOTION_PLAYER, COLUMN_PROMOTION_PLAYER, 0, WHERE_PROMOTION_PLAYER,
            UserGetAccountID(aIndex))
        SendMessageGlobal(string.format("[Sistema] Pacote resgatado com sucesso!"), 1)
    end

end

function Promotion.AddPromotion(aIndex, Arguments)

    if UserGetAuthority(aIndex) == 1 then
        return
    end

    local Name = CommandGetString(Arguments, 1, 0)
    local Value = CommandGetString(Arguments, 2, 0)

    if Value <= "0" or Value > "2" then
        SendMessageGlobal(string.format("[Sistema] Use 1 ou 2 para adicionar promocoes!"), 1)
        return
    end

    if DataBase.GetValue(TABLE_PROMOTION_PLAYER, WHERE_PROMOTION_PLAYER, WHERE_PROMOTION_PLAYER, Name) == -1 then
        SendMessage(string.format("[Sistema] O login [%s] nao existe!"), Name, aIndex, 1)
        return
    end

    LogAdd(string.format("[%s] adicionou o pacote [%s] para o login [%s]", UserGetAccountID(aIndex), Value, Name))
    SendMessageGlobal(string.format("[Sistema] Você adicionou uma promoção para o login [%s]", Name), 1)
    DataBase.SetValue(TABLE_PROMOTION_PLAYER, COLUMN_PROMOTION_PLAYER, Value, WHERE_PROMOTION_PLAYER, Name)
end

Commands.Register(PROMOTION_COMMAND, Promotion.GetPromotion)
Commands.Register(PROMOTION_ADD_COMMAND, Promotion.AddPromotion)

-- [[ Promotion NPC ]]

local PROMOTION_NPC_CREATE = {}

function PromotionTalk(Npc, Player)
    if PROMOTION_NPC_SWITCH == 0 then
        return 0
    end

    for i in pairs(PROMOTION_NPC_CREATE) do
        if PROMOTION_NPC_CREATE[i].NpcIndex == Npc then
            Promotion.Npc(Npc, Player)
            return 1
        end
    end

    return 0
end

function Promotion.MonsterReload()
    local MRESET_NPC_CREATE = {}

    for i in ipairs(PROMOTION_NPC) do
        Promotion.CreateNpc(PROMOTION_NPC[i].Class, PROMOTION_NPC[i].Map, PROMOTION_NPC[i].CoordX,
            PROMOTION_NPC[i].CoordY, PROMOTION_NPC[i].Dir)
    end
end

function Promotion.Init()
    if PROMOTION_NPC_SWITCH == 0 then
        return
    end

    for i, key in ipairs(PROMOTION_NPC_CREATE) do
        if UserGetConnected(PROMOTION_NPC_CREATE[key].NpcIndex) >= 2 then
            gObjDel(PROMOTION_NPC_CREATE[key].NpcIndex)
        end
    end

    local PROMOTION_NPC_CREATE = {}

    for i in ipairs(PROMOTION_NPC) do
        Promotion.CreateNpc(PROMOTION_NPC[i].Class, PROMOTION_NPC[i].Map, PROMOTION_NPC[i].CoordX,
            PROMOTION_NPC[i].CoordY, PROMOTION_NPC[i].Dir)
    end
end

function Promotion.CreateNpc(class, map, x, y, dir)
    index = AddMonster(map)

    if index == -1 then
        LogAdd(string.format("[Promotion NPC] Problema ao criar o Npc :%d", class))
        return
    end

    SetMapMonster(index, map, x, y)

    UserSetDir(index, dir)

    SetMonster(index, class)

    PROMOTION_NPC_CREATE[index] = {
        NpcIndex = index
    }
end

function Promotion.Npc(Npc, Player)
    if PROMOTION_NPC_SWITCH == 0 then
        return
    end

    if DataBase.GetValue(TABLE_PROMOTION_PLAYER, COLUMN_PROMOTION_PLAYER, WHERE_PROMOTION_PLAYER, UserGetName(Player)) <=
        0 then
        ChatTargetSend(Npc, "[Sistema] Você não tem pacotes disponiveis para resgatar!", Player)
        return
    end

    if PROMOTION_INVENTORY == 1 then
        for i = 12, MAX_INVENTORY_RANGE do
            if InventoryIsItem(Player, i) ~= 0 then
                ChatTargetSend(Npc, "[Sistema] Seu inventario precisa estar vazio!", Player)
                return
            end
        end
    end

    if DataBase.GetValue(TABLE_PROMOTION_PLAYER, COLUMN_PROMOTION_PLAYER, WHERE_PROMOTION_PLAYER,
        UserGetAccountID(Player)) == 2 then

        for i, key in ipairs(PROMOTION_ITEMS) do
            local exc = 0

            if PROMOTION_ITEMS[i].Exc1 ~= 0 then
                exc = exc + 1
            end
            if PROMOTION_ITEMS[i].Exc2 ~= 0 then
                exc = exc + 2
            end
            if PROMOTION_ITEMS[i].Exc3 ~= 0 then
                exc = exc + 4
            end
            if PROMOTION_ITEMS[i].Exc4 ~= 0 then
                exc = exc + 8
            end
            if PROMOTION_ITEMS[i].Exc5 ~= 0 then
                exc = exc + 16
            end
            if PROMOTION_ITEMS[i].Exc6 ~= 0 then
                exc = exc + 32
            end

            if PROMOTION_ITEMS[i].Index == 0 then
                if PROMOTION_ITEMS[i].IsSet == 1 then
                    for s = 7, 11 do
                        ItemSerialCreate(Player, 236, 0, 0, GET_ITEM(s, PROMOTION_ITEMS[i].ItemIndex),
                            PROMOTION_ITEMS[i].Level, 255, PROMOTION_ITEMS[i].Luck, PROMOTION_ITEMS[i].Skill,
                            PROMOTION_ITEMS[i].Option, exc)
                    end
                else
                    ItemSerialCreate(Player, 236, 0, 0,
                        GET_ITEM(PROMOTION_ITEMS[i].Section, PROMOTION_ITEMS[i].ItemIndex), PROMOTION_ITEMS[i].Level,
                        255, PROMOTION_ITEMS[i].Luck, PROMOTION_ITEMS[i].Skill, PROMOTION_ITEMS[i].Option, exc)
                end
            end
        end

        DataBase.SetValue(TABLE_PROMOTION_PLAYER, COLUMN_PROMOTION_PLAYER, 1, WHERE_PROMOTION_PLAYER,
            UserGetAccountID(Player))
        ChatTargetSend(Npc, "[Sistema] Pacote resgatado com sucesso, clique no NPC novamente!", Player)
        return
    end

    if DataBase.GetValue(TABLE_PROMOTION_PLAYER, COLUMN_PROMOTION_PLAYER, WHERE_PROMOTION_PLAYER,
        UserGetAccountID(Player)) == 1 then

        for i, key in ipairs(PROMOTION_ITEMS) do
            local exc = 0

            if PROMOTION_ITEMS[i].Exc1 ~= 0 then
                exc = exc + 1
            end
            if PROMOTION_ITEMS[i].Exc2 ~= 0 then
                exc = exc + 2
            end
            if PROMOTION_ITEMS[i].Exc3 ~= 0 then
                exc = exc + 4
            end
            if PROMOTION_ITEMS[i].Exc4 ~= 0 then
                exc = exc + 8
            end
            if PROMOTION_ITEMS[i].Exc5 ~= 0 then
                exc = exc + 16
            end
            if PROMOTION_ITEMS[i].Exc6 ~= 0 then
                exc = exc + 32
            end

            if PROMOTION_ITEMS[i].Index == 1 then
                if PROMOTION_ITEMS[i].IsSet == 1 then
                    for s = 7, 11 do
                        ItemSerialCreate(Player, 236, 0, 0, GET_ITEM(s, PROMOTION_ITEMS[i].ItemIndex),
                            PROMOTION_ITEMS[i].Level, 255, PROMOTION_ITEMS[i].Luck, PROMOTION_ITEMS[i].Skill,
                            PROMOTION_ITEMS[i].Option, exc)
                    end
                else
                    ItemSerialCreate(Player, 236, 0, 0,
                        GET_ITEM(PROMOTION_ITEMS[i].Section, PROMOTION_ITEMS[i].ItemIndex), PROMOTION_ITEMS[i].Level,
                        255, PROMOTION_ITEMS[i].Luck, PROMOTION_ITEMS[i].Skill, PROMOTION_ITEMS[i].Option, exc)
                end
            end
        end

        DataBase.SetValue(TABLE_PROMOTION_PLAYER, COLUMN_PROMOTION_PLAYER, 0, WHERE_PROMOTION_PLAYER,
            UserGetAccountID(Player))
        ChatTargetSend(Npc, "[Sistema] Pacote resgatado com sucesso!", Player)
    end
end

Promotion.Init()
GameServerFunctions.NpcTalk(PromotionTalk)
GameServerFunctions.MonsterReload(Promotion.MonsterReload)

return Promotion

-----------------------------------------------------
-- Coded by /hammyster! Command promotion in lua;
-- https://github.com/hammyster
-- Copyright © hammy 2021
-----------------------------------------------------