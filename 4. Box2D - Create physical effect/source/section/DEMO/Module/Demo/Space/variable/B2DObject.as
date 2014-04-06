﻿/*
	Info:
*/
package section.DEMO.Module.Demo.Space.variable
{
	/*import：Flash內建元件庫*/
	import flash.display.*;
	
	/*external import：外部元件庫、開發人員自定元件庫*/
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.b2Body;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import Box2D.Dynamics.Joints.b2DistanceJointDef;
	import org.gra.model.RuleModel.Core.RMSpaceVar;
	import org.gra.model.RuleModel.Interface.IRMSpace;
		
	public class B2DObject extends RMSpaceVar
	{
		/*const variable：常數變數*/
		/*member variable：物件內部操作變數*/
		protected var m_world : b2World;
		protected var m_worldScale : Number;	
		protected var m_body : b2Body;
		protected var m_param : Object;
		/*display object variable：顯示物件變數，如MovieClip等*/
		
		//
		public function B2DObject( a_space : IRMSpace, 
								  a_world : b2World = null, 
								  a_worldScale : Number = 30, 
								  a_param : Object = null ) : void
		{
			super( 0, 0, 0, 0, 0, 0, a_space, a_space.getName() );
			// 預設世界、更換世界、加入、移除
			// 儲存主要資訊
			this.m_world = a_world;
			this.m_worldScale = a_worldScale;
			
			// 若有參數值，依據參數產生物體
			if( a_param != null )
			{
				this.Initial( a_param )
			}
		}
		
		/*public function：對外公開函數*/
		public function Initial( a_param : Object = null ) : void
		{
			if( a_param == null )
				return ;
				
			this.m_param = a_param;
		}
		
		public function Destory() : void
		{
			if( this.m_body != null )
				this.m_world.DestroyBody( this.m_body );
		}
		
		public function Update() : void
		{
			if( this.m_body != null )
			{
				this.setX( this.m_body.GetPosition().x * this.m_worldScale );
				this.setY( this.m_body.GetPosition().y * this.m_worldScale );
				//sprite.rotation = this.m_body.GetAngle() * (180 / Math.PI);
			}			
		}
		
		public function SetRevoluteJoint( a_target : B2DObject, a_anchorA : b2Vec2, a_anchorB : b2Vec2 ) : void 
		{
			// 設定旋轉聯結
			// target : 聯結目標單位
			// anchorA : 聯結目標的錨點
			// anchorB : 本物件實體的錨點
			if( this.m_body != null )
			{
           	 	var revoluteJointDef : b2RevoluteJointDef = new b2RevoluteJointDef();
            	revoluteJointDef.localAnchorA.Set(a_anchorA.x / this.m_worldScale, a_anchorA.y / this.m_worldScale);
            	revoluteJointDef.localAnchorB.Set(a_anchorB.x / this.m_worldScale, a_anchorB.y / this.m_worldScale);
            	revoluteJointDef.bodyA = a_target.body;
            	revoluteJointDef.bodyB = this.m_body;
            	this.m_world.CreateJoint(revoluteJointDef);
			}
        }
		
		public function SetDistanceJoint( a_target : B2DObject, a_maxLength : Number ) : void 
		{
			// 設定綁繩聯結
			// target : 聯結目標單位
			// length : 與聯結目標的最大距離
			if( this.m_body != null )
			{
           	 	var distanceJointDef : b2DistanceJointDef = new b2DistanceJointDef();
				distanceJointDef.Initialize( a_target.body, this.m_body, a_target.body.GetWorldCenter(), this.m_body.GetWorldCenter() );
				distanceJointDef.length = a_maxLength / this.m_worldScale;
            	this.m_world.CreateJoint(distanceJointDef);
			}
		}
		/*public get/set function：變數存取介面*/
		/*write only：唯寫*/
		/*read only：唯讀*/
		public function get body() : b2Body
		{
			return this.m_body;
		}
		public function get param() : Object
		{
			return this.m_param;
		}
		/*read/write：讀寫*/
		/*private function：私用函數*/
		/*constructor：建構值*/
		/*private event function：私用事件函數*/
	}
}