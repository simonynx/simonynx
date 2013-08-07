package fj1.common.data.dataobject.items.toolTipShowers
{
	import assets.UIResourceLib;
	import fj1.common.GameInstance;
	import fj1.common.res.godpower.GodPowerResManager;
	import fj1.common.res.guild.GuildResManager;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.res.status.StatusTemplateManager;
	import fj1.common.res.status.vo.StatusInfo;
	import fj1.common.staticdata.ItemQuality;
	import fj1.common.staticdata.TImageFontNames;
	import fj1.common.ui.TImageText;
	import fj1.common.ui.font.TImageFont;
	import fj1.common.ui.font.TImageFontManager;
	import fj1.common.vo.character.Hero;
	import fj1.modules.archaeology.model.ArchaeologyModel;
	import fj1.modules.attribute.AttributeFacade;
	import fj1.modules.attribute.staticdata.SungodConst;
	import fj1.modules.title.model.vo.TitleData;
	import flash.display.Sprite;
	import tempest.common.rsl.TRslManager;
	import tempest.ui.components.TList;
	import tempest.utils.HtmlUtil;

	public class PowerToolTipShower extends BaseToolTipShower
	{
		public function PowerToolTipShower()
		{
			super();
		}

		override public function getTipDataArray(params:Object):Array
		{
			var strArray:Array = [];
			var colorValue:String;
			var char:Hero = GameInstance.mainCharData;
			var godPower:int = char.deity_power;
			//名称
//			colorValue = normalPurple;
			colorValue = ItemQuality.getColorString(GodPowerResManager.instance.getGodPowerInfoByValue(godPower).id)
			strArray.push(makeAppendParams2("center", colorValue, setBoldText(getPropText(LanguageManager.translate(100028, "神力阶段") + colonStr, GodPowerResManager.instance.getGodPowerInfoByValue(godPower).
				level_name, colorValue))));
			//分割线
			var line:Sprite = Sprite(TRslManager.getInstance(UIResourceLib.tipLine));
			strArray.push(makeAppendParams(getHtmlTextWithAlign("center", normalWhite, ""), [{src: line, index: 0}]));
			//神力总值
			colorValue = normalWhite;
			var _text:TImageText;
			var font:TImageFont = TImageFontManager.instance.getFont(TImageFontNames.YELLOW);
			_text = new TImageText(font);
			_text.text = char.deity_power.toString();
			strArray.push(makeAppendParams(getHtmlTextWithAlign("center", colorValue, LanguageManager.translate(100029, "神力总值")), [{src: _text, index: 4}]));
			//神力加成详细信息
			strArray.push(makeAppendParams2("left", normalLightYellow, LanguageManager.translate(100030, "神力加成详细信息")));
			//角色属性加成
			colorValue = normalWhite;
			strArray.push(makeAppendParams2("left", colorValue, getPropText(LanguageManager.translate(100031, "角色属性加成") + colonStr, String(char.godPowerFromPoint), colorValue)));
			//装备加成
			strArray.push(makeAppendParams2("left", colorValue, getPropText(LanguageManager.translate(100032, "装备加成") + colonStr, String(char.godPowerFromEquipment), colorValue)));
			//神格加成
			strArray.push(makeAppendParams2("left", colorValue, getPropText(LanguageManager.translate(100033, "神格加成") + colonStr, String(char.godPowerFromGodHood), colorValue)));
			//召唤兽加成
			strArray.push(makeAppendParams2("left", colorValue, getPropText(LanguageManager.translate(100034, "召唤兽加成") + colonStr, String(char.godPowerFromPet), colorValue)));
			//技能神力加成
			strArray.push(makeAppendParams2("left", colorValue, getPropText(LanguageManager.translate(100044, "技能加成：") + colonStr, String(char.godPowerFromSkill), colorValue)));
			//坐骑神力加成
//			var mountGodPower:int = GameInstance.model.mount.mountGodPower;
			strArray.push(makeAppendParams2("left", colorValue, getPropText(LanguageManager.translate(100048, "坐骑加成：") + colonStr, String(char.godPowerFromHorse), colorValue)));
			//称号神力加成
//			var alchemyGodPower:int = GameInstance.model.alchemyModel.alchemyGodPower;
			//公会神力加成
//			var guildGodPower:int = GameInstance.model.guild.guildGodPower;
//			var archModel:ArchaeologyModel = GameInstance.model.archModel;
//			var archSpellPower:int = archModel.archSpellPower;
//			SungodModel(AttributeFacade.instance.inject.getInstance(SungodModel)).getSunGodState(SungodConst.TYPE_QILING).sunGodInfo.stautsInfo;
			strArray.push(makeAppendParams2("left", colorValue, getPropText(LanguageManager.translate(100036, "称号神力") + colonStr, String(char.godPowerFromTile), colorValue)));
			//炼金术加成
			strArray.push(makeAppendParams2("left", colorValue, getPropText(LanguageManager.translate(100056, "炼金术加成") + colonStr, String(char.godPowerFromAlchemy), colorValue)));
			strArray.push(makeAppendParams2("left", colorValue, getPropText(LanguageManager.translate(100057, "公会神力加成") + colonStr, String(char.godPowerFromGuild), colorValue)));
			//寻宝技能神力加成
//			if (archModel.archSpellStatus)
//			{
			strArray.push(makeAppendParams2("left", colorValue, getPropText(LanguageManager.translate(46070, "寻宝犬神力加成") + colonStr, String(char.godPowerFromArch), colorValue)));
//			}
			//太阳神加成
			strArray.push(makeAppendParams2("left", colorValue, getPropText(LanguageManager.translate(24082, "太阳神加成") + colonStr, String(char.godPowerFromSunGod), colorValue)));
			//契灵加成
			strArray.push(makeAppendParams2("left", colorValue, getPropText(LanguageManager.translate(24083, "契灵加成") + colonStr, String(char.godPowerFromQiLing), colorValue)));
			//古神像加成
			strArray.push(makeAppendParams2("left", colorValue, getPropText(LanguageManager.translate(24084, "古神像加成") + colonStr, String(char.godPowerFromStatues), colorValue)));
			//占星加成
			strArray.push(makeAppendParams2("left", colorValue, getPropText(LanguageManager.translate(24085, "占星加成") + colonStr, String(char.godPowerFromAstrology), colorValue)));
			//分割线
			var line1:Sprite = Sprite(TRslManager.getInstance(UIResourceLib.tipLine));
			strArray.push(makeAppendParams(getHtmlTextWithAlign("left", normalWhite, ""), [{src: line1, index: 0}]));
			//神力阶段说明
			var tlist:TList = new TList(null, null, null, ShengLiItemRender, null, powerArr, false);
			tlist.invalidateNow();
			strArray.push(makeAppendParams(getHtmlTextWithAlign("left", normalWhite, ""), [{src: tlist, index: 0}]));
			return strArray;
		}

		private function getPropText(nameStr:String, valueStr:String, valueColor:String):String
		{
			var nameStr:String = HtmlUtil.color(BaseToolTipShower.normalWhite, nameStr);
			var valueStr:String = HtmlUtil.color(valueColor, valueStr);
			return nameStr + valueStr;
		}
		private var powerArr:Array = GodPowerResManager.instance.getGodPowList() as Array;
	}
}
import fj1.common.res.godpower.GodPowerResManager;
import fj1.common.res.godpower.vo.GodPowerInfo;
import fj1.common.res.lan.LanguageManager;
import fj1.common.staticdata.ItemQuality;
import fj1.modules.godhood.view.components.vo.GodHoodInfo;
import flash.display.Shape;
import flash.text.TextFormat;
import tempest.common.staticdata.Colors;
import tempest.ui.UIStyle;
import tempest.ui.components.TListItemRender;
import tempest.ui.components.textFields.TText;

class ShengLiItemRender extends TListItemRender
{
	//神力阶段名字
	private var tf_name:TText;
	//神力阶段范围
	private var tf_value:TText;
	//神力翅膀类型
	private var tf_kind:TText;
	private var shape:Shape;
	private var _textFormat:TextFormat = UIStyle.defaultTextFormat;

	public function ShengLiItemRender(proxy:*, data:Object)
	{
		var shape:Shape = new Shape();
		shape.graphics.drawRoundRect(0, 0, 200, 16, 1);
		super(shape, data);
	}

	override protected function addChildren():void
	{
		super.addChildren();
		tf_name = createTText(0, 0, 65, 20);
		tf_value = createTText(63, 0, 70, 20);
		tf_kind = createTText(138, 0, 65, 20);
		this.addChild(tf_name);
		this.addChild(tf_value);
//		this.addChild(tf_kind);
	}

	override public function set data(value:Object):void
	{
		super.data = value;
		_changeWatcherManger.bindSetter(setGodPower, value, "id", false);
		if (value)
		{
			tf_name.text = value.levelName;
			tf_value.text = value.range;
//			tf_kind.text = value.wing_name;
//			tf_kind.text = LanguageManager.translate(20001, "暂未开放");
		}
		else
		{
			tf_name.text = "";
			tf_value.text = "";
//			tf_kind.text = "";
		}
	}

	private function setGodPower(value:int):void
	{
		switch (value)
		{
			case 0:
				setTextFormat(0xFFD323);
				break;
			case 1:
			case 2:
			case 3:
			case 4:
			case 5:
			case 6:
				setTextFormat(ItemQuality.getColor(value));
				break;
		}
	}

	private function setTextFormat(value:uint):void
	{
		_textFormat.color = value;
		tf_name.format = _textFormat;
		tf_value.format = _textFormat;
		tf_kind.format = _textFormat;
	}

	private function createTText(x:Number, y:Number, width:Number, height:Number):TText
	{
		var result:TText = new TText();
		result.x = x;
		result.y = y;
		result.width = width;
		result.height = height;
		result.mouseEnabled = false;
		return result;
	}
}
