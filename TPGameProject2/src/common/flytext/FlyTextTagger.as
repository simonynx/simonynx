package common.flytext
{
	import com.adobe.utils.DictionaryUtil;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.GTweener;
	import com.gskinner.motion.easing.Sine;
	
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	import common.GameInstance;
	import common.flytext.FlyableText;
	
	import tempest.common.time.vo.TimerData;
	import tempest.engine.SceneCharacter;
	import tempest.manager.TimerManager;
	import tempest.utils.Random;

	/**
	 *文字漂浮弹出对象
	 * @author zhangyong
	 *
	 */
	public class FlyTextTagger
	{
		private static var _flyTextTagger:FlyTextTagger = null;
		private static var _key:Boolean = false;
		private var popInterval:Number = 200; //弹出速度
		private var timerData:TimerData; //弹出定时器
		private var flyTextList:Dictionary = null;
		/**********************************************************************/
		/************************文字漂浮缓动参数*******************************/
		/**********************************************************************/
		private var _distance:int = 100; //向上浮动距离
		private var _distance2:int = 250; //左右浮动距离
		private var _offsetY:int = 35; //左右浮动随机Y距离
		private var _speed:Number = 1; //向上浮动速度
		private var _speed2:Number = 0.5; //左右浮动速度
		private var _delay2:Number = 0.5; //左右消失延时
		private var _arr:Vector.<DisplayObject> = null;
		private var _keyStr:String;
		private static const UP:int = 1;
		private static const DOWN:int = 2;
		private static const LEFT:int = 3;
		private static const RIGHT:int = 4;
		private static const MOST_TOTAL:int = 20;
		private static const DELETE_NUM:int = 10;

		public static function get instance():FlyTextTagger
		{
			if (_flyTextTagger == null)
			{
				_flyTextTagger = new FlyTextTagger();
			}
			return _flyTextTagger;
		}

		public function FlyTextTagger()
		{
			if (!_key)
			{
				_key = true
				timerData = TimerManager.createPreciseTimer(popInterval, 0, onTimer);
				flyTextList = new Dictionary(true);
				_arr = new Vector.<DisplayObject>();
			}
			else
			{
				throw new Error("单例请使用instance获取对象");
			}
		}

		private function onTimer():void
		{
			if (length > 0)
			{
				for (_keyStr in flyTextList)
				{
					_arr = flyTextList[_keyStr];
					popFlyText(_arr.shift(), int(_keyStr));
					if (_arr.length == 0)
					{
						delete flyTextList[_keyStr];
					}
				}
			}
			else
			{
				timerData.reset();
			}
		}

		/**
		 *添加飞行文字等待
		 * @param parm
		 *
		 */
		public function addToShow(sc:SceneCharacter):void
		{
			if (sc)
			{
				var str:int = sc.id;
				if (sc.flyTextArr.length > MOST_TOTAL) //放置队列积累过多
				{
					sc.flyTextArr.splice(0, DELETE_NUM);
				}
				if (flyTextList[str] == null)
				{
					flyTextList[str] = sc.flyTextArr;
				}
				if (!timerData.running)
				{
					timerData.start();
				}
			}
		}

		/**
		 *当前队列长度
		 * @return
		 *
		 */
		public function get length():int
		{
			return DictionaryUtil.getLength(flyTextList);
		}

		/**********************************************************************/
		/**********************************************************************/
		/**********************************************************************/
		/**
		 *飞行文字基础方法
		 * @param flytext    飞行对象
		 * @param character   添加对象
		 *
		 */
		private function popFlyText(flytext:*, guid:int):void
		{
			var character:SceneCharacter = GameInstance.scene.getCharacterById(guid);
			if (flytext && character)
			{
				flytext.y = character.body_offset; //定位到受击对象的头顶
				character.addChild(flytext);
				if (flytext.direction == UP)
				{
					GTweener.to(flytext, 0.1, {scaleX: 2, scaleY: 2, y: (flytext.y - (flytext.height >> 1))}, {onComplete: nextUpTween, ease: Sine.easeIn});
				}
				else if (flytext.direction == LEFT)
				{
					GTweener.to(flytext, _speed2, {x: flytext.x - _distance2, y: flytext.y - Random.range(-_offsetY, _offsetY, true)}, {onComplete: nextLeftTween}, {delay: _delay2});
				}
				else if (flytext.direction == RIGHT)
				{
					GTweener.to(flytext, _speed2, {x: flytext.x + _distance2, y: flytext.y - Random.range(-_offsetY, _offsetY, true)}, {onComplete: nextRightTween}, {delay: _delay2});
				}
			}
		}

		/**
		 *向上第二阶段
		 * @param gt
		 *
		 */
		private function nextUpTween(gt:GTween):void
		{
			GTweener.to(gt.target, 0.1, {scaleX: 1, scaleY: 1}, {onComplete: nextNextUpTween});
		}

		/**
		 *向上第三阶段
		 * @param gt
		 *
		 */
		private function nextNextUpTween(gt:GTween):void
		{
			GTweener.to(gt.target, _speed, {y: gt.target.y - _distance}, {onComplete: onComplete});
		}

		/**
		 *向左第二阶段
		 * @param gt
		 *
		 */
		private function nextLeftTween(gt:GTween):void
		{
			GTweener.to(gt.target, 1, {alpha: 0}, {onComplete: onComplete});
		}

		/**
		 *向右第二阶段
		 * @param gt
		 *
		 */
		private function nextRightTween(gt:GTween):void
		{
			GTweener.to(gt.target, 1, {alpha: 0}, {onComplete: onComplete});
		}

		/**
		 *缓动完毕  飞行文字对象回收
		 * @param g
		 */
		private static function onComplete(gt:GTween):void
		{
			GTweener.removeTweens(gt.target);
			FlyableText.recycleFlyableText((gt.target as FlyableText))
		}
	}
}
