//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Question.view.mediator {
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.ConstData.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import Utils.*;
    import GameUI.Modules.Question.model.*;

    public class IQuestionMediator extends Mediator {

        public static const NAME:String = "IQuestionMediator";

        private var bodymodel:Object = null;
        private var loadswfTool:LoadSwfTool = null;
        private var notifylist:Array;

        public function IQuestionMediator(){
            notifylist = [];
            super(NAME);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, QuestionEvents.QUESTION_REDAY, QuestionEvents.QUESTION_NEXT, QuestionEvents.QUESTION_RESULT, QuestionEvents.QUESTION_UPDATERANKLIST, QuestionEvents.QUESTION_SHOWVIEW, QuestionEvents.QUESTION_HIDEVIEW, QuestionEvents.QUESTION_USESPECIAL_RESULT, QuestionEvents.QUESTION_OVER, QuestionEvents.QUESTION_UPDATETEXT, EventList.RESIZE_STAGE]);
        }
        override public function handleNotification(_arg1:INotification):void{
            if (!QuestionConstData.CheckHasRight()){
                return;
            };
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    break;
                case EventList.RESIZE_STAGE:
                    break;
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
                loadswfTool = new LoadSwfTool(("Question.swf" + GameConfigData.ModuleLoadVerion), true);
                loadswfTool.sendShow = OnModelLoaded;
            };
        }
        private function OnModelLoaded(_arg1:Object):void{
            bodymodel = loadswfTool.loadInfo.content["GetInstance"]();
            facade.registerMediator((bodymodel as IMediator));
            facade.removeMediator(IQuestionMediator.NAME);
            while (notifylist.length > 0) {
                var _local2 = bodymodel;
                _local2["handleNotification"](notifylist.shift());
            };
        }

    }
}//package GameUI.Modules.Question.view.mediator 
