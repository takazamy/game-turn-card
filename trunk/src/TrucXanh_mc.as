package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Pham Tu Thanh
	 */
	public class TrucXanh_mc extends MovieClip 
	{
		private var listData:Array = new Array();
		private var selectedItem:TrucXanhItem;
		public function TrucXanh_mc() 
		{	
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
				item.x = (j % 4) * 110;
				item.y = int(j / 4) * 110;
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
				objParent.startQuesttionGame();
				objParent = null;
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
			} else  // chon sai
			{
				selectedItem.CoverCard();
				item.CoverCard();
				selectedItem = null;
			}
		}
		
	}

}