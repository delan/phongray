#include "wheel.inc"
#include "assignment_cow.inc"

#declare PIGMENT_DEBUG = pigment {
	checker
		color rgb x + z
		color o
	scale 0.02
}

background { color rgb x + z }

sky_sphere {
	pigment { PIGMENT_DEBUG }
	pigment { color rgb <0.3, 0.6, 0.6> }
	pigment {
		bozo
		turbulence 0.65
		octaves 6
		omega 0.7
		lambda 2
		color_map {
			[0.0 color <0.85, 0.85, 0.85, 0, 0>]
			[0.1 color <0.75, 0.75, 0.75, 0, 0>]
			[0.5 color <1, 1, 1, 0, 1>]
		}
		scale <0.2, 0.5, 0.2>
	}
}

camera {
	up z
	right y * 16 / 9
	sky z
	location <0, -240, 30>
	look_at o
}

light_source {
	<0, 240, 240>
	color White
}

rainbow {
	angle 20
	width 5
	distance 1.0e7
	direction <0, 1, -0.25>
	up z
	jitter 0.01
	color_map {
		[0.000 color <1.0, 0.5, 1.0, 1.0, 1.00>]
		[0.100 color <1.0, 0.5, 1.0, 0.8, 0.88>]
		[0.214 color <0.5, 0.5, 1.0, 0.8, 0.86>]
		[0.328 color <0.2, 0.2, 1.0, 0.8, 0.84>]
		[0.442 color <0.2, 1.0, 1.0, 0.8, 0.82>]
		[0.556 color <0.2, 1.0, 0.2, 0.8, 0.82>]
		[0.670 color <1.0, 1.0, 0.2, 0.8, 0.84>]
		[0.784 color <1.0, 0.5, 0.2, 0.8, 0.86>]
		[0.900 color <1.0, 0.2, 0.2, 0.8, 0.88>]
		[1.000 color <1.0, 0.2, 0.2, 1.0, 1.00>]
	}
}

plane {
	z, 0
	pigment {
		image_map {
			jpeg "assignment_dirt_4.jpg"
		}
	}
}

height_field {
	png "assignment_field_2.png"
	smooth
	pigment { PIGMENT_DEBUG }
	pigment {
		image_map {
			jpeg "assignment_dirt_4.jpg"
		}
		// the pigment must also be rotated
		rotate 90 * x
	}
	translate -0.5 * (x + z)
	scale <420, 50, 272>
	rotate 90 * x
	translate -z
}

object {
	ASSIGNMENT_COW
	translate <0, -150, 0>
}

object {
	TyreWheel(205, 55, 16)
	translate <0, -153, 0.310825>
}
