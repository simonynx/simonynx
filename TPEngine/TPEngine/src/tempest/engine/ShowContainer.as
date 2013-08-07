package tempest.engine
{
	import flash.display.Sprite;

	public class ShowContainer extends Sprite
	{
		//		private var _headLayer:Sprite;
		//		private var _showHeadLayer:Sprite;
		private var _mainLayer:Sprite;
		private var _showMainLayer:Boolean = false;
		private var _customLayer:Sprite;
		private var _showCustomLayer:Boolean = false;
		private var _owner:BaseElement = null;

		public function ShowContainer(owner:BaseElement)
		{
			super();
			_owner = owner;
		}

		/**
		 * 所有者
		 * @return
		 */
		public function get owner():BaseElement
		{
			return _owner;
		}

		/**
		 * 主容器层
		 * @return
		 */
		public function get mainLayer():Sprite
		{
			if (_mainLayer == null)
			{
				_mainLayer = new Sprite();
				if (_showMainLayer)
					this.showMainLayer();
			}
			return _mainLayer;
		}

		/**
		 * 显示主容器层
		 */
		public function showMainLayer():void
		{
			this._showMainLayer = true;
			if (_mainLayer && _mainLayer.parent != this)
				this.addChild(_mainLayer);
		}

		/**
		 * 自定义容器层
		 * @return
		 */
		public function get customLayer():Sprite
		{
			if (_customLayer == null)
			{
				_customLayer = new Sprite();
				if (_showCustomLayer)
					this.showCustomLayer();
			}
			return _customLayer;
		}

		/**
		 * 显示自定义容器层
		 */
		public function showCustomLayer():void
		{
			this._showCustomLayer = true;
			if (_customLayer && _customLayer.parent != this)
				this.addChild(_customLayer);
		}
	}
}
