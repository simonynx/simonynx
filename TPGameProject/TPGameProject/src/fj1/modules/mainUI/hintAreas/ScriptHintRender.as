package fj1.modules.mainUI.hintAreas
{
	import fj1.common.res.hint.vo.HintData;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import tempest.core.IPoolClient;
	import tempest.ui.components.TListItemRender;

	/**
	 *脚本提示文本
	 * @author zhangyong
	 *
	 */
	public class ScriptHintRender extends TListItemRender implements IPoolClient
	{
		private var _tf:TextField;

		public function ScriptHintRender(proxy:* = null, data:Object = null)
		{
			super(proxy, data);
		}

		override protected function addChildren():void
		{
			super.addChildren();
			_tf = new TextField();
			_tf.width = 350;
			_tf.autoSize = TextFieldAutoSize.CENTER;
//			_tf.wordWrap = true;
			this.addChild(_tf);
		}

		override public function set data(value:Object):void
		{
			super.data = value;
			var hintData:HintData = HintData(value);
			if (hintData != null)
			{
				_tf.defaultTextFormat = new TextFormat(hintData.hintConfig.font, hintData.hintConfig.size, hintData.hintConfig.color);
				_tf.htmlText = hintData.content;
			}
		}

		override public function invalidateSize(changed:Boolean = false):void
		{
		}

		public function reset(args:Array):void
		{
		}
	}
}
