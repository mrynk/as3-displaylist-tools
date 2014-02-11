package mr.ynk.display
{
    import flash.display.Shape;

    /**
     * @author remco@mrynk.nl
     */
    public class RectangleShape extends Shape
	{

        //__________________________________________________________________________________________________________________
        //                                                                                                                  |
        //                                                                                        C O N S T R U C T O R     |
        //__________________________________________________________________________________________________________________|

        public function RectangleShape( x:Number = 0, y:Number = 0, width:Number = 100, height:Number = 100, fillColor:uint = 0, fillAlpha:Number = 1, lineThickness:Number = 0, lineColor:uint = 0, lineAlpha:Number = 1 )
		{
            if ( lineThickness > 0 )
                graphics.lineStyle ( lineThickness, lineColor, lineAlpha );

            graphics.beginFill ( fillColor, fillAlpha );
            graphics.drawRect ( x, y, width, height );
        }

        //__________________________________________________________________________________________________________________
        //                                                                                                                  |
        //                                                                                                  P U B L I C     |
        //__________________________________________________________________________________________________________________|

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