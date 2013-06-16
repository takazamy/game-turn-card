package  
{
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.sampler.NewObjectSample;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Nguyễn Đoàn Phú
	 */
	public class DuoiHinhBatChu extends MovieClip
	{
		public var ketquabtn:Ket_Qua_btn;
		public var nextBtn:Next_btn;
		public var goiYBtn:Goi_y_btn;
		private var container:MovieClip;
		
		private var bg:BG1;
		private var answer:String = "";
		private var goiY:String = "";
		private var realAnswer:String = "";
		
		public function DuoiHinhBatChu():void
		{
			bg = new BG1();
			this.addChild(bg);
			//bg.textNhap.visible = false;
			//bg.textGoiY.visible = false;
			
			ketquabtn = new Ket_Qua_btn()
			ketquabtn.x = 870//500 - ketquabtn.width/2;
			ketquabtn.y = 470;
			ketquabtn.addEventListener(MouseEvent.CLICK, ketquabtnCLick)
			
			nextBtn = new Next_btn();
			nextBtn.x = 870;
			nextBtn.y = 470;
			nextBtn.addEventListener(MouseEvent.CLICK, nextBtnCLick);
			this.addChild(ketquabtn);			
			this.addChild(nextBtn);	
			
			goiYBtn = new Goi_y_btn();
			goiYBtn.x = 870;
			goiYBtn.y = 553;
			goiYBtn.addEventListener(MouseEvent.CLICK, goiYBtnCLick);
			this.addChild(goiYBtn);
			
			container = new MovieClip();
			this.addChild(container);
		}
		
		private function goiYBtnCLick(e:MouseEvent):void 
		{
			bg.textGoiY.txt.text = goiY;
		}
		
		private function nextBtnCLick(e:MouseEvent):void 
		{
			var main:Main = this.parent as Main;
			main.LoaderNextQuesttion();
			
		}
		
		private var trueAnswer:NotifyWin;
		private function ketquabtnCLick(e:MouseEvent):void 
		{
			if (bg.textNhap.txt.text == answer)
			{
				if (trueAnswer == null) 
				{
					trueAnswer = new NotifyWin();
					this.addChild(trueAnswer);
					trueAnswer.x = 500 - trueAnswer.width / 2;
					trueAnswer.y = 250;
				}
				trueAnswer.result_txt.text =  realAnswer;
				trueAnswer.visible = true;
				TweenLite.to(trueAnswer, 2, { visible:false } );
				
				ketquabtn.visible = false;
				nextBtn.visible = true;
			}
			else
			{
				ShowError();
			}
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
				return;
			}
			this.answer = obj._answer;
			this.goiY = obj._goiY;
			this.realAnswer = obj._realAnswer;
			this.nextBtn.visible = false;
			while (container.numChildren > 0)
			{
				container.removeChildAt(0);
			}
			
			var source:MovieClip = new obj._class as MovieClip;
			source.width = 300;
			source.height = 300;
			container.addChild(source);
			
			container.x = 500 - container.width / 2;
			container.y = 100
		}
		
		private var error:NotifyRetry;
		private function ShowError():void
		{
			if (error == null) 
			{				
				error = new NotifyRetry();
				this.addChild(error);
				error.x = 500 - error.width / 2;
				error.y = 300;				
				this.addChild(error);
			}
			error.alpha = 1;
			TweenLite.to(error, 2, { alpha:0, visible:false} );
		}
	}

}