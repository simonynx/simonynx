//Created by Action Script Viewer - http://www.buraks.com/asv
package {
    import flash.utils.*;

    public class LanguageMgr {

        public static const RunePrefix:Array = ["", "每一击造成的伤害增加", "防御力增加", "生命力增加", "全抗性增加", "攻击力增加", "暴击伤害增加", "击杀怪后魔法值回复", "击杀怪后生命力回复", "技能命中增加", "技能躲闪增加"];
        public static const CHAT_TYPE_FACTION:uint = 2020;
        public static const CHAT_TYPE_TEAM:uint = 2003;
        public static const AchieveMainClassDef:Array = ["成  长", "P V P", "P V E", "装  备", "声  望", "活  动", "特  殊"];
        public static const CHAT_TYPE_STS:uint = 1007;
        public static const starArray:Array = [["生命+58", "魔法+29", "防御+6", "命中+7", "暴击率+0.2%\n躲闪+6", "全抗性+2", "攻击+13"], ["暴击伤害+1%", "生命+86", "魔法+43", "防御+9", "命中+11", "暴击率+0.3%\n躲闪+9", "全抗性+3", "攻击+20"], ["暴击伤害+1.5%", "生命+126", "魔法+63", "防御+13", "命中+16", "暴击率+0.4%\n躲闪+13", "全抗性+5", "攻击+29", "暴击伤害+2.2%", "生命+178", "魔法+89", "防御+18"], ["命中+22", "暴击率+0.5%\n躲闪+18", "全抗性+6", "攻击+40", "暴击伤害+3.1%", "生命+240", "魔法+120\n命中+30", "防御 +24", "暴击率+0.7%\n躲闪+24", "全抗性+9", "攻击+55"], ["暴击伤害+4.2%", "生命+314", "魔法+157\n命中+39", "防御+31", "暴击率+0.9%\n躲闪+31", "全抗性+11", "攻击+71", "暴击伤害+5.5%", "生命+398", "魔法+199\n命中+50", "防御+40"], ["暴击率+1.2%\n躲闪+40", "全抗性+14", "攻击+91", "暴击伤害+7%", "生命+494", "魔法+247\n命中+62", "防御+49", "暴击率+1.5%\n躲闪+49", "全抗性+18", "攻击+112", "暴击伤害+8.7%", "生命+602"], ["魔法+301\n命中+75", "防御+60", "暴击率+1.8%\n躲闪+60", "全抗性+21", "攻击+137", "暴击伤害+10.6%", "生命+720", "魔法+360\n命中+90", "防御+72", "暴击率+2.2%\n躲闪+72", "全抗性+26", "攻击+164", "暴击伤害+12.7%"]];
        public static const DEFAULT_FONT:String = "宋体";
        public static const RaceResultObj:Object = {
            0:"挑战成功，等待具体战报",
            1:"淘汰赛结束后才能开始挑战",
            2:"目标不存在",
            3:"今日挑战次数已满",
            4:"刚刚战斗完,请休息一会再打",
            5:"目标队伍正在挑战中",
            6:"排名相差太远,请重新打开页面刷新"
        };
        public static const EquipHolePrefix:Array = ["", "狂怒", "强固", "贪婪", "年轮", "蛮力", "审判", "真理", "希望", "自由", "避世"];
        public static const EquipHoleType:Array = ["", "攻击", "防御", "命中", "躲闪", "暴击伤害", "暴击率", "生命", "魔法", "契约"];
        public static const CHAT_TYPE_UNITY:uint = 2004;
        public static const AchieveSubClassDef:Array = [["等  级", "任  务", "属  性"], ["战  场", "城  战", "斗  宠"], ["红龙巢穴", "海盗要塞", "亚尔夫海姆", "世界BOSS"], ["强  化", "镶  嵌", "宠  物", "神  兵"], ["职  业", "公  会", "战  场"], ["答  题", "酒  会", "节  日"], ["其  他"]];
        public static const CHAT_TYPE_POST:uint = 77777;
        public static const CHAT_TYPE_FRIEND:uint = 2019;
        public static const CHAT_TYPE_PRIVATE:uint = 2001;
        public static const CHAT_TYPE_NEAR:uint = 2013;
        public static const CHAT_TYPE_STSTEM:uint = 9999;
        public static const CHAT_TYPE_WORLD:uint = 2016;
        public static const CHAT_TYPE_TIPS:uint = 4001;
        public static const CHAT_TYPE_LEO:uint = 2030;

        public static var treasureProps:Array = ["攻击", "生命", "魔法", "眩晕抗性", "虚弱抗性", "昏睡抗性", "魅惑抗性", "定身抗性"];
        public static var JobNameList:Array = ["新手", "战士", "法师", "牧师", "刺客", "猎人"];
        public static var mailTips1:Array = ["系统", "个人"];
        public static var equipParts:Array = ["武  器", "帽  子", "衣  服", "鞋  子"];
        public static var AdditionProperty:Array = ["", "攻击", "防御", "普通命中", "普通躲闪", "暴击伤害", "暴击率", "技能命中", "技能躲闪", "生命", "魔法", "眩晕抗性", "虚弱抗性", "昏睡抗性", "魅惑抗性", "定身抗性", "暴击率减免", "暴击伤害减免", "伤害减免"];
        public static var payWayNameList:Array = ["金币", "点券", "银叶子"];
        public static var replaceArray:Array = ["免费", "无限", "成功率", "每天", "特殊称号", "额外", "远程仓库", "远程药店", "公会捐献", "职业捐献"];
        public static var MarketTypeNameList:Array = ["全部", "强化", "药品", "传送", "神兵", "宠物", "时装", "其它"];
        private static var _dic:Dictionary;
        public static var PersonPanelList:Array = ["武器", "帽子", "衣服", "鞋子", "项链", "戒指", "戒指", "神兵", "徽记", "徽章", "圣契", "护符", "坐骑", "时装"];
        public static var ConvoyColors:Array = ["白色", "绿色", "蓝色", "紫色", "橙色"];
        private static var _reg:RegExp = new RegExp("\\{(\\d+)\\}");
        public static var channelModel:Array = [{
            label:"<font color='#ffffff'>附近</font>",
            name:"附近",
            channel:CHAT_TYPE_NEAR,
            rece:"ALLUSER",
            color:"#ffffff"
        }, {
            label:"<font color='#79a2ff'>队伍</font>",
            name:"队伍",
            channel:CHAT_TYPE_TEAM,
            rece:"ALLUSER",
            color:"#79a2ff"
        }, {
            label:"<font color='#f18dff'>私聊</font>",
            name:"私聊",
            channel:CHAT_TYPE_PRIVATE,
            rece:"私聊对象",
            color:"#f18dff"
        }, {
            label:"<font color='#24d030'>公会</font>",
            name:"公会",
            channel:CHAT_TYPE_UNITY,
            rece:"ALLUSER",
            color:"0x24d030"
        }, {
            label:"<font color='#00deff'>世界</font>",
            name:"世界",
            channel:CHAT_TYPE_WORLD,
            rece:"ALLUSER",
            color:"#00deff"
        }, {
            label:"<font color='#a8ff00'>喇叭</font>",
            name:"喇叭",
            channel:CHAT_TYPE_LEO,
            rece:"ALLUSER",
            color:"#a8ff00"
        }, {
            label:"<font color='#fd7902'>阵营</font>",
            name:"阵营",
            channel:CHAT_TYPE_FACTION,
            rece:"ALLUSER",
            color:"#fd7902"
        }];
        public static var roleTitleArray:Array = ["人物属性", "声 望", "星座守护", "资 料"];
        public static var bagVipBtnTips:Array = ["点击打开远程仓库", "点击打开远程药店", "点击打开公会捐献", "点击打开职业捐献"];

        public function LanguageMgr(){
            _dic = null;
        }
        public static function GetTranslation(_arg1:String, ... _args):String{
            var _local3:int;
            var _local4:String;
            if (_dic == null){
                return (_arg1);
            };
            var _local5:* = (_dic[_arg1]) ? _dic[_arg1] : "";
            var _local6:* = _reg.exec(_local5);
            if (_local6){
                do  {
                    _local3 = int(_local6[1]);
                    _local4 = String(_local6[0]);
                    if ((((_local3 >= 0)) && ((_local3 < _args.length)))){
                        _local5 = _local5.replace(_local4, _args[_local3]);
                    } else {
                        _local5 = _local5.replace(_local4, "{}");
                    };
                    _local6 = _reg.exec(_local5);
                } while (_local6);
            };
            return (_local5);
        }
        public static function setup(_arg1:String):void{
            var _local2:String;
            var _local3:int;
            var _local4:String;
            var _local5:String;
            var _local6:* = String(_arg1).split("\r\n");
            var _local7:int;
            _dic = new Dictionary();
            while (_local7 < _local6.length) {
                _local2 = _local6[_local7];
                if (_local2.indexOf("#") == 0){
                    _local7++;
                } else {
                    _local2 = _local2.replace(/\\r/g, "\r");
                    _local2 = _local2.replace(/\\n/g, "\n");
                    _local3 = _local2.indexOf(":");
                    if (_local3 != -1){
                        _local4 = _local2.substring(0, _local3);
                        _local5 = _local2.substr((_local3 + 1));
                        if (_dic[_local4]){
                            trace((((("language定义重复:" + _local4) + "(") + (_local7 + 1).toString()) + ")"));
                        };
                        _dic[_local4] = _local5;
                    };
                    _local7++;
                };
            };
        }

    }
}//package 
