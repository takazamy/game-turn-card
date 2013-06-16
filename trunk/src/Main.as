package 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
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
		private var questionGame:QuestAndAw;
		
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
			QuestionArr = new Array();
			loadQuestionData()
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
			trucXanhScreen.loadResourceMainQuesttion();
			startBtn.visible = false;
			mainScreen.visible = false;
		}
		
		public function startQuesttionGame():void
		{
			trucXanhScreen.visible = false;
			
			if (questionGame != null) 
			{
				this.removeChild(questionGame);
			}
			questionGame = new QuestAndAw();
			questionGame.x = 106;
			questionGame.y = 340;
			
			questionGame.next_btn.visible = false;
			questionGame.ketQua_btn.visible = true;
			questionGame.ketQua_btn.addEventListener(MouseEvent.CLICK, ketQua_btn_click);
			this.addChild(questionGame);
			
			var question:Question = QuestionArr.shift();
			questionGame.ques_txt.info.text = question.text;
			
			questionGame.answer1.mask_mc.visible = false;
			questionGame.answer2.mask_mc.visible = false;
			questionGame.answer3.mask_mc.visible = false;
			questionGame.answer4.mask_mc.visible = false;
			questionGame.answer5.mask_mc.visible = false;
			questionGame.answer1.visible = false;	
			questionGame.answer1.qno.text = "A:"
			questionGame.answer1.mask_choice_mc.visible = false;		
			questionGame.answer2.visible = false;
			questionGame.answer2.qno.text = "B:"
			questionGame.answer2.mask_choice_mc.visible = false;
			questionGame.answer3.visible = false;
			questionGame.answer3.qno.text = "C:"
			questionGame.answer3.mask_choice_mc.visible = false;
			questionGame.answer4.visible = false;
			questionGame.answer4.qno.text = "D:"
			questionGame.answer4.mask_choice_mc.visible = false;
			questionGame.answer5.visible = false;
			questionGame.answer5.qno.text = "E:"
			questionGame.answer5.mask_choice_mc.visible = false;
			questionGame.question = question;
			GetAnswerInQuestion(question.AnswerArr.length, question);
		}
		
		private function ketQua_btn_click(e:MouseEvent):void 
		{
			var question:Question = questionGame.question as Question;
			for (var i:int = 0; i < question.AnswerArr.length; i++) 
			{
				var aws:Answer = question.AnswerArr[i] as Answer;
				if (aws) 
				{
					if (aws.isTrue) 
					{						
						VisibleMaskAnswerTrue(i + 1);
						break;
					}
				}
			}
			questionGame.ketQua_btn.removeEventListener(MouseEvent.CLICK, ketQua_btn_click);
			questionGame.next_btn.addEventListener(MouseEvent.CLICK, next_btn_click);
			questionGame.next_btn.visible = true;
		}
		
		private function next_btn_click(e:MouseEvent):void 
		{
			this.questionGame.visible = false;
			//if (this.trucXanhScreen.numAnswerComplete < 16) 
			{				
				this.trucXanhScreen.visible = true;
			}
			//else
			{
				//ShowDoanChu();
			}
		}
		
		private var Loader:URLLoader;		
		private var XMLsource:String;
		private var XMLReader:XML;
		private var QuestionArr:Array;
		
		private function loadQuestionData():void
		{
			Loader = new URLLoader();
			QuestionArr = new Array();
			var Url:URLRequest = new URLRequest("QuestionBank.xml");
			Loader.addEventListener(Event.COMPLETE, processXML, false, 0, true );
			Loader.load(Url);
		}
		
		
		private function processXML(e:Event):void 
		{
			XMLsource = e.target.data;
			XMLReader = new XML(XMLsource);			
			
			// Tạo mảng các câu hỏi (có dang sách câu trả lời)
			if (XMLReader) 
			{
				var xmlList:XMLList = XMLReader.children();	
				var q:Question  = null;
				for (var i:int = 0; i < xmlList.length(); i++) 
				{					
					q = new Question(int(xmlList[i].attributes()[0]),xmlList[i].attributes()[1], xmlList[i].*, xmlList[i].attributes()[2]);
					QuestionArr.push(q);
					q = null;
				}			
				
			}
			
			var tempArray:Array = QuestionArr.splice(0);
			var random:int = 0;
			while (tempArray.length > 0)
			{
				random = Math.floor(Math.random() * tempArray.length);
				QuestionArr.push(tempArray[random]);
				tempArray.splice(random, 1);
			}
			
			Loader.removeEventListener(Event.COMPLETE, processXML);
		}
		
		private function GetAnswerInQuestion(numberAns:int, question:Question):void
		{
			
			var ans:Answer;
			var i:int;
			
			for (var j:int = 0; j <question.AnswerArr.length ; j++) 
			{
				ans = question.AnswerArr[j] as Answer;
				SetAnswerToDisplay(j + 1, ans);
				if (ans.isTrue) 
				{
					//indexTrueAnswer = j + 1;
				}
			}			
		}
		
		private function SetAnswerToDisplay(index:int, ans:Answer):void 
		{
			switch(index)
			{
				case 1:
					questionGame.answer1.visible = true;
					questionGame.answer1.info.text =ans.text;
					break;
				case 2:
					questionGame.answer2.visible = true;
					questionGame.answer2.info.text =ans.text;
					break;
				case 3:
					questionGame.answer3.visible = true;
					questionGame.answer3.info.text =ans.text;
					break;
				case 4:
					questionGame.answer4.visible = true;
					questionGame.answer4.info.text =ans.text;
					break;
				case 5:
					questionGame.answer5.visible = true;
					questionGame.answer5.info.text =ans.text;
					break;
				
			}
		}
		
		private function VisibleMaskAnswerTrue(index:int):void
		{
			questionGame.answer1.mask_mc.visible = false;
			questionGame.answer2.mask_mc.visible = false;
			questionGame.answer3.mask_mc.visible = false;
			questionGame.answer4.mask_mc.visible = false;
			questionGame.answer5.mask_mc.visible = false;
			switch(index)
			{
				case 1:
					questionGame.answer1.mask_mc.visible = true;
					break;
				case 2:
					questionGame.answer2.mask_mc.visible = true;
					break;
				case 3:
					questionGame.answer3.mask_mc.visible = true;
					break;
				case 4:
					questionGame.answer4.mask_mc.visible = true;
					break;
				case 5:
					questionGame.answer5.mask_mc.visible = true;
					break;
			}
		}
		
		private var nhapChu:NhapChu_mc;
		
		public function ShowDoanChu():void
		{
			trucXanhScreen.visible = false;
			if (nhapChu != null) 
			{
				this.removeChild(nhapChu);
			}
			nhapChu = new NhapChu_mc(trucXanhScreen.mainAnswer);
			this.addChild(nhapChu);			
		}
		
		private var notificationEndgame:NotifyEndGame;
		
		public function EndGame():void
		{
			notificationEndgame = new NotifyEndGame();
			this.addChild(notificationEndgame);
			notificationEndgame.x = 500 - notificationEndgame.width / 2;
			notificationEndgame.y = 350;
			
			var retry:RetryGame_btn = new RetryGame_btn();
			retry.width = 40;
			retry.height = 40;
			retry.buttonMode = true;
			retry.x = 500 - retry.width / 2
			retry.y = 540;
			this.addChild(retry);
			retry.addEventListener(MouseEvent.CLICK, onRetry);
		}
		
		private function onRetry(e:MouseEvent):void 
		{
			while (numChildren > 0 )
			{
				this.removeChildAt(0);
			}
			mainScreen = null;
			trucXanhScreen = null;
			startBtn = null;
			questionGame = null;
			Loader = null;
			nhapChu = null;
			notificationEndgame = null;
			init();
		}
		
		public function ContinueGame():void
		{			
			//if (trucXanhScreen.numAnswerComplete < 16) 
			//{				
				trucXanhScreen.visible = true;
				nhapChu.visible = false;				
				nhapChu.ketquabtn.visible = true;
			//}
			//else 
		}
	}
	
}