package  
{
	/**
	 * ...
	 * @author Nguyễn Đoàn Phú
	 */
	public class Question 
	{		
		
		public var text:String;
		public var AnswerArr:Array;
		public var id:int
		public var isPhongThuy:int;
		public function Question(Id:int,Text:String, AnswerList:XMLList,IsPhongThuy:String)
		{
			id = Id;
			text = Text;
			isPhongThuy = int(IsPhongThuy);
			AnswerArr = new Array();
			var a:Answer = null;
			for (var i:int = 0; i < AnswerList.length(); i++) 
			{
				a = new Answer(AnswerList[i].attributes()[1], StringToBool(AnswerList[i].attributes()[0]));
				AnswerArr.push(a);
				a = null;
				//Tao Answer bo vao Answer Array
			}		
		}
		
		private function StringToBool(text:String):Boolean
		{
			if (text == "1") 
			{
				return true;
			}
			else 
				return false;
		}
		
	}

}