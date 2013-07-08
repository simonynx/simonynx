//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Transcript.Mediator {
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.ConstData.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import Utils.*;
    import GameUI.Modules.Transcript.Data.*;

    public class ITranscriptMediator extends Mediator {

        public static const NAME:String = "ITranscriptMediator";

        private var bodymodel:Object = null;
        private var loadswfTool:LoadSwfTool = null;
        private var notifylist:Array;

        public function ITranscriptMediator(){
            notifylist = [];
            super(NAME);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, TranscriptEvent.SHOW_ENEMY_INFO, EventList.RESIZE_STAGE, TranscriptEvent.SHOW_TRANSCRIPT_INFO, TranscriptEvent.SHOW_TARGET_RATE, TranscriptEvent.CLOSE_TRANSCRIPT_VIEW, TranscriptEvent.SHOW_TOWER_VIEW, TranscriptEvent.GO_NEXT_TOWER, TranscriptEvent.SHOW_HOLE_VIEW, TranscriptEvent.SHOW_TOWER_BTN, TranscriptEvent.SHOW_SELECT_TOWER_VIEW, TranscriptEvent.JUMP_TOWER, TranscriptEvent.UPDATE_TOWERVIEW, TranscriptEvent.SHOW_TESL_VIEW, TranscriptEvent.CLOSE_TESL_VIEW, TranscriptEvent.TESL_UPDATEDATA]);
        }
        override public function handleNotification(_arg1:INotification):void{
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    break;
                case TranscriptEvent.SHOW_TOWER_BTN:
                    break;
                case EventList.RESIZE_STAGE:
                    if (loadswfTool == null){
                        break;
                    };
                default:
                    LoadModel();
                    if (bodymodel != null){
                        var _local2 = bodymodel;
                        _local2["handleNotification"](_arg1);
                    } else {
                        notifylist.push(_arg1);
                    };
            };
        }
        private function LoadModel(){
            if (loadswfTool == null){
                loadswfTool = new LoadSwfTool(("Tower.swf" + GameConfigData.ModuleLoadVerion), true);
                loadswfTool.sendShow = OnModelLoaded;
            };
        }
        private function OnModelLoaded(_arg1:Object):void{
            bodymodel = loadswfTool.loadInfo.content["GetInstance"]();
            facade.registerMediator((bodymodel as Mediator));
            facade.removeMediator(ITranscriptMediator.NAME);
            while (notifylist.length > 0) {
                var _local2 = bodymodel;
                _local2["handleNotification"](notifylist.shift());
            };
        }

    }
}//package GameUI.Modules.Transcript.Mediator 
