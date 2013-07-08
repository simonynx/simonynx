//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.BaseUI {
    import flash.events.*;
    import flash.text.*;

    public class HConfirmDialog extends HConfirmFrame {

        public static var OK_LABEL:String = "确 定";
        public static var CANCEL_LABEL:String = "取 消";

        private var doOkFun:Function;
        private var doCancelFun:Function;

        public function HConfirmDialog(_arg1:String, _arg2:String, _arg3:Boolean=true, _arg4:Function=null, _arg5:Function=null, _arg6:String=null, _arg7:String=null, _arg8:Number=0){
            var _local10:*;
            super();
            var _local9:* = _arg4;
            _local10 = _arg8;
            titleText = _arg1;
            centerTitle = true;
            _contentTextField.htmlText = _arg2;
            cancelLabel = (_arg7) ? _arg7 : CANCEL_LABEL;
            okLabel = (_arg6) ? _arg6 : OK_LABEL;
            alphaGound = _arg3;
            blackGound = false;
            showCancel = true;
            stopKeyEvent = true;
            doCancelFun = _arg5;
            doOkFun = _arg4;
            okFunction = okFunc;
            cancelFunction = defaultcancelCall;
            if (_local10 != 0){
                if (_local10 > (_contentTextField.width + 100)){
                    setSize(_local10, (_contentTextField.height + 110));
                } else {
                    setSize((_contentTextField.width + 100), (_contentTextField.height + 110));
                };
            } else {
                if ((_contentTextField.width + 100) < 270){
                    setSize(270, (_contentTextField.height + 110));
                } else {
                    setSize((_contentTextField.width + 100), (_contentTextField.height + 110));
                };
            };
            buttonGape = 50;
        }
        public static function show(_arg1:String, _arg2:String, _arg3:Boolean=true, _arg4:Function=null, _arg5:Function=null, _arg6:Boolean=true, _arg7:String=null, _arg8:String=null, _arg9:Number=0, _arg10:Boolean=true):HConfirmDialog{
            var _local11:HConfirmDialog;
            _local11 = new HConfirmDialog(_arg1, _arg2, _arg3, _arg4, _arg5, _arg7, _arg8, _arg9);
            _local11.IsSetFouse = _arg10;
            _local11.centerFrame();
            GameCommonData.GameInstance.GameUI.addChild(_local11);
            return (_local11);
        }

        private function okFunc(){
            if (doOkFun != null){
                dispose();
                doOkFun();
                doCancelFun = null;
                doOkFun = null;
            } else {
                dispose();
                doCancelFun = null;
                doOkFun = null;
            };
        }
        override protected function __addToStage(_arg1:Event):void{
            _arg1.stopImmediatePropagation();
            super.__addToStage(_arg1);
        }
        private function defaultcancelCall(){
            if (doCancelFun != null){
                dispose();
                doCancelFun();
                doCancelFun = null;
                doOkFun = null;
            } else {
                dispose();
                doCancelFun = null;
                doOkFun = null;
            };
        }
        public function get contentTextField():TextField{
            return (_contentTextField);
        }
        override protected function __closeClick(_arg1:MouseEvent):void{
            if (doCancelFun != null){
                dispose();
                doCancelFun();
                doCancelFun = null;
                doOkFun = null;
            } else {
                dispose();
                doCancelFun = null;
                doOkFun = null;
            };
        }

    }
}//package GameUI.View.BaseUI 
