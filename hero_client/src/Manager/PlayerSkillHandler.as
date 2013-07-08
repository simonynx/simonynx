//Created by Action Script Viewer - http://www.buraks.com/asv
package Manager {
    import flash.display.*;
    import GameUI.UICore.*;
    import OopsEngine.Skill.*;
    import OopsEngine.Role.*;
    import OopsEngine.Scene.*;
    import OopsEngine.Scene.StrategyElement.*;
    import GameUI.Modules.HeroSkill.SkillConst.*;
    import flash.geom.*;
    import flash.utils.*;
    import OopsEngine.Utils.*;
    import GameUI.Proxy.*;
    import OopsEngine.Scene.StrategyElement.Person.*;
    import OopsEngine.Graphics.Tagger.*;
    import GameUI.Modules.Transcript.Data.*;

    public class PlayerSkillHandler extends Handler {

        private var clearNumAuto:int;

        public function PlayerSkillHandler(_arg1:GameElementAnimal, _arg2:Handler, _arg3:Array, _arg4:SkillInfo, _arg5:GameSkillBuff, _arg6:int, _arg7:Point=null, _arg8:int=1){
            super(_arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8);
        }
        public static function LoadEffect(_arg1:GameSkillResource):void{
            GameCommonData.SkillOnLoadEffectList[_arg1.EffectName] = _arg1;
        }

        public function AddEffect(_arg1:GameSkillEffect):void{
            var _local2:SmoothMove;
            var _local3:GameSkillResource = (GameCommonData.SkillOnLoadEffectList[skillInfo.Effect] as GameSkillResource);
            if (_local3 == null){
                return;
            };
            var _local4:SkillAnimation = _local3.GetAnimation();
            if ((((_local4 == null)) || ((_arg1.TargerPlayer == null)))){
                IsSmoothMoving = false;
                return;
            };
            var _local5:Sprite = new Sprite();
            _local4.StartClip("jn");
            if (_local4.eventArgs.CurrentClipTotalFrameCount > 0){
                if ((this.Animal is GameElementPlayer)){
                    this.Animal.SetAction(GameElementSkins.ACTION_NEAR_ATTACK);
                };
                _local5.addChild(_local4);
                _local5.x = this.Animal.HitX;
                _local5.y = this.Animal.HitY;
                _local5.mouseEnabled = false;
                GameCommonData.GameInstance.GameScene.GetGameScene.TopLayer.addChild(_local5);
                _local2 = new SmoothMove(_local5, 30);
                _arg1.smoothMove = _local2;
                _arg1.Effect = _local5;
                _local2.Move([new Point(_arg1.TargerPlayer.HitX, _arg1.TargerPlayer.HitY)]);
            } else {
                GameCommonData.SkillOnLoadEffectList[skillInfo.Effect] = null;
                GameCommonData.SkillLoadEffectList[skillInfo.Effect] = null;
            };
            _arg1.EffectState = 1;
            this.Process = 2;
            IsSmoothMoving = true;
        }
        public function AddPlayerHitEffect(_arg1:GameElementAnimal):void{
            var _local2:GameSkillResource;
            var _local3:GameSkillResource;
            var _local4:SkillAnimation;
            if (_arg1.isDispose){
                return;
            };
            if (((_arg1.IsLoadSkins) && (!((_arg1.Role.ActionState == GameElementSkins.ACTION_DEAD))))){
                if (skillInfo.HitEffect.length > 0){
                    if (GameCommonData.SkillLoadEffectList[skillInfo.HitEffect] == null){
                        _local2 = new GameSkillResource();
                        _local2.SkillID = skillInfo.Id;
                        _local2.EffectName = skillInfo.HitEffect;
                        _local2.EffectPath = GameCommonData.GetSkillEffectPath(skillInfo.HitEffect);
                        _local2.OnLoadEffect = PlayerSkillHandler.LoadEffect;
                        _local2.EffectBR.LoadComplete = _local2.onEffectComplete;
                        _local2.EffectBR.Download.Add(_local2.EffectPath);
                        _local2.EffectBR.Load();
                        GameCommonData.SkillLoadEffectList[skillInfo.HitEffect] = skillInfo.HitEffect;
                    } else {
                        if (GameCommonData.SkillOnLoadEffectList[skillInfo.HitEffect] != null){
                            _local3 = (GameCommonData.SkillOnLoadEffectList[skillInfo.HitEffect] as GameSkillResource);
                            _local4 = _local3.GetAnimation();
                            if (_local4 == null){
                                return;
                            };
                            _local4.offsetX = _arg1.PlayerHitX;
                            _local4.offsetY = _arg1.PlayerHitY;
                            _local4.StartClip("jn");
                            if (_local4.eventArgs.CurrentClipTotalFrameCount > 0){
                                if (((SharedManager.getInstance().showSkillEffect) || ((this.Animal == GameCommonData.Player)))){
                                    _arg1.addChild(_local4);
                                };
                                _local4.player = _arg1;
                                _local4.PlayComplete = PlayerPlayComplete;
                                _arg1.skillAnimation.push(_local4);
                            } else {
                                GameCommonData.SkillOnLoadEffectList[skillInfo.HitEffect] = null;
                                GameCommonData.SkillLoadEffectList[skillInfo.HitEffect] = null;
                            };
                        };
                    };
                };
            };
        }
        public function AddHitEffect(_arg1:Point):void{
            var _local2:GameSkillResource;
            var _local3:GameSkillResource;
            var _local4:SkillAnimation;
            if (skillInfo.HitEffect.length > 0){
                if (GameCommonData.SkillLoadEffectList[skillInfo.HitEffect] == null){
                    _local2 = new GameSkillResource();
                    _local2.SkillID = skillInfo.Id;
                    _local2.EffectName = skillInfo.HitEffect;
                    _local2.EffectPath = GameCommonData.GetSkillEffectPath(skillInfo.HitEffect);
                    _local2.OnLoadEffect = PlayerSkillHandler.LoadEffect;
                    _local2.EffectBR.LoadComplete = _local2.onEffectComplete;
                    _local2.EffectBR.Download.Add(_local2.EffectPath);
                    _local2.EffectBR.Load();
                    GameCommonData.SkillLoadEffectList[skillInfo.HitEffect] = skillInfo.HitEffect;
                } else {
                    if (GameCommonData.SkillOnLoadEffectList[skillInfo.HitEffect] != null){
                        _local3 = (GameCommonData.SkillOnLoadEffectList[skillInfo.HitEffect] as GameSkillResource);
                        _local4 = _local3.GetAnimation();
                        if (_local4 == null){
                            return;
                        };
                        _local4.offsetX = _arg1.x;
                        _local4.offsetY = _arg1.y;
                        _local4.StartClip("jn");
                        if (_local4.eventArgs.CurrentClipTotalFrameCount > 0){
                            if (((SharedManager.getInstance().showSkillEffect) || ((this.Animal == GameCommonData.Player)))){
                                GameCommonData.GameInstance.GameScene.GetGameScene.TopLayer.addChild(_local4);
                            };
                            _local4.gameScene = GameCommonData.GameInstance.GameScene.GetGameScene.TopLayer;
                            _local4.PlayComplete = PlayerPlayComplete;
                            this.Animal.skillAnimation.push(_local4);
                        } else {
                            GameCommonData.SkillOnLoadEffectList[skillInfo.HitEffect] = null;
                            GameCommonData.SkillLoadEffectList[skillInfo.HitEffect] = null;
                        };
                    };
                };
            };
        }
        public function AddAttack():void{
            clearTimeout(clearNumAuto);
            if (GameCommonData.IsAddAttack){
                if (GameCommonData.Player.IsAutomatism){
                    if ((((this.Animal.Role.Id == GameCommonData.Player.Role.Id)) && (GameSkillMode.IsCommon(skillInfo.Id)))){
                        if (SkillEffectList[0].TargerState != SkillInfo.TARGET_DEAD){
                            clearNumAuto = setTimeout(AutomatismController.AutoUseSkill, 300);
                        };
                    };
                };
            };
        }
        override public function Run():void{
            switch (this.Process){
                case 1:
                    AddSkill();
                    break;
                case 2:
                    SkillFly();
                    break;
                case 3:
                    DotSkill();
                    break;
                case 4:
                    rushSkill();
                    break;
            };
        }
        override public function Clear():void{
            var _local1:GameSkillEffect;
            if (skillInfo.SkillMode == SkillInfo.SPELL_CATEGORY_MOVEATONCE){
                (this.Animal as GameElementPlayer).IsRushing = false;
                this.Animal.SetMoveSpend(5);
                if (this.Animal.Role.ConvoyFlag > 0){
                    ConvoyController.setMoveSpeed(this.Animal);
                };
            };
            for each (_local1 in this.SkillEffectList) {
                if (((_local1.HitEffect) && (_local1.HitEffect.parent))){
                    _local1.HitEffect.parent.removeChild(_local1.HitEffect);
                    _local1.HitEffect = null;
                };
                if (((_local1.Effect) && (_local1.Effect.parent))){
                    _local1.Effect.parent.removeChild(_local1.Effect);
                    _local1.Effect = null;
                };
                if (((!((GameCommonData.TargetAnimal == null))) && ((_local1.TargerPlayer.Role.Id == GameCommonData.TargetAnimal.Role.Id)))){
                    ShowAttackPrompt(_local1);
                };
                _local1.TargerPlayer = null;
                _local1.smoothMove = null;
            };
            clearTimeout(clearNumAuto);
            super.Clear();
        }
        public function PlayerPlayComplete(_arg1:SkillAnimation):void{
            if (((!((_arg1 == null))) && (_arg1.parent))){
                _arg1.parent.removeChild(_arg1);
                _arg1 = null;
            };
        }
        public function SkillArrive(_arg1:GameSkillEffect):void{
            GameCommonData.GameInstance.GameScene.GetGameScene.TopLayer.removeChild(_arg1.Effect);
            _arg1.smoothMove = null;
            _arg1.Effect = null;
            AddPlayerHitEffect(_arg1.TargerPlayer);
            ShowAttackPrompt(_arg1);
            _arg1.EffectState = 2;
            for each (_arg1 in this.SkillEffectList) {
                if (_arg1.EffectState != 2){
                    return;
                };
            };
            this.IsSmoothMoving = false;
            super.NextHendler();
            if (this.Animal.handler != null){
                this.Animal.handler.Run();
            };
        }
        public function SkillFly():void{
            var _local1:GameSkillEffect;
            var _local2:Rectangle;
            for each (_local1 in this.SkillEffectList) {
                if (_local1.smoothMove != null){
                    _local1.smoothMove.Move([new Point(_local1.TargerPlayer.HitX, _local1.TargerPlayer.HitY)]);
                    Orientation(new Point(_local1.TargerPlayer.HitX, _local1.TargerPlayer.HitY), _local1.Effect);
                    _local2 = new Rectangle((_local1.TargerPlayer.HitX - 25), (_local1.TargerPlayer.HitY - 25), 50, 50);
                    if (_local2.containsPoint(new Point(_local1.Effect.x, _local1.Effect.y))){
                        SkillArrive(_local1);
                    };
                };
            };
        }
        public function AddNoEffAttack(_arg1:GameSkillEffect):void{
            if ((this.Animal is GameElementPlayer)){
                this.Animal.SetAction(GameElementSkins.ACTION_NEAR_ATTACK);
            };
            if (_arg1.TargerPlayer){
                AddPlayerHitEffect(_arg1.TargerPlayer);
                ShowAttackPrompt(_arg1);
            };
        }
        public function SetNextHandler():void{
            this.Animal.Skins.currentActionType = GameElementSkins.ACTION_AFTER;
            this.Animal.Role.ActionState = GameElementSkins.ACTION_AFTER;
            AddAttack();
            super.NextHendler();
            if (this.Animal.handler != null){
                this.Animal.handler.Run();
            };
        }
        public function DotSkill():void{
            var _local1:GameSkillEffect;
            if (SkillEffectList != null){
                for each (_local1 in this.SkillEffectList) {
                    ShowAttackPrompt(_local1);
                };
            };
            super.NextHendler();
            if (this.Animal.handler != null){
                this.Animal.handler.Run();
            };
        }
        public function ShowAttackPrompt(_arg1:GameSkillEffect):void{
            var _local2:Point;
            if (IsShowAttackPrompt(_arg1)){
                switch (_arg1.TargerState){
                    case SkillInfo.TARGET_ERUPTIVE_HP:
                        if (_arg1.TargetValue1 > 0){
                            if (skillInfo != null){
                                if (GameSkillMode.IsDoctorSkill(skillInfo, Animal, _arg1.TargerPlayer)){
                                    _arg1.TargerPlayer.showAttackFace(AttackFace.CHANGE_HP_RECOVER, _arg1.TargetValue1);
                                } else {
                                    if (this.Animal.Role.Type == GameRole.TYPE_PET){
                                        _arg1.TargerPlayer.showAttackFace(AttackFace.ATTACK_PET_CRIT, -(_arg1.TargetValue1));
                                    } else {
                                        if (this.Animal == GameCommonData.Player){
                                            SpeciallyEffectController.getInstance().screen_shake();
                                        };
                                        _arg1.TargerPlayer.showAttackFace(AttackFace.ATTACK_CRITICALHIT, -(_arg1.TargetValue1));
                                    };
                                };
                            };
                            if (_arg1.TargetValue2 > 0){
                                if (skillInfo != null){
                                    _arg1.TargerPlayer.showAttackFace(AttackFace.CHANGE_MP, -(_arg1.TargetValue2));
                                };
                            };
                        };
                        break;
                    case SkillInfo.TARGET_HP:
                    case SkillInfo.TARGET_RESIST:
                        if (_arg1.TargerState == SkillInfo.TARGET_RESIST){
                            _arg1.TargerPlayer.showAttackFace(AttackFace.ATTACK_RESIST);
                        };
                        if (_arg1.TargetValue1 > 0){
                            if (skillInfo != null){
                                if (GameSkillMode.IsDoctorSkill(skillInfo, Animal, _arg1.TargerPlayer)){
                                    _arg1.TargerPlayer.showAttackFace(AttackFace.CHANGE_HP_RECOVER, _arg1.TargetValue1);
                                } else {
                                    if (this.Animal.Role.Type == GameRole.TYPE_PET){
                                        _arg1.TargerPlayer.showAttackFace(AttackFace.CHANGE_HP_OTHER_FROM_PET, -(_arg1.TargetValue1));
                                    } else {
                                        if ((((this.Animal == GameCommonData.Player)) || ((this.Animal == GameCommonData.Player.Role.UsingPetAnimal)))){
                                            _arg1.TargerPlayer.showAttackFace(AttackFace.CHANGE_HP_OTHER, -(_arg1.TargetValue1));
                                        } else {
                                            _arg1.TargerPlayer.showAttackFace(AttackFace.CHANGE_HP, -(_arg1.TargetValue1));
                                        };
                                    };
                                };
                            };
                        };
                        if (_arg1.TargetValue2 > 0){
                            _arg1.TargerPlayer.showAttackFace(AttackFace.CHANGE_MP, -(_arg1.TargetValue2));
                        };
                        break;
                    case SkillInfo.TARGET_EVASION:
                        if (_arg1.TargerPlayer == GameCommonData.Player){
                            _arg1.TargerPlayer.showAttackFace(AttackFace.ATTACK_LOSE);
                        } else {
                            if (_arg1.TargerPlayer == GameCommonData.Player.Role.UsingPetAnimal){
                                _arg1.TargerPlayer.showAttackFace(AttackFace.ATTACK_LOSE_FROM_PET);
                            } else {
                                _arg1.TargerPlayer.showAttackFace(AttackFace.ATTACK_MISS);
                            };
                        };
                        break;
                    case SkillInfo.TARGET_SUCK:
                        CombatController.SuckPrompt(_arg1.TargerPlayer);
                        break;
                    case SkillInfo.TARGET_REBOUND:
                        _local2 = new Point(_arg1.TargetValue1, _arg1.TargetValue2);
                        SpeciallyEffectController.getInstance().hitBack(_arg1.TargerPlayer, _local2, 600, null);
                        break;
                };
            };
        }
        private function rushSkill():void{
            var _local1:int;
            if (this.Animal.IsMoving == false){
                AddPlayerHitEffect(this.SkillEffectList[0].TargerPlayer);
                ShowAttackPrompt(this.SkillEffectList[0]);
                this.IsSmoothMoving = false;
                this.Animal.SetMoveSpend(5);
                if (this.Animal.Role.ConvoyFlag > 0){
                    ConvoyController.setMoveSpeed(this.Animal);
                };
                _local1 = Vector2.DirectionByTan(this.Animal.GameX, this.Animal.GameY, this.SkillEffectList[0].TargerPlayer.GameX, this.SkillEffectList[0].TargerPlayer.GameY);
                this.Animal.SetDirection(_local1);
                this.Animal.SetAction(GameElementSkins.ACTION_NEAR_ATTACK);
                (this.Animal as GameElementPlayer).IsRushing = false;
                super.NextHendler();
                if (this.Animal.handler != null){
                    this.Animal.handler.Run();
                };
            };
        }
        public function IsShowAttackPrompt(_arg1:GameSkillEffect):Boolean{
            var _local2:Boolean;
            if (((_arg1.TargerPlayer) && ((((_arg1.TargerPlayer.Role.Id == GameCommonData.Player.Role.Id)) || (((!((GameCommonData.Player.Role.UsingPetAnimal == null))) && ((GameCommonData.Player.Role.UsingPetAnimal.Role.Id == _arg1.TargerPlayer.Role.Id)))))))){
                _local2 = true;
            };
            if (((Animal) && ((this.Animal.Role.Id == GameCommonData.Player.Role.Id)))){
                _local2 = true;
            };
            if (((Animal) && (((!((GameCommonData.Player.Role.UsingPetAnimal == null))) && ((this.Animal.Role.Id == GameCommonData.Player.Role.UsingPetAnimal.Role.Id)))))){
                _local2 = true;
            };
            if (((_arg1.TargerPlayer) && ((_arg1.TargerPlayer.Role.Type == GameRole.TYPE_NPC)))){
                _local2 = true;
            };
            if (((_arg1) && (_arg1.TargerPlayer))){
                if ((((UIFacade.GetInstance().retrieveProxy(DataProxy.NAME) as DataProxy).TESLPanelIsOpen) && (!((TESL_CommonData.Avatars.indexOf(_arg1.TargerPlayer.Role.MonsterTypeID) == -1))))){
                    _local2 = true;
                };
            };
            return (_local2);
        }
        public function SetNextProcess():void{
            AddAttack();
            this.Animal.Skins.currentActionType = GameElementSkins.ACTION_AFTER;
            this.Animal.Role.ActionState = GameElementSkins.ACTION_AFTER;
            if (this.Animal.handler != null){
                this.Animal.handler.Run();
            };
        }
        public function Orientation(_arg1:Point, _arg2:DisplayObject):void{
            var _local3:Number = (_arg2.x - _arg1.x);
            var _local4:Number = (_arg2.y - _arg1.y);
            var _local5:Number = ((Math.atan2(_local4, _local3) * 180) / Math.PI);
            _arg2.rotation = _local5;
        }
        public function AddSkill():void{
            var _local1:GameSkillEffect;
            var _local2:GameSkillResource;
            var _local3:int;
            var _local4:GameSkillResource;
            var _local5:SkillAnimation;
            var _local6:Sprite;
            var _local7:SmoothMove;
            var _local8:int;
            var _local9:int;
            var _local10:Point;
            if (((((((((!((SkillEffectList == null))) && ((SkillEffectList.length > 0)))) && (!((SkillEffectList[0].TargerPlayer == null))))) || (GameSkillMode.IsShowRect(skillInfo.SkillType)))) || ((skillInfo.SkillMode == 12)))){
                switch (skillInfo.SkillMode){
                    case SkillInfo.SPELL_CATEGORY_CLEAR_FORBID:
                        AddPlayerHitEffect(this.Animal);
                        SetNextHandler();
                        break;
                    case SkillInfo.SPELL_CATEGORY_MELEEATTACK:
                        AddPlayerHitEffect(SkillEffectList[0].TargerPlayer);
                        ShowAttackPrompt(this.SkillEffectList[0]);
                        SetNextHandler();
                        break;
                    case SkillInfo.SPELL_CATEGORY_HEAL:
                        for each (_local1 in this.SkillEffectList) {
                            AddPlayerHitEffect(_local1.TargerPlayer);
                            ShowAttackPrompt(_local1);
                        };
                        SetNextHandler();
                        break;
                    case SkillInfo.SPELL_CATEGORY_NULL:
                        for each (_local1 in this.SkillEffectList) {
                            ShowAttackPrompt(_local1);
                        };
                        SetNextHandler();
                        break;
                    case SkillInfo.SPELL_CATEGORY_BUFFORDOT:
                        AddPlayerHitEffect(SkillEffectList[0].TargerPlayer);
                        SetNextHandler();
                        break;
                    case SkillInfo.SPELL_CATEGORY_REPEATATTACK:
                        if (GameCommonData.SkillLoadEffectList[skillInfo.Effect] == null){
                            _local2 = new GameSkillResource();
                            _local2.SkillID = skillInfo.Id;
                            _local2.EffectName = skillInfo.Effect;
                            _local2.OnLoadEffect = PlayerSkillHandler.LoadEffect;
                            _local2.EffectPath = GameCommonData.GetSkillEffectPath(skillInfo.Effect);
                            _local2.EffectBR.LoadComplete = _local2.onEffectComplete;
                            _local2.EffectBR.Download.Add(_local2.EffectPath);
                            _local2.EffectBR.Load();
                            GameCommonData.SkillLoadEffectList[skillInfo.Effect] = skillInfo.Effect;
                            this.Process = 3;
                        } else {
                            if (GameCommonData.SkillOnLoadEffectList[skillInfo.Effect] != null){
                                _local3 = 0;
                                for each (_local1 in this.SkillEffectList) {
                                    setTimeout(AddEffect, _local3, _local1);
                                    _local3 = (_local3 + 500);
                                };
                            } else {
                                this.Process = 3;
                            };
                        };
                        if (this.Process == 3){
                            SetNextProcess();
                        } else {
                            this.Animal.Role.ActionState = GameElementSkins.ACTION_AFTER;
                            this.Animal.Skins.currentActionType = GameElementSkins.ACTION_AFTER;
                            AddAttack();
                        };
                        break;
                    case SkillInfo.SPELL_CATEGORY_REPEATATTACK_MELEE:
                        _local3 = 0;
                        for each (_local1 in this.SkillEffectList) {
                            setTimeout(AddNoEffAttack, _local3, _local1);
                            _local3 = (_local3 + 500);
                        };
                        SetNextHandler();
                        break;
                    case SkillInfo.SPELL_CATEGORY_REMOTEATTACK:
                        for each (_local1 in this.SkillEffectList) {
                            if (GameCommonData.SkillLoadEffectList[skillInfo.Effect] == null){
                                _local2 = new GameSkillResource();
                                _local2.SkillID = skillInfo.Id;
                                _local2.EffectName = skillInfo.Effect;
                                _local2.OnLoadEffect = PlayerSkillHandler.LoadEffect;
                                _local2.EffectPath = GameCommonData.GetSkillEffectPath(skillInfo.Effect);
                                _local2.EffectBR.LoadComplete = _local2.onEffectComplete;
                                _local2.EffectBR.Download.Add(_local2.EffectPath);
                                _local2.EffectBR.Load();
                                GameCommonData.SkillLoadEffectList[skillInfo.Effect] = skillInfo.Effect;
                                this.Process = 3;
                            } else {
                                if (GameCommonData.SkillOnLoadEffectList[skillInfo.Effect] != null){
                                    _local4 = (GameCommonData.SkillOnLoadEffectList[skillInfo.Effect] as GameSkillResource);
                                    _local5 = _local4.GetAnimation();
                                    _local6 = new Sprite();
                                    _local5.StartClip("jn");
                                    if (_local5.eventArgs.CurrentClipTotalFrameCount > 0){
                                        _local6.addChild(_local5);
                                        _local6.x = this.Animal.HitX;
                                        _local6.y = this.Animal.HitY;
                                        _local6.mouseEnabled = false;
                                        _local6.mouseChildren = false;
                                        GameCommonData.GameInstance.GameScene.GetGameScene.TopLayer.addChild(_local6);
                                        _local7 = new SmoothMove(_local6, 30);
                                        _local1.smoothMove = _local7;
                                        _local1.Effect = _local6;
                                        _local7.Move([new Point(_local1.TargerPlayer.HitX, _local1.TargerPlayer.HitY)]);
                                    } else {
                                        GameCommonData.SkillOnLoadEffectList[skillInfo.Effect] = null;
                                        GameCommonData.SkillLoadEffectList[skillInfo.Effect] = null;
                                    };
                                    this.Process = 2;
                                } else {
                                    this.Process = 3;
                                };
                            };
                            _local1.EffectState = 1;
                        };
                        IsSmoothMoving = true;
                        this.Animal.Role.ActionState = GameElementSkins.ACTION_AFTER;
                        this.Animal.Skins.currentActionType = GameElementSkins.ACTION_AFTER;
                        AddAttack();
                        break;
                    case SkillInfo.SPELL_CATEGORY_TEAMSPELL:
                        AddPlayerHitEffect(this.Animal);
                        for each (_local1 in this.SkillEffectList) {
                            ShowAttackPrompt(_local1);
                        };
                        SetNextHandler();
                        break;
                    case SkillInfo.SPELL_CATEGORY_RANGESPELL:
                        AddHitEffect(this.TargerPoint);
                        this.Process = 3;
                        SetNextProcess();
                        break;
                    case SkillInfo.SPELL_CATEGORY_MOVEATONCE:
                        _local8 = SkillEffectList[0].TargerPlayer.Role.TileX;
                        _local9 = SkillEffectList[0].TargerPlayer.Role.TileY;
                        _local10 = new Point(_local8, _local9);
                        this.Animal.Stop();
                        (this.Animal as GameElementPlayer).IsRushing = true;
                        this.Animal.SetMoveSpend(40);
                        this.Animal.MoveTile(_local10, 1);
                        IsSmoothMoving = true;
                        this.Process = 4;
                        break;
                    case SkillInfo.SPELL_CATEGORY_TREASURES:
                        for each (_local1 in this.SkillEffectList) {
                            ShowAttackPrompt(_local1);
                        };
                        SetNextHandler();
                        break;
                    case SkillInfo.SPELL_CATEGORY_GOUND_ATTACK_SELF:
                        AddPlayerHitEffect(this.Animal);
                        for each (_local1 in this.SkillEffectList) {
                            ShowAttackPrompt(_local1);
                        };
                        SetNextHandler();
                        break;
                    case SkillInfo.SPELL_CATEGORY_GOUND_ATTACK_TARGET:
                        AddPlayerHitEffect(SkillEffectList[0].TargerPlayer);
                        for each (_local1 in this.SkillEffectList) {
                            ShowAttackPrompt(_local1);
                        };
                        SetNextHandler();
                        break;
                };
            };
        }

    }
}//package Manager 
