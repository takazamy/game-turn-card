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
				
				//soundChanel = sound.play();
				//soundChanel.soundTransform = mysoundTransform;				
			}
			
			startBtn.visible = false;
			mainScreen.visible = false;
		}
		
		
		private var resourceClass:Vector.<ResourceClass>;
		private function loadResource():void
		{
			resourceClass = new Vector.<ResourceClass>;
			
			resourceClass.push(new ResourceClass(img1,"Mùi Hương","mui huong","Có thể cảm nhận được điều này bằng một trong 5 giác quan."));
			resourceClass.push(new ResourceClass(img2,"Thuốc Lá","thuoc la","Đây là cái mọi người không nên hút"));
			resourceClass.push(new ResourceClass(img3,"Ngã Ngũ","nga ngu","Từ dùng để diễn đạt: “khi mọi chuyện đã kết thúc”"));
			resourceClass.push(new ResourceClass(img4,"Obama","obama","Tên một tổng thống Mỹ"));
			resourceClass.push(new ResourceClass(img5,"Trình Độ","trinh do","Từ dùng để nói đến khả năng của ai đó, từ đầu tiên gần giống với tên người mẫu"));
			resourceClass.push(new ResourceClass(img6,"Thông Cảm","thong cam","Gần nghĩa với “hiểu nhau”"));
			resourceClass.push(new ResourceClass(img7,"Phong Nha","phong nha","Nam thiên đệ nhất động."));
			resourceClass.push(new ResourceClass(img8,"Hoa Màu","hoa mau","một trong loại cây nông dân hay trồng, khác với cây “lương thực”"));
			resourceClass.push(new ResourceClass(img9,"La Bàn","la ban","Vật dụng dùng để xác định phương hướng"));
			resourceClass.push(new ResourceClass(img10,"Tủ Lạnh","tu lanh","Vật dụng để cất trữ thực phẩm"));
			resourceClass.push(new ResourceClass(img11,"Bán Đứng","ban dung","Đây là hành động phản bội đồng đội, tổ chức"));
			resourceClass.push(new ResourceClass(img12,"Báo Cáo","bao cao"," Mỗi cuối năm đều phải làm cái này"));
			resourceClass.push(new ResourceClass(img13,"Tượng Đài","tuong dai","Xây lên để tưởng niệm, ghi nhớ."));
			resourceClass.push(new ResourceClass(img14,"Tàn Nhẫn","tan nhan","Gần nghĩa với “độc ác”"));
			resourceClass.push(new ResourceClass(img15,"Ba Hoa","ba hoa","Gần nghĩa với nói nhiều, bốc phét"));
			resourceClass.push(new ResourceClass(img16,"Nhạc Nhẹ","nhac nhe"," Nghe du dương."));
			resourceClass.push(new ResourceClass(img17,"Lồng Đèn","long den","Trẻ em thường chơi vào dịp Trung Thu"));
			resourceClass.push(new ResourceClass(img18,"Đầu Tư","dau tu","là một hành động hay đi liền với các từ “địa ốc”, “chứng khoán”, “ngoại tệ”…"));
			resourceClass.push(new ResourceClass(img19,"Đào Hoa","dao hoa","Được nhiều người yêu mến."));
			//resourceClass.push(new ResourceClass(img20, "Cam Tâm", "cam tam", " Chấp nhận, nhẫn nhịn, không than thở."));
			resourceClass.push(new ResourceClass(img21,"Xa Hoa", "xa hoa", "Gần nghĩa với “phung phí”, không biết tiết kiệm"));
			resourceClass.push(new ResourceClass(img22, "Đám Hỏi", "dam hoi", "Trước đám cưới hay tổ chức đám này"));
			resourceClass.push(new ResourceClass(img23, "Hành Lạc", "hanh lac", "Thực hiện việc mình thích thú, sung sướng"));
			resourceClass.push(new ResourceClass(img24, "Đầu Hàng", "dau hang", "Chỉ sự từ bỏ, chấp nhận thất bại"));
			resourceClass.push(new ResourceClass(img25, "Phân Công", "phan cong", "Từ có nghĩa là giao nhiệm vụ, giao việc cho một ai đó"));			
			resourceClass.push(new ResourceClass(img26, "Chân Không", "chan khong", "Đây là từ chỉ tình trạng không có không khí"));
			resourceClass.push(new ResourceClass(img27, "Trái Tim Bên Lề", "trai tim ben le", "Đây là tên một ca khúc mà ca sĩ Bằng Kiều thể hiện rất thành công"));
			resourceClass.push(new ResourceClass(img28, "Câu Giờ", "cau gio", "Đây là hành động cầu thủ đá banh rất hay làm ở cuối trận"));
			
			var defaultClass:Vector.<ResourceClass> = new Vector.<ResourceClass>;
			defaultClass.push(new ResourceClass(imgdf1,"Zacs Phong Thủy","zacs phong thuy","Đây là một trong những sản phẩm của công ty NS Bluescope"));
			defaultClass.push(new ResourceClass(imgdf2,"Zacs Lạnh","zacs lanh","Đây là một trong những sản phẩm của công ty NS Bluescope"));
			defaultClass.push(new ResourceClass(imgdf3, "Zacs Màu", "zacs mau", "Đây là một trong những sản phẩm của công ty NS Bluescope"));
			
			var tempArray:Vector.<ResourceClass> = resourceClass.splice(0,resourceClass.length);
			var random:int = 0;
			while (tempArray.length > 0)
			{
				random = Math.floor(Math.random() * tempArray.length);
				resourceClass.push(tempArray[random]);
				tempArray.splice(random, 1);
			}
			
			resourceClass.push(resourceClass[2]);
			resourceClass.push(resourceClass[4]);
			resourceClass.push(resourceClass[6]);
			
			resourceClass[2] = defaultClass[0];
			resourceClass[4] = defaultClass[1];
			resourceClass[6] = defaultClass[2];
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
			retry.x = 940
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