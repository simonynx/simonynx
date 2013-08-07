package fj1.modules.skill.model
{
	import flash.events.Event;
	
	import mx.events.PropertyChangeEvent;
	
	import fj1.common.GameInstance;
	import fj1.common.data.dataobject.DataObject;
	import fj1.common.data.dataobject.cd.CDGroup;
	import fj1.common.data.dataobject.cd.CDState;
	import fj1.common.data.dataobject.items.toolTipShowers.SkillToolTipShower;
	import fj1.common.data.interfaces.ICDable;
	import fj1.common.data.interfaces.ICountable;
	import fj1.common.data.interfaces.IShortCut;
	import fj1.common.events.CDEvent;
	import fj1.common.events.DataObjectEvent;
	import fj1.common.res.ResPaths;
	import fj1.common.res.skill.vo.SkillInfo;
	import fj1.common.staticdata.DataObjectType;
	import fj1.manager.CDManager;
	import fj1.manager.MessageManager;
	
	import tempest.ui.interfaces.IIcon;
	import tempest.ui.interfaces.IRichTextTipClient;
	import tempest.ui.interfaces.IToolTipClient;
	
	[Bindable]
	public class SkillData extends DataObject implements IIcon, ICDable, IShortCut, ICountable
	{
		protected var _cdState:CDState; //冷却状态
		protected var _toolTipShower:IRichTextTipClient;
		private var _needShowNum:Boolean;
		/**
		 *当前经验
		 */
		public var currentExp:int;
		public var cdVisible:Boolean = true;
		public var skillInfo:SkillInfo;
		public var status:int;
		
		public function SkillData(skillInfo:SkillInfo, skillStatus:int)
		{
			super(skillInfo.id);
			this.status = skillStatus;
			setSkillInfo(skillInfo);
			_needShowNum = true;
		}
		
		/**
		 *获取技能学习tip
		 * @return
		 *
		 */
		public function get learnTipString():String
		{
			return SkillToolTipShower(toolTipShower).getLearnTipString();
		}
		
		/**
		 * 获得tip显示对象
		 * @return
		 *
		 */
		public function get toolTipShower():IToolTipClient
		{
			return _toolTipShower ||= new SkillToolTipShower(this);
		}
		
		public function get quality():int
		{
			return 1;
		}
		
		public function set needShowNum(value:Boolean):void
		{
			_needShowNum = value;
		}
		
		public function get needShowNum():Boolean
		{
			return _needShowNum;
		}
		
		public function get num():int
		{
			return skillInfo.spell_level;
		}
		
		public function set num(value:int):void
		{
		}
		
		public function getNumStr(value:int):String
		{
			return "Lv." + skillInfo.spell_level;
		}
		
		public function get cdTimes():Number
		{
			return skillInfo.cd_times;
		}
		
		/**
		 *技能升级，重新设置技能信息
		 * @param value
		 *
		 */
		public function setSkillInfo(value:SkillInfo):void
		{
			skillInfo = value;
			var cdMannger:CDManager = CDManager.getInstance();
			var cdS:CDState = cdMannger.getCDState(this.groupId, this.templateId, skillInfo.globalCDType);
			if (cdS == null)
			{
				cdMannger.initAdd(skillInfo);
				cdS = cdMannger.getCDState(this.groupId, this.templateId, skillInfo.globalCDType);
			}
			setCDState(cdS);
			this.dispatchEvent(new DataObjectEvent(DataObjectEvent.CDSTATE_RESET));
			this.dispatchEvent(new Event("skillUpgrade"));
		}
		
		/**
		 *设置技能cd
		 * @param value
		 *
		 */
		private function setCDState(value:CDState):void
		{
			if (value != _cdState)
			{
				if (_cdState)
					_cdState.removeEventListener(CDEvent.CDEND_EVENT, onCDEnd);
				_cdState = value;
				_cdState.addEventListener(CDEvent.CDEND_EVENT, onCDEnd);
			}
		}
		
		public function onCDEnd(e:CDEvent):void
		{
			dispatchEvent(new CDEvent(CDEvent.CDEND_EVENT));
		}
		
		/**
		 *进入CD
		 *
		 */
		public function startCD():void
		{
			_cdState.startCD(getRealCDTime(skillInfo));
		}
		
		/**
		 *数据类型
		 * @return
		 *
		 */
		public override function get typeId():uint
		{
			return DataObjectType.SKILL;
		}
		
		/**
		 *技能使用前
		 *普通攻击是否限制
		 * 技能是否限制
		 * 技能普通攻击是否受状态限制
		 */
		public function beforUse(showHint:Boolean = true):Boolean
		{
			if (GameInstance.mainCharData.isLimitSpell && !skillInfo.isNormalSkill)
			{
				if (skillInfo.uneffect_bystatus != 1 && showHint) //该技能是否受状态限制
				{
					MessageManager.instance.addHintById_client(101, "当前状态禁止使用技能"); //当前状态禁止使用该技能
					return false;
				}
				else
				{
					return true;
				}
			}
			else if (GameInstance.mainCharData.isLimitAttack && skillInfo.isNormalSkill)
			{
				if (skillInfo.uneffect_bystatus != 1 && showHint) //该技能是否受状态限制
				{
					MessageManager.instance.addHintById_client(110, "当前状态禁止使用普通攻击"); //当前状态禁止使用该技能
					return false;
				}
				else
				{
					return true;
				}
			}
			if (!_cdState.inCD())
			{
				return true;
			}
			else
			{
				if (!skillInfo.isNormalSkill && showHint)
				{
					MessageManager.instance.addHintById_client(102, "技能正在冷却中"); //这个技能还没有准备好
				}
			}
			return false;
		}
		
		/**
		 *技能正式使用接口
		 *
		 */
		public function useObj():Boolean
		{
			if (skillInfo)
			{
				if (_cdState.inCD())
				{
					return false;
				}
				else
				{
					startCD();
					return true;
				}
			}
			return false;
		}
		
		/**
		 *获取技能CD时间
		 * @param skillInfo
		 * @return
		 *
		 */
		public static function getRealCDTime(skillInfo:SkillInfo):int
		{
			var cdGroup:CDGroup = CDManager.getInstance().getCDGroup(skillInfo.cd_type);
			if (cdGroup && skillInfo.cd_times < cdGroup.cdTime) //当冷却时间小于公共冷却时，使用公共冷却时间
				return cdGroup.cdTime;
			else
				return skillInfo.cd_times;
		}
		
		/**
		 *获取技能图标
		 * @param sizeType
		 * @return
		 *
		 */
		public function getIconUrl(sizeType:int = -1):String
		{
			if (skillInfo && skillInfo.spell_ico > 0)
			{
				return ResPaths.getIconPath(skillInfo.spell_ico, sizeType);
			}
			return ResPaths.getIconPath(10011, sizeType); //默认图片
		}
		
		/**
		 *该技能是否在冷却
		 * @return
		 *
		 */
		public function get isFreed():Boolean
		{
			if (_cdState && !_cdState.inCD())
			{
				return true;
			}
			return false;
		}
		
		public function getName():String
		{
			return this.skillInfo.spell_name;
		}
		
	   override public function get templateId():int
		{
			return skillInfo.templateId;
		}
		
//	   override public function set templateId(value:int):void
//		{
//		}
		
		public function get groupId():int
		{
			return skillInfo.groupId;
		}
		
		/**
		 * 注意：
		 * 不要再cdState上直接添加监听，当技能升级时，监听将无效
		 * @return
		 *
		 */
		public function get cdState():CDState
		{
			if (!skillInfo.is_activeskill)
			{
				return null;
			}
			return _cdState;
		}
		
		/**
		 *
		 * @return
		 *
		 */
		public function get shortCutSendable():Boolean
		{
			return true;
		}
		
		/**
		 *
		 * @return
		 *
		 */
		public function get label():String
		{
			return skillInfo.spell_name
		}
	}
}

