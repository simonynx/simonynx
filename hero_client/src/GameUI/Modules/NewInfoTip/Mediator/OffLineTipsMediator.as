//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NewInfoTip.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.View.HButton.*;
    import flash.net.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import flash.external.*;

    public class OffLineTipsMediator extends Mediator {

        public static const NAME:String = "OffLineTipsMediator";

        private var reloadBtn:HLabelButton;
        private var m_bgloader:Loader = null;
        private var content:Sprite;

        public function OffLineTipsMediator(){
            super(NAME);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.SHOW_OFFLINETIP, EventList.RESIZE_STAGE]);
        }
        private function resetPos():void{
            content.x = ((GameCommonData.GameInstance.ScreenWidth - 400) / 2);
            content.y = ((GameCommonData.GameInstance.ScreenHeight - 168) / 2);
        }
        private function __clickHandler(_arg1:MouseEvent):void{
            ExternalInterface.call("location.reload");
        }
        private function __loadBgCompleteHandler(_arg1:Event):void{
            var _local2:DisplayObject = (_arg1.currentTarget.content as DisplayObject);
            _local2.x = 0;
            _local2.y = 0;
            content.addChildAt(_local2, 0);
        }
        private function init():void{
            var _local1:TextField;
            content = new Sprite();
            content.graphics.beginFill(0, 0.5);
            content.graphics.drawRect(-1000, -1000, 2000, 2000);
            content.graphics.endFill();
            _local1 = new TextField();
            _local1.text = LanguageMgr.GetTranslation("提示玩家掉线的各种原因");
            _local1.selectable = false;
            _local1.textColor = 0xFFFFFF;
            _local1.x = 162;
            _local1.y = 34;
            _local1.width = 265;
            _local1.height = 110;
            var _local2:TextFormat = _local1.defaultTextFormat;
            _local2.leading = 2;
            _local1.defaultTextFormat = _local2;
            content.addChild(_local1);
            reloadBtn = new HLabelButton(0);
            reloadBtn.label = LanguageMgr.GetTranslation("点击重新登陆");
            reloadBtn.x = 315;
            reloadBtn.y = 152;
            content.addChild(reloadBtn);
            reloadBtn.addEventListener(MouseEvent.CLICK, __clickHandler);
            loadBgImg();
        }
        override public function handleNotification(_arg1:INotification):void{
            switch (_arg1.getName()){
                case EventList.SHOW_OFFLINETIP:
                    if (content == null){
                        init();
                    };
                    resetPos();
                    GameCommonData.GameInstance.GameUI.addChild(content);
                    break;
                case EventList.RESIZE_STAGE:
                    if (content){
                        resetPos();
                    };
                    break;
            };
        }
        private function loadBgImg():void{
            m_bgloader = new Loader();
            m_bgloader.contentLoaderInfo.addEventListener(Event.COMPLETE, __loadBgCompleteHandler);
            m_bgloader.load(new URLRequest(((GameCommonData.GameInstance.Content.RootDirectory + "Resources/Img/offlinetipBg.png?v=") + GameConfigData.PlayerVersion)));
        }

    }
}//package GameUI.Modules.NewInfoTip.Mediator 
