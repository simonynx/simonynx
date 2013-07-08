//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Scene.StrategyElement.Person {
    import flash.events.*;
    import flash.display.*;
    import OopsFramework.*;
    import OopsFramework.Content.*;
    import OopsEngine.Scene.StrategyElement.*;
    import Manager.*;
    import OopsFramework.Content.Loading.*;
    import GameUI.View.*;
    import OopsFramework.Content.Provider.*;
    import Net.RequestSend.*;

    public class GameElementPlayerSkin extends GameElementSkins {

        public static var skinLoader:BulkLoader = GameCommonData.playerResourceLoader;

        private var weaponSprite:Sprite;
        private var personResource:LoadingItem;
        private var mount:GameElementPlayerAnimation;
        private var weapon:GameElementPlayerAnimation;
        private var weapon_effect:GameElementPlayerAnimation;
        private var person_mount:GameElementPlayerAnimation;
        private var mountSprite:Sprite;
        private var mountResource:LoadingItem;
        private var weaponResource:LoadingItem;
        private var person_mountSprite:Sprite;
        private var person:GameElementPlayerAnimation;
        private var person_mountResource:LoadingItem;
        private var weaponEffectSprite:Sprite;
        private var personSprite:Sprite;
        private var weaponEffectResource:LoadingItem;

        public function GameElementPlayerSkin(_arg1:GameElementAnimal){
            personSprite = new Sprite();
            weaponSprite = new Sprite();
            mountSprite = new Sprite();
            person_mountSprite = new Sprite();
            weaponEffectSprite = new Sprite();
            super(_arg1);
            this.addChildAt(this.mountSprite, 0);
            this.addChildAt(this.person_mountSprite, 1);
            this.addChildAt(this.personSprite, 2);
            this.addChildAt(this.weaponSprite, 3);
            this.addChildAt(this.weaponEffectSprite, 4);
        }
        private function onMountResourceComplete(_arg1:Event):void{
            var _local2:MovieClip;
            var _local3:GameElementMountData;
            var _local4:Array;
            var _local5:GameElementPlayerSkin;
            _arg1.currentTarget.removeEventListener(Event.COMPLETE, onMountResourceComplete);
            _local2 = (_arg1.currentTarget.loader.content as MovieClip);
            _local3 = new GameElementMountData();
            _local3.resourceName = _arg1.currentTarget.name.substring(GameCommonData.GameInstance.Content.RootDirectory.length);
            _local3.Analyze(_local2);
            if (SkinLoadComplete != null){
                SkinLoadComplete(_local3.resourceName, _local3);
            };
            if (((((this.gep.gameScene) && (!((this.gep.gameScene.ResourceLoadingQueue == null))))) && (!((this.gep.gameScene.ResourceLoadingQueue[_local3.resourceName] == null))))){
                _local4 = this.gep.gameScene.ResourceLoadingQueue[_local3.resourceName];
                _local5 = _local4.shift();
                while (_local5 != null) {
                    _local5.MountLoadComplete(_local3.resourceName);
                    _local5 = _local4.shift();
                };
            };
            this.MountLoadComplete(_local3.resourceName);
            skinLoader.RemoveItem(mountResource.name);
            this.mountResource = null;
            _local2 = null;
        }
        public function ChangeWeapon(_arg1:Boolean=false):void{
            var loaderName:* = null;
            var _arg1:Boolean = _arg1;
            try {
                if (this.gep.Role.WeaponSkinName != null){
                    if (GameCommonData.GameInstance.Content.CacheResource[this.gep.Role.WeaponSkinName] != null){
                        if (this.weapon != null){
                            if (this.weapon.parent != null){
                                this.weapon.parent.removeChild(this.weapon);
                            };
                            this.weapon = null;
                        };
                        if (GameCommonData.GameInstance.Content.CacheResource[this.gep.Role.WeaponSkinName] != true){
                            this.WeaponLoadComplete(this.gep.Role.WeaponSkinName);
                        } else {
                            if (this.gep.gameScene){
                                if (this.gep.gameScene.ResourceLoadingQueue[this.gep.Role.WeaponSkinName] == null){
                                    this.gep.gameScene.ResourceLoadingQueue[this.gep.Role.WeaponSkinName] = new Array();
                                    this.gep.gameScene.ResourceLoadingQueue[this.gep.Role.WeaponSkinName].push(this);
                                } else {
                                    this.gep.gameScene.ResourceLoadingQueue[this.gep.Role.WeaponSkinName].push(this);
                                };
                            };
                        };
                    } else {
                        GameCommonData.GameInstance.Content.CacheResource[this.gep.Role.WeaponSkinName] = true;
                        loaderName = (GameCommonData.GameInstance.Content.RootDirectory + this.gep.Role.WeaponSkinName);
                        skinLoader.Add(loaderName, false, null, 1, 3);
                        this.weaponResource = (skinLoader.GetLoadingItem(loaderName) as LoadingItem);
                        this.weaponResource.name = loaderName;
                        this.weaponResource.addEventListener(Event.COMPLETE, onWeaponResourceComplete);
                        skinLoader.Load();
                    };
                };
            } catch(error:Error) {
                MessageTip.show(((((("" + this.gep.Role.WeaponSkinName) + " , ") + this.gep.gameScene) + ",") + this.gep.gameScene.ResourceLoadingQueue));
                throw (new Error(((((("" + this.gep.Role.WeaponSkinName) + " , ") + this.gep.gameScene) + ",") + this.gep.gameScene.ResourceLoadingQueue)));
            };
        }
        private function onPerson_MountResourceComplete(_arg1:Event):void{
            var _local2:MovieClip;
            var _local3:GameElementPlayerMountData;
            var _local4:Array;
            var _local5:GameElementPlayerSkin;
            _arg1.currentTarget.removeEventListener(Event.COMPLETE, onPerson_MountResourceComplete);
            _local2 = (_arg1.currentTarget.loader.content as MovieClip);
            _local3 = new GameElementPlayerMountData();
            _local3.resourceName = _arg1.currentTarget.name.substring(GameCommonData.GameInstance.Content.RootDirectory.length);
            _local3.Analyze(_local2);
            if (SkinLoadComplete != null){
                SkinLoadComplete(_local3.resourceName, _local3);
            };
            if (((((this.gep.gameScene) && (!((this.gep.gameScene.ResourceLoadingQueue == null))))) && (!((this.gep.gameScene.ResourceLoadingQueue[_local3.resourceName] == null))))){
                _local4 = this.gep.gameScene.ResourceLoadingQueue[_local3.resourceName];
                _local5 = _local4.shift();
                while (_local5 != null) {
                    _local5.person_MountLoadComplete(_local3.resourceName);
                    _local5 = _local4.shift();
                };
            };
            this.person_MountLoadComplete(_local3.resourceName);
            this.person_mountResource = null;
            _local2 = null;
        }
        public function WeaponLoadComplete(_arg1:String):void{
            if (((!((this.gep.Role.WeaponSkinName == _arg1))) || (isDispose))){
                return;
            };
            if (this.weapon != null){
                if (this.weapon.parent != null){
                    this.weapon.parent.removeChild(this.weapon);
                };
                this.weapon = null;
            };
            if (ChangeEquip != null){
                ChangeEquip(GameElementSkins.EQUIP_WEAOIB);
            };
            if (ChangeSkins != null){
                ChangeSkins(GameElementSkins.EQUIP_WEAOIB, this.gep);
            };
            this.weapon = new GameElementPlayerAnimation();
            var _local2:GameElementPlayerData = GameCommonData.GameInstance.Content.CacheResource[this.gep.Role.WeaponSkinName];
            _local2.SetAnimationData(this.weapon);
            if (this.gep.Role.HP == 0){
                this.weapon.StartClip((this.currentActionType + this.currentDirection), 3);
            };
            this.weaponSprite.addChild(this.weapon);
            this.SetActionAndDirection();
        }
        override public function dispose():void{
            if (this.person != null){
                if (this.person.parent){
                    this.person.parent.removeChild(this.person);
                };
                this.person.dispose();
                this.person = null;
            };
            if (this.weapon != null){
                if (this.weapon.parent){
                    this.weapon.parent.removeChild(this.weapon);
                };
                this.weapon.dispose();
                this.weapon = null;
            };
            if (this.weapon_effect != null){
                if (this.weapon_effect.parent){
                    this.weapon_effect.parent.removeChild(this.weapon_effect);
                };
                this.weapon_effect.dispose();
                this.weapon_effect = null;
            };
            if (this.mount != null){
                if (this.mount.parent){
                    this.mount.parent.removeChild(this.mount);
                };
                this.mount.dispose();
                this.mount = null;
            };
            if (this.person_mount != null){
                if (this.person_mount.parent){
                    this.person_mount.parent.removeChild(this.person_mount);
                };
                this.person_mount.dispose();
                this.person_mount = null;
            };
            super.dispose();
        }
        override protected function SetActionAndDirection(_arg1:int=0):void{
            if (this.gep.Role.ActionState.indexOf(GameElementSkins.ACTION_STATIC) > -1){
                this.FrameRate = 3;
            } else {
                if (this.gep.Role.ActionState.indexOf(GameElementSkins.ACTION_DEAD) > -1){
                    this.FrameRate = 5;
                } else {
                    if (this.gep.Role.ActionState.indexOf(GameElementSkins.ACTION_RUN) > -1){
                        this.FrameRate = 12;
                    } else {
                        this.FrameRate = 15;
                    };
                };
            };
            if (this.gep.Role.MountSkinID == 0){
                if (((this.mount) && (this.mount.parent))){
                    this.mount.parent.removeChild(mount);
                };
                if (((this.person_mount) && (this.person_mount.parent))){
                    this.person_mount.parent.removeChild(this.person_mount);
                };
                if (this.person != null){
                    if (this.person.parent == null){
                        this.personSprite.addChild(this.person);
                    };
                    if (this.FrameRate == 3){
                        this.person.StartClip((GameElementSkins.ACTION_STATIC + this.currentDirection), _arg1);
                    } else {
                        if (this.FrameRate == 12){
                            this.person.StartClip((GameElementSkins.ACTION_RUN + this.currentDirection), _arg1);
                        } else {
                            this.person.StartClip((this.currentActionType + this.currentDirection), _arg1);
                        };
                    };
                };
                if (this.weapon != null){
                    if (PlayerSkinsController.canSeeWeapon(this.gep)){
                        if (this.weapon.parent == null){
                            this.weaponSprite.addChild(this.weapon);
                        };
                        if (this.FrameRate == 3){
                            this.weapon.StartClip((GameElementSkins.ACTION_STATIC + this.currentDirection), _arg1);
                        } else {
                            if (this.FrameRate == 12){
                                this.weapon.StartClip((GameElementSkins.ACTION_RUN + this.currentDirection), _arg1);
                            } else {
                                this.weapon.StartClip((this.currentActionType + this.currentDirection), _arg1);
                            };
                        };
                    } else {
                        if (this.weapon.parent){
                            this.weaponSprite.removeChild(this.weapon);
                        };
                    };
                };
                if (this.weapon_effect != null){
                    if (PlayerSkinsController.canSeeWeapon(this.gep)){
                        if (this.weapon_effect.parent == null){
                            this.weaponEffectSprite.addChild(this.weapon_effect);
                        };
                        if (this.FrameRate == 3){
                            this.weapon_effect.StartClip((GameElementSkins.ACTION_STATIC + this.currentDirection), _arg1);
                        } else {
                            if (this.FrameRate == 12){
                                this.weapon_effect.StartClip((GameElementSkins.ACTION_RUN + this.currentDirection), _arg1);
                            } else {
                                this.weapon_effect.StartClip((this.currentActionType + this.currentDirection), _arg1);
                            };
                        };
                    } else {
                        if (this.weapon_effect.parent){
                            this.weaponEffectSprite.removeChild(this.weapon_effect);
                        };
                    };
                };
            } else {
                if (((this.person) && (this.person.parent))){
                    this.person.parent.removeChild(person);
                };
                if (((this.weapon) && (this.weapon.parent))){
                    this.weapon.parent.removeChild(this.weapon);
                };
                if (((this.weapon_effect) && (this.weapon_effect.parent))){
                    this.weapon_effect.parent.removeChild(this.weapon_effect);
                };
                if (this.mount != null){
                    if (this.mount.parent == null){
                        this.mountSprite.addChild(this.mount);
                    };
                    if (this.FrameRate == 3){
                        this.mount.StartClip((GameElementSkins.ACTION_MOUNT_STATIC + this.currentDirection), _arg1);
                    } else {
                        if ((this.FrameRate = 12)){
                            this.mount.StartClip((GameElementSkins.ACTION_MOUNT_RUN + this.currentDirection), _arg1);
                        };
                    };
                };
                if (this.person_mount != null){
                    if (this.person_mount.parent == null){
                        this.person_mountSprite.addChild(this.person_mount);
                    };
                    if (this.FrameRate == 3){
                        this.person_mount.StartClip((GameElementSkins.ACTION_MOUNT_STATIC + this.currentDirection), _arg1);
                    } else {
                        if ((this.FrameRate = 12)){
                            this.person_mount.StartClip((GameElementSkins.ACTION_MOUNT_RUN + this.currentDirection), _arg1);
                        };
                    };
                };
            };
        }
        private function onPersonResourceComplete(_arg1:Event):void{
            var _local2:MovieClip;
            var _local3:GameElementPlayerData;
            var _local4:Array;
            var _local5:GameElementPlayerSkin;
            _arg1.currentTarget.removeEventListener(Event.COMPLETE, onPersonResourceComplete);
            _arg1.currentTarget.removeEventListener(BulkProgressEvent.ERROR, onPersonSkinError);
            _local2 = (_arg1.currentTarget.loader.content as MovieClip);
            _local3 = new GameElementPlayerData();
            _local3.resourceName = _arg1.currentTarget.name.substring(GameCommonData.GameInstance.Content.RootDirectory.length);
            _local3.Analyze(_local2);
            if (SkinLoadComplete != null){
                SkinLoadComplete(_local3.resourceName, _local3);
            };
            if (((((this.gep.gameScene) && (!((this.gep.gameScene.ResourceLoadingQueue == null))))) && (!((this.gep.gameScene.ResourceLoadingQueue[_local3.resourceName] == null))))){
                _local4 = this.gep.gameScene.ResourceLoadingQueue[_local3.resourceName];
                _local5 = _local4.shift();
                while (_local5 != null) {
                    _local5.PersonLoadComplete(_local3.resourceName);
                    _local5 = _local4.shift();
                };
            };
            this.PersonLoadComplete(_local3.resourceName);
            this.personResource = null;
            _local2 = null;
        }
        override public function LoadSkin(_arg1:String="all"):void{
            if ((((_arg1 == GameElementSkins.EQUIP_ALL)) || ((_arg1 == GameElementSkins.EQUIP_PERSON)))){
                PlayerSkinsController.SetSkin(GameElementSkins.EQUIP_PERSON, this.gep.Role.PersonSkinID, this.gep);
            };
            if ((((_arg1 == GameElementSkins.EQUIP_ALL)) || ((_arg1 == GameElementSkins.EQUIP_WEAOIB)))){
                PlayerSkinsController.SetSkin(GameElementSkins.EQUIP_WEAOIB, this.gep.Role.WeaponSkinID, this.gep);
            };
            if ((((_arg1 == GameElementSkins.EQUIP_ALL)) || ((_arg1 == GameElementSkins.EQUIP_MOUNT)))){
                PlayerSkinsController.SetSkin(GameElementSkins.EQUIP_MOUNT, this.gep.Role.MountSkinID, this.gep);
            };
            if ((((_arg1 == GameElementSkins.EQUIP_ALL)) || ((_arg1 == GameElementSkins.EQUIP_WEAPONE_EFFECT)))){
                PlayerSkinsController.SetSkin(GameElementSkins.EQUIP_WEAPONE_EFFECT, this.gep.Role.weaponStength, this.gep);
            };
        }
        public function ChangeMount(_arg1:Boolean=false):void{
            var _local2:String;
            if (this.gep.Role.MountSkinName != null){
                if (this.mount != null){
                    if (this.mount.parent != null){
                        this.mount.parent.removeChild(this.mount);
                    };
                    this.mount = null;
                };
                if (GameCommonData.GameInstance.Content.CacheResource[this.gep.Role.MountSkinName] != null){
                    if (GameCommonData.GameInstance.Content.CacheResource[this.gep.Role.MountSkinName] != true){
                        this.MountLoadComplete(this.gep.Role.MountSkinName);
                    } else {
                        if (this.gep.gameScene){
                            if (this.gep.gameScene.ResourceLoadingQueue[this.gep.Role.MountSkinName] == null){
                                this.gep.gameScene.ResourceLoadingQueue[this.gep.Role.MountSkinName] = new Array();
                                this.gep.gameScene.ResourceLoadingQueue[this.gep.Role.MountSkinName].push(this);
                            } else {
                                this.gep.gameScene.ResourceLoadingQueue[this.gep.Role.MountSkinName].push(this);
                            };
                        };
                    };
                } else {
                    GameCommonData.GameInstance.Content.CacheResource[this.gep.Role.MountSkinName] = true;
                    _local2 = (GameCommonData.GameInstance.Content.RootDirectory + this.gep.Role.MountSkinName);
                    skinLoader.Add(_local2, false, null, 1, 2);
                    this.mountResource = skinLoader.GetLoadingItem(_local2);
                    this.mountResource.name = _local2;
                    this.mountResource.addEventListener(Event.COMPLETE, onMountResourceComplete);
                    skinLoader.Load();
                };
            };
        }
        public function weaponEffectLoadComplete(_arg1:String):void{
            if (((!((this.gep.Role.weaponEffectName == _arg1))) || (isDispose))){
                return;
            };
            if (this.weapon_effect != null){
                if (this.weapon_effect.parent != null){
                    this.weapon_effect.parent.removeChild(this.weapon_effect);
                };
                this.weapon_effect = null;
            };
            this.weapon_effect = new GameElementPlayerAnimation();
            var _local2:GameElementPlayerData = GameCommonData.GameInstance.Content.CacheResource[this.gep.Role.weaponEffectName];
            _local2.SetAnimationData(this.weapon_effect);
            if (this.gep.Role.HP == 0){
                this.weapon_effect.StartClip((this.currentActionType + this.currentDirection), 3);
            };
            this.weaponEffectSprite.addChild(this.weapon_effect);
            this.SetActionAndDirection();
        }
        override public function RemovePersonSkin(_arg1:String):void{
            switch (_arg1){
                case GameElementSkins.EQUIP_PERSON:
                    if (this.person){
                        if (this.person.parent){
                            this.person.parent.removeChild(this.person);
                        };
                        this.person = null;
                        gep.Role.PersonSkinName = null;
                    };
                    break;
                case GameElementSkins.EQUIP_WEAOIB:
                    if (this.weapon){
                        if (this.weapon.parent){
                            this.weapon.parent.removeChild(this.weapon);
                        };
                        this.weapon = null;
                        gep.Role.WeaponSkinName = null;
                    };
                    break;
                case GameElementSkins.EQUIP_WEAPONE_EFFECT:
                    if (this.weapon_effect){
                        if (this.weapon_effect.parent){
                            this.weapon_effect.parent.removeChild(this.weapon_effect);
                        };
                        this.weapon_effect = null;
                        gep.Role.weaponEffectName = null;
                    };
                    break;
                case GameElementSkins.EQUIP_MOUNT:
                    if (this.mount){
                        if (this.mount.parent){
                            this.mount.parent.removeChild(this.mount);
                        };
                        this.mount = null;
                        gep.Role.MountSkinName = null;
                    };
                    if (this.person_mount){
                        if (this.person_mount.parent){
                            this.person_mount.parent.removeChild(this.person_mount);
                        };
                        this.person_mount = null;
                        gep.Role.personMountSkinName = null;
                    };
                    break;
            };
            this.SetActionAndDirection();
            if (ChangeEquip != null){
                ChangeEquip(_arg1);
            };
            if (ChangeSkins != null){
                ChangeSkins(_arg1, this.gep);
            };
        }
        public function ChangeWeaponEffect(_arg1:Boolean=false):void{
            var _local2:String;
            if (this.gep.Role.weaponEffectName != null){
                if (this.weapon_effect != null){
                    if (this.weapon_effect.parent){
                        this.weapon_effect.parent.removeChild(this.weapon_effect);
                    };
                    this.weapon_effect = null;
                };
                if (GameCommonData.GameInstance.Content.CacheResource[this.gep.Role.weaponEffectName] != null){
                    if (GameCommonData.GameInstance.Content.CacheResource[this.gep.Role.weaponEffectName] != true){
                        this.weaponEffectLoadComplete(this.gep.Role.weaponEffectName);
                    } else {
                        if (this.gep.gameScene){
                            if (this.gep.gameScene.ResourceLoadingQueue[this.gep.Role.weaponEffectName] == null){
                                this.gep.gameScene.ResourceLoadingQueue[this.gep.Role.weaponEffectName] = new Array();
                                this.gep.gameScene.ResourceLoadingQueue[this.gep.Role.weaponEffectName].push(this);
                            } else {
                                this.gep.gameScene.ResourceLoadingQueue[this.gep.Role.weaponEffectName].push(this);
                            };
                        };
                    };
                } else {
                    GameCommonData.GameInstance.Content.CacheResource[this.gep.Role.weaponEffectName] = true;
                    _local2 = (GameCommonData.GameInstance.Content.RootDirectory + this.gep.Role.weaponEffectName);
                    skinLoader.Add(_local2, false, null, 1, 4);
                    this.weaponEffectResource = skinLoader.GetLoadingItem(_local2);
                    this.weaponEffectResource.name = _local2;
                    this.weaponEffectResource.addEventListener(Event.COMPLETE, onWeaponEffectResourceComplete);
                    skinLoader.Load();
                };
            };
        }
        public function ChangePerson(_arg1:Boolean=false):void{
            var _local2:String;
            this.gep.IsLoadSkins = false;
            if (GameCommonData.GameInstance.Content.CacheResource[this.gep.Role.PersonSkinName] != null){
                if (this.person != null){
                    if (this.person.parent){
                        this.personSprite.removeChild(this.person);
                    };
                    this.person = null;
                };
                if (GameCommonData.GameInstance.Content.CacheResource[this.gep.Role.PersonSkinName] != true){
                    this.PersonLoadComplete(this.gep.Role.PersonSkinName);
                } else {
                    if (this.gep.gameScene){
                        if (this.gep.gameScene.ResourceLoadingQueue[this.gep.Role.PersonSkinName] == null){
                            this.gep.gameScene.ResourceLoadingQueue[this.gep.Role.PersonSkinName] = new Array();
                            this.gep.gameScene.ResourceLoadingQueue[this.gep.Role.PersonSkinName].push(this);
                        } else {
                            this.gep.gameScene.ResourceLoadingQueue[this.gep.Role.PersonSkinName].push(this);
                        };
                    } else {
                        MessageTip.show("error:没有gameScene将获得不到形象");
                    };
                };
            } else {
                GameCommonData.GameInstance.Content.CacheResource[this.gep.Role.PersonSkinName] = true;
                _local2 = (GameCommonData.GameInstance.Content.RootDirectory + this.gep.Role.PersonSkinName);
                skinLoader.Add(_local2);
                this.personResource = (skinLoader.GetLoadingItem(_local2) as LoadingItem);
                this.personResource.name = _local2;
                this.personResource.addEventListener(Event.COMPLETE, onPersonResourceComplete);
                this.personResource.addEventListener(BulkProgressEvent.ERROR, onPersonSkinError);
                skinLoader.Load();
            };
        }
        private function onWeaponEffectResourceComplete(_arg1:Event):void{
            var _local2:MovieClip;
            var _local3:GameElementPlayerData;
            var _local4:Array;
            var _local5:GameElementPlayerSkin;
            _arg1.currentTarget.removeEventListener(Event.COMPLETE, onWeaponEffectResourceComplete);
            _local2 = (_arg1.currentTarget.loader.content as MovieClip);
            _local3 = new GameElementPlayerData();
            _local3.resourceName = _arg1.currentTarget.name.substring(GameCommonData.GameInstance.Content.RootDirectory.length);
            _local3.Analyze(_local2);
            if (SkinLoadComplete != null){
                SkinLoadComplete(_local3.resourceName, _local3);
            };
            if (((((this.gep.gameScene) && (!((this.gep.gameScene.ResourceLoadingQueue == null))))) && (!((this.gep.gameScene.ResourceLoadingQueue[_local3.resourceName] == null))))){
                _local4 = this.gep.gameScene.ResourceLoadingQueue[_local3.resourceName];
                _local5 = _local4.shift();
                while (_local5 != null) {
                    _local5.weaponEffectLoadComplete(_local3.resourceName);
                    _local5 = _local4.shift();
                };
            };
            this.weaponEffectLoadComplete(_local3.resourceName);
            this.weaponEffectResource = null;
            _local2 = null;
        }
        private function onPersonSkinError(_arg1:ErrorEvent):void{
            _arg1.currentTarget.removeEventListener(BulkProgressEvent.ERROR, onPersonSkinError);
            CharacterSend.sendCurrentStep(("error:资源加载失败" + this.personResource.name));
        }
        public function MountLoadComplete(_arg1:String):void{
            if (((!((this.gep.Role.MountSkinName == _arg1))) || (isDispose))){
                return;
            };
            if (ChangeEquip != null){
                ChangeEquip(GameElementSkins.EQUIP_MOUNT);
            };
            if (ChangeSkins != null){
                ChangeSkins(GameElementSkins.EQUIP_MOUNT, this.gep);
            };
            if (this.mount != null){
                if (this.mount.parent){
                    this.mount.parent.removeChild(this.mount);
                    this.mount = null;
                };
            };
            this.mount = new GameElementPlayerAnimation();
            var _local2:GameElementMountData = GameCommonData.GameInstance.Content.CacheResource[this.gep.Role.MountSkinName];
            _local2.SetAnimationData(this.mount);
            this.SetActionAndDirection();
            this.mountSprite.addChild(this.mount);
        }
        public function PersonLoadComplete(_arg1:String):void{
            if (((!((this.gep.Role.PersonSkinName == _arg1))) || (isDispose))){
                return;
            };
            if (this.person != null){
                if (this.person.parent != null){
                    this.person.parent.removeChild(this.person);
                };
                this.person = null;
            };
            if (ChangeEquip != null){
                ChangeEquip(GameElementSkins.EQUIP_PERSON);
            };
            if (ChangeSkins != null){
                ChangeSkins(GameElementSkins.EQUIP_PERSON, this.gep);
            };
            this.person = new GameElementPlayerAnimation();
            this.person.PlayFrame = this.ActionPlayFrame;
            this.person.PlayComplete = this.ActionPlayComplete;
            var _local2:GameElementPlayerData = GameCommonData.GameInstance.Content.CacheResource[this.gep.Role.PersonSkinName];
            _local2.SetAnimationData(this.person);
            this.personSprite.addChild(this.person);
            this.MaxBodyWidth = this.person.MaxWidth;
            this.MaxBodyHeight = this.person.MaxHeight;
            if (BodyLoadComplete != null){
                BodyLoadComplete();
            };
            this.SetActionAndDirection();
        }
        private function onWeaponResourceComplete(_arg1:Event):void{
            var _local2:MovieClip;
            var _local3:GameElementPlayerData;
            var _local4:Array;
            var _local5:GameElementPlayerSkin;
            _arg1.currentTarget.removeEventListener(Event.COMPLETE, onPersonResourceComplete);
            _arg1.currentTarget.removeEventListener(BulkProgressEvent.ERROR, onPersonSkinError);
            _local2 = (_arg1.currentTarget.loader.content as MovieClip);
            _local3 = new GameElementPlayerData();
            _local3.resourceName = _arg1.currentTarget.name.substring(GameCommonData.GameInstance.Content.RootDirectory.length);
            _local3.Analyze(_local2);
            if (SkinLoadComplete != null){
                SkinLoadComplete(_local3.resourceName, _local3);
            };
            if (((((this.gep.gameScene) && (!((this.gep.gameScene.ResourceLoadingQueue == null))))) && (!((this.gep.gameScene.ResourceLoadingQueue[_local3.resourceName] == null))))){
                _local4 = this.gep.gameScene.ResourceLoadingQueue[_local3.resourceName];
                _local5 = _local4.shift();
                while (_local5 != null) {
                    _local5.WeaponLoadComplete(_local3.resourceName);
                    _local5 = _local4.shift();
                };
            };
            this.WeaponLoadComplete(_local3.resourceName);
            this.weaponResource = null;
            _local2 = null;
        }
        public function person_MountLoadComplete(_arg1:String):void{
            if (((!((this.gep.Role.personMountSkinName == _arg1))) || (isDispose))){
                return;
            };
            if (ChangeEquip != null){
                ChangeEquip(GameElementSkins.EQUIP_MOUNT);
            };
            if (ChangeSkins != null){
                ChangeSkins(GameElementSkins.EQUIP_MOUNT, this.gep);
            };
            if (this.person_mount != null){
                if (this.person_mount.parent){
                    this.person_mount.parent.removeChild(this.person_mount);
                };
                this.person_mount = null;
            };
            this.person_mount = new GameElementPlayerAnimation();
            var _local2:GameElementPlayerMountData = GameCommonData.GameInstance.Content.CacheResource[this.gep.Role.personMountSkinName];
            _local2.SetAnimationData(this.person_mount);
            this.person_mountSprite.addChild(this.person_mount);
            this.SetActionAndDirection();
        }
        override protected function onMouseMove(_arg1:MouseEvent):void{
            var _local2:uint;
            var _local3:uint;
            var _local4:uint;
            var _local5:uint;
            var _local6:uint;
            if (((person) && (person.bitmapData))){
                _local3 = person.bitmapData.getPixel32(Math.abs((this.mouseX - person.x)), Math.abs((this.mouseY - person.y)));
            };
            if (((weapon) && (weapon.bitmapData))){
                _local2 = weapon.bitmapData.getPixel32(Math.abs((this.mouseX - weapon.x)), Math.abs((this.mouseY - weapon.y)));
            };
            if (((mount) && (mount.bitmapData))){
                _local4 = mount.bitmapData.getPixel32(Math.abs((this.mouseX - mount.x)), Math.abs((this.mouseY - mount.y)));
            };
            if (((person_mount) && (person_mount.bitmapData))){
                _local5 = person_mount.bitmapData.getPixel32(Math.abs((this.mouseX - person_mount.x)), Math.abs((this.mouseY - person_mount.y)));
            };
            if (((((((!((_local3 == 0))) || (!((_local2 == 0))))) || (!((_local4 == 0))))) || (!((_local5 == 0))))){
                this.AddHighlight();
            } else {
                this.DeleteHighlight();
            };
        }
        override protected function ActionPlaying(_arg1:GameTime):void{
            if ((((((this.person == null)) && (!((GameCommonData.GameInstance.Content.CacheResource[this.gep.Role.PersonSkinName] == null))))) && (!((GameCommonData.GameInstance.Content.CacheResource[this.gep.Role.PersonSkinName] == true))))){
                if (this.gep.Role.isStalling == 0){
                    PersonLoadComplete(this.gep.Role.PersonSkinName);
                    MessageTip.show("资源已经加载完成--");
                };
            };
            if (((this.person) && (this.person.parent))){
                this.person.Update(_arg1);
            };
            if (((this.weapon) && (this.weapon.parent))){
                this.weapon.Update(_arg1);
            };
            if (((this.weapon_effect) && (this.weapon_effect.parent))){
                this.weapon_effect.Update(_arg1);
            };
            if (((this.mount) && (this.mount.parent))){
                this.mount.Update(_arg1);
            };
            if (((this.person_mount) && (this.person_mount.parent))){
                this.person_mount.Update(_arg1);
            };
        }
        public function ChangePerson_Mount(_arg1:Boolean=false):void{
            var _local2:String;
            if (this.gep.Role.personMountSkinName != null){
                if (this.person_mount != null){
                    if (this.person_mount.parent){
                        this.person_mount.parent.removeChild(this.person_mount);
                    };
                    this.person_mount = null;
                };
                if (GameCommonData.GameInstance.Content.CacheResource[this.gep.Role.personMountSkinName] != null){
                    if (GameCommonData.GameInstance.Content.CacheResource[this.gep.Role.personMountSkinName] != true){
                        this.person_MountLoadComplete(this.gep.Role.personMountSkinName);
                    } else {
                        if (this.gep.gameScene){
                            if (this.gep.gameScene.ResourceLoadingQueue[this.gep.Role.personMountSkinName] == null){
                                this.gep.gameScene.ResourceLoadingQueue[this.gep.Role.personMountSkinName] = new Array();
                                this.gep.gameScene.ResourceLoadingQueue[this.gep.Role.personMountSkinName].push(this);
                            } else {
                                this.gep.gameScene.ResourceLoadingQueue[this.gep.Role.personMountSkinName].push(this);
                            };
                        };
                    };
                } else {
                    GameCommonData.GameInstance.Content.CacheResource[this.gep.Role.personMountSkinName] = true;
                    _local2 = (GameCommonData.GameInstance.Content.RootDirectory + this.gep.Role.personMountSkinName);
                    skinLoader.Add(_local2);
                    this.person_mountResource = skinLoader.GetLoadingItem(_local2);
                    this.person_mountResource.name = _local2;
                    this.person_mountResource.addEventListener(Event.COMPLETE, onPerson_MountResourceComplete);
                    skinLoader.Load();
                };
            };
        }

    }
}//package OopsEngine.Scene.StrategyElement.Person 
