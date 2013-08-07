package fj1.common.data.dataobject
{
	import fj1.common.net.GameClient;
	import fj1.modules.item.service.ItemService;
	import fj1.modules.main.MainFacade;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class HeroDepot extends EventDispatcher
	{
		private static var _instance:HeroDepot = null;

		[Bindable]
		public var money:int;

		[Bindable]
		public var magicCristal:int;

		/**
		 * 仓库是否启用
		 */
		private var _hasPwd:Boolean = false;

		public function get hasPwd():Boolean
		{
			return _hasPwd;
		}

		public function set hasPwd(value:Boolean):void
		{
			_hasPwd = value;
		}

		public static function get instance():HeroDepot
		{
			if (_instance == null)
				new HeroDepot();
			return _instance;
		}

		public function HeroDepot()
		{
			if (_instance != null)
				throw new Error("该类只能创建一个实例");
			_instance = this;
		}

		public function tryOpen(npcId:int):void
		{
			hasPwd = false;
			var itemService:ItemService = MainFacade.instance.inject.getInstance(ItemService) as ItemService;
			itemService.sendDepotOpen(npcId);
		}
	}
}
