package fj1.common.ui.styleSheet
{
	import fj1.common.staticdata.ColorConst;
	import fj1.common.staticdata.ItemQuality;

	import flash.text.StyleSheet;

	import tempest.common.staticdata.Colors;

	public class DefaultStyleSheet extends StyleSheet
	{
		public function DefaultStyleSheet()
		{
			super();
			this.setStyle(".id", {size: "12", leading: "3", marginLeft: "50px", color: "#00FF00"});
			this.setStyle(".guid", {size: "12", leading: "3", marginLeft: "50px", color: "#FFFFFF"});
			this.setStyle(".name", {size: "12", leading: "8", color: "#FFFFFF"});
			this.setStyle(".nameYellow", {size: "12", leading: "8", color: "#FF9900"});
			this.setStyle(".name_quality0", {size: "12", leading: "8", color: ItemQuality.getColorString(ItemQuality.QUALITY_0)});
			this.setStyle(".name_quality1", {size: "12", leading: "8", color: ItemQuality.getColorString(ItemQuality.QUALITY_1)});
			this.setStyle(".name_quality2", {size: "12", leading: "8", color: ItemQuality.getColorString(ItemQuality.QUALITY_2)});
			this.setStyle(".name_quality3", {size: "12", leading: "8", color: ItemQuality.getColorString(ItemQuality.QUALITY_3)});
			this.setStyle(".name_quality4", {size: "12", leading: "8", color: ItemQuality.getColorString(ItemQuality.QUALITY_4)});
			this.setStyle(".name_quality5", {size: "12", leading: "8", color: ItemQuality.getColorString(ItemQuality.QUALITY_5)});
			this.setStyle(".normalRed", {size: "12", leading: "2", color: "#FF0000"});
			this.setStyle(".normalGreen", {size: "12", leading: "2", color: "#00FF00"});
			this.setStyle(".normalWhite", {size: "12", leading: "2", color: "#FFFFFF"});
			this.setStyle(".normalBlue", {size: "12", leading: "2", color: "#0099FF"});
			this.setStyle(".normalYellow", {size: "12", leading: "2", color: "#FF9900"});
			this.setStyle(".normalLightYellow", {size: "12", leading: "2", color: "#FFD323"});
			this.setStyle(".centerGreen", {size: "12", textAlign: "center", leading: "2", color: "#00FF00"});
			this.setStyle(".normalRed", {size: "12", leading: "2", color: "#FF0000"});
			this.setStyle(".green", {size: "12", leading: "2", color: "#00FF00"});
			this.setStyle(".white", {size: "12", leading: "2", color: "#FFFFFF"});
			this.setStyle(".blue", {size: "12", leading: "2", color: "#0099FF"});
			this.setStyle(".yellow", {size: "12", leading: "2", color: "#FF9900"});
			this.setStyle(".red", {size: "12", leading: "2", color: "#FF0000"});
			this.setStyle(".orange", {size: "12", leading: "2", color: "#FFA500"});
			this.setStyle(".purple", {size: "12", leading: "2", color: "#800080"});
		}
	}
}
