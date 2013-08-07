package fj1.modules.scene.util
{
	import fj1.common.GameInstance;
	import fj1.common.net.GameClient;
	import fj1.common.res.map.MapResManager;
	import flash.geom.Point;
	import tempest.engine.SceneCharacter;
	import tempest.engine.staticdata.Status;
	import tempest.engine.vo.map.MapTile;
	import tempest.engine.vo.move.MoveCallBack;
	import tempest.ui.components.TAlert;
	import tempest.ui.events.DataEvent;

	public class MainCharWalkManager
	{
		private static var m_scenePath:Array = [];
		private static var m_moveCallBack:MoveCallBack;

		/**
		 * 清除移动
		 */
		public static function clear():void
		{
			m_scenePath = [];
			m_moveCallBack = null;
			return;
		}

		private static function beforeMove(clearAutoAttack:Boolean = true, isStopAssist:Boolean = true):void
		{
//			GameInstance.tabSelectArr.length = 0;
//			if (clearAutoAttack && FightManager.instance.isPolling)
//			{
//				FightManager.instance.stopPoll();
//			}
//			if (isStopAssist)
//			{
//				GameInstance.signal.assist.start.dispatch(0);
//			}
		}

		/**
		 * 英雄移动
		 * @param moveData 移动数据 [地图ID,目的地坐标,站立距离]
		 * @param showAutoFindPathText 是否显示寻路文本
		 * @param walk_callBack 移动回调
		 * @param clearAutoAttack 是否清理自动攻击
		 * @param isStopAFK 是否停止离开
		 */
		public static function heroWalk(moveData:Array, showAutoFindPathText:Boolean = true, walk_callBack:MoveCallBack = null, clearAutoAttack:Boolean = true, isStopAssist:Boolean = true):void
		{
			var doHeroWalk:Function = function():void
			{
				var old_onWalkReady:Function;
				var old_onWalkUnable:Function;
				var old_onWalkArrived:Function;
				var new_onWalkReady:Function;
				var new_onWalkUnable:Function;
				var new_onWalkArrived:Function;
				new_onWalkReady = function(char:SceneCharacter, endTile:MapTile, path:Array):void
				{
					if (!(old_onWalkReady == null))
					{
						old_onWalkReady(char, endTile, path);
					}
					beforeMove(clearAutoAttack, isStopAssist);
//					if (showAutoFindPathText)
//					{
//						GameInstance.signal.mainChar.autoMoving.dispatch(true);
//					}
				}
				new_onWalkUnable = function(char:SceneCharacter, endTile:MapTile):void
				{
					if (!(old_onWalkUnable == null))
					{
						old_onWalkUnable(char, endTile);
					}
				}
				new_onWalkArrived = function(sc:SceneCharacter, targetTile:MapTile):void
				{
					if (!(old_onWalkArrived == null))
					{
						old_onWalkArrived(sc, targetTile);
					}
//					GameInstance.signal.mainChar.autoMoving.dispatch(false);
				}
				if (!(walk_callBack == null))
				{
					old_onWalkReady = walk_callBack.onWalkReady;
					old_onWalkUnable = walk_callBack.onWalkUnable;
					old_onWalkArrived = walk_callBack.onWalkArrived;
					walk_callBack.onWalkReady = new_onWalkReady;
					walk_callBack.onWalkUnable = new_onWalkUnable;
					walk_callBack.onWalkArrived = new_onWalkArrived;
				}
				else
				{
					walk_callBack = new MoveCallBack();
					walk_callBack.onWalkReady = new_onWalkReady;
					walk_callBack.onWalkUnable = new_onWalkUnable;
					walk_callBack.onWalkArrived = new_onWalkArrived;
				}
				if (moveData == null || moveData.length < 3)
				{
					return;
				}
				goto(moveData[0], moveData[1], moveData[2], walk_callBack);
			};
			//移动判断条件
			if (!canMove())
			{
				return;
			}
			doHeroWalk();
		}

		public static function heroWalk2(vecX:int, vecY:int):void
		{
			//移动判断条件
			if (!canMove())
			{
				return;
			}
			clear();
			GameInstance.mainChar.walk1(vecX, vecY);
		}

		/**
		 *  移动判断条件
		 * @return
		 *
		 */
		public static function canMove():Boolean
		{
//			if (GameInstance.mainCharData.isLimitMove)
//			{
//				return false;
//			}
//			//魔法阵判断
//			if (GameInstance.mainCharData.magicWardID != 0) //是否在魔法阵
//			{
//				TAlertMananger.showAlert(AlertId.MAGIC_WARD_EXIT, LanguageManager.translate(50089, "你确定要退出魔法阵吗？"), true, TAlert.OK | TAlert.CANCEL, function(e:DataEvent):void
//				{
//					if (e.data == TAlert.OK)
//					{
//						GameInstance.ui.taskWaringPanel.magicWardLeft();
//						return;
//					}
//					else
//					{
//						clear();
//					}
//				});
//				return false;
//			}
			return true;
		}

		/**
		 * 前往
		 * @param mapId 地图ID
		 * @param targetTile 目标点
		 * @param standDis 站立距离
		 * @param callBack 回调
		 */
		public static function goto(targetMapId:int, targetTile:Point, standDis:int, walk_callBack:MoveCallBack):void
		{
			var old_onWalkReady:Function;
			var old_onWalkReady2:Function;
			var mapArr:Array;
			var currentMapId:int = GameInstance.scene.id;
			if (targetMapId == currentMapId) //在同一张地图
			{
				var new_onWalkReady:Function = function(char:SceneCharacter, endTile:MapTile, path:Array):void
				{
					if (!(old_onWalkReady == null))
					{
						old_onWalkReady(char, endTile, path);
					}
				};
				if (walk_callBack)
				{
					old_onWalkReady = walk_callBack.onWalkReady;
					walk_callBack.onWalkReady = new_onWalkReady;
				}
				else
				{
					walk_callBack = new MoveCallBack();
					walk_callBack.onWalkReady = new_onWalkReady;
				}
				clear();
				GameInstance.mainChar.walk(targetTile, -1, standDis, walk_callBack);
			}
			else
			{
				mapArr = MapResManager.find(currentMapId, targetMapId);
				if (mapArr && mapArr.length > 0)
				{
					var tempArr:Array = mapArr.shift();
//					var autoRide2:Function = function():void
//					{
//						if (!GameInstance.mainChar.isOnMount && GameInstance.mainChar.walkData.walk_pathArr.length > 25)
//						{
//							GameInstance.signal.mount.upAndDowMount.dispatch(1, 0, false);
//						}
//					}
					var new_onWalkReady2:Function = function(char:SceneCharacter, endTile:MapTile, path:Array):void
					{
						if (!(old_onWalkReady2 == null))
						{
							old_onWalkReady2(char, endTile, path);
						}
//						autoRide2();
					}
					if (walk_callBack != null)
					{
						old_onWalkReady2 = walk_callBack.onWalkReady;
						walk_callBack.onWalkReady = null;
					}
					m_scenePath = mapArr.concat([[targetMapId, targetTile.x, targetTile.y, standDis]]);
					m_moveCallBack = walk_callBack;
					var walk_callBack2:MoveCallBack = new MoveCallBack();
					walk_callBack2.onWalkReady = new_onWalkReady2;
					GameInstance.mainChar.walk(new Point(tempArr[1], tempArr[2]), -1, 0, walk_callBack2);
				}
				else
				{
					clear();
				}
			}
		}

		public static function goon():void
		{
			if (m_scenePath && m_scenePath.length != 0)
			{
				var tempArr:Array = m_scenePath.shift();
				if (tempArr[0] == GameInstance.scene.id)
				{
					if (m_scenePath.length == 0)
					{
						GameInstance.mainChar.walk(new Point(tempArr[1], tempArr[2]), -1, tempArr[3], m_moveCallBack);
					}
					else
					{
						GameInstance.mainChar.walk(new Point(tempArr[1], tempArr[2]));
					}
//					GameInstance.signal.mainChar.autoMoving.dispatch(true);
				}
				else
				{
//					var callBack:MoveCallBack = m_moveCallBack;
//					if (m_scenePath.length != 0)
//					{
//						tempArr = m_scenePath.pop();
//					}
					clear();
//					heroWalk([tempArr[0], new Point(tempArr[1], tempArr[2]), tempArr[3]], true, callBack);
				}
			}
		}

		public static function stopMove(stand:Boolean = true):void
		{
			if (GameInstance.mainChar.getStatus() == Status.WALK)
			{
				GameClient.sendStopMove();
			}
			GameInstance.mainChar.stopWalk(stand);
		}

		/**
		 * 传送
		 * @param tranId 传送点ID
		 */
		public static function teleport(tranId:int, taskID:int = 0, npcID:int = 0):void
		{
			GameInstance.mainChar.stopWalk();
			GameClient.sendPlace(tranId, taskID, npcID); // 传送
		}
	}
}
