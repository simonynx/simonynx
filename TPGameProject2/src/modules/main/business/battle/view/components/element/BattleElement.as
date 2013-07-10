package modules.main.business.battle.view.components.element
{
	import flash.display.Sprite;

	import tempest.core.IDisposable;
	import tempest.engine.graphics.avatar.Avatar;
	import tempest.engine.graphics.tagger.HeadFace;

	public class BattleElement extends Sprite implements IDisposable
	{
		protected var _headFace:HeadFace;
		protected var _mainLayer:Sprite;
		private var _data:Object;
		public var logicX:int;
		public var logicY:int;
		public var camp:int;
		private var _guid:int;

		public function BattleElement(guid:int)
		{
			super();
			_guid = guid;
			_mainLayer = new Sprite();
			this.addChild(_mainLayer);
			_headFace = new HeadFace();
			this.addChild(_headFace);
		}

		public function get guid():int
		{
			return _guid;
		}

		public function set data(value:Object):void
		{
			_data = value;
		}

		public function get data():Object
		{
			return _data;
		}

		public function dispose():void
		{

		}

		public function update(diff:uint):void
		{

		}
	}
}
