package fj1.common.config
{
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import tempest.common.logging.TLog;

	public class CustomConfig
	{
		//验证信息
		public var user_id:int = 0;
		public var time:uint = 0;
		public var cm:int = 0;
		public var plat:String = "qyfz";
		public var sid:int = 0;
		public var sign:String = "";
		//配置信息
		public var cheat_level:int = 1; //作弊级别
		public var keeplive:int = 60; //心跳
		public var log_level:uint = SystemConfig.LOG_LEVEL;
		public var error_page:String = "";
		public var charge_page:String = "";
		public var exchange_page:String = "http://192.168.1.30:8087/";
		public var res_host:String = "http://ly2.ynx.qyfz.com/res/";
//		public var res_host:String = "http://res.kr.ly.qyfz.com/";
//		public var res_host:String = "//192.168.32.9/资源kr";
		public var login_host:String = "dev.kr.ly.qyfz.com";
//		public var login_host:String = "192.168.32.18";
		public var login_port:Array = ["9001", "9002"];
		public var show_band_resion:int = 0;
		public var skip_select_line:int = 0;
		//资源信息
		public var version:String = "1.0.0";
		public var res_ver:int = 1;
		public var res_ver_add:int = 0;
		public var useProtect:int = 0;
		public var res_type:String = "";
		public var locale:String = "cn";

		private static var _instance:CustomConfig = null;

		public function CustomConfig(key:Key)
		{
			if (key == null)
				throw new Error("this is sigleton!");
			//注册回调
			addJSCallBacks();
		}

		public static function get instance():CustomConfig
		{
			return _instance ||= new CustomConfig(new Key());
		}

		/////////////////////////////////////////////////////////////////////////////////////
		public function gotoChargePage():void
		{
			if (charge_page == "")
			{
//				MessageManager.instance.addHintById_client(10001, "暂未开放"); //暂未开放
			}
			else
			{
				navigateToURL(new URLRequest(charge_page), "_blank");
			}
		}

		public function gotoErrorPage():void
		{
			navigateToURL(new URLRequest(error_page), "_blank");
		}

		/**
		 * 重载页面
		 */
		public function reload():void
		{
			if (ExternalInterface.available)
			{
				if (ExternalInterface.call("reload") == null)
				{
					trace("reload调用失败");
					navigateToURL(new URLRequest("javascript:window.location.reload( true );"), "_self");
				}
			}
		}

		/////////////////////////////////////////注册回调///////////////////////////////////////////
		private function addJSCallBacks():void
		{
			if (ExternalInterface.available)
			{
				//获取刷新弹框tip
				ExternalInterface.addCallback("getTips", getTips);
//				//邀请FB好友成功
//				ExternalInterface.addCallback("onRequestFBFriendSuccess", onRequestFBFriendSuccess);
			}
		}

		/**
		 * 退出游戏网页显示Tip
		 * @return
		 */
		private function getTips():String
		{
			return "确定要退出游戏吗？";
		}
	}
}

class Key
{
}
