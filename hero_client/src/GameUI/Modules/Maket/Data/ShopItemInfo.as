//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Maket.Data {
    import GameUI.ConstData.*;
    import Net.*;
    import Utils.*;

    public class ShopItemInfo extends ItemTemplateInfo {

        public static const SELLING_FLAG_NO:uint = 0;
        public static const PAYTYPE_REPUTE:uint = 4;
        public static const SELLING_FLAG_HOT:uint = 4;
        public static const PAYTYPE_GIFT:uint = 2;
        public static const PAYTYPE_EXCHANGE:uint = 5;
        public static const PAYTYPE_CASH:uint = 3;
        public static const SELLING_FLAG_TIME:uint = 16;
        public static const SELLING_FLAG_LIMIT:uint = 8;
        public static const SELLING_FLAG_BOUND:uint = 1;
        public static const SELLING_FLAG_NEW:uint = 2;
        public static const PAYTYPE_GOLD:uint = 1;

        public var APriceArr:Array;
        private var PayType:uint;
        public var curr_amount:uint;
        public var ShopId:uint;
        public var SortVal:uint;
        private var _SellFlag:uint;
        private var _IsLimitDayCnt:Boolean;
        public var limitTime:uint;
        private var _IsHot:Boolean;
        public var exchangeNum1:uint;
        public var exchangeNum2:uint;
        public var ShopType:int;
        public var exchangeGood1:uint;
        public var exchangeGood2:uint;
        private var _Bargain:Boolean;
        private var _IsNew:Boolean;
        public var SCount:int;
        public var ClassTypeFlag:uint;
        private var _IsLimitTime:Boolean;

        public function ShopItemInfo(){
            APriceArr = [0, 0, 0];
            super();
        }
        public function get Bargain():Boolean{
            return (_Bargain);
        }
        public function set SellFlag(_arg1:uint):void{
            this._SellFlag = _arg1;
            _IsNew = ((_SellFlag & SELLING_FLAG_NEW) > 0);
            _IsHot = ((_SellFlag & SELLING_FLAG_HOT) > 0);
            _IsLimitDayCnt = ((_SellFlag & SELLING_FLAG_LIMIT) > 0);
            _IsLimitTime = ((_SellFlag & SELLING_FLAG_TIME) > 0);
        }
        public function ReadFromPacket(_arg1:NetPacket):void{
            ShopId = _arg1.readUnsignedInt();
            TemplateID = _arg1.readUnsignedInt();
            ClassFactory.copyProperties(UIConstData.ItemDic[this.TemplateID], this);
            SCount = _arg1.readUnsignedInt();
            ClassTypeFlag = _arg1.readUnsignedInt();
            SortVal = _arg1.readUnsignedInt();
            SellFlag = _arg1.readUnsignedInt();
            PayType = _arg1.readUnsignedInt();
            exchangeGood1 = _arg1.readUnsignedInt();
            exchangeGood2 = _arg1.readUnsignedInt();
            exchangeNum1 = _arg1.readUnsignedInt();
            exchangeNum2 = _arg1.readUnsignedInt();
            curr_amount = _arg1.readUnsignedInt();
            limitTime = _arg1.readUnsignedInt();
            switch (PayType){
                case PAYTYPE_GOLD:
                    APriceArr[0] = exchangeGood1;
                    break;
                case PAYTYPE_GIFT:
                    APriceArr[1] = exchangeGood1;
                    break;
                case PAYTYPE_CASH:
                    APriceArr[2] = exchangeGood1;
                    break;
            };
        }
        public function get SellFlag():uint{
            return (_SellFlag);
        }
        public function get IsHot():Boolean{
            return (_IsHot);
        }
        public function get IsLimitDayCnt():Boolean{
            return (_IsLimitDayCnt);
        }
        public function get IsLimitTime():Boolean{
            return (_IsLimitTime);
        }
        public function set Bargain(_arg1:Boolean):void{
            _Bargain = _arg1;
        }
        public function get IsNew():Boolean{
            return (_IsNew);
        }

    }
}//package GameUI.Modules.Maket.Data 
