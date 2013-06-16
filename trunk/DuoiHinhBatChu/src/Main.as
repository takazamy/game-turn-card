package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Nguyễn Đoàn Phú
	 */
	public class Main extends Sprite 
	{
		private var mainScreen:MainScreen;
		private var startBtn:Start_Btn;
		private var imageDict:Dictionary;
		private var duoiHinhBatChuScreen:DuoiHinhBatChu;
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
			imageDict = new Dictionary();
		}
		
		private function onClick(e:Event):void 
		{
			if (duoiHinhBatChuScreen != null) 
			{
				this.removeChild(duoiHinhBatChuScreen);
			}
			duoiHinhBatChuScreen = new DuoiHinhBatChu();
			duoiHinhBatChuScreen.x = 500 - duoiHinhBatChuScreen.width / 2;
			duoiHinhBatChuScreen.y = 100;	
			this.addChild(duoiHinhBatChuScreen);
			//duoiHinhBatChuScreen.loadResourceMainQuesttion();
			startBtn.visible = false;
			mainScreen.visible = false;
		}
		
	}
	
}