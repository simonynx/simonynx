//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.GuildFight.View {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import com.greensock.*;
    import GameUI.View.HButton.*;
    import Net.RequestSend.*;

    public class GuildFightProcessView extends Sprite {

        private var _selfKeepTime:Number = 0;
        public var hideBtn:SimpleButton;
        public var bgView:MovieClip;
        public var overRemainTime:int = 0;
        public var state:int = 0;
        public var treasureKeepRemainTime:Number = 0;
        public var switchShowCallBack:Function;
        private var exitBtn:HLabelButton;
        private var _overTime:Number = 0;
        public var rightBtn:MovieClip;
        private var startHoldTime:Number = 0;
        private var _treasureKeepTime:Number = 0;
        public var isShowing:Boolean;
        private var _holded:Boolean;

        public function GuildFightProcessView(){
            initView();
            addEvents();
        }
        public function set overTime(_arg1:Number):void{
            this._overTime = _arg1;
        }
        public function set selfKeepTime(_arg1:Number):void{
            _selfKeepTime = _arg1;
        }
        public function resetPos():void{
            if (isShowing){
                this.x = (GameCommonData.GameInstance.ScreenWidth - bgView.width);
            } else {
                this.x = (GameCommonData.GameInstance.ScreenWidth - rightBtn.width);
            };
            this.y = 185;
        }
        public function hide():void{
            var toX:* = 0;
            var mc:* = null;
            toX = GameCommonData.GameInstance.ScreenWidth;
            mc = this;
            rightBtn.visible = false;
            bgView.visible = true;
            TweenLite.to(mc, 0.5, {
                x:toX,
                onComplete:function ():void{
                    toX = (GameCommonData.GameInstance.ScreenWidth - rightBtn.width);
                    rightBtn.visible = true;
                    bgView.visible = false;
                    TweenLite.to(mc, 0.5, {
                        x:toX,
                        onComplete:function ():void{
                            isShowing = false;
                        }
                    });
                }
            });
        }
        public function set holded(_arg1:Boolean):void{
            if ((((_holded == false)) && ((_arg1 == true)))){
                startHoldTime = TimeManager.Instance.Now().time;
            } else {
                if ((((_holded == true)) && ((_arg1 == false)))){
                    _selfKeepTime = (_selfKeepTime + Math.ceil(((TimeManager.Instance.Now().time - startHoldTime) / 1000)));
                    startHoldTime = 0;
                };
            };
            _holded = _arg1;
        }
        public function show():void{
            var toX:* = 0;
            var mc:* = null;
            bgView.visible = false;
            rightBtn.visible = true;
            toX = GameCommonData.GameInstance.ScreenWidth;
            GameCommonData.GameInstance.GameUI.addChild(this);
            mc = this;
            TweenLite.to(mc, 0.5, {
                x:toX,
                onComplete:function ():void{
                    rightBtn.visible = false;
                    bgView.visible = true;
                    toX = (GameCommonData.GameInstance.ScreenWidth - bgView.width);
                    TweenLite.to(mc, 0.5, {
                        x:toX,
                        onComplete:function ():void{
                            isShowing = true;
                        }
                    });
                }
            });
        }
        private function initView():void{
            bgView = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GuildFightProcessInfoAsset");
            addChild(bgView);
            rightBtn = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("TaskFollowRightBtn");
            addChild(rightBtn);
            rightBtn.titleTF.selectable = false;
            rightBtn.titleTF.mouseEnabled = false;
            rightBtn.titleTF.text = LanguageMgr.GetTranslation("城战信息");
            hideBtn = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByButton("RightButton");
            hideBtn.x = 189;
            hideBtn.y = 0;
            bgView.addChild(hideBtn);
            rightBtn.visible = false;
            bgView["overTimeTF"].text = LanguageMgr.GetTranslation("开始倒计时");
            bgView["guildNameTF"].text = "";
            bgView["keepTimeTF"].text = "0";
            bgView["seflKeepTimeTF"].text = "0";
            bgView.mouseEnabled = false;
            exitBtn = new HLabelButton();
            exitBtn.label = LanguageMgr.GetTranslation("离开");
            exitBtn.x = 160;
            exitBtn.y = 70;
            bgView.addChild(exitBtn);
            this.y = 185;
        }
        public function set keepTime(_arg1:Number):void{
            _treasureKeepTime = _arg1;
        }
        public function get selfKeepTime():Number{
            return (_selfKeepTime);
        }
        private function addEvents():void{
            exitBtn.addEventListener(MouseEvent.CLICK, __btnHandler);
            rightBtn.addEventListener(MouseEvent.CLICK, __btnHandler);
            hideBtn.addEventListener(MouseEvent.CLICK, __btnHandler);
        }
        public function get holded():Boolean{
            return (_holded);
        }
        public function Update():void{
            var _local1:Number;
            if (_overTime > 0){
                if (state == 0){
                    bgView["txt3TF"].text = LanguageMgr.GetTranslation("城战开始倒计时");
                    overRemainTime = (_overTime - (TimeManager.Instance.Now().time / 1000));
                    bgView["overTimeTF"].text = ((int((overRemainTime / 60)) + ":") + int((overRemainTime % 60)));
                } else {
                    if (state == 1){
                        bgView["txt3TF"].text = LanguageMgr.GetTranslation("城战结束倒计时");
                        overRemainTime = (_overTime - (TimeManager.Instance.Now().time / 1000));
                        bgView["overTimeTF"].text = ((int((overRemainTime / 60)) + ":") + int((overRemainTime % 60)));
                    } else {
                        if (state == 7){
                            bgView["txt3TF"].text = LanguageMgr.GetTranslation("城战已结束");
                            bgView["overTimeTF"].text = "";
                        };
                    };
                };
            };
            if (_treasureKeepTime > 0){
                treasureKeepRemainTime = ((TimeManager.Instance.Now().time / 1000) - _treasureKeepTime);
                bgView["keepTimeTF"].text = ((int((treasureKeepRemainTime / 60)) + ":") + int((treasureKeepRemainTime % 60)));
            } else {
                bgView["keepTimeTF"].text = LanguageMgr.GetTranslation("祭台上未被拔出");
            };
            if (state == 7){
                bgView["keepTimeTF"].text = "";
            };
            if (((holded) && (!((startHoldTime == 0))))){
                _local1 = (_selfKeepTime + Math.ceil(((TimeManager.Instance.Now().time - startHoldTime) / 1000)));
            } else {
                _local1 = _selfKeepTime;
            };
            bgView["seflKeepTimeTF"].text = ((int((_local1 / 60)) + ":") + int((_local1 % 60)));
        }
        public function set curDefGuildName(_arg1:String):void{
            bgView["guildNameTF"].text = _arg1;
        }
        private function __btnHandler(_arg1:MouseEvent):void{
            var str:* = null;
            var evt:* = _arg1;
            if (evt.currentTarget == exitBtn){
                str = LanguageMgr.GetTranslation("你是否要离开远古祭坛");
                UIFacade.GetInstance().sendNotification(EventList.SHOWALERT, {
                    comfrim:function ():void{
                        GuildFightSend.LevelGuildFight();
                    },
                    cancel:function ():void{
                    },
                    info:str,
                    title:"提 示"
                });
            } else {
                if (((hideBtn) || ((evt.currentTarget == rightBtn)))){
                    switchShowCallBack();
                };
            };
        }
        public function close():void{
            if (this.parent){
                this.parent.removeChild(this);
            };
        }
        public function get keepTime():Number{
            return (_treasureKeepTime);
        }

    }
}//package GameUI.Modules.GuildFight.View 
