/*
//////////////////////////
//// TextureContainerButton ////
//////////////////////////
	Info:
		- TextureButton基礎物件
		
	Useage:(有開放public 讓外部使用)
		- FunctionName1 : function describe
		
	Date:
		- 2011.08.29
		
	Author:
		- Name : EastMoon
		- Email : jacky_eastmoon@hotmail.com
*/

package section.common.TextureButton
{
	/*import：Flash內建元件庫*/
	import flash.display.Sprite;	
	import flash.events.Event;
	/*external import：外部元件庫、開發人員自定元件庫*/

	public class TextureContainerButton extends Sprite
	{
		/*static const variable : 靜態常數變數*/
		/*const variable：常數變數*/
		/*function variable：函數變數*/
		/*member variable：物件內部操作變數*/
		protected var m_textureContainer : Array;
		/*display object variable：顯示物件變數，如MovieClip等*/
		/*constructor：建構值*/
		public function TextureContainerButton( a_texture : Array )
		{
			// 設定基本事件
			this.addEventListener(Event.ADDED_TO_STAGE, this.InitialProgress);
			
			// 儲存材質
			this.m_textureContainer = new Array();
			for( var i = 0 ; i < a_texture.length ; i++ )
				this.m_textureContainer.push(a_texture[i]);
				
			// 變更物件為可選擇
			this.buttonMode = true;
		}
		/*protected function : 繼承函數*/
		protected function InitialProgress( a_event : Event ) : void
		{
		}
		/*public function：對外公開函數*/
		public function UpdateBrowser() : void
		{
		}
		/*private function：私用函數*/
		/*private event function：私用事件函數*/
		/*public get/set function：變數存取介面*/
		/*write only：唯寫*/
		/*read only：唯讀*/
		public function get textureContainer() : Array
		{
			return this.m_textureContainer;
		}
		/*read/write：讀寫*/
	}
}