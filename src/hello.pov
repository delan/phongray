#include "colors.inc"
#include "shapes.inc"
#include "textures.inc"

camera {
	up z
	right y * 16 / 9
	sky z
	location <3, 3, 1>
	look_at <-1, -1, 1>
	rotate <0, 0, clock * 720>
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

light_source { <4, 4, 4> color White }
