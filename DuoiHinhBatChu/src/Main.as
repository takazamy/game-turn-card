package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
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
		private var soundChanel:SoundChannel;
		private var sound:Sound = new BackgoundSong2();
		private var mysoundTransform:SoundTransform;
		
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
			loadResource();			
			
			// Âm Thanh		
			soundChanel = new SoundChannel();			
			soundChanel.addEventListener(Event.SOUND_COMPLETE, onSoundComplelte);	
			mysoundTransform = new SoundTransform();			
			mysoundTransform.volume = 0.15;				
		}
		
		private function onSoundComplelte(e:Event):void 
		{
			// loop sound						
			soundChanel = sound.play();					
			soundChanel.soundTransform = mysoundTransform;
		}
		
		private function onClick(e:Event):void 
		{
			if (duoiHinhBatChuScreen == null) 
			{
				//this.removeChild(duoiHinhBatChuScreen);
				duoiHinhBatChuScreen = new DuoiHinhBatChu();
				//duoiHinhBatChuScreen.x = 500 - duoiHinhBatChuScreen.width / 2;
				//duoiHinhBatChuScreen.y = 100;	
				this.addChild(duoiHinhBatChuScreen);
				LoaderNextQuesttion();
				//duoiHinhBatChuScreen.loadResourceMainQuesttion();		
				
				soundChanel = sound.play();
				soundChanel.soundTransform = mysoundTransform;
				EndGame()
			}
			
			startBtn.visible = false;
			mainScreen.visible = false;
		}
		
		
		private var resourceClass:Vector.<ResourceClass>;
		private function loadResource():void
		{
			resourceClass = new Vector.<ResourceClass>;
			
			resourceClass.push(new ResourceClass(img1,"Mùi Hương","mui huong","Có thể cảm nhận bằng 1 trong 5 giác quan."));
			resourceClass.push(new ResourceClass(img2,"Thuốc Lá","thuoc la","Không nên hút."));
			resourceClass.push(new ResourceClass(img3,"Ngã Ngũ","nga ngu","Mọi chuyện đã kết thúc"));
			resourceClass.push(new ResourceClass(img4,"Obama","obama"," Tổng thống"));
			resourceClass.push(new ResourceClass(img5,"Trình Độ","trinh do"," Dùng để nói đến khả năng của ai đó."));
			resourceClass.push(new ResourceClass(img6,"Thông Cảm","thong cam"," Hiểu nhau."));
			resourceClass.push(new ResourceClass(img7,"Phong Nha","phong nha"," Nam thiên đệ nhất động."));
			resourceClass.push(new ResourceClass(img8,"Hoa Màu","hoa mau"," Nông dân trồng cây lương thực và “…”"));
			resourceClass.push(new ResourceClass(img9,"La Bàn","la ban"," Dùng để xác định phương hướng."));
			resourceClass.push(new ResourceClass(img10,"Tủ Lạnh","tu lanh"," Cất trữ thực phẩm"));
			resourceClass.push(new ResourceClass(img11,"Bán Đứng","ban dung"," Hành động phản bội, đồng đội, tổ chức."));
			resourceClass.push(new ResourceClass(img12,"Báo Cáo","bao cao"," Mỗi cuối năm đều phải làm cái này"));
			resourceClass.push(new ResourceClass(img13,"Tượng Đài","tuong dai"," Xây lên để tưởng niệm, ghi nhớ."));
			resourceClass.push(new ResourceClass(img14,"Tàn Nhẫn","tan nhan"," Độc ác."));
			resourceClass.push(new ResourceClass(img15,"Ba Hoa","ba hoa"," Nói nhiều, Bốc phét"));
			resourceClass.push(new ResourceClass(img16,"Nhạc Nhẹ","nhac nhe"," Nghe du dương."));
			resourceClass.push(new ResourceClass(img17,"Lồng Đèn","long den"," Trung Thu hay có cái này."));
			resourceClass.push(new ResourceClass(img18,"Đầu Tư","dau tu"," …Địa ốc, … Chứng khoán, … ngoại tệ,…"));
			resourceClass.push(new ResourceClass(img19,"Đào Hoa","dao hoa"," Được nhiều người yêu mến."));
			resourceClass.push(new ResourceClass(img20,"Cam Tâm","cam tam"," Chấp nhận, nhẫn nhịn, không than thở."));
			
			var tempArray:Vector.<ResourceClass> = resourceClass.splice(0,20);
			var random:int = 0;
			while (tempArray.length > 0)
			{
				random = Math.floor(Math.random() * tempArray.length);
				resourceClass.push(tempArray[random]);
				tempArray.splice(random, 1);
			}
		}
		
		public final function LoaderNextQuesttion():void
		{
			duoiHinhBatChuScreen.LoadQuestion(resourceClass.shift());
		}
		
		public final function EndGame():void
		{
			var retry:RetryGame_btn = new RetryGame_btn();
			retry.width = 40;
			retry.height = 40;
			retry.buttonMode = true;
			retry.x = 30
			retry.y = 620;
			this.addChild(retry);
			retry.addEventListener(MouseEvent.CLICK, onRetry);
		}
		
		private function onRetry(e:MouseEvent):void 
		{
			while (numChildren > 0 )
				this.removeChildAt(0);
			mainScreen = null;
			duoiHinhBatChuScreen = null;
			resourceClass = null;
			startBtn = null;
			init();
		}
		
		public function OnSound():void
		{
			soundChanel = sound.play();
			soundChanel.soundTransform = mysoundTransform;
		}
		
		public function OffSound():void
		{
			soundChanel.stop();
		}
	}
	
}