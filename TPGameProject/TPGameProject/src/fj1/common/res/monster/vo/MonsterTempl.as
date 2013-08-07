package fj1.common.res.monster.vo
{
	import fj1.common.res.monster.MonsterResManager;
	import fj1.common.staticdata.MonsterConst;
	import tempest.utils.Random;

	public class MonsterTempl
	{
		public var id:int;
		public var name:String;
		public var level:int;
		public var headIcoId:int;
		public var modelId:int;
		public var hpMax:int;
		public var moveSpeed:int;
		public var zoom:int;
		public var magictype:int; //魔法力类型
		public var idlet_id:int; //休闲谈话
		public var born_id:int; //出生谈话
		public var diffState_id:int; //变异谈话
		public var attack_id:int; //战斗谈话
		public var death_id:int; //死亡谈话
		public var born_effect_id:int; //怪物出生绑定光效
		public var sort:int; //怪物类型

		public function MonsterTempl()
		{
		}

		/**
		 *变异对白
		 * @return
		 *
		 */
		public function get getdiffStateTalk():String
		{
			var talks:Array = MonsterResManager.getTalkText(this.diffState_id);
			if (talks)
			{
				return talks[Random.range(0, talks.length, true)];
			}
			return null;
		}

		/**
		 *出生对白
		 * @return
		 *
		 */
		public function get getbornTalk():String
		{
			var talks:Array = MonsterResManager.getTalkText(this.born_id);
			if (talks)
			{
				return talks[Random.range(0, talks.length, true)];
			}
			return null;
		}

		/**
		 *待机
		 * @return
		 *
		 */
		public function get getidletTalk():String
		{
			var talks:Array = MonsterResManager.getTalkText(this.idlet_id);
			if (talks)
			{
				return talks[Random.range(0, talks.length, true)];
			}
			return null;
		}

		/**
		 *攻击对白
		 * @return
		 *
		 */
		public function get getattackTalk():String
		{
			var talks:Array = MonsterResManager.getTalkText(this.attack_id);
			if (talks)
			{
				return talks[Random.range(0, talks.length, true)];
			}
			return null;
		}

		/**
		 *死亡对白
		 * @return
		 *
		 */
		public function get getdeathTalk():String
		{
			var talks:Array = MonsterResManager.getTalkText(this.death_id);
			if (talks)
			{
				return talks[Random.range(0, talks.length, true)];
			}
			return null;
		}
	}
}
