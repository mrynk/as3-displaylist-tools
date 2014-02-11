as3-displaylist-tools
=====================
Introduction
-----------------------------
(This document is still a work-in-progress)

As I've been using these classes throughout my as3 projects over the past 4 years, I finally realized that other people might find them useful also. A bit late of course, as as3 development isn't as widely used anymore as it used to. Nevertheless, here they are :)
The mr.ynk package hosted in this repo is a part of our internal as3 library here at Mr. Ynk. It consists of many small libraries and tools. For now, I've included a very small subset of it here in this github repo. It's not a framework or whatsoever, just a simple, but handy set of classes to enhance your as3 workflow (hopefully)

Likely the most important class in this package is mr.ynk.display.DisplayListTools. It is an easy to use, standalone class that helps you with some management of Flash' displaylist. As an example: I hated the fact that the flash player would throw an error when I try to remove a DisplayObject from the displaylist that isn't actually on the displaylist (anymore). Mainly this frustration got me to writing this class.

Usage
--------
Some simple functions first. 
```
DisplayListTools.addChildren 
``` 
Will add DisplayObjects to a DisplayObjectContainer. It accepts both a single DisplayObject, as well as (nested) Arrays of DisplayObjects.

(Something I often do, is assigning my objects to a variable within this function).
```ActionScript
DisplayListTools.addChildren( this, 
	_mySprite = new Sprite();
);
```
and:
```ActionScript
var aLotOfDisplayObjects:Array = [];
for ( var i:int = 0; i < 50; i++ )
{
    aLotOfDisplayObjects.push( new Sprite() );
}

DisplayListTools.addChildren( this, 
	aLotOfDisplayObjects
);
//we added 50 sprites to the displaylist at once
//obviously, this specific example is kind of weird, 
//as in this case you might just as well add the DisplayObjects within the for loop.
```
And a more extreme example:
(the function accepts multiple arguments)
```ActionScript
DisplayListTools.addChildren( this,
    [ new Sprite(), new Sprite() ],
    new Sprite(),
    [ [ new Sprite(), new Sprite() ], new Sprite(), [ new Sprite() ] ]
);
```

And when it comes to removing DisplayObjects, without having to worry about errors:
```Actionscript
DisplayListTools.removeFromDisplayList( myDisplayObject );
//removes myDisplayObject from the displaylist, where ever it is.

DisplayListTools.removeAllChildren( this );
//removes all displayobjects within "this"
```

DisplayListTools.getChildren* comes in three different variants. It helps you to select specific children within a container. It will find all (nested) children of the specified type. It will always return an Array of the children that were found.
```ActionScript
var myDisplayObjects:Array = DisplayListTools.getChildrenByName( this, 'some_name' );
//will return all (nested) DisplayObjects within "this" that have the name: 'some_name';

//using a regex:
var myDisplayObjects:Array = DisplayListTools.getChildrenByNameReg( this, /$obj_/i );
//will return all (nested) DisplayObjects within "this" whose names start with: 'obj_';

//using a type/class:
var myDisplayObjects:Array = DisplayListTools.getChildrenByType( this, MySpecialObject );
//will return all (nested) DisplayObjects within "this" that are an instance of MySpecialObject
```
There is more. I'll be updating soon!
