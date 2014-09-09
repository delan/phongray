#include "wheel.inc"
#include "assignment_cow.inc"

#declare PIGMENT_DEBUG = pigment {
	checker
		color rgb x + z
		color o
	scale 0.02
}

#declare CowPosition = spline {
	quadratic_spline
	 0.0, <-200, 100,   0>
	 5.0, <-200, 100,   0>
	 7.5, <   0, 100, 100>
	10.0, < 200, 100,   0>
	15.0, < 200, 100,   0>
	17.5, <   0, 100, 100>
	20.0, <-200, 100,   0>
}

#declare CowRotation = spline {
	quadratic_spline
	 0.0, <0, +25, 180>
	 1.0, <0,   0, 180>
	 4.0, <0,   0,   0>
	 5.0, <0, -25,   0>
	 7.5, <0,   0,   0>
	10.0, <0, +25,   0>
	11.0, <0,   0,   0>
	14.0, <0,   0, 180>
	15.0, <0, -25, 180>
	17.5, <0,   0, 180>
	20.0, <0, +25, 180>
}

#declare CameraPosition = spline {
	 0.0, <0, -220,  40>
	 1.0, <-240,  50, 20>
	 4.0, <-240,  50, 20>
	 5.0, <0, -220,  40>
	10.0, <0, -220,  40>
	11.0, < 240,  50, 20>
	14.0, < 240,  50, 20>
	15.0, <0, -220,  40>
	20.0, <0, -220,  40>
}

global_settings { ambient_light color White }

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
			[0.0 color <0.85, 0.85, 0.85> filter 0 transmit 0]
			[0.1 color <0.75, 0.75, 0.75> filter 0 transmit 0]
			[0.5 color <1.00, 1.00, 1.00> filter 0 transmit 1]
		}
		scale <0.2, 0.5, 0.2>
	}
}

camera {
	up z
	right x * 16 / 9
	sky z
	location CameraPosition(clock)
	direction y
}

light_source {
	<-300, 300, 300>
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
		[0.000 color <1.0, 0.5, 1.0> filter 1.0 transmit 1.00]
		[0.100 color <1.0, 0.5, 1.0> filter 0.8 transmit 0.88]
		[0.214 color <0.5, 0.5, 1.0> filter 0.8 transmit 0.86]
		[0.328 color <0.2, 0.2, 1.0> filter 0.8 transmit 0.84]
		[0.442 color <0.2, 1.0, 1.0> filter 0.8 transmit 0.82]
		[0.556 color <0.2, 1.0, 0.2> filter 0.8 transmit 0.82]
		[0.670 color <1.0, 1.0, 0.2> filter 0.8 transmit 0.84]
		[0.784 color <1.0, 0.5, 0.2> filter 0.8 transmit 0.86]
		[0.900 color <1.0, 0.2, 0.2> filter 0.8 transmit 0.88]
		[1.000 color <1.0, 0.2, 0.2> filter 1.0 transmit 1.00]
	}
}

plane {
	z, 0
	texture {
		Polished_Chrome
		normal {
			bumps 0.03
			scale <1, 1, 3>
			turbulence 0.6
		}
		translate <clock * 2, clock * 2, 0>
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
	union {
		object {
			ASSIGNMENT_COW
			normal {
				bump_map {
					png "assignment_bump_1.png"
					bump_size 420.0
				}
			}
			translate <0, 0, 0.655>
		}
		object {
			TyreWheel(205, 55, 16)
			rotate 36 * clock * y
			translate <+0.5, -0.20, 0.310825>
		}
		object {
			TyreWheel(205, 55, 16)
			rotate 36 * clock * y
			translate <+0.5, +0.20, 0.310825>
		}
		object {
			TyreWheel(205, 55, 16)
			rotate 36 * clock * y
			translate <-0.7, -0.25, 0.310825>
		}
		object {
			TyreWheel(205, 55, 16)
			rotate 36 * clock * y
			translate <-0.7, +0.25, 0.310825>
		}
		light_source {
			<2, +0.1, 2>
			color White
		}
		light_source {
			<2, -0.1, 2>
			color White
		}
		sphere {
			<1.20, -0.12, 1.90>, 0.05
			pigment { color Green }
			finish { phong 1 }
		}
		sphere {
			<1.20, +0.12, 1.90>, 0.05
			pigment { color Green }
			finish { phong 1 }
		}
	}
	scale 10
	rotate CowRotation(clock)
	translate 40 * z
	translate CowPosition(clock)
}
