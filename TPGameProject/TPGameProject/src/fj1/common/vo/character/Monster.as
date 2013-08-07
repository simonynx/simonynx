package fj1.common.vo.character
{
	import com.gskinner.motion.GTweener;
	import fj1.common.GameInstance;
	import fj1.common.res.monster.CollectTemplateManager;
	import fj1.common.res.monster.MonsterResManager;
	import fj1.common.res.monster.vo.CollectTemplate;
	import fj1.common.res.monster.vo.MonsterTempl;
	import fj1.common.staticdata.MonsterConst;
	import fj1.common.staticdata.SceneCharacterType;
	import fj1.manager.AvatarManager;
	import fj1.manager.HeadFaceManager;
	import flash.filters.DropShadowFilter;
	import tempest.common.staticdata.Colors;
	import tempest.engine.SceneCharacter;
	import tempest.engine.graphics.animation.Animation;
	import tempest.engine.graphics.animation.AnimationType;
	import tempest.engine.staticdata.Status;
	import tempest.utils.Random;

	public class Monster extends BaseCharacter
	{
		private var _res:MonsterTempl;

		public function Monster(sc:SceneCharacter, res:MonsterTempl)
		{
			super(sc);
			_res = res;
			///////////////////////
			_sc.alpha = 0;
			_sc.playTo(Status.DEAD);
			if (!canCollect)
			{
				_sc.setBarVisible(true);
			}
		}

		public function get res():MonsterTempl
		{
			return _res;
		}

		//////////////////////////////////////////////////////////////////////
		public override function get bodyModelId():int
		{
			return _bodyModelId;
		}
		[Bindable]
		[Attribute(index = "UNIT_END + 0x0000")]
		public var headIcon:uint;
		private var _monsterType:int = 0;

		public function get monsterType():int
		{
			return _monsterType;
		}

		[Attribute(index = "UNIT_END + 0x0002")]
		public function set monsterType(value:int):void
		{
			if (_monsterType != value)
			{
				_monsterType = value;
//				HeadFaceManager.updateNickCharName([this._sc], false, true);
				HeadFaceManager.updateCharLeftIco([this._sc]);
			}
		}

		public function get isActiveAttack():Boolean
		{
			return _monsterType != 0;
		}
		private var _diffState:int = 0;

		[Attribute(index = "UNIT_END + 0x0003")]
		public function get diffState():int
		{
			return _diffState;
		}

		public function set diffState(value:int):void
		{
			if (_diffState != value) //变异了
			{
				_diffState = value;
				if (_diffState != 0)
				{
					say(MonsterConst.DIFFSTATE, 100); //百分百
				}
				HeadFaceManager.updateNickCharName([this._sc], true, false);
				HeadFaceManager.updateCharLeftIco([this._sc]);
			}
		}

		public function get variation():Boolean
		{
			return (_diffState != 0 && _diffState != -1);
		}

		/**
		 *待机
		 *
		 */
		public function onIdel():void
		{
			say(MonsterConst.IDLET);
		}

		/**
		 *怪物复活
		 *
		 */
		protected override function onRevive():void
		{
			super.onRevive();
			say(MonsterConst.BORN);
			GTweener.to(this._sc, 1, {alpha: 1});
			HeadFaceManager.updateNickCharName([this._sc], true, false);
			HeadFaceManager.updateCharLeftIco([this._sc]);
		}

		/**
		 *怪物死亡
		 *
		 */
		protected override function onDead():void
		{
			super.onDead();
			say(MonsterConst.DEAD);
			if (this._sc.isMouseOn)
			{
				this._sc.isMouseOn = false;
			}
			GTweener.to(this._sc, 2, {alpha: 0}, {delay: 2});
//			GameInstance.signal.smallMap.deletePosMaske.dispatch(_sc.id);
			this._sc.removeAllEffect();
		}

		/**
		 *使用技能
		 *
		 */
		public function onAttack():void
		{
			say(MonsterConst.ATTACK);
		}

		public override function dispose():void
		{
			super.dispose();
		}

		/**
		 *怪物说话
		 * @param type
		 *
		 */
		public function say(type:int, probability:int = 10):void
		{
			if (Random.range(1, 100) > (100 - probability)) //喊话概率20%
			{
				var talkStr:String = getTalkStr(res, type);
				if (talkStr)
				{
					this._sc.talk(talkStr);
				}
			}
		}

		/**
		 *获取对话字符串
		 * @return
		 *
		 */
		private function getTalkStr(templ:MonsterTempl, type:int):String
		{
			switch (type)
			{
				case MonsterConst.BORN:
					return templ.getbornTalk;
					break;
				case MonsterConst.IDLET:
					return templ.getidletTalk;
					break;
				case MonsterConst.ATTACK:
					return templ.getattackTalk;
					break;
				case MonsterConst.DEAD:
					return templ.getdeathTalk;
					break;
				case MonsterConst.DIFFSTATE:
					return templ.getdiffStateTalk;
					break;
			}
			return null;
		}

		public static function create(templateId:int):SceneCharacter
		{
			var monster:SceneCharacter = null;
			//获取模板
			var monsterRes:MonsterTempl = MonsterResManager.getMonsterTempl(templateId);
			if (monsterRes)
			{
				monster = new SceneCharacter(SceneCharacterType.MONSTER, GameInstance.scene);
				var monsterData:Monster = new Monster(monster, monsterRes);
				monster.data = monsterData;
				monsterData.name = monsterRes.name;
				monsterData.level = monsterRes.level;
				monsterData.headIcon = monsterRes.headIcoId;
				monsterData.bodyModelId = monsterRes.modelId;
				monsterData.size = monsterRes.zoom;
				if (monsterRes.born_effect_id > 0)
				{
					var $ani:Animation = Animation.createAnimation(monsterRes.born_effect_id);
					$ani.type = AnimationType.Loop;
					monster.addEffect($ani, false, false, true, false);
				}
			}
			return monster;
		}

		/**
		 *是否采集怪
		 * @return
		 *
		 */
		public function get canCollect():Boolean
		{
			return (_res.sort == MonsterConst.MonsterSort_Loot);
		}

		/**
		 *获取怪物的采集模版
		 * @return
		 *
		 *
		 *
		 */
		public function get collectTemplate():CollectTemplate
		{
			return CollectTemplateManager.instrance.getCollectTempl(_res.id);
		}
	}
}
