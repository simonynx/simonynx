package fj1.common.data.dataobject.items.toolTipShowers
{
	import assets.UIResourceLib;
	import fj1.common.data.dataobject.items.ItemData;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.staticdata.ItemQuality;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.ByteArray;
	import tempest.common.rsl.TRslManager;
	import tempest.utils.HtmlUtil;
	import tempest.utils.StringUtil;

	public class PetEggToolTipShower extends ItemToolTipShower
	{
		public function PetEggToolTipShower(itemData:ItemData)
		{
			super(itemData);
		}

		override public function getTipWidth():int
		{
			return 200;
		}

		override public function getTipDataArray(params:Object):Array
		{
			var strArray:Array = [];
			var unknownStr:String = LanguageManager.translate(100004, "未知");
			var lineStr:String;
			//名称
			strArray.push(makeAppendParams2("center", ItemQuality.getColorString(_itemData.itemTemplate.quality), setBoldText(_itemData.itemTemplate.name)));
			//分割线
			var line:Sprite = Sprite(TRslManager.getInstance(UIResourceLib.tipLine));
			strArray.push(makeAppendParams(getHtmlTextWithAlign("center", normalWhite, ""), [{src: line, index: 0}]));
			//绑定状态
			if (getBindStr() != "")
				strArray.push(makeAppendParams2("left", normalWhite, getBindStr()));
			else
				strArray.push(makeAppendParams(getBindStr()));
			//等级
//			strArray.push(getRichTextFieldObj("left", normalWhite, spaceStr + LanguageManager.translate(19001, "等级：") + unknownStr));
			//使用等级
			strArray.push(makeAppendParams(getLevelReqString()));
			//品质
			strArray.push(makeAppendParams2("left", normalWhite, spaceStr + LanguageManager.translate(3046, "品质：") + unknownStr));
			//融合次数
//			strArray.push(getRichTextFieldObj("left", normalWhite, spaceStr + LanguageManager.translate(3047, "融合次数：") + unknownStr));
			itemDataLayout(strArray, 7);
			//分割线
			var line1:Sprite = Sprite(TRslManager.getInstance(UIResourceLib.tipLine));
			strArray.push(makeAppendParams(getHtmlTextWithAlign("center", normalWhite, ""), [{src: line1, index: 0}]));
			//描述
			strArray.push(makeAppendParams(getDescription()));
			//出售价格
			strArray.push(makeAppendParams(getSellString(0)));
			if(itemData.validDate)//有效期
			{
				//分割线
				strArray.push(getNewSplictLine());
				var nowDate:Date = new Date();
				//
				strArray.push(makeAppendParams(getValidDateString(nowDate)));
				//
				strArray.push(makeAppendParams(getLastValidTime(nowDate)));
			}
			pushDebugInfo(strArray);
			
			return strArray;
		}

		override protected function rebuildTipString(place:int = 0):String
		{
			var strArray:Array = [];
			strArray.push(getSellString(place));
			return "";
		}
	}
}
