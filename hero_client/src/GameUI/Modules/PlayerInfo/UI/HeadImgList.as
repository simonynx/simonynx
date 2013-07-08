//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.PlayerInfo.UI {
    import OopsEngine.Skill.*;
    import flash.utils.*;
    import GameUI.View.Components.*;

    public class HeadImgList extends UISprite {

        protected var imgSpace:uint = 3;
        protected var _dataPro:Array;
        protected var cells:Array;
        protected var cacheDic:Dictionary;

        public function HeadImgList(_arg1:uint=3){
            this.imgSpace = _arg1;
            this.cacheDic = new Dictionary();
            this.createChildren();
        }
        protected function getCell(_arg1:GameSkillBuff, _arg2:Boolean):ImgCell{
            var _local3:ImgCell;
            if (this.cacheDic[_arg1] != null){
                _local3 = this.cacheDic[_arg1];
            } else {
                _local3 = new ImgCell(_arg1, _arg2);
            };
            return (_local3);
        }
        public function get dataPro():Array{
            return (this._dataPro);
        }
        public function set dataPro(_arg1:Array):void{
            this._dataPro = _arg1;
            this.toRepaint();
        }
        protected function toRepaint():void{
            this.removeAllCell();
            this.createChildren();
        }
        protected function doLayout():void{
            var _local1:Array;
            var _local2:uint;
            var _local3:ImgCell;
            var _local4:ImgCell;
            var _local5:uint;
            for each (_local1 in this.cells) {
                if (_local1.length == 0){
                    return;
                };
                _local2 = 0;
                for each (_local4 in _local1) {
                    _local4.x = _local2;
                    _local4.y = _local5;
                    _local2 = (_local2 + (_local4.width + imgSpace));
                    _local3 = _local4;
                };
                _local5 = (_local5 + (_local3.height + imgSpace));
            };
        }
        protected function createChildren():void{
            var _local1:Array;
            var _local2:Array;
            var _local3:Object;
            var _local4:ImgCell;
            this.cells = [];
            for each (_local1 in this._dataPro) {
                _local2 = [];
                if (_local1.length == 0){
                } else {
                    for each (_local3 in _local1) {
                        if (!_local3.hasOwnProperty("info")){
                        } else {
                            _local4 = this.getCell(_local3["info"], _local3["isDeBuff"]);
                            _local2.push(_local4);
                            this.addChild(_local4);
                        };
                    };
                    this.cells.push(_local2);
                };
            };
            this.doLayout();
        }
        protected function removeAllCell():void{
            var _local1:Array;
            var _local2:*;
            for each (_local1 in this.cells) {
                for each (_local2 in _local1) {
                    if (this.contains(_local2)){
                        this.removeChild(_local2);
                        this.cacheDic[_local2.info] = _local2;
                    };
                };
            };
        }

    }
}//package GameUI.Modules.PlayerInfo.UI 
