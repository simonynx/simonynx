package fj1.modules.friend.controller
{
	import fj1.common.GameInstance;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.res.map.MapResManager;
	import fj1.common.res.map.vo.MapRes;
	import fj1.common.staticdata.ChatConst;
	import fj1.common.staticdata.ColorConst;
	import fj1.common.staticdata.FriendConst;
	import fj1.common.ui.TWindowManager;
	import fj1.modules.chat.helper.ChatStringHelper;
	import fj1.modules.chat.model.ChatMutualChannelProcesser;
	import fj1.modules.chat.singles.ChatSignal;
	import fj1.modules.friend.model.FriendModel;
	import fj1.modules.friend.service.FriendService;
	import fj1.modules.friend.signals.FriendSignal;
	import fj1.modules.friend.view.FindPanelMediator;
	import fj1.modules.friend.view.FriendPanelMediator;
	import fj1.modules.friend.view.components.FindPanel;
	import fj1.modules.friend.view.components.FriendPanel;
	import tempest.common.keyboard.KeyCodes;
	import tempest.common.logging.*;
	import tempest.common.mvc.base.Command;
	import tempest.common.staticdata.Colors;
	import tempest.manager.KeyboardManager;
	import tempest.ui.collections.TArrayCollection;
	import tempest.utils.HtmlUtil;

	public class FriendFacadeStartupCommand extends Command
	{
		private static const log:ILogger = TLog.getLogger(FriendFacadeStartupCommand);
		[Inject]
		public var signal:FriendSignal;
		[Inject]
		public var chatSignal:ChatSignal;
		[Inject]
		public var service:FriendService;
		[Inject]
		public var model:FriendModel;

		public override function execute():void
		{
			log.info("好友模块启动");
			model.addContainer(FriendConst.TYPE_FRIEND, new TArrayCollection());
			model.addContainer(FriendConst.TYPE_BLACK, new TArrayCollection());
			model.addContainer(FriendConst.TYPE_ENEMY, new TArrayCollection());
			//注册命令
			commandMap.map([signal.showFriendPanel], ShowFriendPanelCommand); //显示好友面板
			commandMap.map([signal.addBlack], AddBlackCommand); //添加到黑名单
			commandMap.map([signal.delFriendHandler], DelFriendCommand); //删除好友
			commandMap.map([signal.delBlackHandler], DelBlackCommand); //删除黑名單
			commandMap.map([signal.delEnemyHandler], DelEnemyListCommand); //删除仇人
			commandMap.map([signal.friendListQuery], FriendListQueryCommand); //申请好友列表
			commandMap.map([signal.addFriendHandler], AddFriendCommand); //添加好友
			commandMap.map([signal.addEnemy], AddEnemyCommand); //添加仇人
			commandMap.map([signal.showFindPanel], ShowFindPanelCommand); //显示查找玩家面板
			commandMap.map([signal.enemyPosTrace], EnemyPosTraceCommand); //追踪仇人
			commandMap.map([signal.findPlayer], FindPlayerHandler); //查找玩家
			commandMap.map([signal.friendEnsureRequest], FriendEnsureRequestCommand); //同意添加好友
			commandMap.map([signal.friendRepulseRequest], FriendRepulseRequestCommand); //拒绝添加好友
			commandMap.map([chatSignal.processMutualLink], EnemyMutualLinkClickCommand); //交互频道链接点击处理
			//注册中介器
			TWindowManager.instance.registerWindowMediator(FindPanel, FindPanelMediator, mediatorMap.map);
			TWindowManager.instance.registerWindowMediator(FriendPanel, FriendPanelMediator, mediatorMap.map);
//			注册热键
			KeyboardManager.addHotkey(LanguageManager.translate(31030, "社交（F)"), [KeyCodes.F.keyCode], function():void
			{
				signal.showFriendPanel.dispatch(-1);
			});
			//
			service.init();
			ChatMutualChannelProcesser.registerMsgBuildHandler(ChatConst.MUTUAL_TYPE_ENEMY, onBuildLink);
		}

		/**
		 * 构造交互频道链接
		 * @param type
		 * @param senderId
		 * @param senderName
		 * @param color
		 * @param params
		 * @return
		 *
		 */
		private function onBuildLink(type:String, senderId:int, senderName:String, color:String, params:Array):String
		{
			var lineId:int = parseInt(params[0]);
			var mapId:int = parseInt(params[1]);
			var posX:int = parseInt(params[2]);
			var posY:int = parseInt(params[3]);
			var mapRes:MapRes = MapResManager.getMapRes(mapId);
			if (!mapRes)
			{
				log.error("FriendFacadeStartupCommand.onShowLink：无效的地图id = " + mapId);
				return "";
			}
			var linkDataStr:String = mapId + "," + posX + "," + posY;
			var linkStr:String = HtmlUtil.link(ChatMutualChannelProcesser.buildLinkData(type, linkDataStr), LanguageManager.translate(50475, "追踪"));
			linkStr = HtmlUtil.color(ColorConst.Hex2str(Colors.Green), linkStr);
			return HtmlUtil.color(color, LanguageManager.translate(9015, "该玩家位于{0}线{1}地图 X：{2},Y：{3}", lineId, mapRes.name, posX, posY) + " " + linkStr);
		}
	}
}
