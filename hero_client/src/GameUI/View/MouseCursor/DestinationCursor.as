//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.MouseCursor {
    import flash.display.*;
    import Utils.*;

    public class DestinationCursor {

        private static var Instance:DestinationCursor;
        private static var movetoLoadComplate:Boolean;
        private static var mcMoveto:MovieClip;

        private var loadswfTool:LoadSwfTool = null;
        private var sceneLayer:DisplayObjectContainer;
        public var desIcon:Sprite;

        public function DestinationCursor(){
            if (Instance != null){
                throw (new Error("单体"));
            };
            desIcon = new Sprite();
            if (loadswfTool == null){
                loadswfTool = new LoadSwfTool(GameConfigData.MoveToSwf, false);
                loadswfTool.sendShow = sendShow;
            } else {
                if (movetoLoadComplate){
                    desIcon.addChild(mcMoveto);
                    this.desIcon.mouseChildren = false;
                    this.desIcon.mouseEnabled = false;
                };
            };
        }
        public static function getInstance():DestinationCursor{
            if (Instance == null){
                Instance = new (DestinationCursor)();
            };
            return (Instance);
        }

        public function hide():void{
            this.desIcon.visible = false;
        }
        private function sendShow(_arg1:DisplayObject):void{
            if (movetoLoadComplate == false){
                movetoLoadComplate = true;
            };
            mcMoveto = loadswfTool.GetClassByMovieClip("MoveTo");
            this.desIcon.addChild(mcMoveto);
            this.desIcon.mouseChildren = false;
            this.desIcon.mouseEnabled = false;
        }
        public function show():void{
            this.desIcon.x = sceneLayer.mouseX;
            this.desIcon.y = sceneLayer.mouseY;
            this.desIcon.visible = true;
        }
        public function setParent(_arg1:DisplayObjectContainer):void{
            this.sceneLayer = _arg1;
            this.sceneLayer.addChild(this.desIcon);
            hide();
        }

    }
}//package GameUI.View.MouseCursor 
