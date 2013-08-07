package fj1.modules.card.net
{
	import fj1.common.GameInstance;
	import fj1.common.data.factories.CardFactory;
	import fj1.common.data.interfaces.ISlotItem;
	import fj1.common.helper.ObjectCreateHelper;
	import fj1.common.helper.UpdatePropsHelper;
	import fj1.common.net.GameClient;
	import fj1.common.staticdata.ObjectUpdateConst;
	import fj1.manager.SlotItemManager;

	import tempest.common.mvc.base.Actor;
	import tempest.common.net.vo.TPacketIn;
	import tempest.core.ISocket;

	public class CardService extends Actor
	{
		public static const CREATE_CARD:uint = 0x00C;

		public function CardService()
		{
			super();
		}

		override public function init():void
		{
			GameClient.socket.mapOpcodes([CREATE_CARD], createCard);
		}

		private function createCard(socket:ISocket, packet:TPacketIn):void
		{
			while (packet.bytesAvailable)
			{
				var updateData:Object = UpdatePropsHelper.parsePropPacket(packet); //{type: updateType, guid: guid, props: props, templateId: templateId};
				var item:ISlotItem;
				//更新类型分支
				switch (updateData.type) //对象更新类型
				{
					case ObjectUpdateConst.UPDATETYPE_VALUES: //更新属性
						item = ISlotItem(SlotItemManager.instance.getItem(updateData.guid));
						ObjectCreateHelper.updateObj(item, updateData.props, true);
						break;
					case ObjectUpdateConst.UPDATETYPE_CREATE_OBJECT: //创建对象
						item = ISlotItem(CardFactory.create(GameInstance.mainChar.id, updateData.guid, updateData.props, true));
						SlotItemManager.instance.Add(item);
						break;
				}
			}
		}
	}
}
