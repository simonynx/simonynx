//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Team.UI {
    import flash.events.*;
    import flash.display.*;
    import GameUI.View.items.*;
    import GameUI.Modules.Team.Datas.*;
    import GameUI.View.HButton.*;
    import flash.filters.*;
    import GameUI.View.BaseUI.*;

    public class TeamItemCell extends Sprite {

        public static const TYPE_NEAR_NOTEAM:int = 4;
        public static const TYPE_NEAR_HASTEAM:int = 3;
        public static const TYPE_APPLY:int = 1;
        public static const TYPE_INVITE:int = 2;
        public static const TYPE_MEMBER:int = 0;

        private var _info:TeamVo;
        private var index:int = 0;
        public var item:MovieClip = null;
        private var _type:int;
        public var deleteBtn:HBaseButton;

        public function TeamItemCell(_arg1:MovieClip, _arg2:int, _arg3:int){
            this.item = _arg1;
            this.index = _arg2;
            this._type = _arg3;
            init();
            addEvents();
        }
        public function setFilter(_arg1:Boolean=true, _arg2:GlowFilter=null):void{
            if (_arg1){
                item.filters = [_arg2];
            } else {
                item.filters = null;
            };
        }
        public function setLeaderMc(_arg1:Boolean):void{
            item.leaderMc.visible = _arg1;
        }
        private function __mouseOutHandler(_arg1:MouseEvent):void{
            item.mcMouseOver.visible = false;
        }
        private function update():void{
            var _local1:FaceItem = new FaceItem(info.Face.toString(), item.mcMemberPhoto, "face", 1);
            _local1.addEventListener(Event.COMPLETE, loadFaceCompleteHandler);
            setPhoto(_local1);
            setTxtByName("txtMemberName", ((LanguageMgr.GetTranslation("队长") + ":") + info.leaderName));
            setTxtByName("txtRoleLevel", ((LanguageMgr.GetTranslation("平均等级") + ":Lv") + info.teamLevel));
            setTxtByName("txtBusiness", (((("<font color=\"#BB950F\">" + LanguageMgr.GetTranslation("人数")) + ":</font><font color=\"#FFFFFF\">") + info.curCnt) + "/5</font>"));
            item.autoJoinBtn.visible = info.isAutoJoinMode;
        }
        private function init():void{
            item.txtMemberName.mouseEnabled = false;
            item.txtBusiness.mouseEnabled = false;
            item.txtRoleLevel.mouseEnabled = false;
            item.leaderMc.mouseEnabled = false;
            item.mcMouseDown.visible = false;
            item.mcMouseOver.visible = false;
            item.leaderMc.visible = false;
            deleteBtn = new HBaseButton(item.deleteBtn);
            deleteBtn.useBackgoundPos = true;
            item.addChild(deleteBtn);
            if ((((this.type == TYPE_NEAR_HASTEAM)) || ((this.type == TYPE_NEAR_NOTEAM)))){
                deleteBtn.visible = false;
            };
            this.addChild(item);
        }
        private function __mouseOverHandler(_arg1:MouseEvent):void{
            item.mcMouseOver.visible = true;
        }
        private function setTxtByName(_arg1:String, _arg2:String=""):void{
            if (_arg1){
                item[_arg1].htmlText = _arg2;
            };
        }
        public function set info(_arg1:TeamVo):void{
            this._info = _arg1;
            update();
        }
        public function dispose():void{
            removeEvents();
            if (parent){
                parent.removeChild(this);
            };
            if (deleteBtn){
                deleteBtn.dispose();
                deleteBtn = null;
            };
        }
        private function addEvents():void{
            addEventListener(MouseEvent.MOUSE_OVER, __mouseOverHandler);
            addEventListener(MouseEvent.MOUSE_OUT, __mouseOutHandler);
            deleteBtn.addEventListener(MouseEvent.CLICK, __deleteHandler);
        }
        private function getTxtByName(_arg1:String):String{
            if (_arg1){
                return (item[_arg1].text);
            };
            return ("");
        }
        public function get info():TeamVo{
            return (this._info);
        }
        private function setPhoto(_arg1:FaceItem):void{
            var _local2:int;
            var _local3:ItemBase;
            if (_arg1){
                _arg1.x = 7;
                _arg1.y = 7;
                _arg1.width = 55;
                _arg1.height = 50;
                item.addChild(_arg1);
            };
        }
        private function loadFaceCompleteHandler(_arg1:Event):void{
            setPhoto((_arg1.currentTarget as FaceItem));
        }
        public function get type():int{
            return (this._type);
        }
        private function removeEvents():void{
            removeEventListener(MouseEvent.MOUSE_OVER, __mouseOverHandler);
            removeEventListener(MouseEvent.MOUSE_OUT, __mouseOutHandler);
            deleteBtn.removeEventListener(MouseEvent.CLICK, __deleteHandler);
        }
        private function __deleteHandler(_arg1:MouseEvent):void{
        }

    }
}//package GameUI.Modules.Team.UI 
