//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Roll.Mediator {
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.ConstData.*;
    import GameUI.View.*;
    import GameUI.Modules.Roll.Data.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.Roll.View.*;

    public class RollMediator extends Mediator {

        public static const NAME:String = "RollMediator";

        private var rollView:RollListView;

        public function RollMediator(){
            super(NAME);
        }
        override public function listNotificationInterests():Array{
            return ([RollEvent.SHOW_REWARD_VIEW, RollEvent.CLOSE_REWARD_VIEW, RollEvent.SHOW_ROLL_STATE, RollEvent.SHOW_ROLL_INFO, RollEvent.SHOW_WIN, RollEvent.REMOVE_VIEW, EventList.RESIZE_STAGE]);
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:uint;
            var _local3:Object;
            var _local4:Array;
            var _local5:String;
            var _local6:RollInfo;
            var _local7:uint;
            switch (_arg1.getName()){
                case RollEvent.SHOW_REWARD_VIEW:
                    if (rollView == null){
                        rollView = new RollListView();
                    };
                    _local2 = _arg1.getBody().guid;
                    for (_local5 in RollInfo.dic) {
                        if (uint(((RollInfo.dic[_local5] as RollInfo).index / 100)) == _local2){
                            rollView.addItem(RollInfo.dic[_local5], false);
                        };
                    };
                    rollView.UpdatePosition();
                    rollView.x = ((GameCommonData.GameInstance.ScreenWidth / 2) - (rollView.width / 2));
                    rollView.y = ((GameCommonData.GameInstance.ScreenHeight / 2) - (rollView.height / 2));
                    if (rollView.parent == null){
                        GameCommonData.GameInstance.GameUI.addChild(rollView);
                    };
                    break;
                case RollEvent.SHOW_ROLL_STATE:
                    _local3 = _arg1.getBody();
                    if (!_local3.isRoll){
                        MessageTip.show(LanguageMgr.GetTranslation("x对y进行roll点", _local3.playerName, RollInfo.dic[_local3.index].itemName));
                    } else {
                        MessageTip.show(LanguageMgr.GetTranslation("x放弃对y进行roll点", _local3.playerName, RollInfo.dic[_local3.index].itemName));
                    };
                    break;
                case RollEvent.SHOW_ROLL_INFO:
                    _local3 = _arg1.getBody();
                    MessageTip.show((((((((_local3.playerName + LanguageMgr.GetTranslation("对")) + RollInfo.dic[_local3.index].itemName) + "roll") + LanguageMgr.GetTranslation("到")) + "<font color ='#00ff00'>") + _local3.rollNum) + "</font>"));
                    break;
                case RollEvent.SHOW_WIN:
                    _local3 = _arg1.getBody();
                    MessageTip.show(((((_local3.owerPlayerName + LanguageMgr.GetTranslation("获得了")) + "<font color ='#00ff00'>") + RollInfo.dic[_local3.index].itemName) + "</font>"));
                    break;
                case RollEvent.REMOVE_VIEW:
                    _local2 = _arg1.getBody().guid;
                    _local4 = [];
                    for (_local5 in RollInfo.dic) {
                        _local6 = (RollInfo.dic[_local5] as RollInfo);
                        if (uint((_local6.index / 100)) == _local2){
                            rollView.deleteItem(_local6.index, false);
                            _local4.push(_local5);
                        };
                    };
                    rollView.UpdatePosition();
                    _local7 = 0;
                    while (_local7 < _local4.length) {
                        delete RollInfo.dic[_local4[_local7]];
                        _local7++;
                    };
                    break;
                case EventList.RESIZE_STAGE:
                    break;
            };
        }

    }
}//package GameUI.Modules.Roll.Mediator 
