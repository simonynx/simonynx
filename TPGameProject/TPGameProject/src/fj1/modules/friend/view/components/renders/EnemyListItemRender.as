package fj1.modules.friend.view.components.renders
{
	import fj1.common.staticdata.Profession;
	import fj1.modules.friend.model.vo.EnemyInfo;
	import flash.events.Event;
	import flash.text.TextField;
	import tempest.ui.components.MenuListItemRender;
	import tempest.ui.components.TListItemRender;
	import tempest.ui.components.TWindow;

	public class EnemyListItemRender extends BaseSociatyListItemRender
	{
		public var lbl_name:TextField;
		public var lbl_level:TextField;
		public var lbl_killTime:TextField;

		public function EnemyListItemRender(proxy:* = null, data:Object = null)
		{
			super(proxy, data);
		}

		override protected function addChildren():void
		{
			super.addChildren();
			lbl_name = _proxy.lbl_name;
			lbl_level = _proxy.lbl_level;
			lbl_killTime = _proxy.lbl_killTime;
			this.useDoubleClick = true;
		}

		override public function set data(value:Object):void
		{
			super.data = value;
			if (value)
			{
				var enemyInfo:EnemyInfo = EnemyInfo(value);
				lbl_name.text = enemyInfo.name;
				_changeWatcherManger.bindSetter(setOnlineState, enemyInfo, "online", false);
				_changeWatcherManger.bindProperty(lbl_level, "text", enemyInfo, "level");
				_changeWatcherManger.bindProperty(lbl_killTime, "text", enemyInfo, "killTime");
			}
			else
			{
				lbl_name.text = "";
				_changeWatcherManger.bindSetter(setOnlineState, null, "online", false);
				_changeWatcherManger.bindProperty(lbl_level, "text", null, "level");
				_changeWatcherManger.bindProperty(lbl_killTime, "text", null, "killTime");
			}
		}

		private function setOnlineState(value:Boolean):void
		{
			//改变颜色
			if (value)
			{
				setTextFormat(lbl_name, BaseSociatyListItemRender.whiteFormat);
				setTextFormat(lbl_level, BaseSociatyListItemRender.whiteFormat);
				setTextFormat(lbl_killTime, BaseSociatyListItemRender.whiteFormat);
			}
			else
			{
				setTextFormat(lbl_name, BaseSociatyListItemRender.grayFormat);
				setTextFormat(lbl_level, BaseSociatyListItemRender.grayFormat);
				setTextFormat(lbl_killTime, BaseSociatyListItemRender.grayFormat);
			}
		}
	}
}
