wallThick = 2;
cutterMinimum = 1.2; //This is double the final thickness
baseHeight = 2;
height = 12;
flangeWidth = 6;
stampDepth = 1;
lineDepth = 2;
dxfFile = "smily.dxf";
model = "stamp";

if(model == "stamp") {
	stamp();
} else if(model == "cutter") {
	cookiecutter();
} else if(model == "handle") {
	handle();
} else if(model == "stampInverted") {
	stampInverted();
} else {
	echo("model has to be one of stamp, cutter, handle");
}


module handle() {
  handleLength=50;
  translate([53,80,10])
  rotate([90,0,0])
  difference() {
    minkowski() {
      union() {
        cube([baseHeight/3, 20, handleLength]);
        translate([baseHeight/6 - 10,0,0]) {
	  cube([20, baseHeight, handleLength]);
	}
      }
      sphere(r=baseHeight/3, $fn=10);
    }
    translate([-30,-baseHeight*2/3,-handleLength/2]) {
      cube([60, baseHeight, handleLength*2]);
    }
  }
}

module stamp() {
	difference() {
		difference(){
			baseShape(stampDepth + baseHeight);
			translate([0,0,baseHeight])linear_extrude(file = dxfFile, height=stampDepth*1.1, layer = "Stamp");
		}
		translate([0,0,-1]) {
			minkowski() { outline(); cylinder(r = 0.8, h = (stampDepth + baseHeight)*2);}
		}
	}
}

module stampInverted() {
	difference() {
		union(){
			baseShape(baseHeight);
			intersection(){
				baseShape(stampDepth + baseHeight);
				translate([0,0,baseHeight]){
					linear_extrude(file = dxfFile, height=stampDepth*1.1, layer = "Stamp");
				}
			}
		}
		translate([0,0,-1]) {
			minkowski() { outline(); cylinder(r = 0.8, h = (stampDepth + baseHeight)*2);}
		}
	}
}

module cookiecutter() {
	difference(){ //Cut holes in the flange
	union(){ //Add the supports and lines
	difference(){ //Cut out the inside of the cutter
		minkowski(){ 
			outline(cutterMinimum/2);
			cylinder(r1 = wallThick/3, r2 = cutterMinimum/2, h = height);
		}
		baseShape(height + baseHeight * 2);
	}
	flange();
	supports(baseHeight);
	lines(height - lineDepth);
	}
	holes();
	};
}

module flange(){
  difference(){
    minkowski(){
      baseShape(baseHeight/3);
      cylinder(r = flangeWidth, h = baseHeight/3);
    }
    translate([0,0,-baseHeight/2])baseShape(baseHeight*2);
  };
}

module supports(H){
	linear_extrude(file = dxfFile, height=H, layer = "Supports");
}

module holes(H){
	translate([0,0,-H]) linear_extrude(file = dxfFile, height=H*3, layer = "Holes");
}

module baseShape(H){
	linear_extrude(file = dxfFile, height=H, layer = "CC");
}

module lines(H){
	linear_extrude(file = dxfFile, height=H, layer = "Lines");
}

module outline(thickness){
  difference(){
    minkowski(){
      baseShape(baseHeight/3);
      cylinder(r = thickness, h = baseHeight/3);
    }
    translate([0,0,-baseHeight/2]) baseShape(baseHeight*2);
  };
};

