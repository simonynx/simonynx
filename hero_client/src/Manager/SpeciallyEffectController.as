//Created by Action Script Viewer - http://www.buraks.com/asv
package Manager {
    import flash.display.*;
    import OopsEngine.Skill.*;
    import OopsFramework.*;
    import OopsEngine.Scene.StrategyElement.*;
    import flash.geom.*;
    import flash.utils.*;
    import com.greensock.*;
    import OopsEngine.AI.PathFinder.*;
    import Utils.*;
    import OopsFramework.Content.Provider.*;
    import com.greensock.easing.*;

    public class SpeciallyEffectController implements IUpdateable {

        public static const EFFECT_MEDIATION_TOP:String = "MEDIATION_TOP";
        public static const EFFECT_MEDIATION:String = "MEDIATION";
        public static const changeSkinEffectUrl:String = (GameCommonData.GameInstance.Content.RootDirectory + "Resources/Effect/ChangeSkin.swf");
        public static const EFFECT_FIREWORKS:String = "QCYH";

        private static var _instance:SpeciallyEffectController;

        private var changeSkinEffectRes:GameEffectResource;
        public var targetLight:GameEffectResource;
        public var enableScreenShake:Boolean = true;
        private var eggBreakEffectRes:GameEffectResource;
        private var seresDic:Dictionary;
        private var eggBreakEffectAnimation:SkillAnimation;
        private var dieDeffDic:Dictionary;
        public var autoMc:Bitmap;
        private var rectView:Sprite;
        private var _screenShaking:Boolean = false;
        private var deadEffectResDic:Dictionary;
        private var rainEffect:Sprite;
        public var playCahangeEffectloaded:Boolean = false;
        private var updateArr:Array;
        private var addPointEffect:MovieClip;
        private var fireEffect:Sprite;
        private var changeSkinEffectAnimation:SkillAnimation;
        public var targetLightEffect:SkillAnimation;
        private var fireLoadswfTool:LoadSwfTool;

        public function SpeciallyEffectController(){
            updateArr = [];
            seresDic = new Dictionary();
            super();
            initDieDeffDic();
            if (GameCommonData.GameInstance.GameUI.Elements.IndexOf(this) == -1){
                GameCommonData.GameInstance.GameUI.Elements.Add(this);
            };
        }
        public static function endCircle():void{
            if (GameCommonData.Scene.loadCircle != null){
                GameCommonData.GameInstance.GameUI.removeChild(GameCommonData.Scene.loadCircle);
                GameCommonData.Scene.loadCircle = null;
            };
        }
        public static function startCircle():void{
            var _local1:MovieClip;
            if (GameCommonData.Scene.loadCircle == null){
                GameCommonData.Scene.loadCircle = new Sprite();
                GameCommonData.Scene.loadCircle.graphics.beginFill(0, 0.3);
                GameCommonData.Scene.loadCircle.graphics.drawRect(-2000, -2000, 4000, 4000);
                GameCommonData.Scene.loadCircle.graphics.endFill();
                _local1 = (GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("LoadCircle") as MovieClip);
                GameCommonData.Scene.loadCircle.addChild(_local1);
                _local1.x = (GameCommonData.GameInstance.ScreenWidth / 2);
                _local1.y = (GameCommonData.GameInstance.ScreenHeight / 2);
                GameCommonData.GameInstance.GameUI.addChild(GameCommonData.Scene.loadCircle);
            };
        }
        public static function getInstance():SpeciallyEffectController{
            if (_instance == null){
                _instance = new (SpeciallyEffectController)();
            };
            return (_instance);
        }

        public function showAutoMc(_arg1:int=0):void{
            if (autoMc){
                if (autoMc.parent){
                    autoMc.parent.removeChild(autoMc);
                };
                autoMc = null;
            };
            if (_arg1 == 1){
                autoMc = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmap("AutoPlay");
                autoMc.x = ((GameCommonData.GameInstance.ScreenWidth - autoMc.width) / 2);
                autoMc.y = 100;
                GameCommonData.GameInstance.TooltipLayer.addChild(autoMc);
            } else {
                if (_arg1 == 2){
                    autoMc = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmap("AutoPath");
                    autoMc.x = ((GameCommonData.GameInstance.ScreenWidth - autoMc.width) / 2);
                    autoMc.y = 100;
                    GameCommonData.GameInstance.TooltipLayer.addChild(autoMc);
                };
            };
        }
        public function get UpdateOrderChanged():Function{
            return (null);
        }
        public function createAfterimg(_arg1:Bitmap):void{
            var bm:* = null;
            var sprite:* = null;
            var bitmap:* = _arg1;
            if (GameCommonData.Player.gameScene == null){
                return;
            };
            bm = new Bitmap(bitmap.bitmapData);
            sprite = new Sprite();
            bm.x = (-(bm.width) / 2);
            bm.y = (-(bm.height) / 2);
            sprite.addChild(bm);
            var rc:* = bitmap.getBounds(GameCommonData.Player.gameScene);
            sprite.x = (rc.x + (rc.width / 2));
            sprite.y = (rc.y + (rc.height / 2));
            GameCommonData.Player.gameScene.addChild(sprite);
//            with ({}) {
//                {}.onComHandler = function ():void{
//                    if (sprite.parent){
//                        sprite.parent.removeChild(sprite);
//                    };
//                    if (sprite.contains(bm)){
//                        sprite.removeChild(bm);
//                        sprite = null;
//                        bm = null;
//                    };
//                };
//            };//geoffyan
            var onComHandler:* = function ():void{
                if (sprite.parent){
                    sprite.parent.removeChild(sprite);
                };
                if (sprite.contains(bm)){
                    sprite.removeChild(bm);
                    sprite = null;
                    bm = null;
                };
            };
            sprite.alpha = 0.6;
            TweenLite.to(sprite, 2, {
                width:0,
                height:0,
                alpha:0,
                onComplete:onComHandler
            });
        }
        public function hitBack(_arg1:GameElementAnimal, _arg2:Point, _arg3:Number, _arg4:Function):void{
            var _local5:* = null;
            var _local6:* = null;
            var _local7:* = null;
            var _local8:GameElementAnimal = _arg1;
            var _local9:Point = _arg2;
            var _local10:Number = _arg3;
            var _local11:Function = _arg4;
            _local5 = MapTileModel.GetTilePointToStage(_local9.x, _local9.y);
            var _local12:Point = new Point(_local8.x, _local8.y);
            _local6 = new Point(_local5.x, _local5.y);
            var _local13:Number = Point.distance(_local12, _local6);
            var _local14:Number = (_local13 / _local10);
            _local7 = TweenMax.to(_local8, _local14, {
                x:_local6.x,
                y:_local6.y,
                ease:Linear.easeIn,
                onComplete:_local11
            });
        }
        public function set UpdateOrderChanged(_arg1:Function):void{
        }
        public function EggBreak(_arg1:GameElementAnimal):void{
            var eggEffectPlayCompleteHandler:* = null;
            var animal:* = _arg1;
            eggEffectPlayCompleteHandler = function (_arg1:SkillAnimation):void{
                if (((_arg1) && (_arg1.parent))){
                    _arg1.parent.removeChild(_arg1);
                };
                if (updateArr.indexOf(_arg1) != -1){
                    updateArr.splice(updateArr.indexOf(_arg1), 1);
                };
            };
            var deadEffectLoadComplete:* = function (_arg1:GameEffectResource):void{
                if (eggBreakEffectAnimation == null){
                    eggBreakEffectAnimation = _arg1.GetAnimation();
                };
                if (((((eggBreakEffectAnimation) && (animal))) && (animal.getShadow()))){
                    eggBreakEffectAnimation.offsetX = (animal.getShadow().x + (animal.getShadow().width / 2));
                    eggBreakEffectAnimation.offsetY = (animal.getShadow().y + (animal.getShadow().height / 2));
                    animal.addChild(eggBreakEffectAnimation);
                };
                eggBreakEffectAnimation.PlayComplete = eggEffectPlayCompleteHandler;
                if (updateArr.indexOf(eggBreakEffectAnimation) == -1){
                    updateArr.push(eggBreakEffectAnimation);
                };
                eggBreakEffectAnimation.StartClip("jn", 0, 12);
            };
            if (eggBreakEffectAnimation == null){
                eggBreakEffectRes = new GameEffectResource();
                eggBreakEffectRes.EffectName = "WhiteEggBreak";
                eggBreakEffectRes.EffectPath = ((GameCommonData.GameInstance.Content.RootDirectory + GameConfigData.GameEffectSWF) + "WhiteEggBreak.swf");
                eggBreakEffectRes.OnLoadEffect = deadEffectLoadComplete;
                eggBreakEffectRes.EffectBR.LoadComplete = eggBreakEffectRes.onEffectComplete;
                eggBreakEffectRes.EffectBR.Download.Add(eggBreakEffectRes.EffectPath);
                eggBreakEffectRes.EffectBR.Load();
            } else {
                deadEffectLoadComplete(eggBreakEffectRes);
            };
        }
        public function showRainEffect():void{
            var loadswfTool:* = null;
//            with ({}) {
//                {}.completeHandler = function (_arg1:DisplayObject=null):void{
//                    var _local7:int;
//                    var _local8:MovieClip;
//                    var _local2:Sprite = new Sprite();
//                    var _local3:MovieClip = loadswfTool.GetClassByMovieClip("rainMc");
//                    var _local4 = 6;
//                    var _local5 = 6;
//                    var _local6:int;
//                    while (_local6 < (_local5 + 1)) {
//                        _local7 = 0;
//                        while (_local7 < (_local4 + 1)) {
//                            _local8 = loadswfTool.GetClassByMovieClip("rainMc");
//                            _local8.x = (_local7 * (_local8.width - 100));
//                            _local8.y = (_local6 * (_local8.height - 100));
//                            _local8.gotoAndStop(1);
//                            _local8.play();
//                            _local2.addChild(_local8);
//                            _local7++;
//                        };
//                        _local6++;
//                    };
//                    _local2.mouseEnabled = false;
//                    _local2.mouseChildren = false;
//                    rainEffect = _local2;
//                    if (GameCommonData.Player.gameScene){
//                        GameCommonData.Player.gameScene.addChild(rainEffect);
//                    };
//                };
//            };//geoffyan
            var completeHandler:* = function (_arg1:DisplayObject=null):void{
                var _local7:int;
                var _local8:MovieClip;
                var _local2:Sprite = new Sprite();
                var _local3:MovieClip = loadswfTool.GetClassByMovieClip("rainMc");
                var _local4 = 6;
                var _local5 = 6;
                var _local6:int;
                while (_local6 < (_local5 + 1)) {
                    _local7 = 0;
                    while (_local7 < (_local4 + 1)) {
                        _local8 = loadswfTool.GetClassByMovieClip("rainMc");
                        _local8.x = (_local7 * (_local8.width - 100));
                        _local8.y = (_local6 * (_local8.height - 100));
                        _local8.gotoAndStop(1);
                        _local8.play();
                        _local2.addChild(_local8);
                        _local7++;
                    };
                    _local6++;
                };
                _local2.mouseEnabled = false;
                _local2.mouseChildren = false;
                rainEffect = _local2;
                if (GameCommonData.Player.gameScene){
                    GameCommonData.Player.gameScene.addChild(rainEffect);
                };
            };
            if (rainEffect == null){
                loadswfTool = new LoadSwfTool(GameConfigData.RainEffectSwf, false);
                loadswfTool.sendShow = completeHandler;
            } else {
                if (GameCommonData.Player.gameScene){
                    GameCommonData.Player.gameScene.addChild(rainEffect);
                };
            };
        }
        public function set EnabledChanged(_arg1:Function):void{
        }
        public function GetFloorEffect(_arg1:int):void{
            if (rectView == null){
                rectView = new Sprite();
                rectView.addChild(GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmap("SkillRectView"));
            };
            GameCommonData.GameInstance.GameScene.GetGameScene.BottomLayer.addChild(rectView);
            rectView.x = (GameCommonData.GameInstance.GameScene.GetGameScene.BottomLayer.mouseX - (rectView.width / 2));
            rectView.y = (GameCommonData.GameInstance.GameScene.GetGameScene.BottomLayer.mouseY - (rectView.height / 2));
            GameCommonData.Rect = rectView;
            rectView.startDrag();
        }
        public function get Enabled():Boolean{
            return (true);
        }
        public function hideRainEffect():void{
            if (rainEffect){
                if (rainEffect.parent){
                    rainEffect.parent.removeChild(rainEffect);
                };
                while (rainEffect.numChildren) {
                    rainEffect.removeChildAt(0);
                };
                rainEffect = null;
            };
        }
        public function GetCircleFloorEffect(_arg1:int):void{
            var _local2:int = (_arg1 * 40);
            var _local3:Sprite = new Sprite();
            _local3.mouseEnabled = false;
            _local3.graphics.beginFill(0xFF0000, 0.5);
            _local3.graphics.drawCircle(0, 0, _local2);
            _local3.graphics.endFill();
            GameCommonData.GameInstance.GameScene.GetGameScene.BottomLayer.addChild(_local3);
            _local3.x = GameCommonData.GameInstance.GameScene.GetGameScene.BottomLayer.mouseX;
            _local3.y = GameCommonData.GameInstance.GameScene.GetGameScene.BottomLayer.mouseY;
            GameCommonData.Rect = _local3;
            _local3.startDrag();
        }
        public function tLLoadComplete(_arg1:GameEffectResource):void{
            targetLightEffect = targetLight.GetAnimation();
            targetLightEffect.StartClip("jn");
            targetLightEffect.isLoop = true;
        }
        public function showFireEffect():void{
//            with ({}) {
//                {}.completeHandler = function (_arg1:DisplayObject=null):void{
//                    var _local7:int;
//                    var _local8:MovieClip;
//                    var _local2:Sprite = new Sprite();
//                    var _local3:MovieClip = fireLoadswfTool.GetClassByMovieClip("fireMc");
//                    var _local4 = 7;
//                    var _local5 = 4;
//                    var _local6:int;
//                    while (_local6 < (_local5 + 1)) {
//                        _local7 = 0;
//                        while (_local7 < (_local4 + 1)) {
//                            _local8 = fireLoadswfTool.GetClassByMovieClip("fireMc");
//                            _local8.x = (_local7 * (600 - 200));
//                            _local8.y = (_local6 * (500 - 200));
//                            _local8.gotoAndStop(1);
//                            _local8.play();
//                            _local2.addChild(_local8);
//                            _local7++;
//                        };
//                        _local6++;
//                    };
//                    _local2.mouseEnabled = false;
//                    _local2.mouseChildren = false;
//                    fireEffect = _local2;
//                    if (GameCommonData.Player.gameScene){
//                        GameCommonData.Player.gameScene.addChild(fireEffect);
//                    };
//                };
//            };//geoffyan
            var completeHandler:* = function (_arg1:DisplayObject=null):void{
                var _local7:int;
                var _local8:MovieClip;
                var _local2:Sprite = new Sprite();
                var _local3:MovieClip = fireLoadswfTool.GetClassByMovieClip("fireMc");
                var _local4 = 7;
                var _local5 = 4;
                var _local6:int;
                while (_local6 < (_local5 + 1)) {
                    _local7 = 0;
                    while (_local7 < (_local4 + 1)) {
                        _local8 = fireLoadswfTool.GetClassByMovieClip("fireMc");
                        _local8.x = (_local7 * (600 - 200));
                        _local8.y = (_local6 * (500 - 200));
                        _local8.gotoAndStop(1);
                        _local8.play();
                        _local2.addChild(_local8);
                        _local7++;
                    };
                    _local6++;
                };
                _local2.mouseEnabled = false;
                _local2.mouseChildren = false;
                fireEffect = _local2;
                if (GameCommonData.Player.gameScene){
                    GameCommonData.Player.gameScene.addChild(fireEffect);
                };
            };
            hideFireEffect();
            fireLoadswfTool = new LoadSwfTool(GameConfigData.FireEffectSwf, false);
            fireLoadswfTool.sendShow = completeHandler;
        }
        public function hideFireEffect():void{
            if (fireEffect){
                if (fireEffect.parent){
                    fireEffect.parent.removeChild(fireEffect);
                };
                while (fireEffect.numChildren) {
                    fireEffect.removeChildAt(0);
                };
                fireEffect = null;
            };
        }
        private function initDieDeffDic():void{
            deadEffectResDic = new Dictionary();
            dieDeffDic = new Dictionary();
            dieDeffDic[36] = "DeadEffect_GoldEgg";
            dieDeffDic[37] = "DeadEffect_BlackEgg";
        }
        public function ClearFloorEffect():void{
            if (((!((GameCommonData.Rect == null))) && (GameCommonData.GameInstance.GameScene.GetGameScene.BottomLayer.contains(GameCommonData.Rect)))){
                GameCommonData.GameInstance.GameScene.GetGameScene.BottomLayer.removeChild(GameCommonData.Rect);
            };
            GameCommonData.Rect = null;
            rectView = null;
        }
        public function get EnabledChanged():Function{
            return (null);
        }
        public function PlayChangeEffect(_arg1:GameElementAnimal):void{
            var changeSkinPlayCompleteHandler:* = null;
            var animal:* = _arg1;
            changeSkinPlayCompleteHandler = function (_arg1:SkillAnimation):void{
                if (((_arg1) && (_arg1.parent))){
                    _arg1.parent.removeChild(_arg1);
                };
                if (updateArr.indexOf(_arg1) != -1){
                    updateArr.splice(updateArr.indexOf(_arg1), 1);
                };
            };
            var effectLoadComplete:* = function (_arg1:GameEffectResource):void{
                playCahangeEffectloaded = true;
                var _local2:SkillAnimation = _arg1.GetAnimation();
                if (((((_local2) && (animal))) && (animal.getShadow()))){
                    _local2.offsetX = (animal.getShadow().x + (animal.getShadow().width / 2));
                    _local2.offsetY = (animal.getShadow().y + (animal.getShadow().height / 2));
                    animal.addChild(_local2);
                };
                _local2.PlayComplete = changeSkinPlayCompleteHandler;
                if (updateArr.indexOf(_local2) == -1){
                    updateArr.push(_local2);
                };
                _local2.StartClip("jn", 0, 12);
            };
            if (playCahangeEffectloaded == false){
                changeSkinEffectRes = new GameEffectResource();
                changeSkinEffectRes.EffectName = "ChangeSkinEffect";
                changeSkinEffectRes.EffectPath = changeSkinEffectUrl;
                changeSkinEffectRes.OnLoadEffect = effectLoadComplete;
                changeSkinEffectRes.EffectBR.LoadComplete = changeSkinEffectRes.onEffectComplete;
                changeSkinEffectRes.EffectBR.Download.Add(changeSkinEffectRes.EffectPath);
                changeSkinEffectRes.EffectBR.Load();
            } else {
                effectLoadComplete(changeSkinEffectRes);
            };
        }
        public function getAddPointEffect():MovieClip{
            if (addPointEffect == null){
                addPointEffect = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("AddPointEffect");
                addPointEffect.x = -2;
                addPointEffect.y = -2;
            };
            return (addPointEffect);
        }
        public function showSceneMovieEffect(_arg1:String, _arg2:int=0, _arg3:int=0, _arg4:int=0, _arg5:Boolean=false, _arg6:GameElementAnimal=null, _arg7:int=-1):void{
            var gameScene:* = null;
            var effectPath:* = null;
            var sePlayCompleteHandler:* = null;
            var seEffectRes:* = null;
            var type:* = _arg1;
            var mapId:int = _arg2;
            var tileX:int = _arg3;
            var tileY:int = _arg4;
            var isLoop:Boolean = _arg5;
            var targetElement = _arg6;
            var childIdx:int = _arg7;
            gameScene = GameCommonData.Scene.gameScenePlay;
            if (gameScene == null){
                return;
            };
            effectPath = (((GameCommonData.GameInstance.Content.RootDirectory + GameConfigData.GameEffectSWF) + type) + ".swf");
            sePlayCompleteHandler = function (_arg1:SkillAnimation):void{
                if (((_arg1) && (_arg1.parent))){
                    _arg1.parent.removeChild(_arg1);
                };
                if (updateArr.indexOf(_arg1) != -1){
                    updateArr.splice(updateArr.indexOf(_arg1), 1);
                };
            };
            var seLoadComplete:* = function (_arg1:GameEffectResource):void{
                var _local3:Point;
                if (gameScene.CacheResource[effectPath] == null){
                    gameScene.CacheResource[effectPath] = _arg1;
                };
                var _local2:SkillAnimation = _arg1.GetAnimation(true);
                _local2.name = type;
                if (_local2){
                    if (((!((mapId == 0))) && (!((int(GameCommonData.GameInstance.GameScene.GetGameScene.name) == mapId))))){
                        return;
                    };
                    _local3 = MapTileModel.GetTilePointToStage(tileX, tileY);
                    _local2.offsetX = _local3.x;
                    _local2.offsetY = _local3.y;
                    if ((((((((mapId == 0)) && ((tileX == 0)))) && ((tileY == 0)))) && (!((targetElement == null))))){
                        if (targetElement.skins){
                            _local2.offsetX = targetElement.FootPos.x;
                            _local2.offsetY = targetElement.FootPos.y;
                            if (childIdx != -1){
                                targetElement.addChildAt(_local2, childIdx);
                            } else {
                                targetElement.addChild(_local2);
                            };
                        };
                    } else {
                        if (childIdx != -1){
                            GameCommonData.Player.gameScene.TopLayer.addChildAt(_local2, childIdx);
                        } else {
                            GameCommonData.Player.gameScene.TopLayer.addChild(_local2);
                        };
                    };
                };
                _local2.PlayComplete = sePlayCompleteHandler;
                if (updateArr.indexOf(_local2) == -1){
                    updateArr.push(_local2);
                };
                _local2.StartClip("jn", 0, 12);
                _local2.isLoop = isLoop;
            };
            if (gameScene.CacheResource[effectPath] == null){
                seEffectRes = new GameEffectResource();
                seEffectRes.EffectName = ("seEffect_" + type);
                seEffectRes.EffectPath = effectPath;
                seEffectRes.OnLoadEffect = seLoadComplete;
                seEffectRes.EffectBR.LoadComplete = seEffectRes.onEffectComplete;
                seEffectRes.EffectBR.Download.Add(seEffectRes.EffectPath);
                seEffectRes.EffectBR.Load();
            } else {
                seLoadComplete(gameScene.CacheResource[effectPath]);
            };
        }
        public function SetTargetLight(_arg1:GameElementAnimal):void{
            if (targetLight == null){
                targetLight = new GameEffectResource();
                targetLight.EffectName = "TL";
                targetLight.EffectPath = (((GameCommonData.GameInstance.Content.RootDirectory + GameConfigData.GameEffectSWF) + "TL") + ".swf");
                targetLight.OnLoadEffect = tLLoadComplete;
                targetLight.EffectBR.LoadComplete = targetLight.onEffectComplete;
                targetLight.EffectBR.Download.Add(targetLight.EffectPath);
                targetLight.EffectBR.Load();
            } else {
                if (targetLightEffect){
                    if (_arg1 == null){
                        if (targetLightEffect.parent){
                            targetLightEffect.parent.removeChild(targetLightEffect);
                        };
                        return;
                    };
                    if (targetLightEffect.parent != _arg1){
                        targetLightEffect.offsetX = (_arg1.getShadow().x - 10);
                        targetLightEffect.offsetY = (_arg1.getShadow().y - 10);
                        _arg1.addChildAt(targetLightEffect, 1);
                        targetLightEffect.StartClip("jn");
                    };
                };
            };
        }
        public function showChallengedSuccess():void{
            var effectPath:* = null;
            var effectBR:* = null;
            effectPath = (GameCommonData.GameInstance.Content.RootDirectory + GameConfigData.ChallengedSuccessSwf);
            effectBR = new BulkLoaderResourceProvider();
 //           with ({}) {
//                {}.onLoadComplete = function ():void{
//                    var _local1:MovieClip = effectBR.GetResource(effectPath).GetMovieClip();
//                    if (_local1){
//                        _local1.play();
//                        _local1.x = (GameCommonData.GameInstance.ScreenWidth / 2);
//                        _local1.y = 200;
//                        GameCommonData.GameInstance.GameUI.addChild(_local1);
//                    };
//                };
//            };//geoffyan
            var onLoadComplete:* = function ():void{
                var _local1:MovieClip = effectBR.GetResource(effectPath).GetMovieClip();
                if (_local1){
                    _local1.play();
                    _local1.x = (GameCommonData.GameInstance.ScreenWidth / 2);
                    _local1.y = 200;
                    GameCommonData.GameInstance.GameUI.addChild(_local1);
                };
            };
            effectBR.Download.Add(effectPath);
            effectBR.LoadComplete = onLoadComplete;
            effectBR.Load();
        }
        public function showPotDropWaterMc(_arg1:DisplayObjectContainer, _arg2:int, _arg3:int):void{
            var effectPath:* = null;
            var effectBR:* = null;
            var parent:* = _arg1;
            var tileX:* = _arg2;
            var tileY:* = _arg3;
            effectPath = ((GameCommonData.GameInstance.Content.RootDirectory + GameConfigData.GameEffectSWF) + "PotDropwater.swf");
            effectBR = new BulkLoaderResourceProvider();
//            with ({}) {
//                {}.onLoadComplete = function ():void{
//                    var _local2:Point;
//                    var _local1:MovieClip = effectBR.GetResource(effectPath).GetMovieClip();
//                    if (_local1){
//                        _local2 = MapTileModel.GetTilePointToStage(tileX, tileY);
//                        _local1.x = _local2.x;
//                        _local1.y = _local2.y;
//                        parent.addChild(_local1);
//                    };
//                };
//            };//geoffyan
            var onLoadComplete:* = function ():void{
                var _local2:Point;
                var _local1:MovieClip = effectBR.GetResource(effectPath).GetMovieClip();
                if (_local1){
                    _local2 = MapTileModel.GetTilePointToStage(tileX, tileY);
                    _local1.x = _local2.x;
                    _local1.y = _local2.y;
                    parent.addChild(_local1);
                };
            };
            effectBR.Download.Add(effectPath);
            effectBR.LoadComplete = onLoadComplete;
            effectBR.Load();
        }
        public function Update(_arg1:GameTime):void{
            var _local2:int;
            if (updateArr.length > 0){
                _local2 = 0;
                while (_local2 < updateArr.length) {
                    if (((updateArr[_local2]) && ((updateArr[_local2] is SkillAnimation)))){
                        updateArr[_local2].Update(_arg1);
                    };
                    _local2++;
                };
            };
            if (((targetLightEffect) && (targetLightEffect.parent))){
                targetLightEffect.Update(_arg1);
            };
        }
        public function screen_shake(_arg1:Number=0.4, _arg21:Number=50, _arg3:DisplayObject=null):void{
            var dobj:* = undefined;
            var originalX:* = undefined;
            var originalY:* = undefined;
            var _arg1:Number = _arg1;
            var _arg2:int = _arg21;
            var target = _arg3;
            dobj = null;
            originalX = NaN;
            originalY = NaN;
            var $time:* = _arg1;
            var $intensity:* = _arg2;
            if (!enableScreenShake){
                return;
            };
            if (_screenShaking){
                return;
            };
            _screenShaking = true;
            if (target == null){
                dobj = GameCommonData.GameInstance.GameScene;
            } else {
                dobj = target;
            };
            originalX = dobj.x;
            originalY = dobj.y;
            var p:* = new Point(originalX, originalY);
            var middleX:* = p.x;
            var middleY:* = (p.y - $intensity);
            TweenMax.to(dobj, $time, {
                bezier:[{
                    x:middleX,
                    y:middleY
                }, {
                    x:p.x,
                    y:p.y
                }],
                ease:Elastic.easeInOut,
                onComplete:function ():void{
                    dobj.x = originalX;
                    dobj.y = originalY;
                    _screenShaking = false;
                }
            });
        }
        public function get UpdateOrder():int{
            return (0);
        }
        public function SetDeadEffect(_arg1:GameElementAnimal):void{
            var deadEffectPlayCompleteHandler:* = null;
            var deadEffectRes:* = null;
            var animal:* = _arg1;
            if (dieDeffDic[animal.Role.MonsterTypeID] == null){
                return;
            };
            deadEffectPlayCompleteHandler = function (_arg1:SkillAnimation):void{
                if (((_arg1) && (_arg1.parent))){
                    _arg1.parent.removeChild(_arg1);
                };
                if (updateArr.indexOf(_arg1) != -1){
                    updateArr.splice(updateArr.indexOf(_arg1), 1);
                };
                animal.Visible = false;
            };
            var deadEffectLoadComplete:* = function (_arg1:GameEffectResource):void{
                if (deadEffectResDic[_arg1.EffectName] == null){
                    deadEffectResDic[_arg1.EffectName] = _arg1;
                };
                var _local2:SkillAnimation = deadEffectResDic[_arg1.EffectName].GetAnimation();
                if (((((_local2) && (animal))) && (animal.getShadow()))){
                    _local2.offsetX = (animal.getShadow().x + (animal.getShadow().width / 2));
                    _local2.offsetY = (animal.getShadow().y + (animal.getShadow().height / 2));
                    animal.addChild(_local2);
                    animal.RemoveSkin(GameElementSkins.EQUIP_PERSON);
                };
                _local2.PlayComplete = deadEffectPlayCompleteHandler;
                updateArr.push(_local2);
                _local2.StartClip("jn", 0, 12);
            };
            if (deadEffectResDic[dieDeffDic[animal.Role.MonsterTypeID]] == null){
                deadEffectRes = new GameEffectResource();
                deadEffectRes.EffectName = dieDeffDic[animal.Role.MonsterTypeID];
                deadEffectRes.EffectPath = (((GameCommonData.GameInstance.Content.RootDirectory + GameConfigData.GameEffectSWF) + dieDeffDic[animal.Role.MonsterTypeID]) + ".swf");
                deadEffectRes.OnLoadEffect = deadEffectLoadComplete;
                deadEffectRes.EffectBR.LoadComplete = deadEffectRes.onEffectComplete;
                deadEffectRes.EffectBR.Download.Add(deadEffectRes.EffectPath);
                deadEffectRes.EffectBR.Load();
            } else {
                deadEffectLoadComplete(deadEffectResDic[dieDeffDic[animal.Role.MonsterTypeID]]);
            };
        }
        public function showChallengedFail():void{
            var effectPath:* = null;
            var effectBR:* = null;
            effectPath = (GameCommonData.GameInstance.Content.RootDirectory + GameConfigData.ChallengedFailSwf);
            effectBR = new BulkLoaderResourceProvider();
            with ({}) {
//                {}.onLoadComplete = function ():void{
//                    var _local1:MovieClip = effectBR.GetResource(effectPath).GetMovieClip();
//                    if (_local1){
//                        _local1.play();
//                        _local1.x = (GameCommonData.GameInstance.ScreenWidth / 2);
//                        _local1.y = 200;
//                        GameCommonData.GameInstance.GameUI.addChild(_local1);
//                    };
//                };//geoffyan
            };
            var onLoadComplete:* = function ():void{
                var _local1:MovieClip = effectBR.GetResource(effectPath).GetMovieClip();
                if (_local1){
                    _local1.play();
                    _local1.x = (GameCommonData.GameInstance.ScreenWidth / 2);
                    _local1.y = 200;
                    GameCommonData.GameInstance.GameUI.addChild(_local1);
                };
            };
            effectBR.Download.Add(effectPath);
            effectBR.LoadComplete = onLoadComplete;
            effectBR.Load();
        }

    }
}//package Manager 
