package  
{
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.sampler.NewObjectSample;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	/**
	 * ...
	 * @author Nguyễn Đoàn Phú
	 */
	public class DuoiHinhBatChu extends MovieClip
	{
		public var ketquabtn:Ket_Qua_btn;
		public var nextBtn:Next_btn;
		public var goiYBtn:Goi_y_btn;
		public var traLoi:Tra_loi;
		
		private var container:MovieClip;
		
		private var bg:BG1;
		private var answer:String = "";
		private var goiY:String = "";
		private var realAnswer:String = "";
		private var textNhap:textNhap_mc;
		private var textGoiY:textGioiY_mc;
		private var musicOnOff:MusicOnOff;
		private var soundOnOff:SoundOnOff;
		private var soundChanel:SoundChannel;
		
		public function DuoiHinhBatChu():void
		{
			bg = new BG1();
			bg.alpha = 1;
			this.addChild(bg);
			//bg.textNhap.visible = false;
			//bg.textGoiY.visible = false;
			textNhap = new textNhap_mc();
			textNhap.x = 500 - 200;
			textNhap.y = 440;
			this.addChild(textNhap);
			
			textGoiY = new textGioiY_mc();
			textGoiY.x = 223;
			textGoiY.y = 250;
			this.addChild(textGoiY);
			
			ketquabtn = new Ket_Qua_btn()
			ketquabtn.x = 880//870//500 - ketquabtn.width/2;
			ketquabtn.y = 405;
			ketquabtn.addEventListener(MouseEvent.CLICK, ketquabtnCLick)
			
			traLoi = new Tra_loi();
			traLoi.x = 730//870//500 - ketquabtn.width/2;
			traLoi.y = 405;
			traLoi.addEventListener(MouseEvent.CLICK, traloibtnCLick)
			this.addChild(traLoi);
			
			nextBtn = new Next_btn();
			nextBtn.x = 730//870;
			nextBtn.y = 405;
			nextBtn.addEventListener(MouseEvent.CLICK, nextBtnCLick);
			this.addChild(ketquabtn);			
			this.addChild(nextBtn);	
			
			goiYBtn = new Goi_y_btn();
			goiYBtn.x = 730//870;
			goiYBtn.y = 530;
			goiYBtn.addEventListener(MouseEvent.CLICK, goiYBtnCLick);
			this.addChild(goiYBtn);
			
			musicOnOff = new MusicOnOff();
			this.addChild(musicOnOff);
			musicOnOff.gotoAndStop(2);
			musicOnOff.x = 960;			
			musicOnOff.y = 103;			
			musicOnOff.buttonMode = true;
			musicOnOff.addEventListener(MouseEvent.CLICK, onTurnMusic);
			
			soundOnOff = new SoundOnOff();
			this.addChild(soundOnOff);
			soundOnOff.gotoAndStop(1);
			soundOnOff.x = 964;			
			soundOnOff.y = 136;			
			soundOnOff.buttonMode = true;
			soundOnOff.addEventListener(MouseEvent.CLICK, onTurnSound);
			
			container = new MovieClip();
			this.addChild(container);
			
			soundChanel = new SoundChannel();			
		}
		
		private function onTurnSound(e:MouseEvent):void 
		{
			if (soundOnOff.currentFrame == 1) 
			{
				soundOnOff.gotoAndStop(2);
			}
			else
			{
				soundOnOff.gotoAndStop(1);
			}
		}
		
		private function onTurnMusic(e:MouseEvent):void 
		{			
			var main:Main = this.parent as Main;
			if (musicOnOff.currentFrame == 1) 
			{
				musicOnOff.gotoAndStop(2);
				main.OffSound();
			}
			else
			{
				musicOnOff.gotoAndStop(1);
				main.OnSound();
			}
		}
		
		private function traloibtnCLick(e:MouseEvent):void 
		{
			if (textNhap.txt.text == answer)
			{
				if (trueAnswer == null) 
				{
					trueAnswer = new NotifyWin();
					this.addChild(trueAnswer);
					trueAnswer.x = 500 - trueAnswer.width / 2;
					trueAnswer.y = 450;
				}
				trueAnswer.gotoAndStop(1);
				trueAnswer.result_txt.text =  realAnswer;
				trueAnswer.visible = true;
				//TweenLite.to(trueAnswer, 2, { visible:false } );
				
				ketquabtn.visible = false;
				traLoi.visible = false;
				nextBtn.visible = true;
				
				if (soundOnOff.currentFrame == 1) 
				{
					var sound1:Sound = new TrueAnswerSound();
					soundChanel = sound1.play();;
				}
			}
			else
			{
				if (soundOnOff.currentFrame == 1) 
				{					
					var sound2:Sound = new WrongAnswerSound();
					soundChanel = sound2.play();
				}		
				textNhap.txt.text = "";
				ShowError();
			}
		}
		
		private function goiYBtnCLick(e:MouseEvent):void 
		{
			textGoiY.txt.text = goiY;
		}
		
		private function nextBtnCLick(e:MouseEvent):void 
		{
			var main:Main = this.parent as Main;
			main.LoaderNextQuesttion();
			trueAnswer.visible = false;
		}
		
		private var trueAnswer:NotifyWin;
		private function ketquabtnCLick(e:MouseEvent):void 
		{
			if (trueAnswer == null) 
			{
				trueAnswer = new NotifyWin();
				this.addChild(trueAnswer);
				trueAnswer.x = 500 - trueAnswer.width / 2;
				trueAnswer.y = 450;
			}
			trueAnswer.gotoAndStop(2);
			trueAnswer.result_txt.text =  realAnswer;
			trueAnswer.visible = true;
			//TweenLite.to(trueAnswer, 2, { visible:false } );
			traLoi.visible = false;
			ketquabtn.visible = false;
			nextBtn.visible = true;
		}
		private var endGame:NotifyEndGame;
		public function LoadQuestion(obj:ResourceClass):void
		{			
			if (obj == null) 
			{
				if (endGame == null) 
				{
					endGame = new NotifyEndGame();
					this.addChild(endGame);
					endGame.x = 500 - endGame.width / 2;
					endGame.y = 250;
				}
				endGame.visible = true;
				TweenLite.to(endGame, 2, { visible:false } );
				var main:Main = this.parent as Main;
				main.EndGame();
				return;
			}
			
			this.answer = obj._answer;
			this.goiY = obj._goiY;
			textNhap.txt.text = "";
			textGoiY.txt.text = "";
			
			this.realAnswer = obj._realAnswer;
			this.nextBtn.visible = false;
			this.ketquabtn.visible = true;
			this.traLoi.visible = true;
			
			while (container.numChildren > 0)
			{
				container.removeChildAt(0);
			}
			container.addChild(new bgHinh());
			var source:MovieClip = new obj._class as MovieClip;
			source.width = 577;
			source.height = 325;
			source.x = 5;
			source.y = 4.5;
			//trace("con.width:"+container.width);
			//container.width = source.width;
			//container.height = source.height;
			container.addChild(source);
			//trace("con.width:"+container.width);
			container.x = 500 - container.width / 2;
			container.y = 100;
			//container.addChildAt(new border(), 0);
			
		}
		
		private var error:NotifyRetry;
		private function ShowError():void
		{
			if (error == null) 
			{				
				error = new NotifyRetry();
				this.addChild(error);
				error.x = 500 - error.width / 2;
				error.y = 450;				
				this.addChild(error);
			}
			error.alpha = 1;
			error.visible = true;
			TweenLite.to(error, 2, { alpha:0} );
			setTimeout(HideError,2000);
		}
		
		private function HideError():void
		{
			error.visible = false;
		}
	}

}