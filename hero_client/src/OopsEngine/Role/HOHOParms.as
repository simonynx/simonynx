//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Role {
    import flash.utils.*;

    public class HOHOParms {

        public static var UNIT_FIELD_RESISTANCE_VERTIGO = (OBJECT_END + 69);
        public static var UNIT_FIELD_HEALTH_BASE = (OBJECT_END + 14);
        public static var PLAYER_REPUTE1 = (UNIT_END + 32);
        public static var PLAYER_REPUTE2 = (UNIT_END + 33);
        public static var UNIT_FIELD_RESISTANCE_ASTHENIA = (OBJECT_END + 72);
        public static var UNIT_FIELD_RESISTANCE_SLEEP = (OBJECT_END + 75);
        public static var PLAYER_REPUTE3 = (UNIT_END + 34);
        public static var UNIT_FIELD_AURASTATE = (OBJECT_END + 29);
        public static var PLAYER_CURRENT_PETID = (UNIT_END + 12);
        public static var PLAYER_MOUNT_DISPLAYID = (UNIT_END + 27);
        public static var UNIT_FIELD_RESISTANCE_CHARM = (OBJECT_END + 78);
        public static var PLAYER_REPUTE4 = (UNIT_END + 35);
        public static var PLAYER_REPUTE5 = (UNIT_END + 36);
        public static var UNIT_FIELD_MANA_MAX = (OBJECT_END + 19);
        public static var GameRoleParmTypes:Dictionary;
        public static var PLAYER_RARENA_FACTION_ID = (UNIT_END + 46);
        public static var PLAYER_RUNSPEED = (UNIT_END + 26);
        public static var GameRoleParms:Dictionary;
        public static var UNIT_FIELD_PET_BATTLE_FLAGS = (OBJECT_END + 22);
        public static var PLAYER_WEAPON = (UNIT_END + 41);
        public static var UNIT_FIELD_CURRENT_MANA = (OBJECT_END + 13);
        public static var PLAYER_TREASURE_ID = (UNIT_END + 43);
        public static var PLAYER_SOCIAL_ABILITY = (UNIT_END + 39);
        public static var UNIT_FIELD_FIGHTSTATE = (OBJECT_END + 35);
        public static var UNIT_FIELD_DISPLAYID = (OBJECT_END + 33);
        public static var PLAYER_VIP_ENDTIME = (UNIT_END + 45);
        public static var PLAYER_END:Number = 107+47;
        public static var PLAYER_BATTLE_REPUTE = (UNIT_END + 37);
        public static var UNIT_NPC_FLAGS = (OBJECT_END + 39);
        public static var PLAYER_GUILD_OFFER = (UNIT_END + 40);
        public static var PLAYER_CLASS = (UNIT_END + 3);
        public static var UNIT_FIELD_RESISTANCE_FREEZE = (OBJECT_END + 65);
        public static var OBJECT_FIELD_TYPE = 1;
        public static var PLAYER_CURTEAMID = (UNIT_END + 18);
        public static var UNIT_FIELD_LEVEL = (OBJECT_END + 26);
        public static var UNIT_FIELD_BASEATTACKTIME = (OBJECT_END + 30);
        public static var UNIT_FIELD_FLAGS = (OBJECT_END + 28);
        public static var UNIT_END:Number = (OBJECT_END + 104);
        public static var UNIT_FIELD_FACTIONTEMPLATE = (OBJECT_END + 27);
        public static var PLAYER_VIP = (UNIT_END + 44);
        public static var PLAYER_PK_VALUE = (UNIT_END + 28);
        public static var OBJECT_FIELD_ENTRY = 2;
        public static var UNIT_FIELD_AVATAR_DISPLAYID = (OBJECT_END + 34);
        public static var OBJECT_END:Number = 3;
        public static var UNIT_FIELD_HEALTH_MAX = (OBJECT_END + 16);
        public static var UNIT_FIELD_MANA_MODS = (OBJECT_END + 18);
        public static var PLAYER_CLOTHES = (UNIT_END + 42);
        public static var UNIT_DYNAMIC_FLAGS = (OBJECT_END + 37);
        public static var OBJECT_FIELD_GUID = 0;
        public static var PLAYER_CHOSEN_TITLE = (UNIT_END + 20);
        public static var UNIT_FIELD_HEALTH_MODS = (OBJECT_END + 15);
        public static var PLAYER_GUILDID = (UNIT_END + 21);
        public static var PLAYER_GENDER = (UNIT_END + 2);
        public static var UNIT_FIELD_CURRENT_HEALTH = (OBJECT_END + 12);
        public static var UNIT_FIELD_MANA_BASE = (OBJECT_END + 17);
        public static var PLAYER_TEACHING = (UNIT_END + 38);
        public static var PLAYER_ISTEAMLEADER = (UNIT_END + 19);
        public static var UNIT_FIELD_RANGEDATTACKTIME = (OBJECT_END + 31);
        public static var UNIT_FIELD_COMBATREACH = (OBJECT_END + 32);

        public static function InitParmMap():void{
            GameRoleParms = new Dictionary();
            GameRoleParmTypes = new Dictionary();
            var _local1:uint;
            while (_local1 < PLAYER_END) {
                GameRoleParms[_local1] = "";
                GameRoleParmTypes[_local1] = "i";
                _local1++;
            };
            GameRoleParms[OBJECT_FIELD_ENTRY] = "MonsterTypeID";
            GameRoleParms[UNIT_FIELD_CURRENT_HEALTH] = "HP";
            GameRoleParms[UNIT_FIELD_HEALTH_MAX] = "MaxHp";
            GameRoleParms[UNIT_FIELD_CURRENT_MANA] = "MP";
            GameRoleParms[UNIT_FIELD_MANA_MAX] = "MaxMp";
            GameRoleParms[PLAYER_CLASS] = "CurrentJobID";
            GameRoleParms[PLAYER_GENDER] = "Sex";
            GameRoleParms[UNIT_FIELD_LEVEL] = "Level";
            GameRoleParms[UNIT_NPC_FLAGS] = "NpcFlags";
            GameRoleParms[PLAYER_CURTEAMID] = "idTeam";
            GameRoleParms[PLAYER_ISTEAMLEADER] = "isTeamLeader";
            GameRoleParms[UNIT_FIELD_DISPLAYID] = "Face";
            GameRoleParms[UNIT_FIELD_AVATAR_DISPLAYID] = "PersonSkinID";
            GameRoleParms[PLAYER_PK_VALUE] = "PkTime";
            GameRoleParms[UNIT_FIELD_RESISTANCE_VERTIGO] = "VertigoResistance";
            GameRoleParms[UNIT_FIELD_RESISTANCE_ASTHENIA] = "WeakResistance";
            GameRoleParms[UNIT_FIELD_RESISTANCE_SLEEP] = "SleepResistance";
            GameRoleParms[UNIT_FIELD_RESISTANCE_CHARM] = "CharmResistance";
            GameRoleParms[UNIT_FIELD_RESISTANCE_FREEZE] = "FixedBodyResistance";
            GameRoleParms[UNIT_FIELD_FIGHTSTATE] = "FightState";
            GameRoleParms[PLAYER_RUNSPEED] = "Speed";
            GameRoleParms[PLAYER_MOUNT_DISPLAYID] = "MountSkinID";
            GameRoleParms[UNIT_DYNAMIC_FLAGS] = "DynamicFlag";
            GameRoleParms[UNIT_FIELD_PET_BATTLE_FLAGS] = "PetBattleFlag";
            GameRoleParms[PLAYER_GUILDID] = "unityId";
            GameRoleParms[PLAYER_REPUTE1] = "PlayerRepute1";
            GameRoleParms[PLAYER_REPUTE2] = "PlayerRepute2";
            GameRoleParms[PLAYER_REPUTE3] = "PlayerRepute3";
            GameRoleParms[PLAYER_REPUTE4] = "PlayerRepute4";
            GameRoleParms[PLAYER_REPUTE5] = "PlayerRepute5";
            GameRoleParms[PLAYER_BATTLE_REPUTE] = "PlayerBattleRepute";
            GameRoleParms[PLAYER_TEACHING] = "PlayerTeaching";
            GameRoleParms[PLAYER_SOCIAL_ABILITY] = "PlayerSocity";
            GameRoleParms[PLAYER_GUILD_OFFER] = "PlayerGuildOffer";
            GameRoleParms[PLAYER_CURRENT_PETID] = "UsingPetId";
            GameRoleParms[PLAYER_WEAPON] = "WeaponSkinID";
            GameRoleParms[PLAYER_TREASURE_ID] = "TreasureID";
            GameRoleParms[PLAYER_VIP] = "VIP";
            GameRoleParms[PLAYER_VIP_ENDTIME] = "VIPEND";
            GameRoleParms[PLAYER_CHOSEN_TITLE] = "CurrentTitleId";
            GameRoleParms[PLAYER_RARENA_FACTION_ID] = "ArenaTeamId";
            GameRoleParms[UNIT_FIELD_FACTIONTEMPLATE] = "ArenaTeamId";
        }

    }
}//package OopsEngine.Role 
