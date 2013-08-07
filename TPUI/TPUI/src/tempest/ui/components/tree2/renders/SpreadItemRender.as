package tempest.ui.components.tree2.renders
{

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import tempest.common.staticdata.MovieClipResModel;
	import tempest.ui.UIStyle;
	import tempest.ui.components.TButton;
	import tempest.ui.components.TCheckBox;
	import tempest.ui.components.TComponent;
	import tempest.ui.components.TListItemRender;
	import tempest.ui.components.tree2.AutoSizeComponent;
	import tempest.ui.components.tree2.IIndentSetter;
	import tempest.ui.components.tree2.data.TTreeNode;
	import tempest.ui.components.tree2.effect.SpreadEffect;
	import tempest.ui.core.IProxyFactory;
	import tempest.ui.effects.MenuEffect;
	import tempest.ui.events.TTreeEvent;
	import tempest.utils.Fun;

	/**
	 * 可展开列表项
	 * 分为展开区域和头部区域
	 * 可以在头部区域表现列表的选中效果
	 * 展开区域可以放置任意的控件
	 * @author linxun
	 *
	 */
	public class SpreadItemRender extends TListItemRender implements IIndentSetter
	{
		protected var _head:*; //顶部CheckBox
		private var _headBG:*; //顶部控件背景
		private var _headProxySprite:*;

		private var _spreadArea:Sprite; //下拉区域
		protected var _spreadEffect:SpreadEffect; //下拉效果


		private var _spreadObj:DisplayObject; //设置到下拉区域中的组件

		/**
		 *
		 * @param headProxy 用来作为点击展开头部的资源，一般是CheckBox资源
		 * 资源中必须包含“bg”为名称的影片剪辑，用来显示列表效果，否则列表项将没有选中效果
		 * @param data
		 * @param headRender 用来作为点击展开头部的控件类，默认为CheckBox
		 *
		 */
		public function SpreadItemRender(headProxy:* = null, data:Object = null, headRender:* = null)
		{
			_headProxySprite = createProxyInstance(headProxy); //顶部控件资源, 包含checkBox资源，bg资源，双击区域资源
			Fun.stopMC(_headProxySprite);
			super(createShape(_headProxySprite.width, _headProxySprite.height));
			this.addChild(_headProxySprite);
			//
			initHeadCheckBox(_headProxySprite.mc_checkBox, headRender); //初始化CheckBox
			initHeadBG(_headProxySprite); //初始化背景
			_headProxySprite.addEventListener(MouseEvent.CLICK, onHeadClick);

			//下拉区域
			_spreadArea = new AutoSizeComponent();
			_spreadArea.y = _headProxySprite.height;
			this.addChild(_spreadArea);
			_spreadEffect = new SpreadEffect(_spreadArea, SpreadEffect.STATE_RETRACT);
			_spreadEffect.change.add(onChange);
			_spreadEffect.addEventListener(Event.RESIZE, onEffectResize);
		}

		override protected function onClick(event:MouseEvent):void
		{

		}

		override protected function onMouseOut(event:MouseEvent):void
		{

		}

		override protected function onMouseOver(event:MouseEvent):void
		{

		}


		private function createProxyInstance(proxy:*):DisplayObject
		{
			if (proxy is Class)
			{
				return new proxy(); //顶部控件资源
			}
			else
			{
				return proxy;
			}
		}

		private function createShape(width:Number, height:Number):Shape
		{
			var shape:Shape = new Shape();
			shape.graphics.drawRect(0, 0, width, height);
			return shape;
		}

		private function initHeadCheckBox(headproxy:*, headRenderClass:*):void
		{
			if (!headRenderClass)
			{
				_head = new TCheckBox(null, headproxy, null, MovieClipResModel.MODEL_FRAME_2);
			}
			else
			{
				if (headRenderClass is IProxyFactory)
				{
					var factory:IProxyFactory = IProxyFactory(headRenderClass);
					factory.proxy = headproxy;
					_head = factory.newInstance();
				}
				else
				{
					_head = new headRenderClass(null, headproxy, null, MovieClipResModel.MODEL_FRAME_2);
				}
			}
			_head.addEventListener(Event.CHANGE, spreadChange);
		}

		private function initHeadBG(headProxy:*):void
		{
			if (headProxy.hasOwnProperty("bg"))
			{
				_headBG = headProxy.bg;
			}
			if (_headBG)
			{
				_headBG.mouseEnabled = _headBG.mouseChildren = false;
				headProxy.addEventListener(MouseEvent.ROLL_OVER, onHeadRollOver);
				headProxy.addEventListener(MouseEvent.ROLL_OUT, onHeadRollOut);
			}
		}

		protected function onHeadRollOver(event:MouseEvent):void
		{
			if (!selected)
			{
				(_headBG as MovieClip).gotoAndStop(2);
			}
		}

		protected function onHeadRollOut(event:MouseEvent):void
		{
			if (!selected)
			{
				(_headBG as MovieClip).gotoAndStop(1);
			}
		}

		protected function onHeadClick(event:MouseEvent):void
		{
			if (!selected)
			{
				setSelect();
			}
		}

		override protected function changeSelectedEffect(selected:Boolean):void
		{
			if (!_headBG)
			{
				return;
			}
			if (selected)
			{
				(_headBG as MovieClip).gotoAndStop(3);
			}
			else
			{
				(_headBG as MovieClip).gotoAndStop(1);
			}
		}

		/**
		 * 设置缩进
		 * @param value
		 *
		 */
		public function set indentX(value:Number):void
		{
			_head.x = value;
			_head.width = this.width - value;
		}

		public function get head():Sprite
		{
			return _head as Sprite;
		}

		public function setText(str:String):void
		{
			_head.text = str;
		}

		/**
		 * 点击响应区展开列表
		 * @param event
		 *
		 */
		private function spreadChange(event:Event):void
		{
			_spreadEffect.play();
		}

		public function setSpreadPanel(dispObj:DisplayObject):void
		{
			if (_spreadObj == dispObj)
			{
				return;
			}
			var oldSpreadState:int = SpreadEffect.STATE_RETRACT;
			if (_spreadObj)
			{
				oldSpreadState = _spreadEffect.state;
				this.removeChild(_spreadArea);
			}
			_spreadObj = dispObj;
			if (_spreadObj)
			{
				_spreadArea = new AutoSizeComponent();
				_spreadArea.y = _headProxySprite.height;
				this.addChild(_spreadArea);
				_spreadArea.addChild(_spreadObj);
			}
			_spreadEffect.reset(_spreadArea, oldSpreadState);
			_height = _spreadEffect.target ? _headProxySprite.height + _spreadEffect.scorllHeight : _headProxySprite.height;

			dispatchEvent(new Event(Event.RESIZE));
		}

		private function onEffectResize(event:Event):void
		{
			_height = _headProxySprite.height + SpreadEffect(event.currentTarget).scorllHeight;
			if(hasEventListener(Event.RESIZE))
			{
				dispatchEvent(new Event(Event.RESIZE));
			}
		}

		private function onChange(spreadEffect:SpreadEffect):void
		{
			_height = _headProxySprite.height + spreadEffect.scorllHeight;
			if(hasEventListener(Event.RESIZE))
			{
				dispatchEvent(new Event(Event.RESIZE));
			}
		}

		public override function set data(value:Object):void
		{
			var oldData:TTreeNode = data as TTreeNode;
			if (oldData)
			{
				oldData.removeEventListener(TTreeEvent.SPREAD_NODE, onNodeSpread);
				oldData.removeEventListener(TTreeEvent.RETRACT_NODE, onNodeRetract);
			}
			super.data = value;

			var newData:TTreeNode = data as TTreeNode;
			if (newData)
			{
				newData.addEventListener(TTreeEvent.SPREAD_NODE, onNodeSpread);
				newData.addEventListener(TTreeEvent.RETRACT_NODE, onNodeRetract);
			}
		}

		/**
		 * 响应TreeNode抛出的主动展开事件
		 * @param event
		 *
		 */
		private function onNodeSpread(event:TTreeEvent):void
		{
			_head.selected = true;
			_spreadEffect.spread();
		}

		/**
		 * 响应TreeNode抛出的主动收起事件
		 * @param event
		 *
		 */
		private function onNodeRetract(event:TTreeEvent):void
		{
			_head.selected = false;
			_spreadEffect.retract();
		}

		public function set spreadState(spread:Boolean):void
		{
			_head.selected = spread;
			if (spread)
			{
				_spreadEffect.spread();
			}
			else
			{
				_spreadEffect.retract();
			}
		}
		
		public override function invalidateSize(changed:Boolean=false):void
		{
			_headBG.width = _width;
			_head.width = _width;
		}
	}
}
