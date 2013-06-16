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
		public var _cover:Sprite;
		public var _container:Sprite;
		public var _bg:Sprite;
		public function TrucXanhItem(resource:Class,_id:int) 
		{
			_container = new Sprite();
			_pic = new resource as MovieClip;
			_cover = new Sprite();
			
			_pic.width = 100;
			_pic.height = 100;
			_pic.x = 5;
			_pic.y = 5;
			_container.addChild(_pic);
			this.mouseChildren = false;
			this.buttonMode = true;
			id = _id;
			
			//_cover.graphics.lineStyle(5,0xff9900)
			_bg = new Sprite();
			_bg.graphics.beginFill(0xffffff);
			_bg.graphics.drawRect(0, 0, 110, 110);
			_bg.graphics.endFill();
			this.addChild(_bg);
			this.addChild(_container);
			_cover.graphics.beginFill(0xff9900);
			_cover.graphics.drawRect(5, 5, 100, 100);
			_cover.graphics.endFill();	
			
			_cover.graphics.beginFill(0xff0000);
			_cover.graphics.drawRect(10, 10, 90, 90);
			_cover.graphics.endFill();
			
			_container.addChild(_cover);
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
			setTimeout(coverCard, 1000);
		}
		
		private function coverCard():void
		{
			TweenLite.to(this._container, 0.3, { scaleX:0,x: this._container.x + 50,onComplete:completeCover } );
		}
		
		public function OpenCard():void
		{
			TweenLite.to(this._container, 0.3, { scaleX:0, x: this._container.x + 50,onComplete:completeOpen } );
		}
		
		private function completeCover():void
		{								
			this._container.setChildIndex(_cover, this.numChildren - 1);
			_cover.visible = true;
			TweenLite.to(this._container, 0.3, { scaleX:1,x: this._container.x - 50,onComplete:completeCoverCover} );
		}
		
		private function completeCoverCover():void
		{
			isOpened = false;
		}
		
		private function completeOpen():void
		{			
			this._container.setChildIndex(_pic, this.numChildren - 1);
			_cover.visible = false;
			TweenLite.to(this._container, 0.3, { scaleX:1,x: this._container.x - 50,onComplete:dispatchOK} );
		}
		
		private function dispatchOK():void
		{
			dispatchEvent(new Event("Select", true));
		}
		
		public function disapear():void
		{
			setTimeout(disapear2,0.3);
		}
		
		private function disapear2():void
		{
			TweenLite.to(this, 0.3, { alpha:0 } );
		}		
	}

}