package  
{
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Pham Tu Thanh
	 */
	public class MainScreen extends Sprite 
	{
		private var bg:BGimg;
		public function MainScreen() 
		{
			bg = new BGimg();
			bg.height = 670;
			bg.width = 1000;			
			this.addChild(bg);
		}
		
	}

}