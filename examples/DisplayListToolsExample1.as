package
{
	import flash.display.Sprite;
	import mr.ynk.display.DisplayListTools;
	/**
	 * ...
	 * @author remco@mrynk.nl
	 */
	public class DisplayListToolsExample1 
	{
		private var _mySprite:Sprite;
		
		public function DisplayListToolsExample1() 
		{
			init();
		}
		
		private function init():void 
		{
			DisplayListTools.addChildren( this, 
				_mySprite = new Sprite();
			)
		}
		
	}

}