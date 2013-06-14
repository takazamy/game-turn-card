package  
{
	import com.greensock.TweenLite;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author Pham Tu Thanh
	 */
	public class TrucXanhItem extends Sprite 
	{		
		public var id:int = 0;
		public var isOpened:Boolean;
		public var isChecking:Boolean;
		public var _pic:MovieClip;
		public var _cover:Sprite
		
		public function TrucXanhItem(resource:Class,_id:int) 
		{
			_pic = new resource as MovieClip;
			_cover = new Sprite();
			
			if (id <= 6)
			{
				_pic.width = 100;
				_pic.height = 100;
			}
			this.addChild(_pic);
			this.mouseChildren = false;
			this.buttonMode = true;
			id = _id;
			
			_cover.graphics.lineStyle(6,0xff9900)
			_cover.graphics.beginFill(0xff0000);
			_cover.graphics.drawRoundRect(0, 0, 100, 100,10,10);
			_cover.graphics.endFill();
			this.addChild(_cover);
			this.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(e:MouseEvent):void 
		{
			if (!isOpened) 
			{			
				isOpened = true;
				OpenCard();
			}
		}
		
		public function CoverCard():void
		{
			isOpened = false;
			setTimeout(coverCard, 1000);
		}
		
		private function coverCard():void
		{
			TweenLite.to(this, 0.5, { scaleX:0,x: this.x + 50,onComplete:completeCover } );
		}
		
		public function OpenCard():void
		{
			TweenLite.to(this, 0.5, { scaleX:0, x: this.x + 50,onComplete:completeOpen } );
		}
		
		private function completeCover():void
		{			
			this.setChildIndex(_cover, this.numChildren - 1);
			_cover.visible = true;
			TweenLite.to(this, 0.5, { scaleX:1,x: this.x - 50} );
		}
		
		private function completeOpen():void
		{			
			this.setChildIndex(_pic, this.numChildren - 1);
			_cover.visible = false;
			TweenLite.to(this, 0.5, { scaleX:1,x: this.x - 50,onComplete:dispatchOK} );
		}
		
		private function dispatchOK():void
		{
			dispatchEvent(new Event("Select", true));
		}
		
		public function disapear():void
		{
			setTimeout(disapear2,1000);
		}
		
		private function disapear2():void
		{
			TweenLite.to(this, 0.5, { alpha:0 } );
		}
	}

}