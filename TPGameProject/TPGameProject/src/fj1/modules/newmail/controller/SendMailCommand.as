package fj1.modules.newmail.controller
{
	import fj1.common.GameInstance;
	import fj1.common.net.GameClient;
	import fj1.common.net.tcpLoader.NameCheckLoader;
	import fj1.manager.MessageManager;
	import fj1.modules.newmail.model.MailModel;
	import fj1.modules.newmail.model.vo.MailInfo;
	import fj1.modules.newmail.service.MailService;
	import fj1.modules.newmail.signals.MailSignal;
	import tempest.common.mvc.base.Command;
	import tempest.ui.helper.TextFieldHelper;

	public class SendMailCommand extends Command
	{
		private var _name:String;
		private var _title:String;
		private var _content:String;
		private var _sendMoney:String;
		[Inject]
		public var service:MailService;
		[Inject]
		public var model:MailModel;
		[Inject]
		public var signal:MailSignal;

		public override function getHandle():Function
		{
			return this.sendMail;
		}

		/**
		 * 发送邮件
		 * @param name 收件人名字
		 * @param title 标题
		 * @param content 内容
		 *
		 */
		public function sendMail(name:String, title:String, content:String, sendMoney:String):void
		{
			_name = name;
			_title = title;
			_content = content;
			_sendMoney = sendMoney;
			//是不是发给自己
			if (GameInstance.mainCharData.name == name)
			{
				MessageManager.instance.addHintById_client(2051, "不能发邮件给自己");
				return;
			}
			//请输入收件人名字
			if (name.length == 0)
			{
				MessageManager.instance.addHintById_client(2052, "请输入收件人");
				return;
			}
			//请输入主题
			if (title.length == 0)
			{
				MessageManager.instance.addHintById_client(2053, "请输入主题");
				return;
			}
			//请输入内容
			if (content.length == 0)
			{
				MessageManager.instance.addHintById_client(2054, "请输入内容");
				return;
			}
			//邮资不够
			if (GameInstance.mainCharData.money < MailInfo.POSTAGE)
			{
				MessageManager.instance.addHintById_client(2055, "邮资不够");
				return;
			}
			//等级大于10级才能用邮箱
			if (GameInstance.mainCharData.level < MailInfo.MAIL_LEVEL)
			{
				MessageManager.instance.addHintById_client(2061, "等级大于等于10级才可发送邮件");
				return;
			}
			var loader:NameCheckLoader = new NameCheckLoader(name);
			loader.signals.complete.add(onCheckNameComplete);
			loader.load(); //验证名称
		}

		/**
		 * 验证名称结果
		 * @param loader
		 *
		 */
		private function onCheckNameComplete(loader:NameCheckLoader):void
		{
			loader.signals.complete.remove(onCheckNameComplete);
			var result:int = loader.content as int;
			if (result == 0)
			{
				MessageManager.instance.addHintById_client(2064, "该玩家不存在");
			}
			else
			{
				var arr:Array = model.getItemID();
				service.sendMail(_name, _title, _content, int(TextFieldHelper.getMoney(_sendMoney)), arr);
				signal.sendMailComplete.dispatch();
			}
		}
	}
}
