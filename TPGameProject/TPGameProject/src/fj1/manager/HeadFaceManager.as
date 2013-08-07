package fj1.manager
{
	import fj1.common.GameInstance;
	import fj1.common.res.ResPaths;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.res.map.MapResManager;
	import fj1.common.res.map.vo.MapRes;
	import fj1.common.staticdata.ColorConst;
	import fj1.common.staticdata.SceneCharacterType;
	import fj1.common.vo.character.Npc;
	import fj1.common.staticdata.SceneCharacterType;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	import tempest.common.rsl.TRslManager;
	import tempest.common.staticdata.Colors;
	import tempest.engine.BaseElement;
	import tempest.engine.SceneCharacter;
	import tempest.ui.collections.TArrayCollection;
	import tempest.utils.HtmlUtil;

	public class HeadFaceManager
	{
		/**
		 * 更新场景对象名称
		 * @param chars 对象列表
		 * @param updateNickName 是否更新昵称
		 * @param updateNickNameColor 是否更新昵称颜色
		 */
		public static function updateNickCharName(chars:Array, updateNickName:Boolean = true, updateNickNameColor:Boolean = true):void
		{
			var $chars:Array = chars;
			var char:SceneCharacter;
			var name:String = "";
			var color:uint = 0;
			for each (char in $chars)
			{
				if (!char)
				{
					continue;
				}
				switch (char.type)
				{
					case SceneCharacterType.PLAYER:
//						var player:Player = char.data as Player;
//						if (updateNickName)
//						{
//							if (player.isGM)
//							{
//								name += "【GM】";
//							}
//							name += player.name;
//						}
//						else
//						{
//							name = char.nickName;
//						}
//						if (updateNickNameColor)
//						{
//							color = Colors.White;
//							if (char.isMainChar)
//							{
//								color = Colors.HeroBlue;
//							}
//							if (player.pk_state == PKMode.BLUE_NAME)
//							{
//								color = Colors.DodgeBlue;
//							}
//							else if (player.pk_state == PKMode.REN_NAME)
//							{
//								if (player.pk_value > 30)
//								{
//									color = Colors.Red; //大红
//								}
//								else
//								{
//									color = Colors.Pink; //粉红
//								}
//							}
//						}
//						else
//						{
//							color = char.nickNameColor;
//						}
						break;
					case SceneCharacterType.MONSTER:
//						var monster:Monster = char.data as Monster;
//						if (updateNickName)
//						{
//							if (monster.variation)
//							{
//								name = StatusTemplateManager.instance.getStatusName(monster.diffState);
//							}
//							else
//							{
//								name += monster.name;
//							}
//							if (monster.deity_power > 0)
//							{
//								name += LanguageManager.translate(2071, "(神力 {0})", monster.deity_power);
//							}
//						}
//						else
//						{
//							name = char.nickName;
//						}
//						if (updateNickNameColor)
//						{
//							if (!monster.canCollect)
//							{
//								color = getMonstNickColor(monster.level);
//							}
//							else
//							{
//								color = Colors.Green;
//							}
//						}
//						else
//						{
//							color = char.nickNameColor;
//						}
						break;
					case SceneCharacterType.NPC:
						var npc:Npc = char.data as Npc;
						if (updateNickName)
						{
							name += npc.name;
						}
						else
						{
							name = char.nickName;
						}
						if (updateNickNameColor)
						{
							color = Colors.lightGreen;
						}
						else
						{
							color = char.nickNameColor;
						}
						break;
					case SceneCharacterType.PET:
//						var pet:Pet = char.data as Pet;
//						if (updateNickName)
//						{
//							name += pet.name;
//						}
//						else
//						{
//							name = char.nickName;
//						}
//						if (updateNickNameColor)
//						{
//							color = Colors.PetBlue;
//						}
//						else
//						{
//							color = char.nickNameColor;
//						}
						break;
				}
				char.setNickName(name, color);
			}
		}

//		/**
//		 *根据怪物等级获取怪物名字颜色
//		 * @param mLevel
//		 * @return
//		 *
//		 */
//		private static function getMonstNickColor(mLevel:int):uint
//		{
//			var level:int = mLevel - GameInstance.mainCharData.level;
//			var color:int = 0xFFFFFF00;
//			if (level > 5)
//			{
//				color = Colors.Red;
//			}
//			else if (level > 0 && level <= 5)
//			{
//				color = Colors.Yellow;
//			}
//			else if (level > -5 && level < 0)
//			{
//				color = Colors.Green;
//			}
//			else if (level < -5)
//			{
//				color = Colors.Gray;
//			}
//			return color;
//		}

		public static function updateCharCustomHtmlText(chars:Array):void
		{
			var $chars:Array = chars;
			var char:SceneCharacter;
			var htmlTitle:String = "";
			for each (char in $chars)
			{
				if (!char)
				{
					continue;
				}
				switch (char.type)
				{
					case SceneCharacterType.PLAYER:
//						var player:Player = char.data as Player;
//						var rows:int = 0;
////						if (player.titleId4) //称号文字
////						{
////							var titleData:TitleData = TitleData(GameInstance.mainCharData.allTitleArray[player.titleId4]);
////							if (titleData)
////							{
////								htmlTitle += HtmlUtil.color(ItemQuality.getColorString(titleData.rare), titleData.name);
////								rows += 1;
////							}
////						}
//						if (player.teamName.length > 0)
//						{
//							if (htmlTitle.length != 0)
//							{
//								htmlTitle += "<br>";
//							}
//							htmlTitle += "<font color=\'" + ColorConst.getHtmlColor(Colors.DodgeBlue) + "\'>" + "&lt;" + player.teamName + "&gt;" + "</font>";
//							rows += 1;
//						}
//						if (player.guildName.length > 0)
//						{
//							if (htmlTitle.length != 0)
//							{
//								htmlTitle += "<br>";
//							}
//							htmlTitle += "<font color=\'" + ColorConst.green + "\'>" + "[" + player.guildName + "] " + GuildConst.getPost(player.guildPost) + "</font>";
//							rows += 1;
//						}
						break;
					case SceneCharacterType.NPC:
						var npc:Npc = char.data as Npc;
						var title:String = npc.npcRes.template.npc_title;
						if (title.length > 0)
						{
							htmlTitle = HtmlUtil.color(ColorConst.lightBlue, title);
						}
						break;
				}
				char.setCustomTitle(htmlTitle);
			}
		}

		public static function updateCharTopIco(chars:Array):void
		{
			var $chars:Array = chars;
			var char:SceneCharacter;
			var topArray:Array;
			for each (char in $chars)
			{
				if (!char)
				{
					continue;
				}
				topArray = [];
				switch (char.type)
				{
					case SceneCharacterType.PLAYER:
//						var player:Player = char.data as Player;
//						//获取军衔图标
//						if (player.military_rank != 0)
//						{
//							var militaryRankBar:MilitaryRankBar = new MilitaryRankBar(player.military_rank);
//							topArray.push(militaryRankBar);
//						}
//						//获得称号图片资源，放入数组
//						var mapRes:MapRes = MapResManager.getMapRes(GameInstance.scene.id);
//						if (!(mapRes.stateFlag & MapConst.MapStateFlag_HideTitle)) //检查场景的称号屏蔽标示，如果为true不显示称号
//						{
//							var id:int;
//							for (i = 0; i < TitleConst.USING_TITLE_MAX - 1; i++)
//							{
//								id = player["titleId" + i];
//								if (id > 0)
//								{
//									var titleEffectTemplate:TitleEffectTemplate = TitleEffectTemplateManager.getTitleRes(id);
//									if (titleEffectTemplate)
//									{
//										topArray.push(TitleImageResHelper.getTitleImage(titleEffectTemplate.head_effect));
//									}
//								}
//							}
//						}
						break;
					case SceneCharacterType.NPC:
//						var npc:Npc = char.data as Npc;
//						topArray.push(TitleImageResHelper.getTitleImage(npc.npcRes.template.top_ico_id));
						break;
				}
				//创建角色头顶图标
				var topIco:Sprite = createTopIco(topArray);
				char.setTopIco(topIco);
			}
		}

		/**
		 * 创建头顶图标
		 * @param iconArr
		 * @return
		 *
		 */
		private static function createTopIco(iconArr:Array):Sprite
		{
			var sp:Sprite = new Sprite();
			var maxWidth:Number = 0;
			var bottom:Number = 0;
			var gt:DisplayObject;
			for each (gt in iconArr)
			{
				if (gt)
				{
					sp.addChild(gt);
					if (gt.width > maxWidth)
						maxWidth = gt.width;
					gt.y = bottom;
					bottom += gt.height;
				}
			}
			var num:int = sp.numChildren;
			var i:int = 0;
			if (num > 0)
			{
				for (i = 0; i < num; ++i)
				{
					gt = sp.getChildAt(i) as DisplayObject;
					gt.x = (maxWidth - gt.width) * 0.5;
				}
			}
			else
			{
				sp = null;
			}
			return sp;
		}

		/**
		 *设置角色名字左边图标
		 * @param char
		 * @param icoID
		 *
		 */
		public static function updateCharLeftIco(chars:Array):void
		{
			var $chars:Array = chars;
			var char:SceneCharacter;
			var sp:Sprite;
			var leftArray:Array;
			var i:int;
			for each (char in $chars)
			{
				if (!char)
				{
					continue;
				}
				leftArray = [];
				switch (char.type)
				{
					case SceneCharacterType.PLAYER:
//						var player:Player = char.data as Player;
//						var vipIconLib:String = getVIPHeadIconLib(player);
//						if (vipIconLib)
//						{
//							leftArray.push(new Bitmap(TRslManager.getInstance(vipIconLib)));
//						}
//						if (player.isCaptain)
//						{
//							leftArray.push(new Bitmap(TRslManager.getInstance(ResLib.UI_MARK_SCENE_TEAM1)));
//						}
//						if (player.godPowerIsOpen) //神力阶段
//						{
//							var godInfo:GodPowerInfo = GodPowerResManager.instance.getGodPowerInfoByValue(player.deity_power);
//							if (godInfo)
//							{
//								leftArray.push(new Bitmap(TRslManager.getInstance(ResLib.UI_MARK_SCENE_JINGJIE + godInfo.id)));
//							}
//						}
//						switch (player.zhenying) //阵营
//						{
//							case CampConst.GOD:
//								var godBitmap:Bitmap = new Bitmap(TRslManager.getInstance(ResLib.UI_MASK_SCENE_ZHENYING_GOD));
//								leftArray.push(godBitmap);
//								break;
//							case CampConst.EVIL:
//								var evilBitmap:Bitmap = new Bitmap(TRslManager.getInstance(ResLib.UI_MASK_SCENE_ZHENYING_EVAL));
//								leftArray.push(evilBitmap);
//								break;
//						}
						break;
					case SceneCharacterType.MONSTER:
//						var monster:Monster = char.data as Monster;
//						if (monster.res.magictype != 0) //魔法力类型
//						{
//							leftArray.push(new Bitmap(TRslManager.getInstance(ResLib.UI_MARK_SCENE_MAGICTYPE + monster.res.magictype)));
//						}
//						if (!monster.canCollect)
//						{
//							if (monster.isActiveAttack)
//							{
//								leftArray.push(new Bitmap(TRslManager.getInstance(ResLib.UI_MARK_SCENE_MONSTERTYPE + monster.monsterType)));
//							}
//							else
//							{
//								leftArray.push(new Bitmap(TRslManager.getInstance(ResLib.UI_MARK_SCENE_MONSTERTYPE + monster.monsterType)));
//							}
//						}
						break;
				}
				var topIco:Sprite = createLeftIco(leftArray);
				char.setLeftIco(topIco);
			}
		}

		/**
		 * 创建角色头顶图标
		 * @param iconArr
		 * @return
		 *
		 */
		private static function createLeftIco(iconArr:Array):Sprite
		{
			var sp:Sprite = new Sprite();
			var maxHeight:Number = 0;
			var left:Number = 0;
			var gt:Bitmap;
			for each (gt in iconArr)
			{
				if (gt)
				{
					sp.addChild(gt);
					if (gt.height > maxHeight)
						maxHeight = gt.height;
					gt.x = left;
					left += gt.width;
				}
			}
			var num:int = sp.numChildren;
			if (num > 0)
			{
				for (var i:int = 0; i < num; ++i)
				{
					gt = sp.getChildAt(i) as Bitmap;
					gt.y = maxHeight - gt.height;
				}
			}
			else
			{
				sp = null;
			}
			return sp;
		}

//		/**
//		 * 获取VIP图标导出类链接
//		 * @param char
//		 * @return
//		 *
//		 */
//		private static function getVIPHeadIconLib(char:Player):String
//		{
//			if (!char)
//			{
//				return null;
//			}
//			switch (char.vip)
//			{
//				case VIPConst.VIP_LEVEL_1:
//					return ResLib.UI_MARK_SCENE_VIP;
//				case VIPConst.VIP_LEVEL_2:
//					return ResLib.UI_MARK_SCENE_VIP1;
//				case VIPConst.VIP_LEVEL_3:
//					return ResLib.UI_MARK_SCENE_VIP2;
//				case VIPConst.VIP_LEVEL_SPECIAL:
//					return ResLib.UI_MARK_SCENE_VIP2;
//				default:
//					return null;
//			}
//		}
	}
}
