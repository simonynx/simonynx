//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Scene.StrategyElement {
    import flash.events.*;
    import OopsFramework.*;
    import Manager.*;
    import OopsFramework.Utils.*;
    import flash.filters.*;
    import Utils.*;

	/**
	 *技能 
	 * @author wengliqiang
	 * 
	 */	
    public class GameElementSkins extends InteractivePNG {

        public static const DIRECTION_DOWN:int = 2;
        public static const ACTION_NEAR_ATTACK:String = "action_near_attack";
        public static const ACTION_MEDITATION:String = "meditation";
        public static const EQUIP_MOUNT:String = "mount";
        public static const ACTION_DEAD:String = "dead";
        public static const EQUIP_ALL:String = "all";
        public static const ACTION_ACCEPT_ATTACK:String = "accept_attack";
        public static const ACTION_STATIC:String = "static";
        public static const DIRECTION_RIGHT:int = 6;
        public static const ACTION_MOUNT_STATIC:String = "mount_static";
        public static const DIRECTION_RIGHT_UP:int = 9;
        public static const ACTION_AFTER:String = "action_after";
        public static const ACTION_MOUNT_RUN:String = "mount_run";
        public static const EQUIP_WEAOIB:String = "weaoib";
        public static const DIRECTION_RIGHT_DOWN:int = 3;
        public static const DIRECTION_LEFT:int = 4;
        public static const ACTION_RUN:String = "run";
        public static const EQUIP_PERSON:String = "person";
        public static const EQUIP_PERSON_MOUNT:String = "person_mount";
        public static const EQUIP_WEAPONE_EFFECT:String = "weapon_effect";
        public static const DIRECTION_LEFT_UP:int = 7;
        public static const ACTION_FAR_ATTACK:String = "action_far_attack";
        public static const DIRECTION_LEFT_DOWN:int = 1;
        public static const DIRECTION_UP:int = 8;

        public static var GameElementSkinsID:uint;

        public var ActionPlayComplete:Function;
        protected var currentDirection:int = 2;
        private var _selfSkinId:uint;
        protected var isDispose:Boolean;
        public var staticFrameRate:uint = 0;
        public var BodyLoadComplete:Function;
        public var runFrameRate:uint = 0;
        public var ChooseTarger:Function;
        public var ChangeSkins:Function;
        public var UnLoadWeapon:Function;
        public var ChangeEquip:Function;
        public var MaxBodyHeight:int;
        protected var gep:GameElementAnimal;
        private var isEffect:Boolean = true;
        public var MaxBodyWidth:int;
        private var isCanSelect:Boolean = false;
        public var ActionPlayFrame:Function;
        public var MouseOverTarger:Function;
        public var currentActionType:String = "static";
        private var frameRate:Timer;
        public var SkinLoadComplete:Function;
        public var MouseOutTarger:Function;

        public function GameElementSkins(_arg1:GameElementAnimal){
            this.gep = _arg1;
            this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
            this.frameRate = new Timer();
            this.mouseChildren = false;
            super(true);
            _selfSkinId = GameElementSkinsID;
            GameElementSkinsID++;
        }
        public function Update(_arg1:GameTime):void{
            if (this.frameRate.IsNextTime(_arg1)){
                this.ActionPlaying(_arg1);
            };
        }
        public function get SelfSkinId():uint{
            return (_selfSkinId);
        }
        protected function ActionPlaying(_arg1:GameTime):void{
        }
        public function InitActionDead(_arg1:int):void{
            this.gep.Role.ActionState = GameElementSkins.ACTION_DEAD;
            this.currentActionType = GameElementSkins.ACTION_DEAD;
            this.currentDirection = this.gep.Role.Direction;
            this.ChangeAction(this.currentActionType, true, _arg1);
        }
        protected function SetActionAndDirection(_arg1:int=0):void{
        }
        public function LoadSkin(_arg1:String=null):void{
        }
        public function DeleteHighlight():void{
            this.filters = null;
            this.isCanSelect = false;
            this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            if (((!((MouseOutTarger == null))) && ((PlayerMouseController.CurrentSkinId == SelfSkinId)))){
                MouseOutTarger();
            };
        }
        public function dispose():void{
            this.isDispose = true;
            this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            this.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            this.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
        }
        public function reSet():void{
            FrameRate = 0;
            this.isDispose = false;
            this.mouseChildren = true;
            this.mouseEnabled = true;
            this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
            this.x = 0;
            this.y = 0;
        }
        public function set FrameRate(_arg1:uint):void{
            this.frameRate.Frequency = _arg1;
        }
        public function ChangeAction(_arg1:String, _arg2:Boolean=false, _arg3:int=0):void{
            if (((((_arg2) || (!((this.currentActionType == _arg1))))) || (!((this.currentDirection == this.gep.Role.Direction))))){
                this.gep.Role.ActionState = _arg1;
                this.currentActionType = _arg1;
                this.currentDirection = this.gep.Role.Direction;
                this.SetActionAndDirection(_arg3);
            };
        }
        public function AddHighlight():void{
            var _local1:GlowFilter;
            var _local2:Array;
            if (this.isDispose == true){
                return;
            };
            if (isCanSelect == false){
                _local1 = new GlowFilter(10092543, 1, 10, 10, 3, 1, false, false);
                _local2 = new Array(_local1);
                this.filters = _local2;
                this.isCanSelect = true;
                this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
                if (MouseOverTarger != null){
                    MouseOverTarger();
                };
            };
        }
        public function RemovePersonSkin(_arg1:String):void{
        }
        protected function onMouseDown(_arg1:MouseEvent):void{
            if (ChooseTarger != null){
                ChooseTarger(this.gep);
            };
        }
        public function get FrameRate():uint{
            return (this.frameRate.Frequency);
        }
        override protected function removeFilters():void{
            DeleteHighlight();
        }
        public function LoadComplete():void{
        }
        private function onMouseOut(_arg1:MouseEvent=null):void{
            if (this.isEffect){
                DeleteHighlight();
            };
        }
        protected function onMouseMove(_arg1:MouseEvent):void{
        }
        private function onMouseOver(_arg1:MouseEvent):void{
            if (this.isDispose == true){
                return;
            };
            if (this.isEffect){
                AddHighlight();
            };
        }
        public function IsEffect(_arg1:Boolean):void{
            this.isEffect = _arg1;
            this.mouseEnabled = _arg1;
        }

    }
}//package OopsEngine.Scene.StrategyElement 
