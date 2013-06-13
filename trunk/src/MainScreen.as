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
			bg.height = 600;
			bg.width = 800;			
			this.addChild(bg);
		}
		
	}

}