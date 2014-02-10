package mr.ynk.display.bitmap
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
	
	/**
     * ...
     * @author remco@mrynk.nl
     */
    public class Scale9Bitmap extends Bitmap
    {
        static private const ZERO_POINT:Point = new Point();

        private var _originalBitmapData :BitmapData;
        private var _width              :Number;
        private var _height             :Number;

        private var _parts              :Scale9Parts;

        //__________________________________________________________________________________________________________________
        //                                                                                                                  |
        //                                                                                        C O N S T R U C T O R     |
        //__________________________________________________________________________________________________________________|
        public function Scale9Bitmap(bitmapData:BitmapData = null, pixelSnapping:String = "auto", smoothing:Boolean = false)
        {
            super(bitmapData, pixelSnapping, smoothing);
            init();
        }

        //__________________________________________________________________________________________________________________
        //                                                                                                                  |
        //                                                                                                  P U B L I C     |
        //__________________________________________________________________________________________________________________|
        override public function get bitmapData():BitmapData { return super.bitmapData; }
        override public function set bitmapData(value:BitmapData):void
        {
            _originalBitmapData = value;
            redraw();
        }

        override public function get width():Number { return super.width; }
        override public function set width(value:Number):void
        {
            _width = value;
            redraw();
        }

        override public function get height():Number { return super.height; }
        override public function set height(value:Number):void
        {
            _height = value;
            redraw();
        }

        override public function get scaleX():Number { return _width / _originalBitmapData.width; }
        override public function set scaleX(value:Number):void
        {
            _width = _originalBitmapData.width * value;
            redraw();
        }

        override public function get scaleY():Number { return _height / _originalBitmapData.height; }
        override public function set scaleY(value:Number):void
        {
            _height = _originalBitmapData.height * value;
            redraw();
        }

        override public function get scale9Grid():Rectangle { return super.scale9Grid; }
        override public function set scale9Grid(value:Rectangle):void
        {
            super.scale9Grid = value;
            if ( value )
                createParts();
            else
                bake();

            redraw();
        }

        /**
         * Calling this function will clear the current scale9grid and dispose of any information that is used on using scale9 data.
         * Use this function when you need to scale the bitmap for a limited time, and can then finalize the transformations
         */
        public function bake():void
        {
            _originalBitmapData.dispose();
            if ( _parts ) _parts.clear();
            super.scale9Grid = null;
        }

        /**
         * An easy way to modify width and height at once. This causes the bitmap to redraw only once instead of twice.
         */
        public function get size():Point { return new Point ( _width, _height ) }
        public function set size ( pPoint:Point ):void
        {
            _width = pPoint.x;
            _height = pPoint.y;
            redraw();
        }

        /**
         * destroys all related bitmapdatas for this instance
         */
        public function destroy():void
        {
            _originalBitmapData.dispose();
            bitmapData.dispose();

            if ( _parts ) _parts.clear();
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
        private function redraw():void
        {
            if ( super.scale9Grid )
            {
                updateScale9();
            }
            else
            {
                super.width = _width;
                super.height = _height;
            }
        }

        private function createParts():void
        {
            const rect:Rectangle = new Rectangle ( 0, 0, super.scale9Grid.left, super.scale9Grid.top );

            if ( _parts ) _parts.clear();
            _parts = new Scale9Parts();

            //NOTE: The four corners are not stored. They are copied from the original bitmap to save memory.

            /*_parts.tl = new BitmapData ( rect.width, rect.height, _originalBitmapData.transparent, 0x00000000 );
            _parts.tl.copyPixels ( _originalBitmapData, rect, ZERO_POINT );*/

            rect.x = super.scale9Grid.left;
            rect.width = super.scale9Grid.width;
            _parts.t = new BitmapData ( rect.width, rect.height, _originalBitmapData.transparent, 0x00000000 );
            _parts.t.copyPixels ( _originalBitmapData, rect, ZERO_POINT );

            /*rect.x = super.scale9Grid.right;
            rect.width = _width - super.scale9Grid.right;
            _parts.tr = new BitmapData ( rect.width, rect.height, _originalBitmapData.transparent, 0x00000000 );
            _parts.tr.copyPixels ( _originalBitmapData, rect, ZERO_POINT );*/

            rect.x = 0;
            rect.y = super.scale9Grid.top;
            rect.width = super.scale9Grid.left;
            rect.height = super.scale9Grid.height;
            _parts.l = new BitmapData ( rect.width, rect.height, _originalBitmapData.transparent, 0x00000000 );
            _parts.l.copyPixels ( _originalBitmapData, rect, ZERO_POINT );

            rect.x = super.scale9Grid.left;
            rect.width = super.scale9Grid.width;
            _parts.c = new BitmapData ( rect.width, rect.height, _originalBitmapData.transparent, 0x00000000 );
            _parts.c.copyPixels ( _originalBitmapData, rect, ZERO_POINT );

            rect.x = super.scale9Grid.right;
            rect.width = _width - super.scale9Grid.right;
            _parts.r = new BitmapData ( rect.width, rect.height, _originalBitmapData.transparent, 0x00000000 );
            _parts.r.copyPixels ( _originalBitmapData, rect, ZERO_POINT );

            /*rect.x = 0;
            rect.y = super.scale9Grid.bottom;
            rect.width = super.scale9Grid.left;
            rect.height = _height - super.scale9Grid.height;
            _parts.bl = new BitmapData ( rect.width, rect.height, _originalBitmapData.transparent, 0x00000000 );
            _parts.bl.copyPixels ( _originalBitmapData, rect, ZERO_POINT );*/

            rect.y = super.scale9Grid.bottom;
            rect.x = super.scale9Grid.left;
            rect.width = super.scale9Grid.width;
            rect.height = _height - super.scale9Grid.height;
            _parts.b = new BitmapData ( rect.width, rect.height, _originalBitmapData.transparent, 0x00000000 );
            _parts.b.copyPixels ( _originalBitmapData, rect, ZERO_POINT );

            /*rect.x = super.scale9Grid.right;
            rect.width = _width - super.scale9Grid.right;
            _parts.br = new BitmapData ( rect.width, rect.height, _originalBitmapData.transparent, 0x00000000 );
            _parts.br.copyPixels ( _originalBitmapData, rect, ZERO_POINT );*/
        }

        private function updateScale9():void
        {
            const newBmpd:BitmapData = new BitmapData ( _width, _height, _originalBitmapData.transparent, 0x00000000 );
            const pnt:Point = ZERO_POINT.clone();
            const mtx:Matrix = new Matrix();

            //init the rectangle to match the top left corner. It is later modified for the other parts
            const rect:Rectangle = new Rectangle ( 0, 0, super.scale9Grid.left, super.scale9Grid.top );

            //the scale9grid translated in size onto the new bitmap
            const translatedInnerRect:Rectangle = new Rectangle ( super.scale9Grid.left, super.scale9Grid.top, _width - ( _originalBitmapData.width - super.scale9Grid.width ), _height - ( _originalBitmapData.height - super.scale9Grid.height ) );

            //copy top left
            newBmpd.copyPixels ( _originalBitmapData, rect, ZERO_POINT );

            //copy top right
            rect.x = super.scale9Grid.right;
            rect.width = _width - translatedInnerRect.right;
            rect.height = translatedInnerRect.top;
            pnt.x = translatedInnerRect.right;
            newBmpd.copyPixels ( _originalBitmapData, rect, pnt );

            //draw top
            //mtx.identity();
            mtx.scale ( translatedInnerRect.width / super.scale9Grid.width, 1 );
            mtx.translate ( super.scale9Grid.left, 0 );
            newBmpd.draw ( _parts.t, mtx, null, null, null, smoothing );

            //draw left
            mtx.identity();
            mtx.scale ( 1, translatedInnerRect.height / super.scale9Grid.height );
            mtx.translate ( 0, super.scale9Grid.top );
            newBmpd.draw ( _parts.l, mtx, null, null, null, smoothing );

            //draw center
            mtx.identity();
            mtx.scale ( translatedInnerRect.width / super.scale9Grid.width, translatedInnerRect.height / super.scale9Grid.height );
            mtx.translate ( super.scale9Grid.left, super.scale9Grid.top );
            newBmpd.draw ( _parts.c, mtx, null, null, null, smoothing );

            //draw right
            mtx.identity();
            mtx.scale ( 1, translatedInnerRect.height / super.scale9Grid.height );
            mtx.translate ( translatedInnerRect.right, super.scale9Grid.top );
            newBmpd.draw ( _parts.r, mtx, null, null, null, smoothing );

            //copy bottom left
            pnt.x = 0;
            pnt.y = translatedInnerRect.bottom;
            rect.x = 0;
            rect.y = super.scale9Grid.bottom;
            rect.width = translatedInnerRect.left;
            rect.height = _height - translatedInnerRect.bottom;
            newBmpd.copyPixels ( _originalBitmapData, rect, pnt );

            //draw bottom
            mtx.identity();
            mtx.scale ( translatedInnerRect.width / super.scale9Grid.width, 1 );
            mtx.translate ( translatedInnerRect.left, translatedInnerRect.bottom );
            newBmpd.draw ( _parts.b, mtx, null, null, null, smoothing );

            //copy bottom left
            pnt.x = translatedInnerRect.right;
            pnt.y = translatedInnerRect.bottom;
            rect.topLeft = super.scale9Grid.bottomRight;
            rect.width = _width - translatedInnerRect.right;
            rect.height = translatedInnerRect.bottom;
            newBmpd.copyPixels ( _originalBitmapData, rect, pnt );

            if ( super.bitmapData ) super.bitmapData.dispose();
            super.bitmapData = newBmpd;
        }

        private function init():void
        {
            _originalBitmapData = bitmapData.clone();
            if ( _originalBitmapData )
            {
                _width = _originalBitmapData.width;
                _height = _originalBitmapData.height;
            }
        }
    }

}
import flash.display.BitmapData;

class Scale9Parts
{
    private var _tl :BitmapData;
    private var _t  :BitmapData;
    private var _tr :BitmapData;
    private var _l  :BitmapData;
    private var _c  :BitmapData;
    private var _r  :BitmapData;
    private var _bl :BitmapData;
    private var _b  :BitmapData;
    private var _br :BitmapData;

    function Scale9Parts() { }

    internal function clear():void
    {
        if ( _tl ) _tl.dispose();
        if ( _t  ) _t .dispose();
        if ( _tr ) _tr.dispose();
        if ( _l  ) _l .dispose();
        if ( _c  ) _c .dispose();
        if ( _r  ) _r .dispose();
        if ( _bl ) _bl.dispose();
        if ( _b  ) _b .dispose();
        if ( _br ) _br.dispose();

        _tl =
        _t  =
        _tr =
        _l  =
        _c  =
        _r  =
        _bl =
        _b  =
        _br = null;
    }

    internal function get tl():BitmapData { return _tl; }
    internal function set tl(value:BitmapData):void
    {
        _tl = value;
    }

    internal function get t():BitmapData { return _t; }
    internal function set t(value:BitmapData):void
    {
        _t = value;
    }

    internal function get tr():BitmapData { return _tr; }
    internal function set tr(value:BitmapData):void
    {
        _tr = value;
    }

    internal function get l():BitmapData { return _l; }
    internal function set l(value:BitmapData):void
    {
        _l = value;
    }

    internal function get c():BitmapData { return _c; }
    internal function set c(value:BitmapData):void
    {
        _c = value;
    }

    internal function get r():BitmapData { return _r; }
    internal function set r(value:BitmapData):void
    {
        _r = value;
    }

    internal function get bl():BitmapData { return _bl; }
    internal function set bl(value:BitmapData):void
    {
        _bl = value;
    }

    internal function get b():BitmapData { return _b; }
    internal function set b(value:BitmapData):void
    {
        _b = value;
    }

    internal function get br():BitmapData { return _br; }
    internal function set br(value:BitmapData):void
    {
        _br = value;
    }

}