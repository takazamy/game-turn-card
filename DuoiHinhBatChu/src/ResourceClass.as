package  
{
	/**
	 * ...
	 * @author Pham Tu Thanh
	 */
	public class ResourceClass 
	{
		public var _class:Class;
		public var _answer:String;
		public var _realAnswer:String
		public var _goiY:String;
		
		public function ResourceClass(_class:Class,_real:String,_answer:String,_goiY:String) 
		{
			this._answer = _answer;
			this._class = _class;
			this._realAnswer = _real;
			this._goiY = _goiY;
		}

	}

}