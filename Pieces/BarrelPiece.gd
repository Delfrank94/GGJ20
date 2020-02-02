extends Piece

func _on_Area2D_body_entered(body):
	._on_Area2D_body_entered(body)
	

func _on_Timer_timeout():
	var overlappingPieces = $ExplosionArea.get_overlapping_bodies()
	for each in overlappingPieces:
		if each is Piece:
			applyBlast(each,position,300)
	queue_free()
		
func applyBlast(body, blastPosition, power):
#	  void applyBlastImpulse(b2Body* body, b2Vec2 blastCenter, b2Vec2 applyPoint, float blastPower) {
#      b2Vec2 blastDir = applyPoint - blastCenter;
#      float distance = blastDir.Normalize();
#      //ignore bodies exactly at the blast point - blast direction is undefined
#      if ( distance == 0 )
#          return;
#      float invDistance = 1 / distance;
#      float impulseMag = blastPower * invDistance * invDistance;
#      body->ApplyLinearImpulse( impulseMag * blastDir, applyPoint );
	var blastDirection : Vector2 =  body.position - blastPosition
	var distance = blastDirection.length()
	if distance == 0:
		return
	var invDistance = 1/distance
	var impulse = power * invDistance
	body.apply_impulse(Vector2.ZERO, impulse*blastDirection)
	
	
	


func _on_BoxPiece_body_entered(body):
	print(body)
