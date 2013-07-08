//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NPCChat.Command {
    import org.puremvc.as3.multicore.interfaces.*;
    import OopsEngine.Role.*;
    import OopsEngine.Scene.StrategyElement.*;
    import Manager.*;
    import Net.*;
    import GameUI.View.MouseCursor.*;
    import GameUI.View.*;
    import GameUI.Modules.NPCChat.Proxy.*;
    import org.puremvc.as3.multicore.patterns.command.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.NPCChat.Mediator.*;

    public class SelectedNPCCommand extends SimpleCommand {

        override public function execute(_arg1:INotification):void{
            var _local4:Object;
            var _local5:Array;
            var _local2:PipeDataProxy = (facade.retrieveProxy(PipeDataProxy.NAME) as PipeDataProxy);
            var _local3:NPCChatMediator = (facade.retrieveMediator(NPCChatMediator.NAME) as NPCChatMediator);
            var _local6:Object = _arg1.getBody();
            var _local7:int = _local6.npcId;
            if (_local7 == 0){
                return;
            };
            if (_local6 == null){
                return;
            };
            if (DelayOperation.getInstance().isNpcTalkLock){
                MessageTip.show(LanguageMgr.GetTranslation("请求太频繁，请稍候"));
                return;
            };
            if (GameCommonData.Player.Role.isStalling > 0){
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("摆摊时无法与NPC对话"),
                    color:0xFFFF00
                });
                return;
            };
            var _local8:GameElementAnimal = GameCommonData.SameSecnePlayerList[_local7];
            if (!_local8){
                MessageTip.show(LanguageMgr.GetTranslation("当前场景没找到目标NPC"));
                return;
            };
            if (_local8.Role.Type != GameRole.TYPE_NPC){
                return;
            };
            if (!DistanceController.PlayerTargetAnimalDistance(_local8, 4)){
                return;
            };
            if (((((GameCommonData.NPCDialogIsOpen) && ((_local7 == _local3.npcId)))) && ((_local2.linkArr.length == 0)))){
                facade.sendNotification(NPCChatComList.NPCCHAT_VISIBLE, true);
                return;
            };
            DelayOperation.getInstance().lockNpcTalk();
            GameCommonData.talkNpcID = _local7;
            GameCommonData.IsMoveTargetAnimal = false;
            NPCChatSend.HelloNPC(GameCommonData.talkNpcID);
            _local2.desText = LanguageMgr.GetTranslation("很多空格正在加载中点点点");
            _local2.linkArr = [];
            sendNotification(NPCChatComList.SHOW_NPC_CHAT, _local7);
        }

    }
}//package GameUI.Modules.NPCChat.Command 
