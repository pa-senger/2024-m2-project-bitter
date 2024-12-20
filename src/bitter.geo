SetFactory("OpenCASCADE");

// Parameters
ri     = 200e-3;     // Internal radius [m]
l      = 100e-3;     // Length of the bitter [m]
alpha  = Pi/18;      // Angle [rad]
r1     = 10e-3;      // Diameter of Gamma_cool1 [m]
w2     = 1.1e-3;     // Width of Gamma_cool2 [m]
l2     = 5.9e-3;     // Length of Gamma_cool2 [m]
height = 4e-3;       // Height of the geometry [m]
epsilon = 1e-10; // to place the point outide the recangle otherwise the arc is always inward


// Derived parameters
r_cool1 = r1 / 2;     // Radius of the circular hole
r_major = l2 / 2;     // Half of elliptical hole length
r_minor = w2 / 2;     // Half of elliptical hole width

//#################################################################################
// Step 1: Create the annular sector (main domain)
pt_inner_1 = newp; Point(pt_inner_1) = {ri * Cos(0), ri * Sin(0), 0};
pt_inner_2 = newp; Point(pt_inner_2) = {ri * Cos(alpha), ri * Sin(alpha), 0};

pt_outer_1 = newp; Point(pt_outer_1) = {(ri + l) * Cos(0), (ri + l) * Sin(0), 0};
pt_outer_2 = newp; Point(pt_outer_2) = {(ri + l) * Cos(alpha), (ri + l) * Sin(alpha), 0};

pt_center = newp; Point(pt_center) = {0, 0, 0};

// Create arcs and lines
arc_inner = newl; Circle(arc_inner) = {pt_inner_1, pt_center, pt_inner_2};
arc_outer = newl; Circle(arc_outer) = {pt_outer_1, pt_center, pt_outer_2};

line_radial_1 = newl; Line(line_radial_1) = {pt_inner_1, pt_outer_1};
line_radial_2 = newl; Line(line_radial_2) = {pt_inner_2, pt_outer_2};

// ###############################################################################
// Step 2: Create center disk Gamma_cool1
pt_center_cool1 = newp; Point(pt_center_cool1) = {265e-3, 265e-3 * Sin(alpha / 2), 0};

pt_cool1_bound_1 = newp; Point(pt_cool1_bound_1) = {265e-3 + r_cool1, 265e-3 * Sin(alpha / 2), 0};
pt_cool1_bound_2 = newp; Point(pt_cool1_bound_2) = {265e-3 - r_cool1, 265e-3 * Sin(alpha / 2), 0};

arc_cool1_1 = newl; Circle(arc_cool1_1) = {pt_cool1_bound_1, pt_center_cool1, pt_cool1_bound_2};
arc_cool1_2 = newl; Circle(arc_cool1_2) = {pt_cool1_bound_2, pt_center_cool1, pt_cool1_bound_1};

// ###############################################################################
// Step 3: Create Gamma_cool2 holes 
// TODO : put 2 points = center of cirle, dist(p1, p2) = l - w2
// TODO:  make a line w2/2 below, duplicate by translation w2/2 above centers points
// TODO: close with half circles
// TODO: put this into a function that take the 2 center points coord
r_inner_cool2 = 208e-3;  // Radius for first row of holes
r_outer_cool2 = 288e-3;  // Radius for second row of holes

// Angular offset for tangent alignment
x_inner = l2 / (2 * r_inner_cool2);
x_outer = l2 / (2 * r_outer_cool2);

// ##############################################################################
// Hole 1 - Inner row 1
// Define the first line
pt_cool2_inner_1a = newp; Point(pt_cool2_inner_1a) = {
    r_inner_cool2 * Cos(alpha / 4 - x_inner + w2),
    r_inner_cool2 * Sin(alpha / 4 - x_inner + w2), 0
};
pt_cool2_inner_1b = newp; Point(pt_cool2_inner_1b) = {
    r_inner_cool2 * Cos(alpha / 4 + x_inner - w2),
    r_inner_cool2 * Sin(alpha / 4 + x_inner - w2), 0
};
line_cool2_inner_1 = newl; Line(line_cool2_inner_1) = {pt_cool2_inner_1a, pt_cool2_inner_1b};

// Define the second line (translated outward by w2)
pt2_cool2_inner_1a = newp; Point(pt2_cool2_inner_1a) = {
    (r_inner_cool2 + w2) * Cos(alpha / 4 - x_inner + w2),
    (r_inner_cool2 + w2) * Sin(alpha / 4 - x_inner + w2), 0
};
pt2_cool2_inner_1b = newp; Point(pt2_cool2_inner_1b) = {
    (r_inner_cool2 + w2) * Cos(alpha / 4 + x_inner - w2),
    (r_inner_cool2 + w2) * Sin(alpha / 4 + x_inner - w2), 0
};
line_cool2_inner_2 = newl; Line(line_cool2_inner_2) = {pt2_cool2_inner_1a, pt2_cool2_inner_1b};

pt_cool2_arc_center1 = newp; Point(pt_cool2_arc_center1) = {
	(r_inner_cool2 + w2/2) * Cos(alpha / 4 - x_inner + w2 + epsilon),
	(r_inner_cool2 + w2/2) * Sin(alpha / 4 - x_inner + w2 + epsilon), 0
};

pt_cool2_arc_center2 = newp; Point(pt_cool2_arc_center2) = {
	(r_inner_cool2 + w2/2) * Cos(alpha / 4 + x_inner - w2 - epsilon),
	(r_inner_cool2 + w2/2) * Sin(alpha / 4 + x_inner - w2 - epsilon), 0
};

arc_cool2_inner_1 = newl; Circle(arc_cool2_inner_1) = {pt_cool2_inner_1a, pt_cool2_arc_center1, pt2_cool2_inner_1a};
arc_cool2_inner_2 = newl; Circle(arc_cool2_inner_2) = {pt_cool2_inner_1b, pt_cool2_arc_center2, pt2_cool2_inner_1b};

// ###############################################################################
// Hole 2 - outer row 1
// Define the first line
pt_cool2_outer_1a = newp; Point(pt_cool2_outer_1a) = {
    r_outer_cool2 * Cos(alpha / 4 - x_outer + w2),
    r_outer_cool2 * Sin(alpha / 4 - x_outer + w2), 0
};
pt_cool2_outer_1b = newp; Point(pt_cool2_outer_1b) = {
    r_outer_cool2 * Cos(alpha / 4 + x_outer - w2),
    r_outer_cool2 * Sin(alpha / 4 + x_outer - w2), 0
};
line_cool2_outer_1 = newl; Line(line_cool2_outer_1) = {pt_cool2_outer_1a, pt_cool2_outer_1b};

// Define the second line (translated outward by w2)
pt2_cool2_outer_1a = newp; Point(pt2_cool2_outer_1a) = {
    (r_outer_cool2 + w2) * Cos(alpha / 4 - x_outer + w2),
    (r_outer_cool2 + w2) * Sin(alpha / 4 - x_outer + w2), 0
};
pt2_cool2_outer_1b = newp; Point(pt2_cool2_outer_1b) = {
    (r_outer_cool2 + w2) * Cos(alpha / 4 + x_outer - w2),
    (r_outer_cool2 + w2) * Sin(alpha / 4 + x_outer - w2), 0
};
line_cool2_outer_2 = newl; Line(line_cool2_outer_2) = {pt2_cool2_outer_1a, pt2_cool2_outer_1b};

pt_cool2_arc_center1 = newp; Point(pt_cool2_arc_center1) = {
	(r_outer_cool2 + w2/2) * Cos(alpha / 4 - x_outer + w2 + epsilon),
	(r_outer_cool2 + w2/2) * Sin(alpha / 4 - x_outer + w2 + epsilon), 0
};

pt_cool2_arc_center2 = newp; Point(pt_cool2_arc_center2) = {
	(r_outer_cool2 + w2/2) * Cos(alpha / 4 + x_outer - w2 - epsilon),
	(r_outer_cool2 + w2/2) * Sin(alpha / 4 + x_outer - w2 - epsilon), 0
};

arc_cool2_outer_1 = newl; Circle(arc_cool2_outer_1) = {pt_cool2_outer_1a, pt_cool2_arc_center1, pt2_cool2_outer_1a};
arc_cool2_outer_2 = newl; Circle(arc_cool2_outer_2) = {pt_cool2_outer_1b, pt_cool2_arc_center2, pt2_cool2_outer_1b};

// ###############################################################################
// Hole 3 - Outer row 2
// Define the first line
pt_cool23_outer_1a = newp; Point(pt_cool23_outer_1a) = {
	r_outer_cool2 * Cos(3 * alpha / 4 - x_outer + w2),
	r_outer_cool2 * Sin(3 *alpha / 4 - x_outer + w2), 0
};
pt_cool23_outer_1b = newp; Point(pt_cool23_outer_1b) = {
	r_outer_cool2 * Cos(3 * alpha / 4 + x_outer - w2),
	r_outer_cool2 * Sin(3 * alpha / 4 + x_outer - w2), 0
};
line_cool23_outer_1 = newl; Line(line_cool23_outer_1) = {pt_cool23_outer_1a, pt_cool23_outer_1b};

// Define the second line (translated outward by w2)
pt2_cool23_outer_1a = newp; Point(pt2_cool23_outer_1a) = {
	(r_outer_cool2 + w2) * Cos(3 * alpha / 4 - x_outer + w2),
	(r_outer_cool2 + w2) * Sin(3 * alpha / 4 - x_outer + w2), 0
};
pt2_cool23_outer_1b = newp; Point(pt2_cool23_outer_1b) = {
	(r_outer_cool2 + w2) * Cos(3 * alpha / 4 + x_outer - w2),
	(r_outer_cool2 + w2) * Sin(3 * alpha / 4 + x_outer - w2), 0
};
line_cool23_outer_2 = newl; Line(line_cool23_outer_2) = {pt2_cool23_outer_1a, pt2_cool23_outer_1b};

pt_cool23_arc_center3 = newp; Point(pt_cool23_arc_center3) = {
	(r_outer_cool2 + w2/2) * Cos(3 * alpha / 4 - x_outer + w2 + epsilon),
	(r_outer_cool2 + w2/2) * Sin(3 * alpha / 4 - x_outer + w2 + epsilon), 0
};

pt_cool23_arc_center4 = newp; Point(pt_cool23_arc_center4) = {
	(r_outer_cool2 + w2/2) * Cos(3 * alpha / 4 + x_outer - w2 - epsilon),
	(r_outer_cool2 + w2/2) * Sin(3 * alpha / 4 + x_outer - w2 - epsilon), 0
};

arc_cool23_outer_1 = newl; Circle(arc_cool23_outer_1) = {pt_cool23_outer_1a, pt_cool23_arc_center3, pt2_cool23_outer_1a};
arc_cool23_outer_2 = newl; Circle(arc_cool23_outer_2) = {pt_cool23_outer_1b, pt_cool23_arc_center4, pt2_cool23_outer_1b};

// ###############################################################################
// Hole 4 - Inner row 2
// Define the first line
pt_cool24_inner_1a = newp; Point(pt_cool24_inner_1a) = {
	r_inner_cool2 * Cos(3 * alpha / 4 - x_inner + w2),
	r_inner_cool2 * Sin(3 *alpha / 4 - x_inner + w2), 0
};
pt_cool24_inner_1b = newp; Point(pt_cool24_inner_1b) = {
	r_inner_cool2 * Cos(3 * alpha / 4 + x_inner - w2),
	r_inner_cool2 * Sin(3 * alpha / 4 + x_inner - w2), 0
};
line_cool24_inner_1 = newl; Line(line_cool24_inner_1) = {pt_cool24_inner_1a, pt_cool24_inner_1b};

// Define the second line (translated outward by w2)
pt2_cool24_inner_1a = newp; Point(pt2_cool24_inner_1a) = {
	(r_inner_cool2 + w2) * Cos(3 * alpha / 4 - x_inner + w2),
	(r_inner_cool2 + w2) * Sin(3 * alpha / 4 - x_inner + w2), 0
};
pt2_cool24_inner_1b = newp; Point(pt2_cool24_inner_1b) = {
	(r_inner_cool2 + w2) * Cos(3 * alpha / 4 + x_inner - w2),
	(r_inner_cool2 + w2) * Sin(3 * alpha / 4 + x_inner - w2), 0
};
line_cool24_inner_2 = newl; Line(line_cool24_inner_2) = {pt2_cool24_inner_1a, pt2_cool24_inner_1b};

pt_cool24_arc_center3 = newp; Point(pt_cool24_arc_center3) = {
	(r_inner_cool2 + w2/2) * Cos(3 * alpha / 4 - x_inner + w2 + epsilon),
	(r_inner_cool2 + w2/2) * Sin(3 * alpha / 4 - x_inner + w2 + epsilon), 0
};

pt_cool24_arc_center4 = newp; Point(pt_cool24_arc_center4) = {
	(r_inner_cool2 + w2/2) * Cos(3 * alpha / 4 + x_inner - w2 - epsilon),
	(r_inner_cool2 + w2/2) * Sin(3 * alpha / 4 + x_inner - w2 - epsilon), 0
};

arc_cool24_inner_1 = newl; Circle(arc_cool24_inner_1) = {pt_cool24_inner_1a, pt_cool24_arc_center3, pt2_cool24_inner_1a};
arc_cool24_inner_2 = newl; Circle(arc_cool24_inner_2) = {pt_cool24_inner_1b, pt_cool24_arc_center4, pt2_cool24_inner_1b};


// ###############################################################################
// Step 4: Create Surfaces, volumes and physical groups with GUI
// Cu = Omega
Curve Loop(1) = {4, -2, -3, 1};
Curve Loop(2) = {20, -22, -19, 21};
Curve Loop(3) = {8, -10, -7, 9};
Curve Loop(4) = {5, 6};
Curve Loop(5) = {15, 18, -16, -17};
Curve Loop(6) = {11, 14, -12, -13};
Plane Surface(1) = {1, 2, 3, 4, 5, 6};

// Cool1
Curve Loop(7) = {6, 5};
Plane Surface(2) = {7};

// Cool2
Curve Loop(8) = {19, 22, -20, -21};
Curve Loop(9) = {15, 18, -16, -17};
Curve Loop(10) = {11, 14, -12, -13};
Curve Loop(11) = {8, -10, -7, 9};
Plane Surface(3) = {8, 9, 10, 11};
Curve Loop(12) = {11, 14, -12, -13};
Plane Surface(4) = {12};
Curve Loop(13) = {19, 22, -20, -21};
Plane Surface(5) = {13};
Curve Loop(14) = {16, -18, -15, 17};
Plane Surface(6) = {14};


extrudedVolume[] = Extrude {0, 0, 0.004} {
	Surface{1, 2, 3, 4, 5, 6}; Layers {5}; Recombine;
  };


// In
Curve Loop(48) = {29, -26, -3, 28};
Plane Surface(35) = {48};

// Out
Curve Loop(50) = {4, 24, -25, -23};
Plane Surface(36) = {50};

// Channel
Curve Loop(51) = {23, -30, -28, 1};
Plane Surface(37) = {51};
Curve Loop(52) = {2, 24, -27, -26};
Plane Surface(38) = {52};


// Physical groups
Physical Volume("Cu") = {extrudedVolume[1]};
Physical Surface("Channel") = {37, 38};
Physical Surface("Cool1") = {2, 30};
Physical Surface("Out") = {36};
Physical Surface("In") = {35};
Physical Surface("Cool2") = {3, 4, 5, 6, 31, 32, 33, 34};


// Mesh size
Mesh.CharacteristicLengthMin = 0.0005;
Mesh.CharacteristicLengthMax = 0.005;


Mesh 3;
