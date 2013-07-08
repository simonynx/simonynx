//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import GameUI.UICore.*;
    import GameUI.Modules.HeroSkill.SkillConst.*;
    import flash.utils.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import Net.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.MainScene.Proxy.*;
    import GameUI.Modules.NewGuide.Data.*;

    public class SkillInfoAction extends GameAction {

        private static var instance:SkillInfoAction;

        public function SkillInfoAction(){
            if (instance != null){
                throw (new Error("单体出错"));
            };
        }
        public static function getInstance():SkillInfoAction{
            if (instance == null){
                instance = new (SkillInfoAction)();
            };
            return (instance);
        }

        private function getAddPointResult(_arg1:NetPacket):void{
            var _local3:SkillInfo;
            var _local4:int;
            var _local5:SkillInfo;
            var _local6:QuickSkillManager;
            var _local2:int = _arg1.readUnsignedInt();
            if (_local2 == 0){
                _local4 = _arg1.readUnsignedInt();
                SkillManager.MySkillListId.push(_local4);
                SkillManager.setMySkillList();
                _local3 = SkillManager.getMyIdSkillInfo(_local4);
                if ((((_local3.JobLevel >= 1)) && ((_local3.JobLevel <= 3)))){
                    var _local7 = SkillManager.SkillCurrentPoint;
                    var _local8 = (_local3.JobLevel - 1);
                    var _local9 = (_local7[_local8] - 1);
                    _local7[_local8] = _local9;
                };
            };
            facade.sendNotification(EventList.UPDATE_SKILLINFO);
            if (((SkillManager.IsNewSkill(_local4)) && (SkillManager.CanDragSkill(_local3)))){
                if (((SkillManager.IsfirstNewSkill(_local4)) && ((GameCommonData.Player.Role.Level < 13)))){
                    facade.sendNotification(EventList.MOVE_SKILLCELL);
                } else {
                    _local6 = (UIFacade.GetInstance().retrieveProxy(QuickSkillManager.NAME) as QuickSkillManager);
                    _local6.autoAddItem(1, _local3);
                };
            };
            if (((((NewGuideData.newerHelpIsOpen) && ((NewGuideData.curType == 17)))) && ((NewGuideData.curStep == 2)))){
                facade.sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                    TYPE:17,
                    STEP:3
                });
            };
        }
        override public function Processor(_arg1:NetPacket):void{
            switch (_arg1.opcode){
                case Protocol.SMSG_SKILL_ADDPTSTATE:
                    getMySkillInfoList(_arg1);
                    break;
                case Protocol.SMSG_ADDSKILLPOINT:
                    getAddPointResult(_arg1);
                    break;
                case Protocol.SMSG_CLEARSKILLPOINT:
                    clearSkillPoint(_arg1);
                    break;
            };
            facade.sendNotification(EventList.UPDATESKILLVIEW);
        }
        private function clearSkillPoint(_arg1:NetPacket):void{
            var _local3:int;
            var _local4:uint;
            var _local2:int = _arg1.readUnsignedInt();
            if (_local2 == 0){
                _local3 = _arg1.readUnsignedInt();
                if (_local3 == 0){
                    SkillManager.ClearAllMySkill();
                    _local4 = 0;
                    while (_local4 < 3) {
                        SkillManager.SkillCurrentPoint[_local4] = _arg1.readUnsignedInt();
                        _local4++;
                    };
                } else {
                    if ((((((_local3 == 1)) || ((_local3 == 2)))) || ((_local3 == 3)))){
                        SkillManager.SkillCurrentPoint[(_local3 - 1)] = _arg1.readUnsignedInt();
                        SkillManager.clearSkillLayer(_local3);
                    };
                };
                SkillManager.setMySkillList();
                facade.sendNotification(EventList.CLEAR_QUICKBAR_UI);
            };
        }
        private function getMySkillInfoList(_arg1:NetPacket):void{
            var _local3:int;
            var _local4:int;
            var _local5:SkillInfo;
            var _local2:int = _arg1.readUnsignedInt();
            var _local6:uint;
            while (_local6 < _local2) {
                SkillManager.SkillCurrentPoint[_local6] = _arg1.readUnsignedInt();
                _local6++;
            };
            _local3 = _arg1.readUnsignedInt();
            var _local7:uint;
            while (_local7 < _local3) {
                _local4 = _arg1.readUnsignedInt();
                SkillManager.MySkillListId.push(_local4);
                _local7++;
            };
            SkillManager.MySkillListId.push(((SkillManager.SKILLID_Mediation * 100) + 1));
        }

    }
}//package Net.PackHandler 
