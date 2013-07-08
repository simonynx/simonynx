//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View {
    import flash.display.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;

    public class ShowMoney extends Sprite {

        public function ShowMoney(_arg1:String){
        }
        private static function setItemMask(_arg1:DisplayObject, _arg2:DisplayObjectContainer):void{
            var _local3:Shape = new Shape();
            _local3.graphics.beginFill(0xFFFFFF, 1);
            _local3.graphics.drawRect((_arg1.x - 1), _arg1.y, (_arg1.width + 2.6), (_arg1.height + 1));
            _local3.graphics.endFill();
            _local3.blendMode = BlendMode.ERASE;
            _arg2.addChild(_local3);
        }
        private static function testIsMoney(_arg1:String):Boolean{
            var _local3:int;
            var _local2:Array = ["se", "ss", "sc", "ce", "cs", "cc", "ab", "zb", "dq", "aa"];
            while (_local3 < _local2.length) {
                if (_arg1 == _local2[_local3]){
                    return (true);
                };
                _local3++;
            };
            return (false);
        }
        public static function ShowIcon(_arg1:DisplayObjectContainer, _arg2:TextField, _arg3:Boolean=false):void{
            var _local4:int;
            var _local5:Bitmap;
            var _local10:int;
            var _local11:int;
            var _local6:RegExp = /(\\[a-z]{2})/g;
            var _local7:Array = _arg2.text.split(_local6);
            var _local8:int;
            var _local9:int;
            if (_arg2.length > 0){
                _local8 = (2 - _arg2.getCharBoundaries(0).x);
                _local9 = (2 - _arg2.getCharBoundaries(0).y);
            };
            if (((!(_local7)) || ((_local7.length == 0)))){
                return;
            };
            if (_arg3){
                _local4 = (_arg1.numChildren - 1);
                while (_local4) {
                    if ((((((_arg1.getChildAt(_local4) is Bitmap)) || ((_arg1.getChildAt(_local4) is Shape)))) || ((_arg1.getChildAt(_local4) is MovieClip)))){
                        _arg1.removeChild(_arg1.getChildAt(_local4));
                    };
                    _local4--;
                };
            };
            while (_local10 < _local7.length) {
                if (_local6.test(_local7[_local10])){
                    if (_arg1.getChildByName(_local7[_local10].slice(1, 3))){
                        if (_arg1.contains(_arg1.getChildByName(_local7[_local10].slice(1, 3)))){
                            _arg1.removeChild(_arg1.getChildByName(_local7[_local10].slice(1, 3)));
                        };
                    };
                    if (!testIsMoney(_local7[_local10].slice(1, 3))){
                        return;
                    };
                    _local5 = new Bitmap();
                    _local5.bitmapData = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmapData(_local7[_local10].slice(1, 3));
                    _local5.width = 16;
                    _local5.height = 16;
                    _local5.x = (int(((_arg2.getCharBoundaries(_local11).x + _arg2.x) + 1)) + _local8);
                    _local5.y = int(((_arg2.getCharBoundaries(_local11).y + _arg2.y) - 1));
                    _local5.name = _local7[_local10].slice(1, 3);
                    _arg1.blendMode = BlendMode.LAYER;
                    setBmpMask(_local5, _arg1);
                    _arg1.addChild(_local5);
                    _local11 = (_local11 + _local7[_local10].length);
                } else {
                    _local11 = (_local11 + _local7[_local10].length);
                };
                _local10++;
            };
        }
        public static function showGoodCostItem(_arg1:DisplayObjectContainer, _arg2:TextField, _arg3:Boolean=true):void{
            var _local4:int;
            var _local9:MovieClip;
            var _local10:int;
            if (_arg3){
                _local4 = (_arg1.numChildren - 1);
                while (_local4) {
                    if ((((((_arg1.getChildAt(_local4) is Bitmap)) || ((_arg1.getChildAt(_local4) is Shape)))) || ((_arg1.getChildAt(_local4) is MovieClip)))){
                        _arg1.removeChild(_arg1.getChildAt(_local4));
                    };
                    _local4--;
                };
            };
            var _local5:Array = String(_arg2.text).split("_");
            if (((!(_local5)) || ((_local5.length == 0)))){
                return;
            };
            var _local6:String = _local5[1];
            var _local7:String = UIConstData.ItemDic[uint(_local6)].img;
            var _local8:ShopCostItem = new ShopCostItem(_local7);
            _local9 = new MovieClip();
            _local9.addChild(_local8);
            _local9.name = ("npcGoodToGood_" + _local6);
            _local10 = _local5[0].length;
            _arg2.text = (_local5[0] + "aa");
            _local9.x = int((_arg2.getCharBoundaries(_local10).x + _arg2.x));
            _local9.y = int(((_arg2.getCharBoundaries(_local10).y + _arg2.y) - 1));
            _arg1.blendMode = BlendMode.LAYER;
            setItemMask(_local9, _arg1);
            _arg1.addChild(_local9);
        }
        public static function ShowIcon2(_arg1:DisplayObjectContainer, _arg2:TextField, _arg3:Boolean=false):void{
            var _local4:int;
            var _local5:Bitmap;
            var _local10:int;
            var _local11:int;
            var _local6:RegExp = /(\\[a-z]{2})/g;
            var _local7:Array = _arg2.text.split(_local6);
            var _local8:int;
            var _local9:int;
            if (((!(_local7)) || ((_local7.length == 0)))){
                return;
            };
            if (_arg3){
                _local4 = (_arg1.numChildren - 1);
                while (_local4) {
                    if ((((((_arg1.getChildAt(_local4) is Bitmap)) || ((_arg1.getChildAt(_local4) is Shape)))) || ((_arg1.getChildAt(_local4) is MovieClip)))){
                        _arg1.removeChild(_arg1.getChildAt(_local4));
                    };
                    _local4--;
                };
            };
            while (_local10 < _local7.length) {
                if (_local6.test(_local7[_local10])){
                    if (_arg1.getChildByName(_local7[_local10].slice(1, 3))){
                        if (_arg1.contains(_arg1.getChildByName(_local7[_local10].slice(1, 3)))){
                            _arg1.removeChild(_arg1.getChildByName(_local7[_local10].slice(1, 3)));
                        };
                    };
                    if (!testIsMoney(_local7[_local10].slice(1, 3))){
                        return;
                    };
                    _local5 = new Bitmap();
                    _local5.bitmapData = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmapData(_local7[_local10].slice(1, 3));
                    _local5.width = 16;
                    _local5.height = 16;
                    _local5.x = (int(((_arg2.getCharBoundaries(_local11).x + _arg2.x) + 1)) + _local8);
                    _local5.y = int(((_arg2.getCharBoundaries(_local11).y + _arg2.y) - 1));
                    _local5.name = _local7[_local10].slice(1, 3);
                    _arg1.blendMode = BlendMode.LAYER;
                    setBmpMask(_local5, _arg1);
                    _arg1.addChild(_local5);
                    _local11 = (_local11 + _local7[_local10].length);
                } else {
                    _local11 = (_local11 + _local7[_local10].length);
                };
                _local10++;
            };
        }
        private static function setBmpMask(_arg1:Bitmap, _arg2:DisplayObjectContainer):void{
            var _local3:Shape = new Shape();
            _local3.graphics.beginFill(0xFFFFFF, 1);
            _local3.graphics.drawRect((_arg1.x - 1), _arg1.y, (_arg1.width + 2), (_arg1.height + 1));
            _local3.graphics.endFill();
            _local3.blendMode = BlendMode.ERASE;
            _arg2.addChild(_local3);
        }

    }
}//package GameUI.View 
