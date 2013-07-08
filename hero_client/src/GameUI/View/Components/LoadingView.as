//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.Components {
    import flash.display.*;

    public class LoadingView extends Sprite {

        private static var _instance:LoadingView;

        private var _loadingMc:MovieClip;
        private var _parentContainer:DisplayObjectContainer = null;
        private var _h:Number = 580;
        private var _w:Number = 1000;

        public function LoadingView(){
            this._loadingMc = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("LoadCircle");
            this._loadingMc.gotoAndStop(1);
            var _local1:Shape = new Shape();
            _local1.graphics.beginFill(0, 0);
            _local1.graphics.drawRect(0, 0, _w, _h);
            _local1.graphics.endFill();
            this.addChild(_local1);
        }
        public static function getInstance():LoadingView{
            if (_instance == null){
                _instance = new (LoadingView)();
            };
            return (_instance);
        }

        public function removeLoading():void{
            this._loadingMc.stop();
            if (((!((this._parentContainer == null))) && (_parentContainer.contains(this._loadingMc)))){
                _parentContainer.removeChild(this._loadingMc);
            } else {
                if (this.contains(this._loadingMc)){
                    this.removeChild(this._loadingMc);
                };
            };
            if (GameCommonData.GameInstance.GameUI.contains(this)){
                GameCommonData.GameInstance.GameUI.removeChild(this);
            };
        }
        public function showLoading(_arg1:DisplayObjectContainer=null):void{
            if (this.stage != null){
                return;
            };
            this._loadingMc.gotoAndPlay(1);
            this._parentContainer = _arg1;
            if (this._parentContainer == null){
                this.addChild(this._loadingMc);
                this._loadingMc.x = (GameCommonData.GameInstance.ScreenWidth / 2);
                this._loadingMc.y = (GameCommonData.GameInstance.ScreenHeight / 2);
            } else {
                this._parentContainer.addChild(this._loadingMc);
                this._loadingMc.x = Math.floor((this.parent.width / 2));
                this._loadingMc.y = Math.floor((this.parent.height / 2));
            };
            GameCommonData.GameInstance.GameUI.addChild(this);
        }

    }
}//package GameUI.View.Components 
