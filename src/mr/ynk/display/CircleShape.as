package mr.ynk.display
{
	import flash.display.Shape;
	
	/**
     * ...
     * @author remco@mrynk.nl
     */
    public class CircleShape extends Shape
    {
        private var _x:Number;
        private var _y:Number;
        private var _radius:Number;
        private var _alpha:Number;
        private var _fillColor:Number;
        private var _lineThickness:Number;
        private var _lineColor:Number;
        private var _lineAlpha:Number;

        //__________________________________________________________________________________________________________________
        //                                                                                                                  |
        //                                                                                        C O N S T R U C T O R     |
        //__________________________________________________________________________________________________________________|
        public function CircleShape( pX:Number = 0, pY:Number = 0, pRadius:Number = 100, pFillColor:uint = 0, pFillAlpha:Number = 1, pLineThickness:Number = 0, pLineColor:uint = 0, pLineAlpha:Number = 1 )
        {
            update ( pX, pY, pRadius, pFillColor, pFillAlpha, pLineThickness, pLineColor, pLineAlpha );

            super();
        }

        //__________________________________________________________________________________________________________________
        //                                                                                                                  |
        //                                                                                                  P U B L I C     |
        //__________________________________________________________________________________________________________________|
        public function update ( pX:Number = 0, pY:Number = 0, pRadius:Number = 100, pFillColor:uint = 0, pFillAlpha:Number = 1, pLineThickness:Number = 0, pLineColor:uint = 0, pLineAlpha:Number = 1 ):void
        {
            graphics.clear();

            if ( pLineThickness > 0 )
                graphics.lineStyle ( _lineThickness = pLineThickness, _lineColor = pLineColor, _lineAlpha = pLineAlpha );

            graphics.beginFill ( _fillColor = pFillColor, _alpha = pFillAlpha );
            graphics.drawCircle ( _x = pX, _y = pY, _radius = pRadius );
        }

        public function updateFill ( pColor:uint, pAlpha:Number = 1 ):void
        {
            update ( _x, _y, _radius, pColor, pAlpha, _lineThickness, _lineColor, _lineAlpha );
        }

        //__________________________________________________________________________________________________________________
        //                                                                                                                  |
        //                                                                                G E T T E R S / S E T T E R S     |
        //__________________________________________________________________________________________________________________|

        public function get radius():Number { return _radius; }
        public function set radius(value:Number):void
        {
            update ( _x, _y, value, _fillColor, _alpha, _lineThickness, _lineColor, _lineAlpha );
        }

        public function get fillColor():Number { return _fillColor; }
        public function set fillColor(value:Number):void
        {
            update ( _x, _y, _radius, value, _alpha, _lineThickness, _lineColor, _lineAlpha );
        }

        public function get lineThickness():Number { return _lineThickness; }
        public function set lineThickness(value:Number):void
        {
            update ( _x, _y, _radius, _fillColor, _alpha, value, _lineColor, _lineAlpha );
        }

        public function get lineColor():Number { return _lineColor; }
        public function set lineColor(value:Number):void
        {
            update ( _x, _y, _radius, _fillColor, _alpha, _lineThickness, value, _lineAlpha );
        }

        public function get lineAlpha():Number { return _lineAlpha; }
        public function set lineAlpha(value:Number):void
        {
            update ( _x, _y, _radius, _fillColor, _alpha, _lineThickness, _lineColor, value );
        }

        //__________________________________________________________________________________________________________________
        //                                                                                                                  |
        //                                                                                  E V E N T   H A N D L E R S     |
        //__________________________________________________________________________________________________________________|

        //__________________________________________________________________________________________________________________
        //                                                                                                                  |
        //                                                                                            P R O T E C T E D     |
        //__________________________________________________________________________________________________________________|

        //__________________________________________________________________________________________________________________
        //                                                                                                                  |
        //                                                                                                P R I V A T E     |
        //__________________________________________________________________________________________________________________|
    }

}