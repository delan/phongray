#include "colors.inc"
#include "shapes.inc"
#include "textures.inc"

camera {
	up z
	right y * 16 / 9
	sky z
	location <5, 5, 1>
	look_at <-1, -1, 1>
}

light_source { <0, 1, 1> color White }

torus {
	0.4, 0.05
	translate <0, 2, 0.45>
	texture {
		pigment { color rgb <0.1, 0.1, 0.1> }
		finish { phong 0.5 }
	}
}

sphere {
	<2, 0, 1.5 - (clock * 2 - 1) * (clock * 2 - 1)>, 0.5
	texture {
		pigment { color Magenta }
		finish { phong 0.5 }
	}
}

plane {
	z, 0
	pigment {
		checker
			color rgb <0.8, 0.8, 0.8>
			color rgb <0.9, 0.9, 0.9>
	}
}

merge {
	cylinder {
		<-1, 0, 0>, <1, 0, 0>, 0.1
		pigment {
			color Red
		}
	}
	cylinder {
		<0, -1, 0>, <0, 1, 0>, 0.1
		pigment {
			color Green
		}
	}
	cylinder {
		<0, 0, -1>, <0, 0, 1>, 0.1
		pigment {
			color Blue
		}
	}
	cone {
		<1, 0, 0>, 0.2
		<1.5, 0, 0>, 0
		pigment {
			color Red
		}
	}
	cone {
		<0, 1, 0>, 0.2
		<0, 1.5, 0>, 0
		pigment {
			color Green
		}
	}
	cone {
		<0, 0, 1>, 0.2
		<0, 0, 1.5>, 0
		pigment {
			color Blue
		}
	}
}

background { color DarkSlateGrey }

light_source { <2, 2, 2> color White }
