/*
	Info:
		- Reference page : Box2dFlashAS3 2.1a / Examples / HelloWorld.fla
		- Box2D lib : Box2dFlashAS3 2.1a, http://www.box2dflash.org/
		
		- Introduction : 
*/

package section.DEMO.Module.Demo.Space.variable
{
	/*import：Flash內建元件庫*/
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
		
	/*external import：外部元件庫、開發人員自定元件庫*/
	import Box2D.Dynamics.b2World;
	import org.gra.model.RuleModel.Core.RMSpaceVar;
	import org.gra.model.RuleModel.Interface.IRMSpace;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Common.Math.b2Vec2;
		
	public class B2DWorld extends RMSpaceVar
	{
		/*const variable：常數變數*/
		/*member variable：物件內部操作變數*/
		// 世界物件
		private var m_world : b2World;
		// 加速度循環
		private var m_velocityIterations:int = 10;
		// 位置循環
		private var m_positionIterations:int = 10;
		// 更新率
		private var m_timeStep:Number = 1.0/30.0;
		// 世界縮放比
		private var m_worldScale : Number = 30;		
		// 邊界物件
		private var m_obstacle : Array;
		/*display object variable：顯示物件變數，如MovieClip等*/
		private var m_debugStage : Sprite;
		
		
		
		/*constructor：建構值*/
		public function B2DWorld( a_space : IRMSpace, a_debug : Boolean = false )
		{
			// 初始化世界			
			super( 0, 0, 0, 0, 0, 0, a_space, a_space.getName() );
			// Define the gravity vector
			var gravity : b2Vec2 = new b2Vec2(0.0, 0.0);
			
			// Allow bodies to sleep
			var doSleep : Boolean = true;
			
			// Construct a world object
			this.m_world = new b2World( gravity, doSleep);
			// Use the given object as a broadphase. 
			// boardphase : http://http.developer.nvidia.com/GPUGems3/gpugems3_ch32.html
			//this.m_world.SetBroadPhase(new b2BroadPhase(this.m_worldAABB));
			// nable/disable warm starting. For testing. 
			this.m_world.SetWarmStarting(true);
			
			// 偵錯系統
			if( a_debug )
			{
				var debug_draw : b2DebugDraw = new b2DebugDraw();
				this.m_debugStage = new Sprite();
			
				debug_draw.SetSprite(this.m_debugStage);
				debug_draw.SetDrawScale(this.m_worldScale);  
				debug_draw.SetFillAlpha( 0.5 );
				debug_draw.SetLineThickness( 1 )
				debug_draw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit); 
				this.m_world.SetDebugDraw(debug_draw);
			}
			// create boarder obstacle
			this.m_obstacle = new Array();
			for( var i = 0 ; i < 4 ; i++ )
				this.m_obstacle.push( this.CreateBox() );
		}
		
		// 
		public function SetBoarder( a_width, a_height ) : void
		{
			if( this.getWidth() != a_width && this.getHeight() != a_height )
			{
				this.setWidth( a_width )
				this.setHeight( a_height );
				// 調整邊界
				var wall : B2DObject = null;
				if( this.m_obstacle.length > 0 )
				{
					for( var i = 0 ; i < this.m_obstacle.length ; i++ )
					{
						// 取得牆壁
						wall = this.m_obstacle[i];
						
						// 移除舊物件
						wall.Destory();
						
						// 重設物件
						switch( i )
						{
							case 0 :
								// Top
								wall.Initial( { "x" : a_width/2 , "y" : 0, "w" : a_width, "h" : 2, "phy" : [1,1,0] } );
							break;
							case 1 :
								// Botton
								wall.Initial( { "x" : a_width/2, "y" : a_height, "w" : a_width, "h" : 2, "phy" : [1,1,0] } );
							break;
							case 2 :
								// Left
								wall.Initial( { "x" : 0, "y" : a_height/2, "w" : 2, "h" : a_height, "phy" : [1,1,0] } );
							break;
							case 3 :
								// Right
								wall.Initial( { "x" : a_width, "y" : a_height/2, "w" : 2, "h" : a_height, "phy" : [1,1,0] } );
							break;
						}
					}
				}
			}
			
		}
		// 畫面更新
		public function Update() : void
		{
			// 更新世界
			this.m_world.Step(m_timeStep, m_velocityIterations, m_positionIterations);
			// 清除力
			this.m_world.ClearForces();
			// 繪製 Debug data
			if( this.m_debugStage != null )
				this.m_world.DrawDebugData();
			
			// Go through body list and update sprite positions/rotations
			/*
			for(var bb:b2Body = m_world.GetBodyList(); bb; bb = bb.GetNext())
			{
				if( bb.GetUserData() is B2Object )
				{
					(bb.GetUserData() as B2Object).Update();
				}
			}
			*/
		}
		
		// 建立工廠
		public function CreateBox() : B2DObject
		{
			return new B2DBox( this.getSpace(), this.m_world, this.m_worldScale );
		}
		
		public function CreateCircle() : B2DObject
		{
			return new B2DCircle( this.getSpace(), this.m_world, this.m_worldScale );
		}
		/*public function：對外公開函數*/
		/*public get/set function：變數存取介面*/
		/*write only：唯寫*/
		// 偵錯系統，送入舞臺資訊，啟動顯示物理世界的偵錯模式。
		public function get debugStage() : Sprite
		{
			return this.m_debugStage;
		}
		/*read only：唯讀*/
		/*read/write：讀寫*/
		/*private function：私用函數*/
		/*private event function：私用事件函數*/
	}
}