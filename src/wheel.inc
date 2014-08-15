#include "colors.inc"
#include "shapes.inc"
#include "textures.inc"

#declare TyreBaseColour = rgb <0.1, 0.1, 0.1>;
#declare TyreTextThickness = 0.002;

#macro WheelRim(OuterDiameter, Width, Thickness)
	difference {
		cylinder {
			-Width / 2 * y, Width / 2 * y,
			OuterDiameter / 2
			texture { Chrome_Metal }
		}
		cylinder {
			// avoid Z-fighting
			-(Width / 2 + 1) * y, (Width / 2 + 1) * y,
			OuterDiameter / 2 - Thickness
			texture { Chrome_Metal }
		}
	}
#end

#macro WheelSpokePair(Length, Thickness, Rotation)
	cylinder {
		o, Length * x, Thickness / 2
		texture { Chrome_Metal }
		translate +Thickness * 0.625 * z
		rotate Rotation * y
	}
	cylinder {
		o, Length * x, Thickness / 2
		texture { Chrome_Metal }
		translate -Thickness * 0.625 * z
		rotate Rotation * y
	}
#end

#macro WheelSpokes(Count, Length, Thickness)
	#local Spoke = 0;
	#while (Spoke < Count)
		WheelSpokePair(Length, Thickness, Spoke * 360 / Count)
		#local Spoke = Spoke + 1;
	#end
#end

#macro WheelHub(Diameter, Width)
	cylinder {
		-Width / 2 * y, Width / 2 * y, Diameter / 2
		texture { Chrome_Metal }
	}
#end

#macro WheelHole(Diameter, Distance, Rotation)
	cylinder {
		-y, y, Diameter / 2
		translate Distance * x
		rotate Rotation * y
		texture { Chrome_Metal }
	}
#end

#macro WheelHoles(Count, Diameter, Distance)
	#local Hole = 0;
	#while (Hole < Count)
		WheelHole(Diameter, Distance, Hole * 360 / Count)
		#local Hole = Hole + 1;
	#end
#end

#macro Wheel(Diameter, Width)
	difference {
		union {
			WheelRim(Diameter, Width, 0.01)
			WheelSpokes(7, Diameter / 2, 0.04)
			WheelHub(0.16, 0.05)
		}
		WheelHoles(7, 0.024, 0.05)
	}
#end

#macro TyreBase(NominalSectionWidth, AspectRatio, WheelDiameter)
	#local HelperTorusMinor = 0.25 * NominalSectionWidth;
	#local HelperTorusMajor = WheelDiameter / 2 + SidewallHeight - HelperTorusMinor;
	#local HelperTorusOffset = NominalSectionWidth / 2 - HelperTorusMinor;
	difference {
		union {
			torus {
				HelperTorusMajor, HelperTorusMinor
				pigment { color TyreBaseColour }
				translate y * HelperTorusOffset
				TyreNormal(
					"wheel_edge_1.png",
					HelperTorusOffset * 2,
					// circumference
					pi * (HelperTorusMajor + HelperTorusMinor)
					// width
					/ HelperTorusOffset
				)
			}
			torus {
				HelperTorusMajor, HelperTorusMinor
				pigment { color TyreBaseColour }
				translate -y * HelperTorusOffset
				TyreNormal(
					"wheel_edge_2.png",
					HelperTorusOffset * 2,
					// circumference
					pi * (HelperTorusMajor + HelperTorusMinor)
					// width
					/ HelperTorusOffset
				)
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
				TyreNormal(
					"wheel_tread.png",
					HelperTorusOffset * 2,
					// circumference
					pi * (HelperTorusMajor + HelperTorusMinor)
					// width
					/ HelperTorusOffset
				)
			}
		}
		cylinder {
			-y * (HelperTorusOffset + HelperTorusMinor + 1),
			+y * (HelperTorusOffset + HelperTorusMinor + 1),
			WheelDiameter / 2
			pigment { color TyreBaseColour }
		}
	}
#end

#macro TyreNormal(Filename, Width, Multiplicity)
	normal {
		// map_type 2 does not allow repetition of the bump map
		// use a cylindrical warp instead
		// also this cylindrical map works very well for the toruses
		bump_map {
			png Filename
			map_type 0 // planar mapping
			bump_size 1
		}
		scale <1 / Multiplicity, 1, 1>
		warp { cylindrical }
		translate <0, 0.5, 0>
		scale <1, Width, 1>
	}
#end

#macro TyreText(
	RawNominalSectionWidth,
	RawAspectRatio,
	RawWheelDiameter
)
	#local NominalSectionWidth = RawNominalSectionWidth / 1000;
	#local AspectRatio = RawAspectRatio / 100;
	#local WheelDiameter = RawWheelDiameter * 2.54 / 100;
	#local SidewallHeight = NominalSectionWidth * AspectRatio;
	object {
		Circle_Text(
			"timrom.ttf",
			concat(
				str(RawNominalSectionWidth, 0, 0),
				"/"
				str(RawAspectRatio, 0, 0),
				"R",
				str(RawWheelDiameter, 0, 0)
			),
			SidewallHeight / 5,
			0,
			TyreTextThickness,
			WheelDiameter / 2 + SidewallHeight / 4,
			0,
			Align_Center,
			0
		)
		rotate 90 * x
		translate (NominalSectionWidth / 2 + TyreTextThickness) * y
		rotate -90 * y
		scale -x
		pigment { color TyreBaseColour }
	}
#end

#macro Tyre(RawNominalSectionWidth, RawAspectRatio, RawWheelDiameter)
	#local NominalSectionWidth = RawNominalSectionWidth / 1000;
	#local AspectRatio = RawAspectRatio / 100;
	#local WheelDiameter = RawWheelDiameter * 2.54 / 100;
	#local SidewallHeight = NominalSectionWidth * AspectRatio;
	#local HelperTorusMinor = 0.25 * NominalSectionWidth;
	#local HelperTorusMajor = WheelDiameter / 2 + SidewallHeight - HelperTorusMinor;
	#local HelperTorusOffset = NominalSectionWidth / 2 - HelperTorusMinor;
	union {
		TyreBase(NominalSectionWidth, AspectRatio, WheelDiameter)
		TyreText(RawNominalSectionWidth, RawAspectRatio, RawWheelDiameter)
	}
#end

#macro TyreWheel(RawNominalSectionWidth, RawAspectRatio, RawWheelDiameter)
	#local NominalSectionWidth = RawNominalSectionWidth / 1000;
	#local WheelDiameter = RawWheelDiameter * 2.54 / 100;
	union {
		Tyre(RawNominalSectionWidth, RawAspectRatio, RawWheelDiameter)
		Wheel(WheelDiameter, NominalSectionWidth)
	}
#end
