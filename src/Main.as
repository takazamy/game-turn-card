package 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	//import flash.filters.GlowFilter;
	
	/**
	 * ...
	 * @author Nguyễn Đoàn Phú
	 */
	public class Main extends Sprite 
	{
		private var mainScreen:MainScreen;
		private var startBtn:Start_Btn;
		private var trucXanhScreen:TrucXanh_mc;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			mainScreen = new MainScreen();			
			startBtn = new Start_Btn();			
			this.addChild(mainScreen);
			startBtn.x = 500 - startBtn.width / 2;
			startBtn.y = 500;
			this.addChild(startBtn);
			startBtn.addEventListener(MouseEvent.CLICK, onClick);			
		}
		
		private function onClick(e:MouseEvent):void 
		{
			if (trucXanhScreen != null) 
			{
				this.removeChild(trucXanhScreen);
			}
			trucXanhScreen = new TrucXanh_mc();
			trucXanhScreen.x = 500 - trucXanhScreen.width / 2;
			trucXanhScreen.y = 100;	
			this.addChild(trucXanhScreen);
			
			startBtn.visible = false;
			mainScreen.visible = false;
		}
		
	}
	
}