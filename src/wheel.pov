#include "wheel.inc"

camera {
	up z
	right y * 16 / 9
	sky z
	location <0, 1, 0.5> * 0.7
	rotate 12 * clock * z
	look_at o
}

light_source {
	<0, 1, 0.5> * 0.7
	color White
	rotate 12 * clock * z
}

light_source {
	<0, 1, 0.5> * 0.7
	color White
	rotate 30 * z
	rotate 30 * y
	rotate 12 * clock * z
}

object {
	TyreWheel(205, 55, 16)
	rotate 36 * clock * y
}

background { color DarkSlateGrey }
