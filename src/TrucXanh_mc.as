package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Pham Tu Thanh
	 */
	public class TrucXanh_mc extends MovieClip 
	{
		private var listData:Array = new Array();
		private var selectedItem:TrucXanhItem;
		private var doanChu_btn:Doan_chu_btn;
		private var textNhap:TextField;
		public var mainAnswer:String;
		public var numAnswerComplete:int;
		
		public function TrucXanh_mc() 
		{	
			//this.graphics.beginFill(0x000000);
			//this.graphics.drawRect(0, 0, 1000, 670);
			//this.graphics.endFill();
			
			// random
			var tempArray:Array = new Array();
			for (var i:int = 1; i < 9; i++) 
			{
				tempArray.push(i);
				tempArray.push(i);
			}			
			while (tempArray.length > 0)
			{
				var random:int = Math.floor(Math.random() * tempArray.length);
				listData.push(tempArray.splice(random, 1));
			}
			tempArray = listData.splice(0);
			while (tempArray.length > 0)
			{
				random = Math.floor(Math.random() * tempArray.length);
				listData.push(tempArray.splice(random, 1));
			}
			// fill stage
			var item:TrucXanhItem;
			var y:int = 0;
			for (var j:int = 0; j < listData.length; j++) 
			{
				item = new TrucXanhItem(MainScreen.getResource(listData[j]), listData[j]);
				item.x = (j % 4) * 109;
				item.y = int(j / 4) * 109;
				this.addChild(item);
			}
			
			// event
			this.addEventListener("Select", onSelect);
			
		}
		
		private function onSelect(e:Event):void 
		{
			var item:TrucXanhItem = e.target as TrucXanhItem;
			if (item.id > 6) 
			{
				// câu hỏi
				var objParent:Main = parent as Main;
				item.disapear();
				objParent.startQuesttionGame();
				objParent = null;
				numAnswerComplete++;
			}
			else if (selectedItem == null) 
			{
				selectedItem = item;
			}
			else if (selectedItem.id == item.id) // chon dung
			{
				selectedItem.disapear();
				item.disapear();
				selectedItem = null;
				numAnswerComplete += 2;
				if (numAnswerComplete == 16) 
				{
					on_doanChu_btnClick(null);
				}
			} else  // chon sai
			{
				selectedItem.CoverCard();
				item.CoverCard();
				selectedItem = null;
			}
			
		}
		
		private var mainQuestion:MovieClip;
		public function loadResourceMainQuesttion():void
		{
			mainQuestion = new Question1 as MovieClip;
			mainQuestion.width = mainQuestion.height = 437;
			this.addChildAt(mainQuestion, 0);
			mainAnswer = "coca";
			
			doanChu_btn = new Doan_chu_btn();
			this.addChild(doanChu_btn);
			doanChu_btn.x = 450;
			doanChu_btn.y = 420;
			
			var bg:BG2 = new BG2();
			bg.x = -229;
			bg.y = 38;
			this.addChildAt(bg, 0);
			doanChu_btn.addEventListener(MouseEvent.CLICK,on_doanChu_btnClick)
		}
		
		private function on_doanChu_btnClick(e:MouseEvent):void 
		{
			var main:Main = this.parent as Main;
			main.ShowDoanChu();
		}
		
	}

}