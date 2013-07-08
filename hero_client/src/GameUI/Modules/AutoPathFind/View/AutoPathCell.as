//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.AutoPathFind.View {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import flash.geom.*;
    import Manager.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.Modules.AutoPlay.command.*;
    import GameUI.Modules.AutoPathFind.Datas.*;

    public class AutoPathCell extends Sprite {

        private var remark:String;
        private var txt1:TextField = null;
        private var txt2:TextField = null;
        private var mc:MovieClip;
        private var isNpc:Boolean;
        private var tag:String;
        private var id:uint;
        private var yPos:uint;
        private var txtContainer:Sprite = null;
        private var sceneName:String;
        private var xPos:uint;
        private var format:TextFormat = null;

        public function AutoPathCell(_arg1:uint, _arg2:String){
            id = _arg1;
            sceneName = _arg2;
            initData();
            initUI();
        }
        private function select(_arg1:MouseEvent):void{
            if (id != AutoPathData.currSelect){
                mc.visible = true;
                mc.gotoAndStop(1);
                AutoPathData.currSelect = id;
            };
            if (id != 0){
                UIFacade.GetInstance().sendNotification(EventList.Reset_AUTOPATH_UI);
            };
        }
        public function resetCell():void{
            outHandler(null);
        }
        private function outHandler(_arg1:MouseEvent):void{
            if (id != AutoPathData.currSelect){
                mc.visible = false;
            };
        }
        private function overHandler(_arg1:MouseEvent):void{
            if (id == AutoPathData.currSelect){
                return;
            };
            mc.visible = true;
            mc.gotoAndStop(2);
        }
        private function initData():void{
            var _local1:Object = (AutoPathData.autoPathDic[id] as Object);
            tag = _local1.Name;
            remark = _local1.Remark;
            xPos = _local1.X;
            yPos = _local1.Y;
            if (_local1.Type == 1){
                isNpc = false;
            } else {
                isNpc = true;
            };
        }
        private function initUI():void{
            txtContainer = new Sprite();
            this.addChild(txtContainer);
            txtContainer.addEventListener(Event.ADDED_TO_STAGE, addHandler);
        }
        private function removeHandler(_arg1:Event):void{
            txtContainer.removeEventListener(MouseEvent.DOUBLE_CLICK, go);
            txtContainer.removeEventListener(MouseEvent.MOUSE_OVER, overHandler);
            txtContainer.removeEventListener(MouseEvent.MOUSE_OUT, outHandler);
            txtContainer.removeEventListener(Event.REMOVED_FROM_STAGE, removeHandler);
            txt1 = null;
            txt2 = null;
            format = null;
        }
        private function go(_arg1:MouseEvent):void{
            if (GameCommonData.Player.IsAutomatism){
                PlayerController.EndAutomatism();
                UIFacade.UIFacadeInstance.sendNotification(AutoPlayEventList.CANCEL_AUTOPLAY_EVENT);
            };
            GameCommonData.isAutoPath = true;
            GameCommonData.IsFollow = false;
            if (isNpc){
                GameCommonData.targetID = this.id;
                GameCommonData.TaskTargetCommand = "";
                GameCommonData.Scene.MapPlayerTitleMove(new Point(xPos, yPos), 2, sceneName);
            } else {
                GameCommonData.targetID = -1;
                GameCommonData.TaskTargetCommand = "";
                GameCommonData.Scene.MapPlayerTitleMove(new Point(xPos, yPos), 0, GameCommonData.GameInstance.GameScene.GetGameScene.name);
            };
        }
        private function addHandler(_arg1:Event):void{
            showTxt();
            txtContainer.addEventListener(Event.REMOVED_FROM_STAGE, removeHandler);
        }
        private function showTxt():void{
            format = new TextFormat();
            format.size = 12;
            txt1 = new TextField();
            txt1.x = 54;
            txt1.width = 50;
            txt1.text = tag;
            txt1.textColor = 14074524;
            txt1.height = 16;
            txt1.setTextFormat(format);
            txt2 = new TextField();
            txt2.x = 4;
            txt2.width = 58;
            txt2.height = 16;
            txt2.textColor = 442892;
            txt2.text = remark;
            txt2.setTextFormat(format);
            mc = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("Selection");
            mc.width = 112;
            mc.height = 16;
            mc.x = 1;
            mc.visible = false;
            txtContainer.addChild(mc);
            txtContainer.addChild(txt1);
            txtContainer.addChild(txt2);
            txtContainer.height = 17;
            txtContainer.width = 136;
            txtContainer.mouseChildren = false;
            txtContainer.doubleClickEnabled = true;
            txtContainer.addEventListener(MouseEvent.DOUBLE_CLICK, go);
            txtContainer.addEventListener(MouseEvent.CLICK, select);
            txtContainer.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
            txtContainer.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
        }

    }
}//package GameUI.Modules.AutoPathFind.View 
