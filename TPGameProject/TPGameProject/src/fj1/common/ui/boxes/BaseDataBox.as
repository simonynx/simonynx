package fj1.common.ui.boxes
{
	import assets.ResLib;
	import assets.UIResourceLib;
	import assets.UISkinLib;

	import fj1.common.GameInstance;
	import tempest.common.rsl.RslManager;
	import fj1.common.data.dataobject.items.ItemData;
	import fj1.common.data.interfaces.ICDable;
	import fj1.common.data.interfaces.ICountable;
	import fj1.common.data.interfaces.ILockable;
	import fj1.common.data.interfaces.IPlayerBindable;
	import fj1.common.events.DataObjectEvent;
	import fj1.common.helper.MenuHelper;
	import fj1.common.res.ResPaths;
	import fj1.common.staticdata.IconSizeType;
	import fj1.common.staticdata.ItemQuality;
	import fj1.common.staticdata.ToolTipName;
	import fj1.common.ui.animation.AnimationFrameController;
	import fj1.common.ui.animation.BitmapAnimation;
	import fj1.common.ui.animation.IAnimationFrameController;
	import fj1.common.ui.animation.QualityAniResMananger;
	import fj1.common.ui.pools.IconBoxPool;
	import fj1.common.ui.pools.IconBoxPoolManager;
	import fj1.common.ui.pools.MenuPool;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	import mx.events.PropertyChangeEvent;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeMappedSignal;

	import tempest.common.rsl.TRslManager;
	import tempest.common.rsl.vo.TRslType;
	import tempest.common.rsl.vo.TRslVO;
	import tempest.common.staticdata.CursorPriority;
	import tempest.core.IPoolClient;
	import tempest.engine.graphics.animation.Animation;
	import tempest.engine.graphics.animation.AnimationType;
	import tempest.ui.ChangeWatcherManager;
	import tempest.ui.CursorManager;
	import tempest.ui.MouseOperatorLock;
	import tempest.ui.TToolTipManager;
	import tempest.ui.UIStyle;
	import tempest.ui.collections.TMutexGroup;
	import tempest.ui.components.TComponent;
	import tempest.ui.components.TDragableImage;
	import tempest.ui.components.TListMenu;
	import tempest.ui.components.TWindow;
	import tempest.ui.components.tips.TRichTextToolTip;
	import tempest.ui.components.tips.TToolTip;
	import tempest.ui.effects.CDEffect;
	import tempest.ui.events.DataEvent;
	import tempest.ui.events.DragEvent;
	import tempest.ui.interfaces.IIcon;
	import tempest.ui.interfaces.ILoaderTipClient;
	import tempest.ui.interfaces.IToolTipClient;
	import tempest.utils.Fun;
	import tempest.utils.ListenerManager;
	import tempest.utils.Random;

	/**
	 * 基础DataObject显示类
	 * 支持Tip显示, 弹出菜单, 拖放，显示数量，品质
	 *
	 */
	[Event(name = "select", type = "tempest.ui.events.DataEvent")]
	public class BaseDataBox extends TComponent implements IPoolClient
	{
		protected var changeWatcherMananger:ChangeWatcherManager;
		protected var _listenerMananger:ListenerManager;
		protected var _freezeEffect:CDEffect;
		protected var _dragImage:TDragableImage; //拖放图片
		private var _dragBackAreaArray:Array; //拖放放下后，会自动回到原处的范围
		private var _lbl_amount:TextField;
		protected var _mc_color:MovieClip;
//		protected var _sp_disableCover:Shape;		//标记物品不可用的层
		protected var _professionErrorIcon:DisplayObject; //职业不符时显示的图标
		protected var _playerBindIcon:Bitmap; //物品被绑定时显示的图标
		protected var _bg:MovieClip;
		protected var _sizeType:int = -1;
		protected var _enableNumBinding:Boolean = true; //是否绑定数量
		protected var _enablePlayerBindableBinding:Boolean = true; //是否绑定可绑定状态
		public var enableLockState:Boolean = true; //是否通过检测lock属性来设置格子的可用状态
		private var _enableCD:Boolean = true;
		private var _showAmountHandler:Function; //用于设置数量显示文本的回调，参数如function (box:BaseDataBox, value:int, data:ItemData);
		private var _menuSelectSignal:ISignal;
		private static var _aniController:IAnimationFrameController; //品质动画播放的帧率控制器
		private var _disposed:Boolean = true; //是否从舞台中移除

		private var _qualityAnimGroup:TMutexGroup; //品质边框动画组
		private var _qualityFireGroup:TMutexGroup; //品质火焰动画组

		public function BaseDataBox(proxy:* = null, dragBackAreaArray:Array = null, constraints:Object = null)
		{
			_dragBackAreaArray = dragBackAreaArray;
			super(constraints, proxy);
			changeWatcherMananger = new ChangeWatcherManager();
			_listenerMananger = new ListenerManager();
//			changeWatcherManger.createAlways = true;
			this.sizeType = IconSizeType.ICON36;
			_freezeEffect = new CDEffect(this);
			this.addEventListener(MouseEvent.CLICK, onClick);
			//toolTip初始化
			var toolTip:TRichTextToolTip = TToolTipManager.instance.getToolTipInstance(ToolTipName.RICHTEXT) as TRichTextToolTip;
			this.toolTip = toolTip;
			Fun.stopMC(this);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		public function get menuSelectSignal():ISignal
		{
			return _menuSelectSignal ||= new Signal();
		}

		private function onAddedToStage(event:Event):void
		{
			_listenerMananger.addEventListener(GameInstance.mainCharData, PropertyChangeEvent.PROPERTY_CHANGE, onHeroPropertyChange, false, 0, true);
			_disposed = false;
			bindQuality(); //绑定品质
		}

		private function onRemoveFromStage(event:Event):void
		{
			_disposed = true;
			if (_freezeEffect)
				_freezeEffect.stop();
			_listenerMananger.removeAll();
//			changeWatcherManger.bindSetter(setQuality, null, "quality");
			bindQuality();
//			changeWatcherManger.unWatchSetter(setQuality);
//			setQuality(1);
		}

		private function onHeroPropertyChange(event:PropertyChangeEvent):void
		{
			var itemData:ItemData;
			switch (event.property)
			{
				case "gender":
					itemData = data as ItemData;
					if (itemData)
					{
						set_enabled(checkEnabled(itemData));
					}
					break;
				case "level":
					itemData = data as ItemData;
					if (itemData)
					{
						set_enabled(checkEnabled(itemData));
					}
					break;
			}
		}

		private function checkEnabled(itemData:ItemData):Boolean
		{
//			if (itemData.itemTemplate.request_gender != 0 && itemData.itemTemplate.request_gender != GameInstance.mainCharData.gender)
//			{
//				return false;
//			}
//			if (itemData.itemTemplate.request_userprofession != 0 && itemData.itemTemplate.request_userprofession != GameInstance.mainCharData.professions)
//			{
//				return false;
//			}
			return true;
		}

		/**
		 * 初始化拖动图片和菜单(派生类可以扩展)
		 * @param event
		 *
		 */
		override protected function addChildren():void
		{
			var imgBk:Sprite = new Sprite();
			imgBk.graphics.drawRect(0, 0, _proxy.width, _proxy.height);
			_dragImage = new TDragableImage(null, imgBk);
			_dragImage.dropBackAreaArray = _dragBackAreaArray;
			_dragImage.addEventListener(DragEvent.SELECT, onSelect);
			_dragImage.addEventListener(DragEvent.DROP_DOWN, onDropDown);
			_dragImage.setMouseSkinHandler = setDragMouseSkin;
			_proxy.img.addChild(_dragImage);
//			this.addChild(_proxy.img);
			if (_proxy.hasOwnProperty("mc_imgCover"))
			{
				_proxy.mc_imgCover.mouseEnabled = false;
			}
			if (_proxy.hasOwnProperty("mc_color") && _proxy.mc_color != null)
			{
				_mc_color = _proxy.mc_color;
			}
			if (_mc_color)
			{
				_mc_color.mouseEnabled = _mc_color.mouseChildren = false;
				_mc_color.stop();
				this.addChild(_mc_color);
				//品质动画初始化
				initQualityAnim();
				initQualityFire();
			}
			if (_proxy.hasOwnProperty("bg") && _proxy.bg != null)
			{
				_bg = _proxy.bg;
				_bg.mouseEnabled = _bg.mouseChildren = false;
			}
			if (_proxy.hasOwnProperty("lbl_amount"))
			{
				_lbl_amount = _proxy.lbl_amount;
				_lbl_amount.mouseEnabled = false;
				_lbl_amount.text = "";
				this.addChild(_lbl_amount);
			}
		}

		/*****************************品质动画初始化*****************************/

		/**
		 * 初始化品质边框动画
		 *
		 */
		private function initQualityAnim():void
		{
			_qualityAnimGroup = new TMutexGroup(this);
			_qualityAnimGroup.add(createQualityAnim(ResLib.QUALITY_EFFECT_PURPLE));
			_qualityAnimGroup.add(createQualityAnim(ResLib.QUALITY_EFFECT_YELLOW));
			_qualityAnimGroup.add(createQualityAnim(ResLib.QUALITY_EFFECT_RED));
		}

		private function createQualityAnim(id:String):BitmapAnimation
		{
			var resMgr:QualityAniResMananger = QualityAniResMananger.getInstance();
			var qualityAnim:BitmapAnimation = new BitmapAnimation(resMgr.getRes(id), resMgr.frameCtrl);
			qualityAnim.mouseEnabled = qualityAnim.mouseChildren = false
			qualityAnim.scaleX = (_sizeType == IconSizeType.ICON36) ? 0.5 : 1;
			qualityAnim.scaleY = (_sizeType == IconSizeType.ICON36) ? 0.5 : 1;
			qualityAnim.blendMode = BlendMode.ADD;
			qualityAnim.x = (_sizeType == IconSizeType.ICON36) ? _mc_color.x - 1 : _mc_color.x - 2;
			qualityAnim.y = (_sizeType == IconSizeType.ICON36) ? _mc_color.y - 1 : _mc_color.y - 2;
			qualityAnim.addEventListener(Event.ADDED_TO_STAGE, onQualityAnimAdd);
			qualityAnim.addEventListener(Event.REMOVED_FROM_STAGE, onQualityAnimRemove);
			return qualityAnim;
		}

		private function onQualityAnimAdd(event:Event):void
		{
			var ani:BitmapAnimation = event.currentTarget as BitmapAnimation;
			ani.play();
		}

		private function onQualityAnimRemove(event:Event):void
		{
			var ani:BitmapAnimation = event.currentTarget as BitmapAnimation;
			ani.stop();
		}

		/**
		 * 初始化品质火焰动画
		 *
		 */
		private function initQualityFire():void
		{
			_qualityFireGroup = new TMutexGroup(this);
			_qualityFireGroup.add(createQualityFire(ResLib.QUALITY_FIRE_YELLOW));
			_qualityFireGroup.add(createQualityFire(ResLib.QUALITY_FIRE_RED));
		}

		private function createQualityFire(id:String):BitmapAnimation
		{
			var resMgr:QualityAniResMananger = QualityAniResMananger.getInstance();
			var fire:BitmapAnimation = new BitmapAnimation(resMgr.getRes(id), resMgr.frameCtrl);
			fire.mouseChildren = fire.mouseEnabled = false;
			fire.scaleX = (_sizeType == IconSizeType.ICON36) ? 0.5 : 1;
			fire.scaleY = (_sizeType == IconSizeType.ICON36) ? 0.5 : 1;
			fire.blendMode = BlendMode.ADD;
			fire.x = (_sizeType == IconSizeType.ICON36) ? _mc_color.x - 1 : _mc_color.x - 2;
			fire.y = (_sizeType == IconSizeType.ICON36) ? _mc_color.y - 1 : _mc_color.y - 2;
			fire.addEventListener(Event.ADDED_TO_STAGE, onQualityFireAdd);
			fire.addEventListener(Event.REMOVED_FROM_STAGE, onQualityFireRemove);
			return fire;
		}

		private function onQualityFireAdd(event:Event):void
		{
			var ani:BitmapAnimation = event.currentTarget as BitmapAnimation;
			ani.play();
		}

		private function onQualityFireRemove(event:Event):void
		{
			var ani:BitmapAnimation = event.currentTarget as BitmapAnimation;
			ani.stop();
		}

		/*************************************************************************/

		public function get lbl_amount():TextField
		{
			return _lbl_amount;
		}

		private var tempDisableClick:Boolean = false;

		/**
		 * 物品放下
		 * @param event
		 *
		 */
		private function onDropDown(event:Event):void
		{
			//临时禁用弹出菜单
			tempDisableClick = true;
			this.addEventListener(Event.ENTER_FRAME, enableTempDisableClick);
		}

		/**
		 * 一帧后恢复click可用
		 * @param event
		 *
		 */
		private function enableTempDisableClick(event:Event):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			tempDisableClick = false;
		}

		/**
		 * 物品拾起状态改变时触发(派生类可以扩展)
		 * @param event
		 *
		 */
		protected function onSelect(event:DragEvent):void
		{
			var dragImage:TDragableImage = event.currentTarget as TDragableImage;
			if (dragImage)
			{
				if (dragImage.bePickedUp)
				{
					dragImage.setFilter(UIStyle.disableFilter);
				}
				else
				{
					dragImage.removeFilters();
				}
			}
		}

		/**
		 * 点击时触发(派生类可以扩展)
		 * @param event
		 *
		 */
		protected function onClick(event:MouseEvent):void
		{
			if (!checkClick())
			{
				return;
			}
			//显示菜单
			showMenu();
		}

		/**
		 * 检查连接是否可点击
		 * @return
		 *
		 */
		protected function checkClick():Boolean
		{
			//临时禁用弹出菜单
			if (tempDisableClick)
			{
				tempDisableClick = false;
				return false;
			}
			//如果正在拾取中, 取消菜单显示
//			if (dragImage.fetchEnable && FetchHelper.instance.isFetching)
//			{
//				return false;
//			}
			if (MouseOperatorLock.instance.isLocked())
			{
				return false;
			}
			else
			{
				return true;
			}
		}

		protected function showMenu():void
		{
			if (data != null)
			{
				var typeArray:Array = buildMenuHandler != null ? buildMenuHandler(this) : buildMenu();
				MenuHelper.show(null, this, this.getParentView(TWindow) as TWindow, typeArray, null, onMenuSelect);
			}
		}
		/**
		 * 用于构造菜单的回调
		 * 格式：function (box:BaseDataBox):Array
		 */
		public var buildMenuHandler:Function;

		/**
		 * 构造菜单(派生类可以扩展)
		 * @param event
		 *
		 */
		protected function buildMenu():Array
		{
			return [];
		}

		/**
		 * 弹出菜单点击 (派生类可以扩展)
		 * @param event
		 *
		 */
		protected function onMenuSelect(event:Event):void
		{
//			switch ((event.data as MenuDataItem).operateType)
//			{
//				case MenuOperationType.XXX:
//					//do something...
//					break;
//			}
			dispatchEvent(event.clone());
			menuSelectSignal.dispatch(event, data);
		}

		/**
		 * 设置Tip类型, 派生类可覆盖
		 *
		 */
		protected function setToolTip():void
		{
			var icon:IIcon = data as IIcon;
			if (!icon)
			{
				return;
			}
			var tipShower:IToolTipClient = icon.toolTipShower;
			if (tipShower)
			{
				var tip:TToolTip = TToolTipManager.instance.getToolTipInstance(tipShower.getTipType()) as TToolTip;
				if (this.toolTip != tip)
					this.toolTip = tip;
			}
			else
			{
				this.toolTip = null;
			}
		}

		/**
		 *
		 * @param value
		 *
		 */
		override public function set data(value:Object):void
		{
			changeWatcherMananger.unWatchAll();
			var oldData:Object = super.data;
			if (oldData is EventDispatcher && oldData is ICDable)
			{
				EventDispatcher(oldData).removeEventListener(DataObjectEvent.CDSTATE_RESET, onCDStateReset);
			}
			set_enabled(true);
			//
			super.data = value;
			//更换Tip
			setToolTip();
			//图片资源设置
			setImageData(value);
			//置冷却效果为0 
			if (_freezeEffect)
				_freezeEffect.ratio = 0;
			//绑定冷却值
			bindCDState();
			//是否被锁定
			bindLocked();
			//绑定数目
			bindCount(value);
			//绑定品质颜色
			bindQuality();
			//绑定物品绑定状态
			bindPlayerBindable();
			//物品是否满足职业要求
			var itemData:ItemData = data as ItemData;
			if (itemData)
			{
				set_enabled(checkEnabled(itemData));
			}
		}

		/**
		 * 绑定物品绑定状态
		 *
		 */
		private function bindPlayerBindable():void
		{
			if (_enablePlayerBindableBinding)
			{
				if (data is IPlayerBindable)
				{
					var bindClient:IPlayerBindable = IPlayerBindable(data);
					changeWatcherMananger.bindSetter(setPlayerBindable, bindClient, "playerBinded");
				}
				else
				{
					changeWatcherMananger.bindSetter(setPlayerBindable, null, "playerBinded");
				}
			}
		}

		private static var _count1:int = 0;
		private static var _count2:int = 0;

		/**
		 * 绑定品质
		 *
		 */
		private function bindQuality():void
		{
			if (!this._mc_color)
			{
				return;
			}
			if (!_disposed && data && data is IIcon)
			{
//				if (data is PetObjectData)
//				{
//					changeWatcherMananger.bindSetter(setQuality, data.petProperty, "quality");
//				}
//				else
//				{
				changeWatcherMananger.bindSetter(setQuality, data, "quality");
//				}
			}
			else
			{
				changeWatcherMananger.bindSetter(setQuality, null, "quality");
			}
		}

		/**
		 * 绑定锁定状态（不是物品的绑定状态）
		 *
		 */
		private function bindLocked():void
		{
			if (enableLockState)
			{
				if (!data)
				{
					setLocked(false);
				}
				else
				{
					var iLockable:ILockable = data as ILockable;
					if (iLockable)
					{
						changeWatcherMananger.bindSetter(setLocked, iLockable, "locked", false);
					}
				}
			}
		}

		private function bindCDState():void
		{
			if (_enableCD)
			{
				var iCDable:ICDable = data as ICDable;
				if (iCDable)
				{
					EventDispatcher(data).addEventListener(DataObjectEvent.CDSTATE_RESET, onCDStateReset);
					changeWatcherMananger.bindSetter(bindCDVisible, iCDable, "cdVisible", false);
				}
				else
				{
					changeWatcherMananger.bindSetter(bindCDVisible, null, "cdVisible", false);
				}
			}
			else
			{
				changeWatcherMananger.bindSetter(bindCDVisible, null, "cdVisible", false);
			}
		}

		private function bindCDVisible(value:Boolean):void
		{
			var iCDable:ICDable = data as ICDable;
			if (iCDable && value)
			{
				changeWatcherMananger.bindProperty(_freezeEffect, "ratio", iCDable.cdState, "cdRatio");
			}
			else
			{
				changeWatcherMananger.bindProperty(_freezeEffect, "ratio", null, "cdRatio");
			}
		}

		private function bindCount(data:Object):void
		{
			if (_enableNumBinding && this._lbl_amount)
			{
//				changeWatcherManger.unWatchSetter(set_lbl_amount); //清除绑定
				var countableObject:ICountable = data as ICountable;
				if (!countableObject)
				{
					changeWatcherMananger.bindSetter(set_lbl_amount, null, "num");
				}
				else
				{
					changeWatcherMananger.bindSetter(set_lbl_amount, countableObject, "num");
				}
				changeWatcherMananger.bindSetter(set_lbl_show, countableObject, "needShowNum", false);
			}
		}

		/**
		 * CDState被重置时触发
		 * @param event
		 *
		 */
		private function onCDStateReset(event:DataObjectEvent):void
		{
			bindCDVisible(ICDable(data).cdVisible);
		}

		private var _qualityValid:Boolean = true;
		private var _quality:int = 1;

		private function setQuality(quality:int):void
		{
			if (!quality)
			{
				quality = 1;
			}
			_quality = quality;
			invaliateQuality();
		}

		private function invaliateQuality():void
		{
//			if (_qualityValid)
//			{
//				_qualityValid = false;
//				this.addEventListener(Event.ENTER_FRAME, onValidQuality);
//			}
			//DEBUG
			if (_mc_color)
			{
				_mc_color.gotoAndStop(!_disposed ? _quality : 1);
				//切换到对应品质的品质动画
				updateQualityAni();
				updateQualityFire();
			}
		}

		private function onValidQuality(event:Event):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			if (_mc_color)
			{
				_mc_color.gotoAndStop(!_disposed ? _quality : 1);
				//切换到对应品质的品质动画
				updateQualityAni();
				updateQualityFire();
			}
			_qualityValid = true;
		}

		/**
		 * 切换品质边框动画
		 *
		 */
		private function updateQualityAni():void
		{
			var quality:int = !_disposed ? _quality : 1;
			var index:int = qualityToAniIndex(quality);
			if (_qualityAnimGroup.currentIndex == index)
			{
				return;
			}
			_qualityAnimGroup.currentIndex = index;
			if (_lbl_amount)
			{
				this.setChildIndex(_lbl_amount, this.numChildren - 1);
			}
		}

		private function qualityToAniIndex(quality:int):int
		{
			switch (quality)
			{
				case ItemQuality.QUALITY_3:
					return 0;
				case ItemQuality.QUALITY_4:
					return 1;
				case ItemQuality.QUALITY_5:
					return 2;
				default:
					return -1;
			}
		}

		/**
		 * 切换品质火焰动画
		 *
		 */
		private function updateQualityFire():void
		{
			var quality:int = !_disposed ? _quality : 1;
			var index:int = qualityToFireIndex(quality);
			if (_qualityFireGroup.currentIndex == index)
			{
				return;
			}
			_qualityFireGroup.currentIndex = index;
			if (_lbl_amount)
			{
				this.setChildIndex(_lbl_amount, this.numChildren - 1);
			}
		}

		private function qualityToFireIndex(quality:int):int
		{
			switch (quality)
			{
				case ItemQuality.QUALITY_4:
					return 0;
				case ItemQuality.QUALITY_5:
					return 1;
				default:
					return -1;
			}
		}

		public function set sizeType(value:int):void
		{
			if (_sizeType == value)
			{
				return;
			}
			_sizeType = value;
			//改变品质光效大小
			if (_mc_color)
			{
				var list:Vector.<DisplayObject> = _qualityAnimGroup.objList.concat(_qualityFireGroup.objList);
				for each (var ani:BitmapAnimation in list)
				{
					ani.scaleX = (_sizeType == IconSizeType.ICON36) ? 0.5 : 1;
					ani.scaleY = (_sizeType == IconSizeType.ICON36) ? 0.5 : 1;
					ani.x = (_sizeType == IconSizeType.ICON36) ? _mc_color.x - 1 : _mc_color.x - 2;
					ani.y = (_sizeType == IconSizeType.ICON36) ? _mc_color.y - 1 : _mc_color.y - 2;
				}
			}
		}

		private function setPlayerBindable(value:Boolean):void
		{
			if (value)
			{
				if (!_playerBindIcon)
				{
					_playerBindIcon = new Bitmap(RslManager.getInstance(UIResourceLib.itemBindIcon));
					_playerBindIcon.x = this.width - _playerBindIcon.width - 3;
					_playerBindIcon.y = 3;
				}
				this.addChild(_playerBindIcon);
			}
			else
			{
				if (_playerBindIcon && _playerBindIcon.parent)
				{
					this.removeChild(_playerBindIcon);
				}
			}
		}

		private function set_enabled(value:Boolean):void
		{
			if (_sizeType == IconSizeType.ICON72)
			{
				value = true;
			}
			if (value)
			{
				if (_professionErrorIcon && _professionErrorIcon.parent)
				{
					this.removeChild(_professionErrorIcon);
				}
			}
			else
			{
				if (!_professionErrorIcon)
				{
					_professionErrorIcon = new Bitmap(TRslManager.getInstance(UISkinLib.professionReqErrorSkin) as BitmapData);
					_professionErrorIcon.x = _dragImage.x + 3;
					_professionErrorIcon.y = _dragImage.y + 22;
				}
				if (!_professionErrorIcon.parent)
				{
					this.addChild(_professionErrorIcon);
				}
			}
		}

		private function set_lbl_amount(value:int):void
		{
			if (_lbl_amount)
			{
				if (_showAmountHandler != null)
				{
					_showAmountHandler(this, value, data);
				}
				else
				{
					if (!data || !(data is ICountable))
					{
						_lbl_amount.text = "";
					}
					else
					{
						var countableObj:ICountable = ICountable(data);
						if (countableObj)
						{
							_lbl_amount.text = countableObj.getNumStr(value);
						}
						else
						{
//							_lbl_amount.text = value ? value.toString() : "";
							_lbl_amount.text = value.toString();
						}
					}
				}
			}
		}

		/**
		 * 设置显示文本
		 * @param value
		 *
		 */
		public function setText(value:String):void
		{
			if (_lbl_amount)
			{
				_lbl_amount.text = value;
			}
		}

		/**
		 * 用于设置数量显示文本的回调，参数如function (box:BaseDataBox, value:int, data:ItemData):void{};
		 * @param value
		 *
		 */
		public function set showAmountHandler(value:Function):void
		{
			if (_showAmountHandler == value)
			{
				return;
			}
			_showAmountHandler = value;
		}

		public function set_lbl_show(obj:Boolean):void
		{
			_lbl_amount.visible = obj;
		}

		protected function setLocked(value:Boolean):void
		{
			this.enabled = !value;
			if (this.enabled)
			{
				this.filters = null;
			}
			else
			{
				this.filters = [UIStyle.disableFilter];
			}
		}

		/**
		 * 设置_dragImage图片数据
		 * @param value
		 *
		 */
		private function setImageData(value:Object):void
		{
			_dragImage.data = value;
			if (value != null)
			{
				var icon:IIcon = value as IIcon;
				if (icon != null)
				{
					_dragImage.setSource(icon.getIconUrl(_sizeType));
				}
				else
				{
					_dragImage.setSource(null);
				}
			}
			else
			{
				_dragImage.setSource(null);
			}
		}

		public function get dragImage():TDragableImage
		{
			return _dragImage;
		}

		public function set dragBackAreaArray(value:Array):void
		{
			_dragImage.dropBackAreaArray = value;
		}

		public function set pickUpEnabled(value:Boolean):void
		{
			_dragImage.pickUpEnable = value;
		}

		/**
		 * 标记图片所在的逻辑地点，方便逻辑判断
		 * @param value
		 *
		 */
		public function set place(value:int):void
		{
			_dragImage.place = value;
		}

		public function get freezeEffect():CDEffect
		{
			return _freezeEffect;
		}

		override public function getTipData():Object
		{
			if (_tipData)
				return _tipData;
			if (!data)
				return null;
			if (!(data is IIcon))
				return null;
			var tipShower:IToolTipClient = IIcon(data).toolTipShower;
			if (!tipShower)
				return null;
			var loaderTipShower:ILoaderTipClient = tipShower as ILoaderTipClient;
			if (loaderTipShower)
				return loaderTipShower.loader;
			return tipShower;
		}

		/**
		 * 是否绑定数量
		 * @param value
		 *
		 */
		public function set enableNumBinding(value:Boolean):void
		{
			if (_enableNumBinding == value)
				return;
			_enableNumBinding = value;
			if (!_enableNumBinding && this._lbl_amount)
			{
				this._lbl_amount.text = "";
				this._lbl_amount.visible = true;
				//清除绑定
				changeWatcherMananger.unWatchSetter(set_lbl_amount);
			}
			else
			{
				//重新刷新data
				this.data = this.data;
			}
		}

		/**
		 * 是否开启物品绑定状态显示
		 * @param value
		 *
		 */
		public function set enablePlayerBindableBinding(value:Boolean):void
		{
			if (_enablePlayerBindableBinding == value)
			{
				return;
			}
			_enablePlayerBindableBinding = value;
			if (_enablePlayerBindableBinding)
			{
				bindPlayerBindable();
			}
			else
			{
				changeWatcherMananger.bindSetter(setPlayerBindable, null, "playerBinded");
			}
		}

		public function set enableCD(value:Boolean):void
		{
			if (_enableCD == value)
			{
				return;
			}
			_enableCD = value;
			bindCDState();
		}

		/**
		 * 设置_dragImage的拖放位置
		 * @param value
		 *
		 */
		public function set imageDragPlace(value:int):void
		{
			_dragImage.place = value;
		}

		public function setDragMouseSkin():void
		{
			var box:IconBox = new IconBox(TRslManager.getInstance(UISkinLib.itemMoveBoxSkin));
			box.sizeType = _sizeType;
			box.data = this.data;
			box.filters = this.filters;
			CursorManager.instance.setTempCursor(box, -box.width / 2, -box.height / 2, CursorPriority.DRAG);
		}

//		/**
//		 * Tip显示处理
//		 * @param event
//		 *
//		 */
//		private function onShowTip(event:TComponentEvent):void
//		{
//			event.preventDefault();
//			var tipClient:IRichTextTipClient = getTipData() as IRichTextTipClient;
//			if (tipClient)
//			{
//				TToolTipManager.instance.showTip(_toolTip, this, tipClient, ItemConst.TIP_PLACE_DEFAULT);
//			}
//		}
		public function reset(args:Array):void
		{
			// TODO Auto Generated method stub
		}

		override protected function implementSize(width:Number, height:Number):void
		{
			this.$width = width;
			this.$height = height;
//			super.implementSize(width, height);
		}
	}
}
