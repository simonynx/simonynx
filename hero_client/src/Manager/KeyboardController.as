//Created by Action Script Viewer - http://www.buraks.com/asv
package Manager {
    import flash.events.*;
    import GameUI.UICore.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.View.*;
    import GameUI.Modules.Chat.Data.*;
    import GameUI.Modules.MainScene.Data.*;
    import GameUI.Modules.HeroSkill.View.*;
    import Net.PackHandler.*;
    import GameUI.Modules.Bag.Proxy.*;
    import GameUI.Modules.ChangeLine.Data.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.RoleProperty.Datas.*;
    import org.aswing.*;
    import flash.ui.*;

    public class KeyboardController {

        public function KeyboardController(){
            GameCommonData.GameInstance.KeyUp = onKeyUp;
            GameCommonData.GameInstance.KeyDown = onKeyDown;
        }
        protected function useQuickKey(_arg1):void{
            var _local2:InventoryItemInfo;
            if ((((_arg1 == null)) || (_arg1.IsCdTimer))){
                return;
            };
            if ((_arg1 is UseItem)){
                if (((GameCommonData.Player.Role.canUseItem) && (_arg1.canUseIt))){
                    _local2 = QuickBarData.getInstance().getItemFromBag(_arg1);
                    if (_local2){
                        if (ItemConst.IsMedicalExceptBAG(_local2)){
                            UIFacade.GetInstance().sendNotification(EventList.RECEIVE_CD_MEDICINAL);
                        };
                        BagInfoSend.ItemUse(_local2.ItemGUID);
                    };
                };
            } else {
                if ((_arg1 is SkillUseItem)){
                    PlayerController.UseSkill(_arg1.skillInfo);
                };
            };
        }
        private function onKeyUp(_arg1:KeyboardEvent):void{
            var _local2:Object;
            var _local3:uint;
            if ((((_arg1.target is TextField)) && (!((_arg1.keyCode == Keyboard.ENTER))))){
                return;
            };
            if (!UIConstData.KeyBoardCanUse){
                return;
            };
            switch (_arg1.keyCode){
                case 67:
                case 66:
                case 83:
                case 81:
                case 85:
                case 70:
                case 84:
                case 79:
                case 69:
                case 77:
                case 80:
                case 82:
                case 76:
                case 87:
                case 68:
                case 86:
                case 88:
                case 78:
                case 90:
                case 65:
                case 71:
                case 72:
                case 73:
                case 74:
                case 75:
                case Keyboard.SPACE:
                case Keyboard.ENTER:
                case Keyboard.ESCAPE:
                case Keyboard.F8:
                case Keyboard.F12:
                case Keyboard.F9:
                    GameCommonData.UIFacadeIntance.GetKeyCode(_arg1.keyCode);
                    break;
                case Keyboard.DELETE:
                    if (GameCommonData.Player.Role.GMFlag > 0){
                        if (GameCommonData.TargetAnimal){
                            _local2 = {
                                color:0xFFFFFF,
                                item:"",
                                jobId:0,
                                name:"ALLUSER",
                                talkMsg:("@remove " + GameCommonData.TargetAnimal.Role.Id),
                                type:2013
                            };
                            UIFacade.GetInstance().sendNotification(ChatEvents.SENDCOMMAND, _local2);
                        };
                    };
                    break;
                case Keyboard.UP:
                case Keyboard.DOWN:
                case Keyboard.LEFT:
                case Keyboard.RIGHT:
                case Keyboard.PAGE_UP:
                case Keyboard.PAGE_DOWN:
                    if ((((GameCommonData.Player.Role.GMFlag > 0)) && (GameCommonData.TargetAnimal))){
                        GameCommonData.TargetAnimal.Offset.x = (GameCommonData.TargetAnimal.Offset.x + ((_arg1.keyCode == Keyboard.RIGHT)) ? 1 : 0);
                        GameCommonData.TargetAnimal.Offset.x = (GameCommonData.TargetAnimal.Offset.x + ((_arg1.keyCode == Keyboard.LEFT)) ? -1 : 0);
                        GameCommonData.TargetAnimal.Offset.y = (GameCommonData.TargetAnimal.Offset.y + ((_arg1.keyCode == Keyboard.DOWN)) ? 1 : 0);
                        GameCommonData.TargetAnimal.Offset.y = (GameCommonData.TargetAnimal.Offset.y + ((_arg1.keyCode == Keyboard.UP)) ? -1 : 0);
                        GameCommonData.TargetAnimal.OffsetHeight = (GameCommonData.TargetAnimal.OffsetHeight + ((_arg1.keyCode == Keyboard.PAGE_UP)) ? 1 : 0);
                        GameCommonData.TargetAnimal.OffsetHeight = (GameCommonData.TargetAnimal.OffsetHeight + ((_arg1.keyCode == Keyboard.PAGE_DOWN)) ? -1 : 0);
                        GameCommonData.TargetAnimal.skins.x = (GameCommonData.TargetAnimal.Offset.x - 95);
                        GameCommonData.TargetAnimal.skins.y = (GameCommonData.TargetAnimal.Offset.y + GameCommonData.TargetAnimal.OffsetHeight);
                        GameCommonData.TargetAnimal.shadow.y = (((GameCommonData.TargetAnimal.skins.MaxBodyHeight + 20) - 15) + GameCommonData.TargetAnimal.OffsetHeight);
                        MessageTip.show(((((GameCommonData.TargetAnimal.Offset.x.toString() + ":") + GameCommonData.TargetAnimal.Offset.y.toString()) + ":") + GameCommonData.TargetAnimal.OffsetHeight));
                    };
                    break;
                case Keyboard.NUMPAD_0:
                    if ((((GameCommonData.Player.Role.GMFlag > 0)) && (GameCommonData.TargetAnimal))){
                        MessageTip.show((((GameCommonData.TargetAnimal.Role.Id.toString() + LanguageMgr.GetTranslation("怪物类型")) + ":") + GameCommonData.TargetAnimal.Role.MonsterTypeID.toString()));
                    };
                    break;
                case 192:
                    if (!GameCommonData.Player.IsAutomatism){
                        TargetController.GetTarget();
                    };
                    break;
                case Keyboard.F12:
                    UIFacade.UIFacadeInstance.sendNotification(ChgLineData.ONE_KEY_HIDE);
                    break;
                case Keyboard.F1:
                    GameCommonData.Scene.gameScenePlay.ScrollFlag = !(GameCommonData.Scene.gameScenePlay.ScrollFlag);
                    break;
            };
            if ((((_arg1.keyCode >= KeyStroke.VK_1.getCode())) && ((_arg1.keyCode <= KeyStroke.VK_8.getCode())))){
                _local3 = (_arg1.keyCode - KeyStroke.VK_1.getCode());
                if (_arg1.ctrlKey){
                    this.useQuickKey(QuickBarData.getInstance().expandKeyDic[_local3]);
                } else {
                    if (_arg1.shiftKey){
                        this.useShiftQuickKey(_local3);
                    } else {
                        this.useQuickKey(QuickBarData.getInstance().quickKeyDic[_local3]);
                    };
                };
                return;
            };
        }
        private function onKeyDown(_arg1:KeyboardEvent):void{
            if (!UIConstData.KeyBoardCanUse){
                return;
            };
        }
        private function useShiftQuickKey(_arg1:int):void{
            var _local2:NewSkillCell;
            var _local3:InventoryItemInfo;
            switch (_arg1){
                case 0:
                    _local2 = new NewSkillCell();
                    _local3 = RolePropDatas.ItemList[ItemConst.EQUIPMENT_SLOT_TREASURE];
                    _local2.setWeaponSkill(_local3);
                    if (((!((_local2.skillInfo == null))) && (!(_local2.IsCdTimer)))){
                        PlayerController.UseSkill(_local2.skillInfo);
                    };
                    break;
            };
        }

    }
}//package Manager 
