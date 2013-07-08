//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import OopsEngine.Skill.*;
    import OopsEngine.Role.*;
    import GameUI.Modules.HeroSkill.SkillConst.*;
    import flash.utils.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.Proxy.*;
    import GameUI.View.*;
    import GameUI.Modules.Task.Model.*;
    import GameUI.Modules.Equipment.model.*;
    import GameUI.Modules.Maket.Data.*;
    import GameUI.Modules.NewInfoTip.Data.*;
    import GameUI.Modules.MainScene.Data.*;
    import GameUI.Modules.HeroSkill.View.*;
    import GameUI.Modules.Unity.Data.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.Trade.Data.*;
    import GameUI.Modules.Bag.Proxy.*;
    import GameUI.Modules.CSBattle.vo.*;
    import GameUI.Modules.Activity.VO.*;
    import Utils.*;
    import GameUI.Modules.RoleProperty.Datas.*;
    import GameUI.Modules.RoleProperty.Mediator.*;
    import GameUI.Modules.FilterBag.Proxy.*;
    import GameUI.Modules.NPCExchange.Data.*;
    import GameUI.Modules.ToolTip.Const.*;
    import GameUI.Modules.Stall.Data.*;
    import GameUI.Modules.Arena.Data.*;
    import GameUI.Modules.Depot.Data.*;
    import GameUI.Modules.Verification.Proxy.*;
    import GameUI.Modules.NPCShop.Data.*;
    import GameUI.Modules.Achieve.Data.*;
    import GameUI.Modules.Entrust.Data.*;
    import GameUI.Modules.CSBattle.Data.*;

    public class UILayerMediator extends Mediator {

        public static const NAME:String = "UILayerMediator";

        private var tmpObj:Object = null;
        private var delayNum:Number = 0;
        private var dataProxy:DataProxy;
        private var isEquip:Boolean = false;

        public function UILayerMediator(){
            super(NAME, GameCommonData.GameInstance.GameUI);
        }
        private function showOnly(_arg1:String):void{
            if (dataProxy.BigMapIsOpen){
                sendNotification(EventList.CLOSEBIGMAP);
            };
            switch (_arg1){
                case "hero":
                    if (dataProxy.SkillIsOpen){
                        facade.sendNotification(EventList.CLOSESKILLVIEW);
                    };
                    if (dataProxy.PetIsOpen){
                        facade.sendNotification(EventList.CLOSEPETVIEW);
                    };
                    if (dataProxy.TaskIsOpen){
                        facade.sendNotification(EventList.CLOSETASKVIEW);
                    };
                    break;
                case "pet":
                    if (dataProxy.SkillIsOpen){
                        facade.sendNotification(EventList.CLOSESKILLVIEW);
                    };
                    if (dataProxy.HeroPropIsOpen){
                        facade.sendNotification(EventList.CLOSEHEROPROP);
                    };
                    if (dataProxy.TaskIsOpen){
                        facade.sendNotification(EventList.CLOSETASKVIEW);
                    };
                    break;
                case "skill":
                    if (dataProxy.HeroPropIsOpen){
                        facade.sendNotification(EventList.CLOSEHEROPROP);
                    };
                    if (dataProxy.PetIsOpen){
                        facade.sendNotification(EventList.CLOSEPETVIEW);
                    };
                    if (dataProxy.TaskIsOpen){
                        facade.sendNotification(EventList.CLOSETASKVIEW);
                    };
                    break;
                case "task":
                    if (dataProxy.SkillIsOpen){
                        facade.sendNotification(EventList.CLOSESKILLVIEW);
                    };
                    if (dataProxy.PetIsOpen){
                        facade.sendNotification(EventList.CLOSEPETVIEW);
                    };
                    if (dataProxy.HeroPropIsOpen){
                        facade.sendNotification(EventList.CLOSEHEROPROP);
                    };
                    break;
                default:
                    if (dataProxy.SkillIsOpen){
                        facade.sendNotification(EventList.CLOSESKILLVIEW);
                    };
                    if (dataProxy.PetIsOpen){
                        facade.sendNotification(EventList.CLOSEPETVIEW);
                    };
                    if (dataProxy.HeroPropIsOpen){
                        facade.sendNotification(EventList.CLOSEHEROPROP);
                    };
                    if (dataProxy.TaskIsOpen){
                        facade.sendNotification(EventList.CLOSETASKVIEW);
                    };
            };
        }
        override public function listNotificationInterests():Array{
            return ([EventList.REGISTERCOMPLETE, EventList.ALLROLESREADY, EventList.ENTERMAPCOMPLETE, EventList.SHOWONLY, EventList.SHOWONLY_CENTER_FIVE_PANEL, EventList.ITEMREMOVED]);
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:String;
            switch (_arg1.getName()){
                case EventList.REGISTERCOMPLETE:
                    facade.sendNotification(EventList.INITVIEW);
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    break;
                case EventList.ENTERMAPCOMPLETE:
                    addListenerUIComponet();
                    break;
                case EventList.SHOWONLY:
                    showOnly((_arg1.getBody() as String));
                    break;
            };
        }
        private function getToolTip(_arg1:MouseEvent):void{
            var _local2:Array;
            var _local3:*;
            var _local4:InventoryItemInfo;
            var _local5:ItemTemplateInfo;
            var _local6:SkillInfo;
            var _local7:GameSkillBuff;
            var _local8:ActivityInfo;
            var _local9:uint;
            var _local10:String;
            var _local12:uint;
            var _local13:uint;
            var _local14:String;
            var _local15:String;
            var _local16:int;
            var _local17:int;
            var _local18:int;
            var _local19:TaskInfoStruct;
            var _local20:String;
            var _local21:String;
            var _local22:ItemTemplateInfo;
            var _local23:ItemTemplateInfo;
            var _local24:AchieveInfo;
            var _local25:NewInfoTipVo;
            var _local26:CSBattleRewardItemInfo;
            var _local27:ItemTemplateInfo;
            var _local28:uint;
            _local2 = _arg1.target.name.split("_");
            UIConstData.ToolTipShow = true;
            var _local11:String = _arg1.target.parent.name.split("_")[0];
            switch (_local11){
                case "strengthen":
                    _local10 = LanguageMgr.GetTranslation("UILayer1");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "BtnGetSoulValue":
                    _local10 = EquipDataConst.getInstance().getSacrificeTips();
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "TreasureBatchRebuild":
                    _local10 = LanguageMgr.GetTranslation("UILayer2");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "PetBatchRebuild":
                    _local10 = LanguageMgr.GetTranslation("UILayer3");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
            };
            switch (_arg1.target.name){
                case "randomBtn":
                    _local10 = LanguageMgr.GetTranslation("随机选择职业");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "btnCoolDown":
                    _local10 = EquipDataConst.getInstance().getCDTimeTips();
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "mc_redOneTip":
                    if (getQualifiedClassName(_arg1.target.parent) == "Self"){
                        _local10 = (((LanguageMgr.GetTranslation("UILayer4") + GameCommonData.Player.Role.HP) + "/") + GameCommonData.Player.Role.MaxHp);
                        facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                        uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                        return;
                    };
                    break;
                case "mc_buleOneTip":
                    if (getQualifiedClassName(_arg1.target.parent) == "Self"){
                        _local10 = (((LanguageMgr.GetTranslation("UILayer5") + GameCommonData.Player.Role.MP) + "/") + GameCommonData.Player.Role.MaxMp);
                        facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                        uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                        return;
                    };
                    break;
                case "hpLeverBtn":
                    _local10 = LanguageMgr.GetTranslation("UILayer6", ColorFilters.ORANGE_HTML, ColorFilters.BLUE_HTML, SharedManager.getInstance().hpPercent, ColorFilters.GREEN_HTML);
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "hpLever":
                    _local10 = LanguageMgr.GetTranslation("UILayer7", ColorFilters.ORANGE_HTML, ColorFilters.BLUE_HTML, SharedManager.getInstance().mpPercent, ColorFilters.GREEN_HTML);
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "allCount":
                    _local10 = (((LanguageMgr.GetTranslation("UILayer11") + ArenaInfo.SelfArenaInfo.count) + LanguageMgr.GetTranslation("UILayer12")) + ArenaInfo.SelfArenaInfo.winCount);
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "arenaExp":
                    _local10 = LanguageMgr.GetTranslation("UILayer13");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "weaponExp":
                    _local10 = (LanguageMgr.GetTranslation("UILayer14") + GameCommonData.MagicWeaponExp);
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "mpLeverBtn":
                    _local10 = LanguageMgr.GetTranslation("UILayer15", ColorFilters.ORANGE_HTML, ColorFilters.BLUE_HTML, SharedManager.getInstance().mpPercent, ColorFilters.GREEN_HTML);
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "mpLever":
                    _local10 = LanguageMgr.GetTranslation("UILayer20", ColorFilters.ORANGE_HTML, ColorFilters.BLUE_HTML, SharedManager.getInstance().mpPercent, ColorFilters.GREEN_HTML);
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "autoPlayHp_0":
                    _local10 = LanguageMgr.GetTranslation("UILayer17");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "autoPlayMp":
                    _local10 = LanguageMgr.GetTranslation("UILayer18");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "txt_level":
                    _local10 = LanguageMgr.GetTranslation("等级");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "pkBtn":
                    _local10 = LanguageMgr.GetTranslation("UILayer19");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "btn_Verification":
                case "btn_Verification2":
                    if (VerificationData.VerificationType == VerificationData.ANTIWALLOW_VN){
                        _local10 = LanguageMgr.GetTranslation("UILayer21");
                        _local14 = String(uint(((VerificationData.PlayTime / 3600) % 24)));
                        _local15 = String(uint(((VerificationData.PlayTime / 60) % 60)));
                        _local16 = int(_local14);
                        if (_local14.length == 1){
                            _local14 = ("0" + _local14);
                        };
                        if (_local15.length == 1){
                            _local15 = ("0" + _local15);
                        };
                        _local10 = _local10.replace("h", _local14);
                        _local10 = _local10.replace("m", _local15);
                        if ((((_local16 >= 3)) && ((_local16 < 5)))){
                            _local10 = _local10.replace("#00ff00", "#ffff00");
                        } else {
                            if (_local16 >= 5){
                                _local10 = _local10.replace("#00ff00", "#ff0000");
                            };
                        };
                    } else {
                        if (VerificationData.VerificationType == VerificationData.ANTIWALLOW_CN){
                            _local10 = LanguageMgr.GetTranslation("UILayer22");
                        };
                    };
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "btnChang":
                    if (_arg1.target.parent.name == "btnSelectCh"){
                        _local10 = LanguageMgr.GetTranslation("UILayer23");
                        facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                        uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                        return;
                    };
                    break;
                case "btnSetHeight":
                    _local10 = LanguageMgr.GetTranslation("UILayer24");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "btnSend":
                    _local10 = LanguageMgr.GetTranslation("UILayer25");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "btnClear":
                    _local10 = LanguageMgr.GetTranslation("UILayer26");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "btnFace":
                    _local10 = LanguageMgr.GetTranslation("UILayer27");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "expTipsMc":
                    _local12 = UIConstData.ExpDic[GameCommonData.Player.Role.Level];
                    _local13 = GameCommonData.Player.Role.Exp;
                    _local10 = (((LanguageMgr.GetTranslation("UILayer28") + _local13) + "/") + _local12);
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "hammerBtn":
                    _local10 = LanguageMgr.GetTranslation("UILayer29");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "autoPlayBtn":
                    _local10 = LanguageMgr.GetTranslation("UILayer29_1");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "petBtn":
                    _local10 = LanguageMgr.GetTranslation("UILayer30");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "lockBtn":
                    _local10 = LanguageMgr.GetTranslation("UILayer31");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "role_btn":
                    _local10 = LanguageMgr.GetTranslation("UILayer32");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "bag_btn":
                    _local10 = LanguageMgr.GetTranslation("UILayer33");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "skill_btn":
                    _local10 = LanguageMgr.GetTranslation("UILayer34");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "btn_task":
                    _local10 = LanguageMgr.GetTranslation("UILayer35");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "achieve_btn":
                    _local10 = LanguageMgr.GetTranslation("UILayer36");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "btn_vip":
                    _local10 = "VIP";
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "pet_btn":
                    _local10 = LanguageMgr.GetTranslation("UILayer37");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "friend_btn":
                    _local10 = LanguageMgr.GetTranslation("UILayer38");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "btn_7":
                    _local10 = LanguageMgr.GetTranslation("UILayer39");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "btn_8":
                    _local10 = LanguageMgr.GetTranslation("UILayer40");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "consortia_btn":
                    _local10 = LanguageMgr.GetTranslation("UILayer41");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "shopBtn":
                    _local10 = LanguageMgr.GetTranslation("UILayer42");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "fx":
                    _local10 = LanguageMgr.GetTranslation("UILayer43");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "btn_official":
                    _local10 = LanguageMgr.GetTranslation("UILayer44");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "btn_forum":
                    _local10 = LanguageMgr.GetTranslation("UILayer45");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "btn_sound":
                    _local10 = LanguageMgr.GetTranslation("UILayer46");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "btn_equipstreng":
                    _local10 = LanguageMgr.GetTranslation("UILayer47");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "btn_rank":
                    _local10 = LanguageMgr.GetTranslation("UILayer48");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "btn_help":
                    _local10 = LanguageMgr.GetTranslation("UILayer49");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "btn_mail":
                    _local10 = LanguageMgr.GetTranslation("UILayer50");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "btn_sceneMap":
                    _local10 = LanguageMgr.GetTranslation("UILayer51");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "btn_activity":
                    _local10 = LanguageMgr.GetTranslation("UILayer52");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "btn_fullMoney":
                    _local10 = LanguageMgr.GetTranslation("UILayer53");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "btn_gm":
                    _local10 = LanguageMgr.GetTranslation("UILayer54");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "CHARGECHEST":
                    _local10 = LanguageMgr.GetTranslation("UILayer55");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "CHARGECHEST1":
                    _local10 = "";
                    if (GameCommonData.accuChargeLeftDay > 0){
                        _local10 = (_local10 + (((LanguageMgr.GetTranslation("UILayer56") + "<font color ='#00ff00'>") + GameCommonData.accuChargeLeftDay) + LanguageMgr.GetTranslation("UILayer57")));
                    };
                    _local10 = (_local10 + ((((LanguageMgr.GetTranslation("UILayer58") + LanguageMgr.GetTranslation("UILayer59")) + ",") + LanguageMgr.GetTranslation("UILayer60")) + LanguageMgr.GetTranslation("UILayer61")));
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "changeLineView":
                    _local10 = LanguageMgr.GetTranslation("UILayer62");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "mc_headImg":
                    if (getQualifiedClassName(_arg1.target.parent) == "Counter"){
                        if (((GameCommonData.TargetAnimal) && ((GameCommonData.TargetAnimal.Role.Type == GameRole.TYPE_PLAYER)))){
                            _local10 = LanguageMgr.GetTranslation("UILayer63");
                            facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                            uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                        };
                        return;
                    };
                    break;
                case "msgButton":
                    _local10 = LanguageMgr.GetTranslation("UILayer64");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "GetRewardTips_Mount":
                    _local10 = LanguageMgr.GetTranslation("UILayer65");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "GetRewardTips_Ring":
                    _local10 = LanguageMgr.GetTranslation("UILayer66");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "GetRewardTips_Login":
                    _local10 = LanguageMgr.GetTranslation("UILayer67");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "GiftRewardBtnBtn":
                    _local10 = LanguageMgr.GetTranslation("UILayer68");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "petTypeTF":
                case "txtMainType":
                case "mcMain":
                    _local10 = LanguageMgr.GetTranslation("UILayer69");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "petSubTypeTF":
                case "txtSubType":
                case "mcSub":
                    _local10 = LanguageMgr.GetTranslation("UILayer70");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "starTF":
                case "txtStar":
                case "startTF":
                    _local10 = LanguageMgr.GetTranslation("UILayer71");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "crit":
                case "critRate":
                case "critTF":
                case "critRateTF":
                    _local10 = LanguageMgr.GetTranslation("UILayer72");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "addBloodBtn":
                    _local10 = LanguageMgr.GetTranslation("UILayer73");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "tipPetUpgrade_0":
                    _local10 = LanguageMgr.GetTranslation("UILayer74");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "tipPetUpgrade_1":
                    _local10 = LanguageMgr.GetTranslation("UILayer75");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "tipPetUpgrade_2":
                    _local10 = LanguageMgr.GetTranslation("UILayer76");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "quickget":
                    _local10 = LanguageMgr.GetTranslation("UILayer77");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
            };
            switch (_local2[0]){
                case "bag":
                    _local9 = int(_local2[1]);
                    if (BagData.GridUnitList[BagData.SelectIndex][(_local9 % BagData.MAX_GRIDS)].Item != null){
                        _local4 = BagData.AllItems[BagData.SelectIndex][_local9];
                    } else {
                        _local4 = null;
                    };
                    if (!_local4){
                        facade.sendNotification(EventList.REMOVEITEMTOOLTIP);
                        return;
                    };
                    facade.sendNotification(EventList.SHOWITEMPARALLELPANEL, _local4);
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    break;
                case "vipItem":
                    _local10 = LanguageMgr.bagVipBtnTips[_local2[1]];
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    return;
                case "filterBag":
                    _local9 = int(_local2[1]);
                    if (!FilterBagData.AllItems[0][_local9]){
                        facade.sendNotification(EventList.REMOVEITEMTOOLTIP);
                        return;
                    };
                    _local9 = FilterBagData.AllItems[0][_local9].Place;
                    if (_local9 >= ItemConst.NORMAL_SLOT_START){
                        _local9 = ItemConst.placeToOffset(_local9);
                        _local4 = BagData.AllItems[0][_local9];
                    } else {
                        _local4 = RolePropDatas.ItemList[_local9];
                    };
                    if (!_local4){
                        facade.sendNotification(EventList.REMOVEITEMTOOLTIP);
                        return;
                    };
                    facade.sendNotification(EventList.SHOWITEMTOOLTIP, _local4);
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    break;
                case "key":
                    _local3 = QuickBarData.getInstance().quickKeyDic[_local2[1]];
                    if ((((_local3 == null)) || ((_local3 == 0)))){
                        return;
                    };
                    if ((_local3 is SkillUseItem)){
                        _local6 = (_local3 as SkillUseItem).skillInfo;
                        facade.sendNotification(EventList.SHOW_SKILL_TIP, _local6);
                    } else {
                        if ((_local3 is UseItem)){
                            _local4 = QuickBarData.getInstance().getItemFromBag(_local3);
                            if (!_local4){
                                _local5 = UIConstData.ItemDic[_local3.Type];
                                if (!_local5){
                                    facade.sendNotification(EventList.REMOVEITEMTOOLTIP);
                                    return;
                                };
                                facade.sendNotification(EventList.SHOWITEMTOOLTIP, _local5);
                            } else {
                                facade.sendNotification(EventList.SHOWITEMTOOLTIP, _local4);
                            };
                        };
                    };
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    break;
                case "keyF":
                    _local3 = QuickBarData.getInstance().expandKeyDic[_local2[1]];
                    if ((((_local3 == null)) || ((_local3 == 0)))){
                        return;
                    };
                    if ((_local3 is SkillUseItem)){
                        _local6 = (_local3 as SkillUseItem).skillInfo;
                        facade.sendNotification(EventList.SHOW_SKILL_TIP, _local6);
                    } else {
                        if ((_local3 is UseItem)){
                            _local4 = QuickBarData.getInstance().getItemFromBag(_local3);
                            if (!_local4){
                                _local5 = UIConstData.ItemDic[_local3.Type];
                                if (!_local5){
                                    facade.sendNotification(EventList.REMOVEITEMTOOLTIP);
                                    return;
                                };
                                facade.sendNotification(EventList.SHOWITEMTOOLTIP, _local5);
                            } else {
                                facade.sendNotification(EventList.SHOWITEMTOOLTIP, _local4);
                            };
                        };
                    };
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    break;
                case "skillCell":
                    _local3 = _arg1.target;
                    _local6 = (_local3 as NewSkillCell).skillInfo;
                    facade.sendNotification(EventList.SHOW_SKILL_TIP, _local6);
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    break;
                case "starCell":
                    _local17 = _local2[1];
                    _local6 = SkillManager.getIdSkillInfo(_local17);
                    if (_local6 != null){
                        facade.sendNotification(EventList.SHOW_SKILL_TIP, _local6);
                        uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    };
                    break;
                case "buffIcon":
                    _local7 = GameCommonData.BuffList[_local2[1]];
                    facade.sendNotification(EventList.SHOW_SKILL_TIP, _local7);
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    break;
                case "MarketSaleItem":
                    _local5 = MarketConstData.curPageData[int(_local2[1])];
                    if (!_local5){
                        facade.sendNotification(EventList.REMOVEITEMTOOLTIP);
                        return;
                    };
                    facade.sendNotification(EventList.SHOWITEMTOOLTIP, _local5);
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    break;
                case "MarketSaleViewItem":
                    if (_arg1.target.hasOwnProperty("shopItemInfo")){
                        _local5 = _arg1.target.shopItemInfo;
                    };
                    if (!_local5){
                        facade.sendNotification(EventList.REMOVEITEMTOOLTIP);
                        return;
                    };
                    facade.sendNotification(EventList.SHOWITEMTOOLTIP, _local5);
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    break;
                case "TaskEqu":
                case "GetReward":
                    _local5 = UIConstData.ItemDic[int(_local2[1])];
                    if (!_local5){
                        facade.sendNotification(EventList.REMOVEITEMTOOLTIP);
                        return;
                    };
                    facade.sendNotification(EventList.SHOWITEMTOOLTIP, _local5);
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    break;
                case "mcNPCGoodPhoto":
                    _local5 = NPCShopConstData.getNPCShopItemById(int(_local2[1]));
                    if (!_local5){
                        facade.sendNotification(EventList.REMOVEITEMTOOLTIP);
                        return;
                    };
                    facade.sendNotification(EventList.SHOWITEMTOOLTIP, _local5);
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    break;
                case "dstNPCExchangePhoto":
                    _local5 = NPCExchangeConstData.getNPCExchangeItemById(int(_local2[1]));
                    if (!_local5){
                        facade.sendNotification(EventList.REMOVEITEMTOOLTIP);
                        return;
                    };
                    facade.sendNotification(EventList.SHOWITEMTOOLTIP, _local5);
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    break;
                case "srcNPCExchangePhoto":
                case "QuickBuyT":
                case "MailItemT":
                case "Treasure":
                case "PetRebuildT":
                case "PetStrengthenT":
                case "PetLearnT":
                case "GetMountReward":
                case "EquipComposeT":
                case "EquipEmbedT2":
                case "EquipComposeT2":
                case "petRaceRewardT":
                case "PetUpgradeT":
                case "EquipRefineFadeT":
                case "csbrewardItem":
                    _local5 = UIConstData.ItemDic[int(_local2[1])];
                    if (!_local5){
                        facade.sendNotification(EventList.REMOVEITEMTOOLTIP);
                        return;
                    };
                    if ((((_local2[0] == "EquipEmbedT2")) || ((_local2[0] == "EquipComposeT2")))){
                        _local5.Set = _local2[3];
                    };
                    if (_local2[0] == "MailItemT"){
                        IntroConst.GlobalBind = _local2[6];
                    };
                    facade.sendNotification(EventList.SHOWITEMTOOLTIP, _local5);
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    break;
                case "Entrust":
                    _local3 = uint(_local2[1]);
                    _local4 = EntrustData.findItemInAllEntrust(_local3);
                    if (!_local4){
                        facade.sendNotification(EventList.REMOVEITEMTOOLTIP);
                        return;
                    };
                    facade.sendNotification(EventList.SHOWITEMTOOLTIP, _local4);
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    break;
                case "autoPlayHp":
                case "autoPlayMp":
                    if ((_arg1.target is UseItem)){
                        _local4 = QuickBarData.getInstance().getItemFromBag(UseItem(_arg1.target));
                        if (!_local4){
                            _local5 = UIConstData.ItemDic[int(_local2[1])];
                            if (!_local5){
                                facade.sendNotification(EventList.REMOVEITEMTOOLTIP);
                                return;
                            };
                            facade.sendNotification(EventList.SHOWITEMTOOLTIP, _local5);
                        } else {
                            facade.sendNotification(EventList.SHOWITEMTOOLTIP, _local4);
                        };
                    };
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    break;
                case "NPCShopSale":
                    _local3 = uint(_local2[1]);
                    if (NPCShopConstData.goodSaleList[_local3]){
                        _local4 = BagData.getItemById(NPCShopConstData.goodSaleList[_local3].ItemGUID);
                        if (!_local4){
                            facade.sendNotification(EventList.REMOVEITEMTOOLTIP);
                            return;
                        };
                        facade.sendNotification(EventList.SHOWITEMTOOLTIP, _local4);
                        uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    };
                    break;
                case "Convoy":
                    _local3 = uint(_local2[1]);
                    _local4 = BagData.getItemById(_local3);
                    if (!_local4){
                        facade.sendNotification(EventList.REMOVEITEMTOOLTIP);
                        return;
                    };
                    facade.sendNotification(EventList.SHOWITEMTOOLTIP, _local4);
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    break;
                case "stall":
                    _local3 = uint(_local2[1]);
                    if (StallConstData.goodUpList[_local3]){
                        _local27 = UIConstData.ItemDic[StallConstData.goodUpList[_local3].type];
                        if (((ItemConst.IsEquip(_local27)) || (ItemConst.IsPet(_local27)))){
                            if ((((StallConstData.stallIdToQuery == 0)) || ((StallConstData.stallIdToQuery == GameCommonData.Player.Role.Id)))){
                                _local4 = BagData.getItemById(StallConstData.goodUpList[_local3].id);
                                if (_local4){
                                    _local4.price = StallConstData.goodUpList[_local3].price;
                                } else {
                                    _local4 = (StallConstData.goodUpList[_local3] as InventoryItemInfo);
                                    if (_local4){
                                        _local4.price = StallConstData.goodUpList[_local3].price;
                                    };
                                };
                            } else {
                                _local4 = (StallConstData.goodUpList[_local3] as InventoryItemInfo);
                                _local4.price = StallConstData.goodUpList[_local3].price;
                            };
                            if (_local4){
                                facade.sendNotification(EventList.SHOWITEMTOOLTIP, _local4);
                                uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                                return;
                            };
                        };
                        _local5 = UIConstData.ItemDic[StallConstData.goodUpList[_local3].type];
                        if (!_local5){
                            facade.sendNotification(EventList.REMOVEITEMTOOLTIP);
                            return;
                        };
                        _local5.price = StallConstData.goodUpList[_local3].price;
                        facade.sendNotification(EventList.SHOWITEMTOOLTIP, _local5);
                        uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    } else {
                        facade.sendNotification(EventList.REMOVEITEMTOOLTIP);
                    };
                    break;
                case "stalldown":
                    _local3 = uint(_local2[1]);
                    if (StallConstData.goodDownList[_local3]){
                        _local5 = UIConstData.ItemDic[StallConstData.goodDownList[_local3].type];
                        if (!_local5){
                            facade.sendNotification(EventList.REMOVEITEMTOOLTIP);
                            return;
                        };
                        _local5.price = StallConstData.goodDownList[_local3].price;
                        facade.sendNotification(EventList.SHOWITEMTOOLTIP, _local5);
                        uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    };
                    break;
                case "hero":
                    _local4 = RolePropDatas.ItemList[int(_local2[1])];
                    if (!_local4){
                        facade.sendNotification(EventList.REMOVEITEMTOOLTIP);
                        return;
                    };
                    facade.sendNotification(EventList.SHOWITEMTOOLTIP, _local4);
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    break;
                case "playerinfo":
                    _local4 = (facade.retrieveMediator(PlayerEquipMediator.NAME) as PlayerEquipMediator).ItemList[int(_local2[1])];
                    if (!_local4){
                        facade.sendNotification(EventList.REMOVEITEMTOOLTIP);
                        return;
                    };
                    facade.sendNotification(EventList.SHOWITEMTOOLTIP, _local4);
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    break;
                case "depot":
                    _local3 = uint(_local2[1]);
                    _local4 = DepotConstData.goodList[_local3];
                    if (!_local4){
                        facade.sendNotification(EventList.REMOVEITEMTOOLTIP);
                        return;
                    };
                    facade.sendNotification(EventList.SHOWITEMTOOLTIP, _local4);
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    break;
                case "mcPhoto":
                    _local3 = uint(_local2[1]);
                    if (TradeConstData.goodSelfList[_local3]){
                        _local4 = TradeConstData.goodSelfList[_local3];
                        if (!_local4){
                            facade.sendNotification(EventList.REMOVEITEMTOOLTIP);
                            return;
                        };
                        facade.sendNotification(EventList.SHOWITEMTOOLTIP, _local4);
                        uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    };
                    break;
                case "mcOpPhoto":
                    _local3 = uint(_local2[1]);
                    if (TradeConstData.goodOpList[_local3]){
                        _local4 = TradeConstData.goodOpList[_local3];
                        if (!_local4){
                            facade.sendNotification(EventList.REMOVEITEMTOOLTIP);
                            return;
                        };
                        facade.sendNotification(EventList.SHOWITEMTOOLTIP, _local4);
                        uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    };
                    break;
                case "Strengen":
                case "EquipPourT":
                case "EquipBreakT":
                case "EquipActiveT":
                case "EquipIdentifyT":
                case "EquipRefineT":
                case "EquipUpStarT":
                case "EquipTransferT":
                case "EquipTransformT":
                case "TreasureTransformT":
                case "EquipEmbedT":
                case "TreasureSacrificeT":
                case "TreasureResetT":
                case "TreasureRebuildT":
                case "TreasureBatchRebuildT":
                case "PetBatchRebuildT":
                case "TreasureTransferT":
                    _local4 = BagData.getItemById(_local2[1]);
                    if (!_local4){
                        _local4 = RolePropDatas.getItemById(_local2[1]);
                        if (!_local4){
                            facade.sendNotification(EventList.REMOVEITEMTOOLTIP);
                            return;
                        };
                    };
                    facade.sendNotification(EventList.SHOWITEMTOOLTIP, _local4);
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    break;
                case "EquipFadeT":
                    _local4 = BagData.getItemById(_local2[1]);
                    if (!_local4){
                        _local4 = RolePropDatas.getItemById(_local2[1]);
                        if (!_local4){
                            facade.sendNotification(EventList.REMOVEITEMTOOLTIP);
                            return;
                        };
                    };
                    IntroConst.GlobalLevel = uint(_local2[2]);
                    if (_local2.length > 4){
                        _local28 = 0;
                        _local28 = 0;
                        while (_local28 < 12) {
                            IntroConst.GlobalTreasureLife[_local28] = uint(_local2[(_local28 + 3)]);
                            _local28++;
                        };
                        IntroConst.GlobalBind = uint(_local2[15]);
                    } else {
                        IntroConst.GlobalBind = uint(_local2[3]);
                    };
                    facade.sendNotification(EventList.SHOWITEMTOOLTIP, _local4);
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    break;
                case "taskfollowTaskInfo":
                    _local18 = _local2[1];
                    _local19 = GameCommonData.TaskInfoDic[_local18];
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {
                        data:_local19.objectives,
                        change:true
                    });
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    break;
                case "SMALLMAP":
                    _local20 = _local2[1];
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {
                        data:_local20,
                        change:true
                    });
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    break;
                case "OfferProgressBarShape":
                    _local21 = "";
                    switch (int(_local2[1])){
                        case 0:
                        case 1:
                        case 2:
                        case 3:
                        case 4:
                            _local21 = (RolePropDatas.OfferTipsArr[_local2[1]] + LanguageMgr.GetTranslation("UILayer78"));
                            break;
                        case 5:
                            _local21 = (RolePropDatas.OfferTipsArr[_local2[1]] + LanguageMgr.GetTranslation("UILayer79"));
                            break;
                        case 6:
                            _local21 = (RolePropDatas.OfferTipsArr[_local2[1]] + LanguageMgr.GetTranslation("UILayer80"));
                            break;
                        default:
                            return;
                    };
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {
                        data:_local21,
                        change:true
                    });
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    break;
                case "target":
                case "target1":
                case "activitytarget":
                    _local22 = UIConstData.ItemDic[_local2[1]];
                    if (!_local22){
                        facade.sendNotification(EventList.REMOVEITEMTOOLTIP);
                        return;
                    };
                    if (_local2[0] == "target"){
                        IntroConst.GlobalBind = 3;
                    } else {
                        if (_local2[0] == "activitytarget"){
                            IntroConst.ShowBind = false;
                        };
                    };
                    facade.sendNotification(EventList.SHOWITEMTOOLTIP, _local22);
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    break;
                case "towerTarget":
                    _local23 = UIConstData.ItemDic[_local2[1]];
                    if (!_local23){
                        facade.sendNotification(EventList.REMOVEITEMTOOLTIP);
                        return;
                    };
                    if (_local23.Name == LanguageMgr.GetTranslation("UILayer81")){
                        IntroConst.GlobalBind = 3;
                    } else {
                        IntroConst.GlobalBind = 0;
                    };
                    facade.sendNotification(EventList.SHOWITEMTOOLTIP, _local23);
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    break;
                case "PetRaceWinnerT":
                    _local10 = _local2[1];
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    break;
                case "guildLevelTipsMask":
                    _local10 = "";
                    if (UnityConstData.myGuildInfo){
                        _local10 = (LanguageMgr.GetTranslation("UILayer82") + UnityConstData.GuildLevelDef[UnityConstData.myGuildInfo.Level]);
                    };
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    break;
                case "achieveProcess":
                    _local24 = GameCommonData.AchieveDic[_local2[1]];
                    if (_local24){
                        _local10 = (((LanguageMgr.GetTranslation("UILayer83") + _local24.CurrentProgress) + "/") + _local24.TargetProgress);
                        facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                        uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    };
                    break;
                case "newinfotips":
                    _local25 = _arg1.target["info"];
                    if (_local25){
                        _local10 = _local25.title;
                        facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                        uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    };
                    break;
                case "tesltrap":
                    _local10 = LanguageMgr.GetTranslation(("机关tips" + _local2[1]));
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    break;
                case "EveryDayDes":
                    _local10 = LanguageMgr.GetTranslation("点击查看详细信息");
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    break;
                case "csbrewardtips":
                    _local26 = CSBattleData.GetRewardItemByRewardid(int(_local2[1]));
                    _local10 = LanguageMgr.GetTranslation("消耗X兑换Y个[Z]", _local26.ReqCSBPoint, _local26.ReqGold, _local26.ReqMoney, _local26.Count, _local26.Name);
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    break;
                case "btnBuy":
                    _local10 = UITipsConst.EquipBuyBtnTipList[_local2[1]];
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    break;
                case "gradeBible":
                    _local10 = UITipsConst.GradeBibleTipList[_local2[1]];
                    if (((!((_local10 == null))) && (!((UIUtils.TrimString(_local10) == ""))))){
                        facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                        uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    };
                    break;
                case "occu":
                    _local10 = LanguageMgr.JobNameList[_local2[1]];
                    facade.sendNotification(EventList.SHOWTEXTTOOLTIP, {data:_local10});
                    uiLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    break;
                default:
                    uiLayer.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    facade.sendNotification(EventList.REMOVEITEMTOOLTIP);
                    UIConstData.ToolTipShow = false;
            };
        }
        private function addListenerUIComponet():void{
            GameCommonData.GameInstance.addEventListener(MouseEvent.MOUSE_OVER, getToolTip);
        }
        public function onMouseMove(_arg1:MouseEvent):void{
            facade.sendNotification(EventList.MOVEITEMTOOLTIP);
        }
        public function get uiLayer():Sprite{
            return ((viewComponent as Sprite));
        }

    }
}//package GameUI.Mediator 
