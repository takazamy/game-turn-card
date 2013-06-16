package  
{
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	/**
	 * ...
	 * @author Pham Tu Thanh
	 */
	public class NhapChu_mc extends Sprite
	{
		private var textNhap:TextField;
		private var ans:String;
		public var ketquabtn:Ket_Qua_btn;
		public function NhapChu_mc(ans:String) 
		{
			this.ans = ans;
			
			textNhap = new TextField();
			textNhap.border = true;
			textNhap.width = 980;
			textNhap.height = 300;
			textNhap.x = 10;
			textNhap.y = 10;
			textNhap.type = "input";
			//textNhap.borde = 0xffffff;
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.size = 100;
			textNhap.setTextFormat(textFormat);
			textNhap.defaultTextFormat = textFormat;
			textNhap.wordWrap = true;
			
			this.addChild(textNhap);
			
			ketquabtn = new Ket_Qua_btn()
			ketquabtn.x = 500 - ketquabtn.width/2;
			ketquabtn.y = 530;
			ketquabtn.addEventListener(MouseEvent.CLICK, ketquabtnCLick)
			this.addChild(ketquabtn);
		}
		
		private function ketquabtnCLick(e:MouseEvent):void 
		{
			var main:Main = this.parent as Main;
			if (ans == (textNhap.text.toLowerCase())) 
			{				
				main.EndGame();
				ketquabtn.visible = false;
			}
			else
			{
				ketquabtn.visible = false;
				textNhap.text = "";
				setTimeout(main.ContinueGame,1000);
				ShowError();
			}
		}
		
		private var error:NotifyRetry;
		private function ShowError():void
		{
			if (error == null) 
			{				
				error = new NotifyRetry();
				this.addChild(error);
				error.x = 500 - error.width / 2;
				error.y = 350;				
				this.addChild(error);
			}
			error.alpha = 1;
			TweenLite.to(error, 1, { alpha:0, visible:false} );
		}
	}

}