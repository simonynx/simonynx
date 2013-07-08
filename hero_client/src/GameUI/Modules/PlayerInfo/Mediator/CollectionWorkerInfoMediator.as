//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.PlayerInfo.Mediator {
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import OopsFramework.*;
    import OopsEngine.Role.*;
    import OopsEngine.Scene.StrategyElement.*;
    import flash.geom.*;
    import OopsEngine.Graphics.Animation.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.View.*;
    import OopsEngine.Scene.StrategyElement.Person.*;
    import GameUI.Modules.PlayerInfo.Command.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Utils.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Hint.Events.*;

    public class CollectionWorkerInfoMediator extends Mediator implements IUpdateable {

        public static const NAME:String = "CollectionWorkerInfoMediator";

        private var localMS:Number;
        private var isCollect:Boolean = false;
        private var dataProxy:DataProxy;
        private var timeCounter:Number = 5000;
        private var isGrabPet:Boolean = false;
        private var role:GameRole;

        public function CollectionWorkerInfoMediator(_arg1:String=null, _arg2:Object=null){
            super(NAME, _arg2);
        }
        override public function listNotificationInterests():Array{
            return ([PlayerInfoComList.INIT_PLAYERINFO_UI, PlayerInfoComList.HIDE_COLLECTIONWORKERINFO_UI, PlayerInfoComList.SELECT_ELEMENT_COLLECT, PlayerInfoComList.START_COLLECT, PlayerInfoComList.CANCEL_COLLECT, PlayerInfoComList.REMOVE_TARGET_COLLECT, EventList.RESIZE_STAGE, PlayerInfoComList.CAPTURE_PET]);
        }
        public function get view():MovieClip{
            return ((getViewComponent() as MovieClip));
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:GameElementAnimal;
            var _local3:Boolean;
            var _local4:GameRole;
            var _local5:InventoryItemInfo;
            switch (_arg1.getName()){
                case PlayerInfoComList.INIT_PLAYERINFO_UI:
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    facade.sendNotification(EventList.GETRESOURCE, {
                        type:UIConfigData.MOVIECLIP,
                        mediator:this,
                        name:"CollectProgressAsset"
                    });
                    this.view.mouseEnabled = false;
                    view.mouseEnabled = false;
                    view.mouseChildren = false;
                    initView();
                    break;
                case PlayerInfoComList.SELECT_ELEMENT_COLLECT:
                    _local2 = (_arg1.getBody() as GameElementAnimal);
                    if (isCollect){
                        if (((role) && (!((role.Id == _local2.Role.Id))))){
                            sendNotification(PlayerInfoComList.CANCEL_COLLECT, false);
                        };
                    };
                    break;
                case PlayerInfoComList.HIDE_COLLECTIONWORKERINFO_UI:
                    this.role = null;
                    if (GameCommonData.Scene.gameScenePlay.contains(this.view)){
                        GameCommonData.Scene.gameScenePlay.removeChild(this.view);
                    };
                    GameCommonData.GameInstance.GameUI.Elements.Remove(this);
                    isCollect = false;
                    isGrabPet = false;
                    dataProxy.IsCollecting = false;
                    dataProxy.IsGrabPeting = false;
                    localMS = 0;
                    proess(0);
                    break;
                case EventList.RESIZE_STAGE:
                    break;
                case PlayerInfoComList.START_COLLECT:
                    if (GameCommonData.Player.Role.MountSkinID > 0){
                        _local5 = BagData.getItemByType(GameCommonData.Player.Role.MountSkinID);
                        if (_local5 != null){
                            BagInfoSend.ItemUse(_local5.ItemGUID);
                        };
                    };
                    if (GameCommonData.Player.Role.IsMediation){
                        PlayerController.BeginMediation(false);
                    };
                    _local2 = (_arg1.getBody() as GameElementAnimal);
                    if (_local2 == null){
                        return;
                    };
                    if (GameCommonData.GameInstance.GameUI.Elements.IndexOf(this) == -1){
                        GameCommonData.GameInstance.GameUI.Elements.Add(this);
                    };
                    if (!isCollect){
                        isCollect = true;
                        role = _local2.Role;
                        this.updateInfo();
                        this.view.x = (_local2.X - ((view.width - _local2.width) / 2));
                        this.view.y = (_local2.Y + _local2.height);
                        GameCommonData.Scene.gameScenePlay.addChild(this.view);
                        dataProxy.IsCollecting = true;
                        localMS = 0;
                        view.lightAsset.visible = true;
                        GameCommonData.IsCollected = false;
                        MessageTip.show(LanguageMgr.GetTranslation("开始采集"));
                    };
                    break;
                case PlayerInfoComList.CANCEL_COLLECT:
                    _local3 = (_arg1.getBody() as Boolean);
                    if (isCollect){
                        MessageTip.show(LanguageMgr.GetTranslation("取消采集"));
                        sendNotification(PlayerInfoComList.HIDE_COLLECTIONWORKERINFO_UI);
                    } else {
                        if (isGrabPet){
                            if (_local3){
                                return;
                            };
                            MessageTip.show(LanguageMgr.GetTranslation("取消抓宠"));
                            sendNotification(PlayerInfoComList.HIDE_COLLECTIONWORKERINFO_UI);
                        };
                    };
                    this.role = null;
                    if (GameCommonData.Scene.gameScenePlay.contains(this.view)){
                        localMS = 0;
                        proess(0);
                        GameCommonData.Scene.gameScenePlay.removeChild(this.view);
                    };
                    break;
                case PlayerInfoComList.REMOVE_TARGET_COLLECT:
                    _local4 = (_arg1.getBody() as GameRole);
                    if (((role) && ((role.Id == _local4.Id)))){
                        if (isCollect){
                            MessageTip.show(LanguageMgr.GetTranslation("被别人抢先一步采集"));
                        };
                        sendNotification(PlayerInfoComList.HIDE_COLLECTIONWORKERINFO_UI);
                    };
                    break;
                case PlayerInfoComList.CAPTURE_PET:
                    _local2 = (_arg1.getBody() as GameElementAnimal);
                    if (_local2 == null){
                        MessageTip.popup(LanguageMgr.GetTranslation("捕捉对象已不存在"));
                        return;
                    };
                    if (_local2.Role.Title != LanguageMgr.GetTranslation("可抓捕")){
                        MessageTip.show(LanguageMgr.GetTranslation("它不是可抓宠物"));
                        return;
                    };
                    if (!BagData.isHasItem(70500001)){
                        MessageTip.show(LanguageMgr.GetTranslation("缺乏抓捕道具"));
                        return;
                    };
                    if (GameCommonData.Player.Role.MountSkinID > 0){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("乘骑时不能抓宠"),
                            color:0xFFFF00
                        });
                        return;
                    };
                    if (GameCommonData.GameInstance.GameUI.Elements.IndexOf(this) == -1){
                        GameCommonData.GameInstance.GameUI.Elements.Add(this);
                    };
                    if (!isGrabPet){
                        isGrabPet = true;
                        role = _local2.Role;
                        this.updateInfo();
                        this.view.x = (_local2.X - ((view.width - _local2.width) / 2));
                        this.view.y = (_local2.Y + _local2.height);
                        GameCommonData.Scene.gameScenePlay.addChild(this.view);
                        dataProxy.IsGrabPeting = true;
                        localMS = 0;
                        view.lightAsset.visible = true;
                        MessageTip.show(LanguageMgr.GetTranslation("开始抓宠"));
                    };
                    break;
            };
        }
        public function get UpdateOrderChanged():Function{
            return (null);
        }
        public function get EnabledChanged():Function{
            return (null);
        }
        private function initView():void{
            view.progressMc.mask = view.progressMask;
            view.TargetNameTF.text = "";
            view.load_txt.text = "";
            proess(0);
        }
        private function updateInfo():void{
            if (isCollect){
                if (role){
                    view.TargetNameTF.text = role.Name;
                    timeCounter = (role.Level * 1000);
                };
            } else {
                if (isGrabPet){
                    if (role){
                        view.TargetNameTF.text = role.Name;
                        timeCounter = 10000;
                    };
                };
            };
        }
        private function completeHandler():void{
            SoundManager.getInstance().playLoadSound(GameConfigData.GameCommonAudio, "completeSound");
            view.lightAsset.visible = false;
            PlayerActionSend.CollectObject(role.Id);
            setCObjectMoveEffect();
            GameCommonData.IsCollected = true;
            sendNotification(PlayerInfoComList.HIDE_COLLECTIONWORKERINFO_UI);
        }
        public function get Enabled():Boolean{
            return (true);
        }
        private function completeGrabHandler():void{
            CombatController.ReserveSkillAttack(900201, role.Id, role.TileX, role.TileY, 0, 0);
        }
        public function set EnabledChanged(_arg1:Function):void{
        }
        private function setCObjectMoveEffect():void{
            var _local1:GameElementNPCSkin = (role.CurrentPlayer.skins as GameElementNPCSkin);
            if (!_local1){
                return;
            };
            var _local2:AnimationPlayer = _local1.GetAction();
            if (!_local2){
                return;
            };
            var _local3:BitmapData = new BitmapData(_local2.width, _local2.height, true, 0);
            trace(_local3.width, _local3.height);
            _local3.draw(_local1.GetAction());
            var _local4:Bitmap = new Bitmap(_local3);
            var _local5:Point = new Point(_local2.x, _local2.y);
            _local5 = _local1.localToGlobal(_local5);
            _local4.x = _local5.x;
            _local4.y = _local5.y;
            GameCommonData.GameInstance.GameUI.addChild(_local4);
            var _local6:MovieClip = (GameCommonData.GameInstance.GameUI.getChildByName("mainScene")["btn_4"] as MovieClip);
            var _local7:MovieClip = (GameCommonData.GameInstance.GameUI.getChildByName("mainScene") as MovieClip);
            var _local8:Point = _local7.localToGlobal(new Point(_local6.x, _local6.y));
            EffectLib.foodMove(_local4, _local8.x, _local8.y);
        }
        public function set UpdateOrderChanged(_arg1:Function):void{
        }
        public function get UpdateOrder():int{
            return (0);
        }
        public function Update(_arg1:GameTime):void{
            if ((((isCollect == false)) && ((isGrabPet == false)))){
                return;
            };
            localMS = (localMS + _arg1.ElapsedGameTime);
            proess(((localMS * 1) / timeCounter));
            if (localMS > timeCounter){
                if (isCollect){
                    isCollect = false;
                    completeHandler();
                } else {
                    if (isGrabPet){
                        isGrabPet = false;
                        completeGrabHandler();
                        trace("发送");
                    };
                };
            };
        }
        private function proess(_arg1:Number):void{
            _arg1 = ((_arg1 > 1)) ? 1 : _arg1;
            view.load_txt.text = (int((100 * _arg1)) + "%");
            view.progressMask.width = (_arg1 * view.progressMc.width);
            view.lightAsset.x = (view.progressMask.x + view.progressMask.width);
        }

    }
}//package GameUI.Modules.PlayerInfo.Mediator 
