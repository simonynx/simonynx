//Created by Action Script Viewer - http://www.buraks.com/asv
package Manager {
    import flash.events.*;
    import OopsEngine.Role.*;
    import OopsEngine.Scene.StrategyElement.*;
    import flash.net.*;

    public class SharedManager extends EventDispatcher {

        private static var _instance:SharedManager;

        private var sharedObject:SharedObject;
        private var _showBI:Boolean = true;
        private var _rednameTipsDay:int = 0;
        private var _onlineTimeToday:int = 0;
        private var _showTI:Boolean = true;
        private var _soundVolumn:Number;
        private var _radioEquipCompose:Boolean = false;
        private var _showPlayerTitle:Boolean = true;
        private var _showSelfBlood:Boolean = false;
        private var _petHpPercent:String = "80";
        private var _mpPercent:String = "80";
        private var _hpPercent:String = "80";
        private var _showGuildName:Boolean = true;
        private var _enterPKSceneTips:Boolean;
        private var _petMpPercent:String = "80";
        private var _allowPK:Boolean = true;
        private var _showSkillEffect:Boolean = true;
        private var _showOtherBlood:Boolean = false;
        private var my_so:SharedObject;
        private var _petBatchRebuildAlert:int = 0;
        private var _allowSound:Boolean = true;
        private var _musicVolumn:Number;
        private var _treasureBatchRebuildAlert:int = 0;
        private var _allowMusic:Boolean = true;

        public static function getInstance():SharedManager{
            if (!_instance){
                _instance = new (SharedManager)();
            };
            return (_instance);
        }

        public function get showSkillEffect():Boolean{
            return (_showSkillEffect);
        }
        public function get rednameTipsDay():int{
            return (_rednameTipsDay);
        }
        public function set showSkillEffect(_arg1:Boolean):void{
            _showSkillEffect = _arg1;
        }
        public function get showBI():Boolean{
            return (_showBI);
        }
        public function get myso():SharedObject{
            if (my_so){
                return (my_so);
            };
            return (null);
        }
        public function set rednameTipsDay(_arg1:int):void{
            _rednameTipsDay = _arg1;
            if (my_so){
                my_so.data.rednameTipsDay = _arg1;
            };
        }
        public function get soundVolumn():Number{
            return (_soundVolumn);
        }
        public function get allowPK():Boolean{
            return (_allowPK);
        }
        public function get hpPercent():String{
            return (_hpPercent);
        }
        public function set DbneverTipsDay_AutoGift(_arg1:int):void{
            if (my_so){
                my_so.data.DbneverTipsDay_AutoGift = _arg1;
            };
        }
        public function set showBI(_arg1:Boolean):void{
            _showBI = _arg1;
        }
        public function set showSelfBlood(_arg1:Boolean):void{
            _showSelfBlood = _arg1;
            GameCommonData.Player.setBloodViewVisble(_arg1);
        }
        public function set allowPK(_arg1:Boolean):void{
            _allowPK = _arg1;
        }
        public function set soundVolumn(_arg1:Number):void{
            var val:* = _arg1;
            _soundVolumn = val;
            try {
                my_so.data.soundVolumn = val;
            } catch(e:Error) {
                trace("");
            };
        }
        public function get mpPercent():String{
            return (_mpPercent);
        }
        public function get showTI():Boolean{
            return (_showTI);
        }
        public function get DbneverTipsDay_AutoGift():int{
            if (my_so){
                return (my_so.data.DbneverTipsDay_AutoGift);
            };
            return (0);
        }
        public function get DbneverTipsDay_Gift():int{
            if (my_so){
                return (my_so.data.DbneverTipsDay_Gift);
            };
            return (0);
        }
        public function set hpPercent(_arg1:String):void{
            var value:* = _arg1;
            _hpPercent = value;
            try {
                my_so.data.hpPercent = _hpPercent;
            } catch(e:Error) {
            };
        }
        public function set showGuildName(_arg1:Boolean):void{
            var _local2:String;
            var _local3:GameElementAnimal;
            _showGuildName = _arg1;
            if (_arg1){
                GameCommonData.Player.showGuildName();
            } else {
                GameCommonData.Player.hideGuildName();
            };
            for (_local2 in GameCommonData.SameSecnePlayerList) {
                _local3 = GameCommonData.SameSecnePlayerList[_local2];
                if (_local3.Role.Type == GameRole.TYPE_PLAYER){
                    if (_arg1){
                        _local3.showGuildName();
                    } else {
                        _local3.hideGuildName();
                    };
                };
            };
        }
        public function SetSkillAutoInfo(_arg1:Boolean, _arg2:String):void{
            var _local3:int;
            if (_arg1){
                _local3 = 1;
            };
            SkillSO.data.autoSkill[_arg2] = _local3;
            SkillSO.flush();
        }
        private function get SkillSO():SharedObject{
            if (!sharedObject){
                sharedObject = SharedObject.getLocal(String(GameCommonData.Player.Role.Id));
                if (sharedObject.data.autoSkill == undefined){
                    sharedObject.data.autoSkill = new Object();
                };
            };
            return (sharedObject);
        }
        public function set musicVolumn(_arg1:Number):void{
            var val:* = _arg1;
            _musicVolumn = val;
            try {
                my_so.data.musicVolumn = val;
            } catch(e:Error) {
                trace("");
            };
        }
        public function set showOtherBlood(_arg1:Boolean):void{
            var _local2:String;
            var _local3:GameElementAnimal;
            if (_arg1 != _showOtherBlood){
                _showOtherBlood = _arg1;
                for (_local2 in GameCommonData.SameSecnePlayerList) {
                    _local3 = GameCommonData.SameSecnePlayerList[_local2];
                    _local3.setBloodViewVisble(_arg1);
                };
            };
        }
        public function get enterPKSceneTips():Boolean{
            return (_enterPKSceneTips);
        }
        public function get onlineTimeToday():int{
            return (_onlineTimeToday);
        }
        private function isFirstLogin():Boolean{
            if ((((((((((((((((((((((((((((((((((my_so.data.allowMusic == undefined)) || ((my_so.data.allowSound == undefined)))) || ((my_so.data.musicVolumn == undefined)))) || ((my_so.data.soundVolumn == undefined)))) || ((my_so.data.showTI == undefined)))) || ((my_so.data.showBI == undefined)))) || ((my_so.data.allowPK == undefined)))) || ((my_so.data.showSkillEffect == undefined)))) || ((my_so.data.showGuildName == undefined)))) || ((my_so.data.showPlayerTitle == undefined)))) || ((my_so.data.showSelfBlood == undefined)))) || ((my_so.data.showOtherBlood == undefined)))) || ((my_so.data.hpPercent == undefined)))) || ((my_so.data.mpPercent == undefined)))) || ((my_so.data.petHpPercent == undefined)))) || ((my_so.data.petMpPercent == undefined)))) || ((my_so.data.radioEquipCompose == undefined)))){
                return (true);
            };
            return (false);
        }
        public function set showTI(_arg1:Boolean):void{
            _showTI = _arg1;
        }
        public function set mpPercent(_arg1:String):void{
            var value:* = _arg1;
            _mpPercent = value;
            try {
                my_so.data.mpPercent = _mpPercent;
            } catch(e:Error) {
            };
        }
        public function get allowMusic():Boolean{
            return (_allowMusic);
        }
        public function get treasureBatchRebuildAlert():int{
            return (_treasureBatchRebuildAlert);
        }
        public function set DbneverTipsDay_Gift(_arg1:int):void{
            if (my_so){
                my_so.data.DbneverTipsDay_Gift = _arg1;
            };
        }
        public function get allowSound():Boolean{
            return (_allowSound);
        }
        public function set showPlayerTitle(_arg1:Boolean):void{
            var _local2:String;
            var _local3:GameElementAnimal;
            _showPlayerTitle = _arg1;
            if (_arg1){
                GameCommonData.Player.ShowTitle();
            } else {
                GameCommonData.Player.HideTitle();
            };
            for (_local2 in GameCommonData.SameSecnePlayerList) {
                _local3 = GameCommonData.SameSecnePlayerList[_local2];
                if (_local3.Role.Type == GameRole.TYPE_PLAYER){
                    if (_arg1){
                        _local3.ShowTitle();
                    } else {
                        _local3.HideTitle();
                    };
                };
            };
        }
        public function set petHpPercent(_arg1:String):void{
            var value:* = _arg1;
            _petHpPercent = value;
            try {
                my_so.data.petHpPercent = _petHpPercent;
            } catch(e:Error) {
            };
        }
        public function save():void{
            var so:* = null;
            try {
                so = SharedObject.getLocal("yxwz");
                so.data["allowMusic"] = allowMusic;
                so.data["allowSound"] = allowSound;
                so.data["showTI"] = showTI;
                so.data["showBI"] = showBI;
                so.data["allowPK"] = allowPK;
                so.data["showSkillEffect"] = showSkillEffect;
                so.data["showGuildName"] = showGuildName;
                so.data["showPlayerTitle"] = showPlayerTitle;
                so.data["showSelfBlood"] = showSelfBlood;
                so.data["showOtherBlood"] = showOtherBlood;
                so.data["hpPercent"] = hpPercent;
                so.data["mpPercent"] = mpPercent;
                so.data["petHpPercent"] = petHpPercent;
                so.data["petMpPercent"] = petMpPercent;
                so.data["enterPKSceneTips"] = enterPKSceneTips;
                so.data["radioEquipCompose"] = radioEquipCompose;
                so.data["rednameTipsDay"] = rednameTipsDay;
                so.data["onlineTimeToday"] = onlineTimeToday;
                so.data["petBatchRebuildAlert"] = petBatchRebuildAlert;
                so.data["treasureBatchRebuildAlert"] = treasureBatchRebuildAlert;
                so.flush(((20 * 0x0400) * 0x0400));
            } catch(e:Error) {
            };
        }
        public function setup():void{
            try {
                my_so = SharedObject.getLocal("yxwz");
                if (isFirstLogin()){
                    my_so.data.allowMusic = true;
                    my_so.data.allowSound = true;
                    my_so.data.showTI = true;
                    my_so.data.showBI = true;
                    my_so.data.allowPK = true;
                    my_so.data.showSkillEffect = true;
                    my_so.data.showGuildName = true;
                    my_so.data.showPlayerTitle = true;
                    my_so.data.showSelfBlood = false;
                    my_so.data.showOtherBlood = false;
                    my_so.data.musicVolumn = 80;
                    my_so.data.soundVolumn = 80;
                    my_so.data.hpPercent = "80";
                    my_so.data.mpPercent = "80";
                    my_so.data.petHpPercent = "80";
                    my_so.data.petMpPercent = "80";
                    my_so.data.enterPKSceneTips = false;
                    my_so.data.rednameTipsDay = 0;
                    my_so.data.onlineTimeToday = 0;
                    my_so.data.petBatchRebuildAlert = 0;
                    my_so.data.treasureBatchRebuildAlert = 0;
                };
                _allowMusic = my_so.data.allowMusic;
                _allowSound = my_so.data.allowSound;
                _showTI = my_so.data.showTI;
                _showBI = my_so.data.showBI;
                _allowPK = my_so.data.allowPK;
                _showSkillEffect = my_so.data.showSkillEffect;
                _showGuildName = my_so.data.showGuildName;
                _showPlayerTitle = my_so.data.showPlayerTitle;
                _showSelfBlood = my_so.data.showSelfBlood;
                _showOtherBlood = my_so.data.showOtherBlood;
                _musicVolumn = my_so.data.musicVolumn;
                _soundVolumn = my_so.data.soundVolumn;
                _hpPercent = my_so.data.hpPercent;
                _mpPercent = my_so.data.mpPercent;
                _petHpPercent = my_so.data.petHpPercent;
                _petMpPercent = my_so.data.petMpPercent;
                _enterPKSceneTips = my_so.data.enterPKSceneTips;
                _radioEquipCompose = my_so.data.radioEquipCompose;
                _rednameTipsDay = my_so.data.rednameTipsDay;
                _onlineTimeToday = my_so.data.onlineTimeToday;
                _petBatchRebuildAlert = my_so.data.petBatchRebuildAlert;
                _treasureBatchRebuildAlert = my_so.data.treasureBatchRebuildAlert;
            } catch(e:Error) {
                my_so.data.allowMusic = true;
                my_so.data.allowSound = true;
                my_so.data.showTI = true;
                my_so.data.showBI = true;
                my_so.data.allowPK = true;
                my_so.data.showSkillEffect = true;
                my_so.data.showGuildName = true;
                my_so.data.showPlayerTitle = true;
                my_so.data.showSelfBlood = false;
                my_so.data.showOtherBlood = false;
                my_so.data.musicVolumn = 80;
                my_so.data.soundVolumn = 80;
                my_so.data.hpPercent = "80";
                my_so.data.mpPercent = "80";
                my_so.data.petHpPercent = "80";
                my_so.data.petMpPercent = "80";
                my_so.data.enterPKSceneTips = false;
                my_so.data.radioEquipCompose = false;
                my_so.data.rednameTipsDay = 0;
                my_so.data.onlineTimeToday = 0;
                my_so.data.petBatchRebuildAlert = 0;
                my_so.data.treasureBatchRebuildAlert = 0;
            };
        }
        public function set petMpPercent(_arg1:String):void{
            var value:* = _arg1;
            _petMpPercent = value;
            try {
                my_so.data.petMpPercent = _petMpPercent;
            } catch(e:Error) {
            };
        }
        public function get showSelfBlood():Boolean{
            return (_showSelfBlood);
        }
        public function set allowSound(_arg1:Boolean):void{
            _allowSound = _arg1;
            SoundManager.getInstance().allowSound = _arg1;
        }
        public function get showGuildName():Boolean{
            return (_showGuildName);
        }
        public function get showOtherBlood():Boolean{
            return (_showOtherBlood);
        }
        public function get musicVolumn():Number{
            return (_musicVolumn);
        }
        public function set DbneverTipsDay_Money(_arg1:int):void{
            if (my_so){
                my_so.data.DbneverTipsDay_Money = _arg1;
            };
        }
        public function set enterPKSceneTips(_arg1:Boolean):void{
            _enterPKSceneTips = _arg1;
            save();
        }
        public function changed():void{
        }
        public function set allowMusic(_arg1:Boolean):void{
            _allowMusic = _arg1;
            SoundManager.getInstance().allowMusic = _arg1;
        }
        public function get petHpPercent():String{
            return (_petHpPercent);
        }
        public function set radioEquipCompose(_arg1:Boolean):void{
            _radioEquipCompose = _arg1;
            if (my_so){
                my_so.data.radioEquipCompose = _arg1;
            };
        }
        public function set onlineTimeToday(_arg1:int):void{
            _onlineTimeToday = _arg1;
            if (my_so){
                my_so.data.onlineTimeToday = _arg1;
            };
        }
        public function get petMpPercent():String{
            return (_petMpPercent);
        }
        public function get showPlayerTitle():Boolean{
            return (_showPlayerTitle);
        }
        public function get DbneverTipsDay_Money():int{
            if (my_so){
                return (my_so.data.DbneverTipsDay_Money);
            };
            return (0);
        }
        public function GetSkillAutoInfo(_arg1:String):Boolean{
            var _local2:int;
            if (SkillSO.data.autoSkill[_arg1] != undefined){
                _local2 = SkillSO.data.autoSkill[_arg1];
            } else {
                _local2 = 1;
                SkillSO.data.autoSkill[_arg1] = 1;
            };
            SkillSO.flush();
            if (_local2 == 0){
                return (false);
            };
            return (true);
        }
        public function get radioEquipCompose():Boolean{
            return (_radioEquipCompose);
        }
        public function set treasureBatchRebuildAlert(_arg1:int):void{
            _treasureBatchRebuildAlert = _arg1;
            if (my_so){
                my_so.data.treasureBatchRebuildAlert = _arg1;
            };
        }
        public function set petBatchRebuildAlert(_arg1:int):void{
            _petBatchRebuildAlert = _arg1;
            if (my_so){
                my_so.data.petBatchRebuildAlert = _arg1;
            };
        }
        public function get petBatchRebuildAlert():int{
            return (_petBatchRebuildAlert);
        }

    }
}//package Manager 
