package  
{
	// Gồm các tính năng, chọn câu hỏi khó, dể, random câu hỏi...
	import fl.core.*;
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
			WinPoint = 100;
			Loader = new URLLoader();
			var Url:URLRequest = new URLRequest("QuestionBank.xml");
			Loader.addEventListener(Event.COMPLETE, processXML, false, 0, true );
			Loader.load(Url);
			QuestionArr = new Array();
			QuestionChoiceArr = new Array();
			
			notify = new Notify();
			notify.name = "Notify";	
			notify.x = 295;
			notify.y = 400;			
			mainMovie.addChild(notify);
			notify.visible = false;
			mainMovie.QandA.visible = false;
			
			notifyEndRoundWin = new NotifyEndRoundWin();
			notifyEndRoundWin.x = 295;
			notifyEndRoundWin.y = 400;
			mainMovie.addChild(notifyEndRoundWin);
			notifyEndRoundWin.visible = false;
			
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
			mainMovie.QandA.answer1.addEventListener(MouseEvent.CLICK, Answer_click, false, 0, true);
			mainMovie.QandA.answer2.addEventListener(MouseEvent.CLICK, Answer_click, false, 0, true);
			mainMovie.QandA.answer3.addEventListener(MouseEvent.CLICK, Answer_click, false, 0, true);
			mainMovie.QandA.answer4.addEventListener(MouseEvent.CLICK, Answer_click, false, 0, true);
			mainMovie.QandA.answer5.addEventListener(MouseEvent.CLICK, Answer_click, false, 0, true);
			addChild(mainMovie);
			notify.easy_btn.addEventListener(MouseEvent.CLICK, easy_btn_click, false, 0, true);
			notify.hard_btn.addEventListener(MouseEvent.CLICK, hard_btn_click, false, 0, true);
			
			mainMovie.next_btn.visible = false;
			mainMovie.next_btn.addEventListener(MouseEvent.CLICK, nextbtn_Click, false, 0, true);
			mainMovie.pointcounter.visible = false;
			mainMovie.scene.visible = false;
			
			
			//timer = new Timer(1000);
			//timer.addEventListener(TimerEvent.TIMER, timer_tick, false, 0, true);
			timerWaitingAnswer = new Timer(2000);
			timerWaitingAnswer.addEventListener(TimerEvent.TIMER, timerWaiting_Tick, false, 0, true);
			mainMovie.intro.visible = false;
			mainMovie.intro.alpha = 0;
			timerIntro = new Timer(200,20);
			timerIntro.addEventListener(TimerEvent.TIMER, timerIntro_Tick, false, 0, true);
			
			wrongAnswerSound = new WrongAnswerSound();
			trueAnswerSound = new TrueAnswerSound();
			TadaSound = new TaDa();
			super.configUI();
		}
		
		private function nextbtn_Click(e:MouseEvent):void 
		{
			mainMovie.QandA.visible = false;
			this.mainMovie.play_btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			
		}
		
		private function refreshbtn_Click(e:MouseEvent):void 
		{
			WinPoint = 100;			
			mainMovie.pointcounter.counter_txt.text = WinPoint;
			ChangeSceneFollowWinPoint(WinPoint);
			mainMovie.pointcounter.visible = false;
			mainMovie.scene.visible = false;
			notifyEndRoundWin.visible = false;
			mainMovie.gotoAndStop(1);			
			mainMovie.start_btn.visible = true;
			mainMovie.start_btn.addEventListener(MouseEvent.CLICK, start_click, false, 0, true);
		}
		
		private function timerIntro_Tick(e:TimerEvent):void 
		{
			mainMovie.intro.alpha += 0.2;
			mainMovie.intro.visible = true;
			
		}
		
		private function timerIntro_Tick_complete(e:TimerEvent):void 
		{
			timerIntro.stop();
			timerIntro.reset();
			mainMovie.intro.alpha = 0;
			mainMovie.intro.visible = false;
			mainMovie.pointcounter.visible = true;
			mainMovie.play_btn.visible = true;
			mainMovie.scene.visible = true;
			mainMovie.refresh_btn.visible = true;
			//mainMovie.start_btn.removeEventListener(MouseEvent.CLICK, start_click);
			
		}
		
		private function timerWaiting_Tick(e:TimerEvent):void 
		{
			timerWaitingAnswer.stop();
			timerWaitingAnswer.reset();
			
			if (IndexChoiceAnser == indexTrueAnswer) 
			{
				
				if (HardChoice) 
				{
					WinPoint -= 50;
				}
				else
				{
					WinPoint -= 25;
				}
				mainMovie.pointcounter.counter_txt.text = WinPoint;
				ChangeSceneFollowWinPoint(WinPoint);
				
			}
			
			VisibleMaskAnswerTrue(indexTrueAnswer);
			
			//mainMovie.QandA.visible = false;
			//mainMovie.play_btn.visible = true;
			mainMovie.next_btn.visible = true;
			if (WinPoint == 0) 
			{				
				notifyEndRoundWin.visible = true;
			}
			
		}
		
		private function Answer_click(e:MouseEvent):void 
		{
			var name:String = e.currentTarget.name;
			name = name.slice( -1, name.length);
			IndexChoiceAnser = int(name);
			VisibleAnsersChoice(IndexChoiceAnser);
			//var notifyChoiceAnswer:NotifyChoiceAnswer = mainMovie.getChildByName("NotifyChoiceAnswer") as NotifyChoiceAnswer;
			//if (notifyChoiceAnswer == null) 
			//{
				//notifyChoiceAnswer = new NotifyChoiceAnswer();
				//notifyChoiceAnswer.name = "NotifyChoiceAnswer";
				//this.alignToMiddleCenter(notifyChoiceAnswer);
				//notifyChoiceAnswer.agreebtn.addEventListener(MouseEvent.CLICK, agree_Click);
				//notifyChoiceAnswer.denybtn.addEventListener(MouseEvent.CLICK, deny_Click);
				//mainMovie.addChild(notifyChoiceAnswer);
			//}
			//notifyChoiceAnswer.visible = true;
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
		
		//private function deny_Click(e:MouseEvent):void 
		//{
			//e.target.parent.visible = false;
		//}
		//
		//private function agree_Click(e:MouseEvent):void 
		//{
			//timer.stop();			
			//timerWaitingAnswer.start();
			//if (IndexChoiceAnser == indexTrueAnswer) 
			//{
				//trueAnswerSound.play();
			//}
			//else {
				//wrongAnswerSound.play();
			//}
			//e.target.parent.visible = false;
		//}
		
		private function ChangeSceneFollowWinPoint(winpoint:int):void
		{
			var human:Human = null;
			var count:int;
			var rand:int;
			var i:int;			
			for (i = 1; i < mainMovie.scene.numChildren; i++) 
			{
				human = mainMovie.scene.getChildAt(i) as Human;
				human.gotoAndStop(1);
			}
			switch(winpoint)
			{				
				case 75:
					count = 25;
					while (count > 0)
					{
						rand = RandomRange(0, mainMovie.scene.numChildren - 1);
						human =  mainMovie.scene.getChildAt(rand) as Human;
						if (human) 
						{
							human.gotoAndStop(2);
							count--;
						}
						
					}
					break;
				case 50:
					count = 50;
					while (count > 0)
					{
						rand = RandomRange(0, mainMovie.scene.numChildren - 1);
						human =  mainMovie.scene.getChildAt(rand) as Human;
						if (human) 
						{
							if (human.currentFrame == 1) 
							{
								human.gotoAndStop(2);
								count--;
							}
						}
						
					}
					break;
				case 25:
					count = 75;
					while (count > 0)
					{
						rand = RandomRange(0, mainMovie.scene.numChildren - 1);
						human =  mainMovie.scene.getChildAt(rand) as Human;
						if (human) 
						{
							if (human.currentFrame == 1) 
							{
								human.gotoAndStop(2);
								count--;
							}
						}
						
					}
					break;
				case 0:
					for ( i = 1; i < mainMovie.scene.numChildren; i++) 
					{
						human = mainMovie.scene.getChildAt(i) as Human;
						human.gotoAndStop(2);
					}
					break;
			}
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
		private function easy_btn_click(e:MouseEvent):void
		{
			HardChoice = false;
			notify.visible = false;
			//ResetTimer();
			//timer.start();
			mainMovie.QandA.visible = true;
			RandomEasy();
		}
		
		private function RandomEasy():void 
		{		
			mainMovie.QandA.answer4.visible = false;
			mainMovie.QandA.answer4.mask_choice_mc.visible = false;
			mainMovie.QandA.answer5.visible = false;
			mainMovie.QandA.answer5.mask_choice_mc.visible = false;
			GetAnswerInQuestion(3);
			
		}
		
		private function GetAnswerInQuestion(numberAns:int):void
		{
			
			var ans:Answer;
			var i:int;
			
			var ArrNum:Array = new Array();
			for (i = 0; i <numberAns ; i++) 
			{
				ArrNum[i] = i + 1;
			}
			
			var AnsDisplayArr:Array = new Array();
			//Lấy ra câu trả lời đúng
			var trueAns:Answer;
			var trueInd:int;
			for (i = 0; i < QuestionChoiced.AnswerArr.length; i++) 
			{
				trueAns = QuestionChoiced.AnswerArr[i];
				trueInd = i;
				if (trueAns.isTrue) 
				{					
					break;
				}
			}
			
			//tạo vị trí ngẫu nhiên cho câu trả lời đúng
			var rand:int;
			rand = RandomRange(0, ArrNum.length - 1);
			SetAnswerToDisplay(ArrNum[rand], trueAns);
			AnsDisplayArr.push(trueInd);
			//trace("TrueAnser:" + rand +";ArrNum[i]:" + ArrNum[rand]);
			//trace(trueAns.text);
			indexTrueAnswer = ArrNum[rand];
			ArrNum.splice(rand, 1);
			while (ArrNum.length > 0)
			{
				rand = RandomRange(0, QuestionChoiced.AnswerArr.length - 1);
				if (CheckNotExit(rand,AnsDisplayArr)) 
				{
					ans = QuestionChoiced.AnswerArr[rand] as Answer;
					SetAnswerToDisplay(ArrNum[0], ans);
					ArrNum.splice(0, 1);	
					AnsDisplayArr.push(rand);
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
					mainMovie.QandA.answer1.info.text ="A. " +ans.text;
					break;
				case 2:
					mainMovie.QandA.answer2.info.text ="B. " +ans.text;
					break;
				case 3:
					mainMovie.QandA.answer3.info.text ="C. " +ans.text;
					break;
				case 4:
					mainMovie.QandA.answer4.info.text ="D. " + ans.text;
					break;
				case 5:
					mainMovie.QandA.answer5.info.text ="E. " + ans.text;
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
		
		private function hard_btn_click(e:MouseEvent):void
		{
			HardChoice = true;
			notify.visible = false;
			mainMovie.QandA.visible = true;
			//mainMovie.QandA.ques_txt.visible = true;
			//ResetTimer();
			//timer.start();
			RandomHard();
		}
		
		private function RandomHard():void 
		{		
			mainMovie.QandA.answer4.visible = true;
			mainMovie.QandA.answer4.mask_choice_mc.visible = false;
			mainMovie.QandA.answer5.visible = true;
			mainMovie.QandA.answer5.mask_choice_mc.visible = false;
			GetAnswerInQuestion(5);
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
					q = new Question(int(xmlList[i].attributes()[0]),xmlList[i].attributes()[1], xmlList[i].*);
					QuestionArr.push(q);
					q = null;
				}			
				
			}		
			
			Loader.removeEventListener(Event.COMPLETE, processXML);
			
		}
		private function ResetTimer():void
		{
			//counter	 = TIME_OUT / 1000;
			//mainMovie.clock.text = counter.toString();
			//timer.reset();
		}
		private function timer_tick(e:TimerEvent):void 
		{
			//counter--;
			//if (counter < 0) 
			//{		
				//wrongAnswerSound.play();
				//counter	 = TIME_OUT / 1000;
				//mainMovie.gotoAndStop(1);
				//mainMovie.start_btn.addEventListener(MouseEvent.CLICK, start_click, false, 0, true);
				//mainMovie.QandA.visible = false;
				//mainMovie.play_btn.visible = true;
				//
				//timer.stop();
				//timer.reset();
				//
				//mainMovie.clock.text = counter.toString();
			//}
			//if (mainMovie.currentFrame == 2) 
			//{
				//mainMovie.clock.text = counter.toString();
			//}
			
		}
		
		private function play_click(e:MouseEvent):void 
		{
			e.target.visible = false;
			//
			mainMovie.next_btn.visible = false;
			VisibleMaskAnswerTrue(0);
			Random();
			if (QuestionChoiced != null ) 
			{
				
				//if (WinPoint == 0) 
				//{
					//WinPoint = 100;
					//mainMovie.pointcounter.counter_txt.text = WinPoint;
					//ChangeSceneFollowWinPoint(WinPoint);
				//}
				//notify.visible = true;
				mainMovie.QandA.ques_txt.info.text = QuestionChoiced.text;
				mainMovie.QandA.answer1.visible = true;	
				mainMovie.QandA.answer1.mask_choice_mc.visible = false;		
				mainMovie.QandA.answer2.visible = true;
				mainMovie.QandA.answer2.mask_choice_mc.visible = false;
				mainMovie.QandA.answer3.visible = true;
				mainMovie.QandA.answer3.mask_choice_mc.visible = false;
				notify.hard_btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				
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
			
			//mainMovie.play_btn.removeEventListener(MouseEvent.CLICK, play_click);
		}
		
		private function closebtn_click(e:MouseEvent):void 
		{
			System.exit(0);
			
		}
		
		private function start_click(e:MouseEvent):void
		{
			//timerIntro.start();
			timerIntro.addEventListener(TimerEvent.TIMER_COMPLETE, timerIntro_Tick_complete, false, 0, true);
			mainMovie.gotoAndStop(2);
			mainMovie.refresh_btn.visible = false;
			mainMovie.refresh_btn.addEventListener(MouseEvent.CLICK, refreshbtn_Click, false, 0, true);
			mainMovie.play_btn.visible = false;
			mainMovie.play_btn.addEventListener(MouseEvent.CLICK, play_click, false, 0, true);
			mainMovie.play_btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			timerIntro.dispatchEvent(new TimerEvent(TimerEvent.TIMER_COMPLETE));
		}
		
		
		
		public final function alignToMiddleCenter(displayObject:DisplayObject):void
		{
			displayObject.x = (this.stage.stageWidth - displayObject.width) * 0.5;
			displayObject.y = (this.stage.stageHeight - displayObject.height) * 0.5;
			displayObject = null;
		}
	}

}