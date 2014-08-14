#include "colors.inc"
#include "shapes.inc"
#include "textures.inc"

camera {
	up z
	right y * 16 / 9
	sky z
	location (x + y + z) * 0.5
	rotate -15 * clock * z
	look_at o
}

#macro Tyre(NominalSectionWidth, AspectRatio, WheelDiameter)
	#local TyreBaseColour = rgb <0.1, 0.1, 0.1>;
	#local NominalSectionWidth = NominalSectionWidth / 1000;
	#local SidewallHeight = NominalSectionWidth * AspectRatio / 100;
	#local WheelDiameter = WheelDiameter * 2.54 / 100;
	#local HelperTorusMinor = 0.05;
	#local HelperTorusMajor = WheelDiameter / 2 + SidewallHeight - HelperTorusMinor;
	#local HelperTorusOffset = NominalSectionWidth / 2 - HelperTorusMinor;
	difference {
		merge {
			torus {
				HelperTorusMajor, HelperTorusMinor
				pigment { color TyreBaseColour }
				translate y * HelperTorusOffset
			}
			torus {
				HelperTorusMajor, HelperTorusMinor
				pigment { color TyreBaseColour }
				translate -y * HelperTorusOffset
			}
			cylinder {
				-y * (HelperTorusOffset + HelperTorusMinor),
				+y * (HelperTorusOffset + HelperTorusMinor),
				HelperTorusMajor
				pigment { color TyreBaseColour }
			}
			cylinder {
				-y * HelperTorusOffset,
				+y * HelperTorusOffset,
				HelperTorusMajor + HelperTorusMinor
				pigment { color TyreBaseColour }
				normal {
					// see http://wiki.povray.org/content/Knowledgebase:Language_Questions_and_Tips
					// section "If I use an image map with a cylindrical map type (map_type 2) the
					// image is used only once around the cylinder. Is there any way to repeat the
					// image several times around it instead of just once?"
					bump_map {
						png "tyre_tread.png"
						map_type 0 // don't use cylindrical
						bump_size 2000
					}
					scale <HelperTorusOffset / (HelperTorusMajor + HelperTorusMinor) / pi, 1, 1>
					warp { cylindrical }
					translate <0, 0.5, 0>
					scale <1, HelperTorusOffset * 2, 1>
				}
			}
		}
		cylinder {
			-y * (HelperTorusOffset + HelperTorusMinor + 1),
			+y * (HelperTorusOffset + HelperTorusMinor + 1),
			WheelDiameter / 2
		}
	}
#end

object {
	Tyre(205, 55, 16)
	rotate 5 * clock * y
}

light_source {
	(x + y + z) * 0.5
	color White
	rotate -15 * clock * z
}

light_source {
	x * 0.4
	color White
	rotate -30 * y
}

light_source {
	-x * 0.4
	color White
	rotate 30 * y
}

background { color DarkSlateGrey }
