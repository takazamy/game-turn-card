package  
{
	import fl.core.*;
	import flash.display.MovieClip;
	import flash.display.StageDisplayState;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.xml.*;
	import flash.system.System;
	import WrongAnswerSound;
	/**
	 * Project cho game dạng Đấu Trường 100
	 * Chọn câu hỏi dễ(3 đáp án - 25đ) hoặc khó(5 đáp án-50đ)
	 * Random câu hỏi theo danh sách câu hỏi trong QuestionBank.xml
	 * Không trùng lặp câu hỏi
	 * @author Nguyễn Đoàn Phú
	 */
	
	
	
	public class DauTruong100 extends UIComponent	
	{
		public var mainMovie:Game = null;	
		//====Data Reader
		public var XMLReader:XML;
		private var Loader:URLLoader;
		private var XMLsource:String;
		
		//====Logic Variables
		private var notify:Notify;
		private var notifyEndRoundWin:NotifyEndRoundWin;
		private var QuestionChoiceArr:Array;
		private var QuestionArr:Array;
		private var QuestionChoiced:Question;
		private var IndexChoiceAnser:int;
		private var indexTrueAnswer:int;
		private var HardChoice:Boolean;
		private var WinPoint:int;		
		private var isChange:Boolean;
		
		
		//====Sound
		private var wrongAnswerSound:Sound;
		private var trueAnswerSound:Sound;
		private var TadaSound:Sound;
		
		//====Timer
		private var timerIntro:Timer;
		private var timerWaitingAnswer:Timer;
		//private var timer:Timer;
		//public var TIME_OUT:int = 30000;
		//private var counter:int = TIME_OUT / 1000;
		
		public function DauTruong100()
		{
			configUI();
		}
		protected override function draw():void
		{
			super.draw();
		}
		
		protected override function configUI():void 
		{
			
			//stage.displayState = StageDisplayState.FULL_SCREEN;
			mainMovie = new Game();
			mainMovie.start_btn.addEventListener(MouseEvent.CLICK, start_click, false, 0, true);			
			Loader = new URLLoader();
			var Url:URLRequest = new URLRequest("QuestionBank.xml");
			Loader.addEventListener(Event.COMPLETE, processXML, false, 0, true );
			Loader.load(Url);		
			QuestionArr = new Array();
			QuestionChoiceArr = new Array();
			mainMovie.QandA.visible = false;
			
			mainMovie.QandA.answer1.buttonMode = true;
			mainMovie.QandA.answer2.buttonMode = true;
			mainMovie.QandA.answer3.buttonMode = true;
			mainMovie.QandA.answer4.buttonMode = true;
			mainMovie.QandA.answer5.buttonMode = true;
			mainMovie.QandA.answer1.mask_mc.visible = false;
			mainMovie.QandA.answer2.mask_mc.visible = false;
			mainMovie.QandA.answer3.mask_mc.visible = false;
			mainMovie.QandA.answer4.mask_mc.visible = false;
			mainMovie.QandA.answer5.mask_mc.visible = false;
			//mainMovie.QandA.answer1.addEventListener(MouseEvent.CLICK, Answer_click, false, 0, true);
			//mainMovie.QandA.answer2.addEventListener(MouseEvent.CLICK, Answer_click, false, 0, true);
			//mainMovie.QandA.answer3.addEventListener(MouseEvent.CLICK, Answer_click, false, 0, true);
			//mainMovie.QandA.answer4.addEventListener(MouseEvent.CLICK, Answer_click, false, 0, true);
			//mainMovie.QandA.answer5.addEventListener(MouseEvent.CLICK, Answer_click, false, 0, true);
			addChild(mainMovie);
			mainMovie.ketqua_btn.visible = false;
			mainMovie.ketqua_btn.addEventListener(MouseEvent.CLICK, ketqua_btn_Click, false, 0, true);
			mainMovie.next_btn.visible = false;
			mainMovie.next_btn.addEventListener(MouseEvent.CLICK, next_btn_Click, false, 0, true);
			timerWaitingAnswer = new Timer(3000);
			timerWaitingAnswer.addEventListener(TimerEvent.TIMER, timerWaiting_Tick, false, 0, true);
			timerIntro = new Timer(2000);
			timerIntro.addEventListener(TimerEvent.TIMER, timerintro_Tick, false, 0, true);
			wrongAnswerSound = new WrongAnswerSound();
			trueAnswerSound = new TrueAnswerSound();
			TadaSound = new TaDa();
			
			
			super.configUI();
		}
		
		private function next_btn_Click(e:MouseEvent):void 
		{
			mainMovie.QandA.visible = false;
			mainMovie.ketqua_btn.visible = false;
			mainMovie.next_btn.visible = false;
			mainMovie.start_btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		private function ketqua_btn_Click(e:MouseEvent):void 
		{
			TadaSound.play();
			VisibleMaskAnswerTrue(indexTrueAnswer);	
			mainMovie.next_btn.visible = true;
		}
		
		private function timerintro_Tick(e:TimerEvent):void 
		{
			mainMovie.QandA.visible = true;
			mainMovie.refresh_btn.visible = true;
			mainMovie.ketqua_btn.visible = true;
			//mainMovie.next_btn.visible = true;
			timerIntro.stop();
			timerIntro.reset();
		}
		
		
		private function refreshbtn_Click(e:MouseEvent):void 
		{
			mainMovie.refresh_btn.visible = false;
			mainMovie.gotoAndStop(1);
			mainMovie.QandA.visible = false;			
			mainMovie.ketqua_btn.visible = false;
			mainMovie.next_btn.visible = false;
			mainMovie.start_btn.visible = true;
			mainMovie.start_btn.addEventListener(MouseEvent.CLICK, start_click, false, 0, true);
		}
		
		
		private function timerWaiting_Tick(e:TimerEvent):void 
		{
			
			
			timerWaitingAnswer.stop();
			timerWaitingAnswer.reset();
			
			VisibleMaskAnswerTrue(indexTrueAnswer);			
			
			
		}
		
		private function Answer_click(e:MouseEvent):void 
		{
			var name:String = e.currentTarget.name;
			name = name.slice( -1, name.length);
			IndexChoiceAnser = int(name);
			VisibleAnsersChoice(IndexChoiceAnser);
			
			if (IndexChoiceAnser == indexTrueAnswer) 
			{
				TadaSound.play();
				trueAnswerSound.play();
			}
			else
			{
				
				wrongAnswerSound.play();
			}
			timerWaitingAnswer.start();
			
		}		
		
		private function VisibleMaskAnswerTrue(index:int):void
		{
			mainMovie.QandA.answer1.mask_mc.visible = false;
			mainMovie.QandA.answer2.mask_mc.visible = false;
			mainMovie.QandA.answer3.mask_mc.visible = false;
			mainMovie.QandA.answer4.mask_mc.visible = false;
			mainMovie.QandA.answer5.mask_mc.visible = false;
			switch(index)
			{
				case 1:
					mainMovie.QandA.answer1.mask_mc.visible = true;
					break;
				case 2:
					mainMovie.QandA.answer2.mask_mc.visible = true;
					break;
				case 3:
					mainMovie.QandA.answer3.mask_mc.visible = true;
					break;
				case 4:
					mainMovie.QandA.answer4.mask_mc.visible = true;
					break;
				case 5:
					mainMovie.QandA.answer5.mask_mc.visible = true;
					break;
			}
		}
		
		private function VisibleAnsersChoice(index:int):void
		{
			switch(index)
			{
				case 1:					
					mainMovie.QandA.answer1.mask_choice_mc.visible = true;
					mainMovie.QandA.answer2.mask_choice_mc.visible = false;
					mainMovie.QandA.answer3.mask_choice_mc.visible = false;
					mainMovie.QandA.answer4.mask_choice_mc.visible = false;
					mainMovie.QandA.answer5.mask_choice_mc.visible = false;
					break;
				case 2:
					mainMovie.QandA.answer1.mask_choice_mc.visible = false;
					mainMovie.QandA.answer2.mask_choice_mc.visible = true;
					mainMovie.QandA.answer3.mask_choice_mc.visible = false;
					mainMovie.QandA.answer4.mask_choice_mc.visible = false;
					mainMovie.QandA.answer5.mask_choice_mc.visible = false;
					break;
				case 3:
					mainMovie.QandA.answer1.mask_choice_mc.visible = false;
					mainMovie.QandA.answer2.mask_choice_mc.visible = false;
					mainMovie.QandA.answer3.mask_choice_mc.visible = true;
					mainMovie.QandA.answer4.mask_choice_mc.visible = false;
					mainMovie.QandA.answer5.mask_choice_mc.visible = false;
					break;
				case 4:
					mainMovie.QandA.answer1.mask_choice_mc.visible = false;
					mainMovie.QandA.answer2.mask_choice_mc.visible = false;
					mainMovie.QandA.answer3.mask_choice_mc.visible = false;
					mainMovie.QandA.answer4.mask_choice_mc.visible = true;
					mainMovie.QandA.answer5.mask_choice_mc.visible = false;
					break;
				case 5:
					mainMovie.QandA.answer1.mask_choice_mc.visible = false;
					mainMovie.QandA.answer2.mask_choice_mc.visible = false;
					mainMovie.QandA.answer3.mask_choice_mc.visible = false;
					mainMovie.QandA.answer4.mask_choice_mc.visible = false;
					mainMovie.QandA.answer5.mask_choice_mc.visible = true;
					break;
			}
		}
				
		private function GetAnswerInQuestion(numberAns:int):void
		{
			
			var ans:Answer;
			var i:int;
			
			for (var j:int = 0; j <QuestionChoiced.AnswerArr.length ; j++) 
			{
				ans = QuestionChoiced.AnswerArr[j] as Answer;
				SetAnswerToDisplay(j + 1, ans);
				if (ans.isTrue) 
				{
					indexTrueAnswer = j + 1;
				}
			}
			
			
		}
		
		private function CheckNotExit(number:int, Arr:Array):Boolean
		{
			for (var i:int = 0; i <Arr.length ; i++) 
			{
				if (Arr[i] == number) 
				{
					return false;
				}
			}
			return true;
		}
		private function SetAnswerToDisplay(index:int, ans:Answer):void 
		{
			switch(index)
			{
				case 1:
					mainMovie.QandA.answer1.visible = true;
					mainMovie.QandA.answer1.info.text =ans.text;
					break;
				case 2:
					mainMovie.QandA.answer2.visible = true;
					mainMovie.QandA.answer2.info.text =ans.text;
					break;
				case 3:
					mainMovie.QandA.answer3.visible = true;
					mainMovie.QandA.answer3.info.text =ans.text;
					break;
				case 4:
					mainMovie.QandA.answer4.visible = true;
					mainMovie.QandA.answer4.info.text =ans.text;
					break;
				case 5:
					mainMovie.QandA.answer5.visible = true;
					mainMovie.QandA.answer5.info.text =ans.text;
					break;
				
			}
		}
		
		private function Random():void 
		{	
			var i:int = RandomRange(0, QuestionArr.length - 1);
			QuestionChoiced = QuestionArr[i];
			QuestionArr.splice(i, 1);
			
		}
		
		private function RandomRange(min:int, max:int):int
		{
			return (Math.floor(Math.random() * (max - min + 1)) + min);
		}
		
		
		public function processXML(e:Event):void
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
			
			Loader.removeEventListener(Event.COMPLETE, processXML);
			
		}				
		
		
		private function closebtn_click(e:MouseEvent):void 
		{
			System.exit(0);			
		}
		
		private function start_click(e:MouseEvent):void
		{
			mainMovie.start_btn.visible = false;
			mainMovie.gotoAndStop(2);
			mainMovie.bgTween.gotoAndStop(1);
			VisibleMaskAnswerTrue(0);
			Random();
			
			
			if (QuestionChoiced != null ) 
			{	
				
				if (QuestionChoiced.isPhongThuy == 0) 
				{
					
					mainMovie.bgTween.gotoAndPlay(20);
				}
				else if(QuestionChoiced.isPhongThuy == 1) 
				{
				
					mainMovie.bgTween.gotoAndPlay(2);
					
				}
				else
				{
					mainMovie.bgTween.gotoAndPlay(39);
				}
				
				mainMovie.QandA.ques_txt.info.text = QuestionChoiced.text;
				
				mainMovie.QandA.answer1.visible = false;	
				mainMovie.QandA.answer1.qno.text = "A:"
				mainMovie.QandA.answer1.mask_choice_mc.visible = false;		
				mainMovie.QandA.answer2.visible = false;
				mainMovie.QandA.answer2.qno.text = "B:"
				mainMovie.QandA.answer2.mask_choice_mc.visible = false;
				mainMovie.QandA.answer3.visible = false;
				mainMovie.QandA.answer3.qno.text = "C:"
				mainMovie.QandA.answer3.mask_choice_mc.visible = false;
				mainMovie.QandA.answer4.visible = false;
				mainMovie.QandA.answer4.qno.text = "D:"
				mainMovie.QandA.answer4.mask_choice_mc.visible = false;
				mainMovie.QandA.answer5.visible = false;
				mainMovie.QandA.answer5.qno.text = "E:"
				mainMovie.QandA.answer5.mask_choice_mc.visible = false;
				
				GetAnswerInQuestion(QuestionChoiced.AnswerArr.length);
				timerIntro.start();
				
				
			}
			else
			{
				mainMovie.QandA.visible = false;
				var notifyend:NotifyEndGame = mainMovie.getChildByName("notifyEndGame") as NotifyEndGame;
				if (notifyend == null) 
				{
					notifyend = new NotifyEndGame();
					notifyend.name = "notifyEndGame";
					mainMovie.addChild(notifyend);
					this.alignToMiddleCenter(notifyend);
					notifyend.close_btn.addEventListener(MouseEvent.CLICK, closebtn_click, false, 0, true);
				}
				notifyend.visible = true;
				return;
			}	
			//mainMovie.bgTween.gotoAndPlay(2);
			mainMovie.refresh_btn.visible = false;
			mainMovie.refresh_btn.addEventListener(MouseEvent.CLICK, refreshbtn_Click, false, 0, true);			
		}
		
		
		
		public final function alignToMiddleCenter(displayObject:DisplayObject):void
		{
			displayObject.x = (this.stage.stageWidth - displayObject.width) * 0.5;
			displayObject.y = (this.stage.stageHeight - displayObject.height) * 0.5;
			displayObject = null;
		}
	}

}