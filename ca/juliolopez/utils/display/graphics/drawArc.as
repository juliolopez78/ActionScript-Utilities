/****************************************************************
TITLE:			drawArc
AUTHOR:			Julio Lopez
LAST UPDATED: 	2011-01-20
DESCRIPTION:	Draws arcs because flash.display.graphics does not
****************************************************************/
package ca.juliolopez.utils.display.graphics {
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * Draws an arc from one degree to another with a given radius and center point. Arc is drawn by drawing many tiny lines
	 * along a circumference.
	 * 
	 * @param sprite		Sprite. The Sprite object who's graphics object we are using
	 * @param centerX		Number. The x coord of the center of the arc
	 * @param centerY		Number. The y coord of the center of the arc
	 * @param radius		Number. The arc's radius
	 * @param angleFrom		Number. The starting angle of the arc
	 * @param angleTo		Number. The ending angle of the arc
	 * @param precision		Number. The precision which to use when drawing the arc, higher = smoother arc
	 *
	 * @return 			Point. the x and y coords of one end of the arc
	 */
	public function drawArc(sprite:Sprite, centerX:Number, centerY:Number, radius:Number, angleFrom:Number, angleTo:Number, precision:Number):Point {
		var degToRad:Number = 0.0174532925;				//used to convert degrees to rad
		var angleDiff:Number = angleTo - angleFrom;			//the total degrees the arc will span
		var steps:int = Math.round(angleDiff * precision);		//the number of steps that will be used to draw the arc
		var angle:Number = angleFrom;					//current angle, start at angleFrom
		var px:Number = centerX + radius * Math.cos(angle * degToRad);	//Starting x coord
		var py:Number = centerY + radius * Math.sin(angle * degToRad);	//Starting y coord
		var i:int;							//the current step
		var toX:Number;							//x coord to draw to
		var toY:Number;							//y coord to draw to
		
		sprite.graphics.moveTo(px,py);					//move the drawing point to px,py
		
		//step through and draw each segment of the arc
		for (i = 1; i<= steps; i++) {
			angle = angleFrom + angleDiff / steps * i;
			toX = centerX + radius * Math.cos(angle * degToRad);
			toY = centerY + radius * Math.sin(angle * degToRad);
			sprite.graphics.lineTo(toX, toY);
		}
		
		return new Point(px,py);
	}
}
