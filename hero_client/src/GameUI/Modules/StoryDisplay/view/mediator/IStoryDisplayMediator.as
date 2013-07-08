//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.StoryDisplay.view.mediator {
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.Task.Model.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import Utils.*;
    import GameUI.Modules.StoryDisplay.model.data.*;
    import GameUI.Modules.StoryDisplay.model.vo.*;

    public class IStoryDisplayMediator extends Mediator {

        public static const NAME:String = "IStoryDisplayMediator";

        private var dataProxy:DataProxy;
        private var loadswfTool:LoadSwfTool = null;
        private var notifylist:Array;
        private var bodymodel:Object = null;

        public function IStoryDisplayMediator(){
            notifylist = [];
            super(NAME);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, EventList.SHOW_STORY_DISPLAY, EventList.CLOSE_STORY_DISPLAY, EventList.ENTERMAPCOMPLETE, EventList.RESIZE_STAGE, StoryDisplayConst.TASK_ACCEPT, StoryDisplayConst.TASK_COMPLETE, StoryDisplayConst.TASK_COMMIT, StoryDisplayConst.PLAYER_STOP, StoryDisplayConst.BAG_ITEM, EventList.TRANSTER_MAP]);
        }
        private function LoadModel(){
            if (loadswfTool == null){
                if (initStoryDisplayList()){
                    facade.removeMediator(IStoryDisplayMediator.NAME);
                    return;
                };
                loadswfTool = new LoadSwfTool(("StoryDisplay.swf" + GameConfigData.ModuleLoadVerion), true);
                loadswfTool.sendShow = OnModelLoaded;
            };
        }
        private function analyzeXML():void{
            var _local2:StoryVO;
            var _local3:XML;
            var _local4:XML;
            var _local5:XML;
            var _local6:XML;
            var _local7:XML;
            var _local1:XML = GameCommonData.StoryDisplayXMLs;
            GameCommonData.StoryDisplayList = [];
            for each (_local3 in _local1.elements()) {
                _local2 = new StoryVO();
                _local2.taskID = _local3.@taskID;
                if (_local2.taskID < StoryDisplayConst.minTaskId){
                    StoryDisplayConst.minTaskId = _local2.taskID;
                };
                if (_local2.taskID > StoryDisplayConst.maxTaskId){
                    StoryDisplayConst.maxTaskId = _local2.taskID;
                };
                _local2.taskProgress = _local3.@taskProgress.split(",");
                _local2.type = _local3.@type;
                _local2.count = _local3.@count;
                _local2.transcriptID = _local3.@transcriptID;
                _local2.tileList = {};
                for each (_local4 in _local3.tileRoot.elements()) {
                    _local2.tileList[int(_local4.@id)] = [];
                    for each (_local6 in _local4.elements()) {
                        _local2.tileList[int(_local4.@id)].push([int(_local6.@sceneID), int(_local6.@tileX), int(_local6.@tileY)]);
                    };
                };
                _local2.dialogList = {};
                for each (_local5 in _local3.dialogRoot.elements()) {
                    _local2.dialogList[int(_local5.@id)] = [];
                    for each (_local7 in _local5.elements()) {
                        _local2.dialogList[int(_local5.@id)].push([int(_local7.@id), String(_local7.@name), String(_local7.@picUrl), _local7]);
                    };
                };
                if (_local2.count <= GameCommonData.TaskInfoDic[_local2.taskID].storyCount){
                } else {
                    GameCommonData.StoryDisplayList.push(_local2);
                };
            };
            GameCommonData.StoryDisplayXMLs = null;
        }
        override public function handleNotification(_arg1:INotification):void{
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    break;
                case EventList.ENTERMAPCOMPLETE:
                    analyzeXML();
                    break;
                case EventList.RESIZE_STAGE:
                    if (!StoryDisplayConst.isInitView){
                        return;
                    };
                    LoadModel();
                    if (bodymodel != null){
                        var _local2 = bodymodel;
                        _local2["handleNotification"](_arg1);
                    } else {
                        notifylist.push(_arg1);
                    };
                    break;
                default:
                    LoadModel();
                    if (bodymodel != null){
                        _local2 = bodymodel;
                        _local2["handleNotification"](_arg1);
                    } else {
                        notifylist.push(_arg1);
                    };
            };
        }
        private function initStoryDisplayList():Boolean{
            var _local1:StoryVO;
            for each (_local1 in GameCommonData.StoryDisplayList) {
                if (TaskCommonData.CompleteTaskIdArray.indexOf(_local1.taskID) != -1){
                    GameCommonData.StoryDisplayList.splice(GameCommonData.StoryDisplayList.indexOf(_local1), 1);
                };
            };
            if (GameCommonData.StoryDisplayList.length == 0){
                return (true);
            };
            return (false);
        }
        private function OnModelLoaded(_arg1:Object):void{
            bodymodel = loadswfTool.loadInfo.content["GetInstance"]();
            facade.registerMediator((bodymodel as Mediator));
            facade.removeMediator(IStoryDisplayMediator.NAME);
            bodymodel["dataProxy"] = this.dataProxy;
            while (notifylist.length > 0) {
                var _local2 = bodymodel;
                _local2["handleNotification"](notifylist.shift());
            };
        }

    }
}//package GameUI.Modules.StoryDisplay.view.mediator 
