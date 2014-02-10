package mr.ynk.display
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import mr.ynk.display.definitions.Align;
    import mr.ynk.display.definitions.FitType;

    public class DisplayListTools
    {
        /**
         * Removes all children from the specified container
         * @param	d - the DisplayObjectContainer that you want to clear
         * @return  int - the number of children removed.
         */
        static public function removeAllChildren ( d:DisplayObjectContainer ):int
        {
            if ( !d ) return 0;

            var num:int = 0;
            while ( d.numChildren > 0 )
            {
                num++;
                d.removeChildAt ( 0 );
            }

            return num;
        }

        /**
         * removes the specified displayobject from the displaylist
         * @param	d - the displayobject that must be removed
         * @return Boolean - the displayobject that was removed, or null if it was not on the displaylist
         */
        static public function removeFromDisplayList ( d:DisplayObject ):DisplayObject
        {
            if ( !d ) return null;

            if ( d.parent )
                return d.parent.removeChild ( d );

            return null;
        }

        /**
         * adds children to d's displaylist
         * @param	d - the displayobjectcontainer that children are added to
         * @param	children - one or more DisplayObjects or arrays containing DisplayObjects
         * @return Array - all the children that were added. Note: this is a 1-dimensional array!
         */
        static public function addChildren ( d:DisplayObjectContainer, ...children:* ):Array
        {
            var rtn:Array = [];

            if ( !d || children.length == 0 ) return [];
            for each ( var c:* in children )
            {
                if ( c is Array )
                {
                    for each ( var child:* in c )
                        rtn = rtn.concat ( addChildren ( d, child ) );
                }
                else if ( c is DisplayObject )
                {
                    rtn.push ( d.addChild ( c ) );
                }
            }

            return rtn;
        }

        /**
         * removes children from the displaylist
         * @param	children - the children that you want to remove from the displaylist, these must be displayobjects or arrays containing displayobjects
         * @return void
         */
        static public function removeChildren ( ...children:* ):void
        {
            if ( children.length == 0 ) return;
            for each ( var c:* in children )
            {
                if ( c is Array )
                {
                    for each ( var child:DisplayObject in c ) removeFromDisplayList ( child );
                }
                else if ( c is DisplayObject )
                {
                    removeFromDisplayList ( c );
                }
            }
        }
		
        /**
         * creates a new Sprite containing children
         * @param	...children - Any number of displayobjects or arrays containing displayobjects
         * @return
         */
        static public function createContainerSprite ( ...children:* ):Sprite
        {
            var rtn:Sprite = new Sprite();
            addChildren ( rtn, children.concat() );
            return rtn;
        }

        /**
         * creates a new MovieClip containing children
         * @param	...children
         * @return MovieClip
         */
        static public function createContainerMovieClip ( ...children:* ):MovieClip
        {
            var rtn:MovieClip = new MovieClip();
            addChildren ( rtn, children.concat() );
            return rtn;
        }
		
		/**
		 * stops the timeline on all MovieClips that are a child or subchild of dc.
		 * @param	dc
		 */
		static public function stopAllMovieClipChildren ( dc:DisplayObjectContainer ):void
		{
            getChildrenByType ( dc, MovieClip ).forEach ( function ( e:MovieClip, ...uselessStuff:* ):void { e.stop() } )
		}
		
		/**
		 * plays the timeline on all MovieClips that are a child or subchild of dc
		 * @param	dc
		 */
		static public function playAllMovieClipChildren ( dc:DisplayObjectContainer ):void
		{
            getChildrenByType ( dc, MovieClip ).forEach ( function ( e:MovieClip, ...uselessStuff:* ):void { e.play() } )
		}

        /**
         * Proportionally scales a DisplayObject to fit as tight as possible into a Rectangle.
         * Keeps in consideration the DisplayObjects inner rectangle and positions it correctly no matter what.
         * @param	d           - the DisplayObject that you want to fit in a Rectangle
         * @param	rect        - Rectangle, the rectangle that the DisplayObject must fit into
         * @param   pFitType    - How to scale ( touch rectangle from the outside or from the inside)
         * @param   pAlign      - How to align the scaled displayobject in the rectangle
         *
         * @return for your convenience, the transformed DisplayObject
         *
         * @see mr.ynk.lib.util.display.definitions .FitType
         * @see mr.ynk.lib.util.display.definitions.Align
         */
        static public function fitInRectangle ( d:DisplayObject, rect:Rectangle, pFitType:String = "inner", pAlign:String = "topLeft" ):DisplayObject
        {
            const dRect:Rectangle = d.getRect ( d );
            var scale:Number = 1;

            switch ( pFitType )
            {
                case FitType.INNER:
                    scale = Math.min ( rect.width / ( dRect.width * d.scaleX ), rect.height / ( dRect.height * d.scaleY ) );
                break;

                case FitType.OUTER:
                    scale = Math.max ( rect.width / ( dRect.width * d.scaleX ), rect.height / ( dRect.height * d.scaleY ) );
                break;
            }
            d.scaleX *= scale;
            d.scaleY *= scale;

            return alignInRectangle( d, rect, pAlign );
        }

        /**
         * Aligns a displayobject inside a given rectangle, using the Align property
         *
         * @param	d           - the DisplayObject that you want to align in a Rectangle
         * @param	rect        - the Rectangle to fit the displayobject into
         * @param	pAlign      - the type of align to perform
         *
         * @return for your convenience, the positioned DisplayObject
         *
         * @see mr.ynk.lib.util.display.definitions.Align
         */
        static public function alignInRectangle( d:DisplayObject, rect:Rectangle, pAlign:String ):DisplayObject
        {
            const dRect:Rectangle = d.getRect ( d );

            switch( pAlign )
            {
                case Align.TOP_LEFT:
                    d.x = rect.left - dRect.left;
                    d.y = rect.top - dRect.top;
                break;

                case Align.TOP:
                    d.x = rect.left - dRect.left + ( rect.width - dRect.width ) / 2;
                    d.y = rect.top - dRect.top;
                break;

                case Align.TOP_RIGHT:
                    d.x = rect.right - dRect.right;
                    d.y = rect.top - dRect.top;
                break;


                case Align.LEFT:
                    d.x = rect.left - dRect.left;
                    d.y = rect.top - dRect.top + ( rect.height - d.height ) / 2;
                break;

                case Align.CENTER:
                    d.x = rect.left - dRect.left + ( rect.width - d.width ) / 2;
                    d.y = rect.top - dRect.top + ( rect.height - d.height ) / 2;
                break;

                case Align.RIGHT:
                    d.x = rect.right - dRect.right;
                    d.y = rect.top - dRect.top + ( rect.height - dRect.height ) / 2;
                break;


                case Align.BOTTOM_LEFT:
                    d.x = rect.left - dRect.left;
                    d.y = rect.bottom - dRect.bottom;
                break;

                case Align.BOTTOM:
                    d.x = rect.left - dRect.left + ( rect.width - dRect.width ) / 2;
                    d.y = rect.bottom - dRect.bottom;
                break;

                case Align.BOTTOM_RIGHT:
                    d.x = rect.right - dRect.right;
                    d.y = rect.bottom - dRect.bottom;
                break;

                default:
                    // do nothing.
                break;
            }

            return d;
        }

        /**
         * gets all the nested children in d that have a specific name
         * @param	d - the displayobjectcontainer to start checking in
         * @param	childName - the name of the displayobject(s) that you want to find
         * @param	pMaxDepth - the maximum nested depth to check. A number smaller than 0 will return all nested children, using 0 will return only the immediate children, using 1 will return the children's children as well, etc.
         * @return Array of DisplayObjects
         */
        static public function getChildrenByNameReg ( d:DisplayObjectContainer, pReg:RegExp, pMaxDepth:int = -1 ):/*DisplayObject*/Array
        {
            if ( !d ) return [];

            var rtn:Array = [];

            var num:uint = d.numChildren;
            var child:DisplayObject;

            while ( num > 0 )
            {
                child = d.getChildAt ( num - 1 );

                if ( child )
                {
                    if ( child.name.match ( pReg ) )
                        rtn.push ( child );

                    if ( child is DisplayObjectContainer && pMaxDepth != 0 )
                        rtn = rtn.concat ( getChildrenByNameReg ( ( child as DisplayObjectContainer ), pReg, pMaxDepth - 1 ) );
                }

                num--;
            }

            return rtn;
        }

        /**
         * gets all the nested children in d that have a specific name
         * @param	d - the displayobjectcontainer to start checking in
         * @param	childName - the name of the displayobject(s) that you want to find
         * @param	pMaxDepth - the maximum nested depth to check. A number smaller than 0 will return all nested children, using 0 will return only the immediate children, using 1 will return the children's children as well, etc.
         * @return Array of DisplayObjects
         */
        static public function getChildrenByName ( d:DisplayObjectContainer, childName:String, pMaxDepth:int = -1 ):/*DisplayObject*/Array
        {
            if ( !d ) return [];

            var rtn:Array = [];

            var num:uint = d.numChildren;
            var child:DisplayObject;

            while ( num > 0 )
            {
                child = d.getChildAt ( num - 1 );

                if ( child )
                {
                    if ( child.name == childName )
                        rtn.push ( child );

                    if ( child is DisplayObjectContainer && pMaxDepth != 0 )
                        rtn = rtn.concat ( getChildrenByName ( ( child as DisplayObjectContainer ), childName, pMaxDepth - 1 ) );
                }

                num--;
            }

            return rtn;
        }

        /**
         * gets all the nested children in d that have a specific Class
         * @param	d - the displayobjectcontainer to start checking in
         * @param	type - the type of the DisplayObject that you are looking for. I.e. MovieClip, or your own custom class.
         * @param	pMaxDepth - the maximum nested depth to check. A number smaller than 0 will return all nested children, using 0 will return only the immediate children, using 1 will return the children's children as well, etc.
         * @return Array of DisplayObjects
         */
        static public function getChildrenByType ( d:DisplayObjectContainer, type:Class, pMaxDepth:int = -1 ):/*DisplayObject*/Array
        {
            if ( !d ) return [];

            var rtn:Array = [];

            var num:uint = d.numChildren;
            var child:DisplayObject;

            while ( num > 0 )
            {
                child = d.getChildAt ( num - 1 );

                if ( child )
                {
                    if ( child is type )
                        rtn.push ( child );

                    if ( child is DisplayObjectContainer && pMaxDepth != 0 )
                        rtn = rtn.concat ( getChildrenByType ( ( child as DisplayObjectContainer ), type, pMaxDepth - 1 ) );
                }

                num--;
            }

            return rtn;
        }
    }
}