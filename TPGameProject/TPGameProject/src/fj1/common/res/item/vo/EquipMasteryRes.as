package fj1.common.res.item.vo
{

	public class EquipMasteryRes
	{
		/**
		 * ABB (A表示部位，0武器,1胸甲,2戒指,3鞋子,4腰带,5护手,6项链,7头盔,8勋章; BB表示位置1~12)
		 * 如是雕琢配置A+20
		 */
		public var id:int;
		public var succ_rate:int; //强化成功率		该值/1000000=强化到该等级的成功率
		public var bigstone_addsuccrate:int; //小宝石成功率加成	该值/1000000=等于强化到该等级时单颗小宝石对成功率的加成
		public var frontlink_rate:int; //前连概率
		public var behindlink_rate:int; //后连概率
		public var req_playerlev:int; //要求玩家最低等级
//		public var expend_money:int; //消耗金钱
		public var expend_belief:int; //消耗信仰力
		public var attack_add:int; //加攻击
		public var defense_add:int; //加防御
		public var haymaker_add:int; //加暴击
		public var delicacy_add:int; //加敏捷
		public var health_add:int; //加生命
		public var magic_add:int; //加魔法

		public function EquipMasteryRes()
		{
		}
	}
}
