//Created by Action Script Viewer - http://www.buraks.com/asv
package Utils {
    import flash.display.*;
    import flash.geom.*;
    import flash.text.*;
    import com.greensock.*;
    import flash.filters.*;
    import GameUI.Modules.NPCChat.Proxy.*;
    import com.greensock.easing.*;

    public class EffectLib {

        private static var exps:TextField;
        private static var transArr:Array;

        private static function coms(_arg1:MovieClip):void{
            _arg1.gotoAndStop((_arg1.totalFrames - 1));
            if (_arg1.parent){
                _arg1.parent.removeChild(_arg1);
            };
        }
        private static function onexpCom(_arg1):void{
            if ((_arg1 is MovieClip)){
                _arg1.gotoAndStop(_arg1.totalFrames);
            };
            if (_arg1.parent){
                _arg1.parent.removeChild(_arg1);
            };
        }
        private static function onexpStart(_arg1):void{
            if ((_arg1 is MovieClip)){
                (_arg1 as MovieClip).visible = true;
            };
        }
        public static function foodsMove(_arg1:Array, _arg2:String=""):void{
            var _local5:Point;
            var _local6:DisplayObject;
            var _local7:BitmapData;
            var _local8:Bitmap;
            var _local9:Rectangle;
            var _local3:MovieClip = (GameCommonData.GameInstance.GameUI.getChildByName("mainScene")["btn_4"] as MovieClip);
            var _local4:MovieClip = (GameCommonData.GameInstance.GameUI.getChildByName("mainScene") as MovieClip);
            _local5 = _local4.localToGlobal(new Point(_local3.x, _local3.y));
            for each (_local6 in _arg1) {
                _local7 = new BitmapData(_local6.width, _local6.height, true, 0);
                _local7.draw(_local6);
                _local8 = new Bitmap(_local7);
                _local9 = _local6.getBounds(GameCommonData.GameInstance.MainStage);
                _local8.x = _local9.x;
                _local8.y = _local9.y;
                GameCommonData.GameInstance.GameUI.addChild(_local8);
                foodMove(_local8, _local5.x, _local5.y);
            };
        }
        private static function foodMoveonComplete(_arg1:Bitmap):void{
            if (_arg1.parent){
                _arg1.bitmapData.dispose();
                _arg1.parent.removeChild(_arg1);
            };
        }
        private static function numberFLoatComp(_arg1:TextField):void{
            if (_arg1){
                _arg1.text = parseInt(_arg1.text).toString();
            };
        }
        private static function checkAddEffect(_arg1:DisplayObject, _arg2:Stage):void{
            if (transArr.length < 2){
                return;
            };
            var _local3:DisplayObject = transArr[0];
            TweenLite.to(_arg1, 0.5, {
                x:int((((_arg2.stageWidth - _arg1.width) - _local3.width) / 2)),
                y:int(((_arg2.stageHeight - _local3.height) / 2))
            });
            if ((((_arg1.name == "vipshop")) || ((_arg1.name == "depot")))){
                _arg1.y = _local3.y;
            };
            if (_arg1.name == "role"){
                TweenLite.to(_local3, 0.5, {
                    x:(int((((_arg2.stageWidth + _arg1.width) - _local3.width) / 2)) - 17),
                    y:int(((_arg2.stageHeight - _local3.height) / 2))
                });
            } else {
                TweenLite.to(_local3, 0.5, {
                    x:int((((_arg2.stageWidth + _arg1.width) - _local3.width) / 2)),
                    y:int(((_arg2.stageHeight - _local3.height) / 2))
                });
            };
        }
        public static function addExpEffect(_arg1:int, _arg2:int, _arg3:int, _arg4:int, _arg5:String=null):void{
            var _local10:MovieClip;
            var _local11:TextFormat;
            if (TaskEffectConstData.loadswfTool == null){
                return;
            };
            var _local6:MovieClip = TaskEffectConstData.loadswfTool.GetClassByMovieClip("com.fla.addExp1");
            var _local7:MovieClip = TaskEffectConstData.loadswfTool.GetClassByMovieClip("com.fla.addExp2");
            var _local8:MovieClip = TaskEffectConstData.loadswfTool.GetClassByMovieClip("com.fla.addExp3");
            if (((((!(_local6)) || (!(_local7)))) || (!(_local8)))){
                return;
            };
            var _local9:Array = [_local6, _local7, _local8];
            for each (_local10 in _local9) {
                _local10.gotoAndPlay(1);
                _local10.visible = false;
                GameCommonData.GameInstance.GameUI.addChild(_local10);
            };
            _local9[0].visible = true;
            _local9[0].x = (_local9[1].x = _arg1);
            _local9[0].y = (_local9[1].y = _arg2);
            TweenLite.to(_local9[0], _local9[0].totalFrames, {
                useFrames:true,
                onComplete:onexpCom,
                onCompleteParams:[_local9[0]],
                onUpdate:onexpUpdate,
                onUpdateParams:[_local9[0]]
            });
            TweenLite.to(_local9[1], 1, {
                onStart:onexpStart,
                onStartParams:[_local9[1]],
                delay:0.5,
                x:_arg3,
                y:_arg4,
                onComplete:onexpCom,
                onCompleteParams:[_local9[1]]
            });
            (_local9[2] as MovieClip).x = (_arg3 + ((_local9[2] as MovieClip).width / 3));
            (_local9[2] as MovieClip).y = (_arg4 + ((_local9[2] as MovieClip).height / 3));
            TweenLite.to(_local9[2], 0.5, {
                onStart:onexpStart,
                onStartParams:[_local9[2]],
                delay:1.5,
                onComplete:onexpCom,
                onCompleteParams:[_local9[2]]
            });
            exps = new TextField();
            exps.filters = [new GlowFilter(0, 1)];
            _local11 = new TextFormat(null, "25");
            exps.defaultTextFormat = _local11;
            exps.textColor = 0xFF00;
            exps.x = (_arg3 - ((_local9[2] as MovieClip).width / 3));
            exps.y = ((_local9[2] as MovieClip).y - 100);
            exps.text = _arg5;
            exps.width = (exps.textWidth + 15);
            exps.height = (exps.textHeight + 5);
            GameCommonData.GameInstance.GameUI.addChild(exps);
            TweenLite.from(exps, 1, {
                ease:Expo.easeOut,
                visible:true,
                delay:1.5,
                scaleX:0,
                scaleY:0,
                y:_arg4,
                onComplete:onexpCom,
                onCompleteParams:[exps]
            });
        }
        private static function onexpUpdate(_arg1:MovieClip):void{
            if (GameCommonData.GameInstance.GameUI.contains(_arg1)){
                GameCommonData.GameInstance.GameUI.setChildIndex(_arg1, (GameCommonData.GameInstance.GameUI.numChildren - 1));
            };
        }
        public static function foodMove(_arg1:Bitmap, _arg2:int, _arg3:int):void{
            if ((((_arg1.width < 60)) && ((_arg1.height < 60)))){
                TweenLite.to(_arg1, 1, {
                    x:_arg2,
                    y:_arg3,
                    onComplete:foodMoveonComplete,
                    onCompleteParams:[_arg1],
                    onUpdate:foodMoveOnUpdate,
                    onUpdateParams:[_arg1]
                });
            } else {
                TweenLite.to(_arg1, 1, {
                    scaleX:0.5,
                    scaleY:0.5,
                    x:_arg2,
                    y:_arg3,
                    onComplete:foodMoveonComplete,
                    onCompleteParams:[_arg1],
                    onUpdate:foodMoveOnUpdate,
                    onUpdateParams:[_arg1]
                });
            };
        }
        private static function starts(_arg1:MovieClip):void{
            _arg1.gotoAndPlay(1);
        }
        public static function numberFloat(_arg1:TextField, _arg2:String):void{
            if (_arg1){
                TweenLite.to(_arg1, 2, {
                    text:parseInt(_arg2),
                    ease:Linear.easeIn,
                    onUpdate:numberFLoatComp,
                    onUpdateParams:[_arg1]
                });
            };
        }
        private static function foodMoveOnUpdate(_arg1:Bitmap):void{
            if (!_arg1.parent){
                return;
            };
            if (GameCommonData.GameInstance.GameUI.numChildren == 0){
                return;
            };
            GameCommonData.GameInstance.GameUI.setChildIndex(_arg1, (GameCommonData.GameInstance.GameUI.numChildren - 1));
        }
        public static function checkTranslationByClose(_arg1:DisplayObject, _arg2:Stage):void{
            var _local5:DisplayObject;
            var _local3:int = transArr.indexOf(_arg1);
            if (_local3 != -1){
                transArr.splice(_local3, 1);
            };
            var _local4:int;
            while (_local4 < transArr.length) {
                _local5 = transArr[_local4];
                TweenLite.to(_local5, 0.5, {
                    x:int(((_arg2.stageWidth - _local5.width) / 2)),
                    y:int(((_arg2.stageHeight - _local5.height) / 2))
                });
                _local4++;
            };
        }
        public static function moveExp(_arg1:MovieClip):void{
            _arg1.gotoAndStop(1);
            TweenLite.to(_arg1, (_arg1.totalFrames - 1), {
                delay:10,
                onStart:starts,
                onStartParams:[_arg1],
                onComplete:coms,
                onCompleteParams:[_arg1],
                useFrames:true
            });
        }
        public static function checkTranslationByShow(_arg1:DisplayObject, _arg2:Stage):void{
            var _local4:int;
            if (!_arg1){
                return;
            };
            if (!transArr){
                transArr = [];
            };
            var _local3:int = transArr.indexOf(_arg1);
            if (_arg1.name == "bag"){
                if (_local3 == -1){
                    transArr.unshift(_arg1);
                };
                _local4 = 1;
                while (_local4 < transArr.length) {
                    checkAddEffect(transArr[_local4], _arg2);
                    _local4++;
                };
            } else {
                if (_local3 == -1){
                    transArr.push(_arg1);
                };
                checkAddEffect(_arg1, _arg2);
            };
        }
        public static function textBlink(_arg1:TextField, _arg2:String=""):void{
            var tf:* = _arg1;
            var newInfo:String = _arg2;
            if (((((tf) && (!((tf.text == ""))))) && (!((tf.text == newInfo))))){
                //with ({}) {
                //    {}.com = function (){
                //        tf.textColor = 0xFFFFFF;
                //    };
                //};//geoffyan
                TweenMax.from(tf, 0.2, {
                    textColor:0xFF0000,
                    yoyo:true,
                    repeat:2,
                    onComplete:function (){
                        tf.textColor = 0xFFFFFF;
                    }
                });
            };
        }

    }
}//package Utils 
