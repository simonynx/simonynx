//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine {
    import flash.display.*;
    import OopsFramework.*;
    import OopsEngine.GameComponents.*;
    import OopsEngine.Scene.*;

	/**
	 *游戏引擎类(游戏分层)
	 * @author wengliqiang
	 * 
	 */	
    public class Engine extends Game {

        public static var UILibrary:String;

        private var systemCursor:Sprite;
        private var gameUI:UIComponent;
        private var worldMap:Sprite;
        private var toolTipLayer:Sprite;
        private var gameScene:GameSceneComponent;

        public function Engine(_arg1:Stage=null){
            super(_arg1);
            this.gameScene = new GameSceneComponent(this);
            this.Components.Add(this.gameScene);
            this.gameUI = new UIComponent(this);
            this.Components.Add(this.gameUI);
            this.worldMap = new Sprite();
            this.worldMap.name = "WorldMap";
            this.worldMap.tabEnabled = false;
            this.worldMap.tabChildren = false;
            this.worldMap.mouseEnabled = true;
           
            this.toolTipLayer = new Sprite();
            this.toolTipLayer.name = "ToolTipLayer";
            this.toolTipLayer.mouseEnabled = false;
            
            this.systemCursor = new Sprite();
            this.systemCursor.mouseEnabled = false;
            this.systemCursor.mouseChildren = false;
			
			this.addChildAt(this.worldMap, 2);
			this.addChildAt(this.toolTipLayer, 3);
            this.addChildAt(this.systemCursor, 4);
        }
        public function get GameScene():GameSceneComponent{
            return (this.gameScene);
        }
        public function get CursorLayer():Sprite{
            return (this.toolTipLayer);
        }
        public function get GameUI():UIComponent{
            return (this.gameUI);
        }
        public function get TooltipLayer():Sprite{
            return (this.toolTipLayer);
        }
        public function get WorldMap():Sprite{
            return (this.worldMap);
        }

    }
}//package OopsEngine 
