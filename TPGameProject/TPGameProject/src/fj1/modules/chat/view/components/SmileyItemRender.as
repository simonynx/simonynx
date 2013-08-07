package fj1.modules.chat.view.components
{
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.staticdata.ColorConst;
	import fj1.common.staticdata.ToolTipName;
	
	import flash.display.DisplayObject;
	
	import tempest.common.staticdata.Colors;
	import tempest.ui.TToolTipManager;
	import tempest.ui.components.TListItemRender;
	import tempest.utils.HtmlUtil;
	
	public class SmileyItemRender extends TListItemRender
	{
		private var _simileyDispObj:DisplayObject;
		
		public function SmileyItemRender(proxy:*=null, data:Object=null)
		{
			super(proxy, data);
			this.toolTip = TToolTipManager.instance.getToolTipInstance(ToolTipName.AUTO_WIDTH);
		}
		
		override public function set data(value:Object):void
		{
			super.data = value;
			if(_simileyDispObj)
			{
				this.removeChild(_simileyDispObj);
				this.toolTipString = "";
			}
			_simileyDispObj = value ? new value.src() : null;
			if(_simileyDispObj)
			{
				_simileyDispObj.x = _proxy.vv.x;
				_simileyDispObj.y = _proxy.vv.y;
				this.addChild(_simileyDispObj);
				this.toolTipString = HtmlUtil.color(ColorConst.getHtmlColor(Colors.Yellow), value.desc, true) 
					+ HtmlUtil.color(ColorConst.getHtmlColor(Colors.White), LanguageManager.translate(39001, "快捷键") + value.shortcut);
			}
			
			
		}
	}
}