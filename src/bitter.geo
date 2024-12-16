SetFactory("OpenCASCADE");

// Parameters
ri     = 200e-3;     // Internal radius [m]
l      = 100e-3;     // Length of the bitter [m]
alpha  = Pi/18;      // Angle [rad]
r1     = 10e-3;      // Diameter of Gamma_cool1 [m]
w2     = 1.1e-3;     // Width of Gamma_cool2 [m]
l2     = 5.9e-3;     // Length of Gamma_cool2 [m]
height = 4e-3;       // Height of the geometry [m]

// Derived parameters
r_cool1 = r1 / 2;     // Radius of the circular hole
r_major = l2 / 2;     // Half of elliptical hole length
r_minor = w2 / 2;     // Half of elliptical hole width

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

// Step 2: Create center disk Gamma_cool1
pt_center_cool1 = newp; Point(pt_center_cool1) = {265e-3, 265e-3 * Sin(alpha / 2), 0};

pt_cool1_bound_1 = newp; Point(pt_cool1_bound_1) = {265e-3 + r_cool1, 265e-3 * Sin(alpha / 2), 0};
pt_cool1_bound_2 = newp; Point(pt_cool1_bound_2) = {265e-3 - r_cool1, 265e-3 * Sin(alpha / 2), 0};

arc_cool1_1 = newl; Circle(arc_cool1_1) = {pt_cool1_bound_1, pt_center_cool1, pt_cool1_bound_2};
arc_cool1_2 = newl; Circle(arc_cool1_2) = {pt_cool1_bound_2, pt_center_cool1, pt_cool1_bound_1};

// Step 3: Create Gamma_cool2 holes (rectangular lines)
r_inner_cool2 = 208e-3;  // Radius for first row of holes
r_outer_cool2 = 288e-3;  // Radius for second row of holes

// Angular offset for tangent alignment
x_inner = l2 / (2 * r_inner_cool2);
x_outer = l2 / (2 * r_outer_cool2);

// Hole 1 - Inner row
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

epsilon = 1e-10; // to place the point outide the recangle otherwise the arc is always inward
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

