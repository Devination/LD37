package;

import nape.phys.Body;
import nape.space.Space;
import nape.geom.Vec2;

class LaunchManager {
	public var space:Space;

	var grabbed:Body;
	var mousePoint:Vec2;
	var dragStartPos:Vec2;

	public function new (space:Space) {
		this.space = space;
		mousePoint = new Vec2();
		dragStartPos = new Vec2();

		kha.input.Mouse.get().notify(onMouseDown, onMouseUp, onMouseMove, null);
	}

	function onMouseDown(button:Int, x:Int, y:Int):Void {
		// Determine the set of Body's which are intersecting mouse point.
		// And search for any 'dynamic' type Body to begin dragging.
		for (body in space.bodiesUnderPoint(mousePoint)) {
			if (!body.isDynamic()) {
				continue;
			}
			grabbed = body;
			dragStartPos.setxy(x, y);
			break;
		}
	}
	
	function onMouseUp(button:Int, x:Int, y:Int):Void {
		if (grabbed != null) {
			grabbed.velocity = dragStartPos.sub(mousePoint).mul(2);
			grabbed = null;
		}
	}
	
	function onMouseMove(x:Int, y:Int, cx:Int, cy:Int):Void {
		//TODO: Display helper arc?
		mousePoint.setxy(x, y);
	}
}