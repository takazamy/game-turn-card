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
		
		public static function getResource(id:int):Class
		{
			switch(id)
			{
				case 1:
					return Kim_mc;
				case 2:
					return Moc_mc;
				case 3:
					return Thuy_mc;
				case 4:
					return Hoa_mc;
				case 5:
					return Tho_mc;
				case 6:
					return BlueSS_mc;
				default:
					return Question_mc;
			}
		}
	}

}