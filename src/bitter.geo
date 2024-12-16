SetFactory("OpenCASCADE");

// Parameters
ri     = 200e-3;      // internal radius [m]
l      = 100e-3;      // length of the bitter [m]
alpha  = Pi/18;    // angle [rad]
r1     = 10e-3;       // diameter of Gamma_cool,1 [m]
w2     = 1.1e-3;      // width of Gamma_cool,2 [m]
l2     = 5.9e-3;      // length of Gamma_cool,2 [m]
height = 4e-3;         // height of the geometry [m]

// Derived parameters
r_cool1 = r1/2;     // radius of the circular hole
r_major = l2/2;     // half of elliptical hole length
r_minor = w2/2;     // half of elliptical hole width

// Step 1: Create the annular sector (the main domain)
p_in1 = newp; Point(p_in1) = {ri*Cos(0),       ri*Sin(0),       0};
p_in2 = newp; Point(p_in2) = {ri*Cos(alpha),    ri*Sin(alpha),   0};

// Outer arc endpoints
p_out1 = newp; Point(p_out1) = {(ri+l)*Cos(0),    (ri+l)*Sin(0),    0};
p_out2 = newp; Point(p_out2) = {(ri+l)*Cos(alpha),(ri+l)*Sin(alpha),0};

p_center = newp; Point(p_center) = {0,0,0};

// Create arcs and lines
// Inner arc
c_in = newl; Circle(c_in) = {p_in1, p_center, p_in2};
// Outer arc
c_out = newl; Circle(c_out) = {p_out1, p_center, p_out2};
// Radial lines
l_in = newl; Line(l_in) = {p_in1, p_out1};
l_out = newl; Line(l_out) = {p_in2, p_out2};

// Create the surface of the annular sector
loop_main = newll; Line Loop(loop_main) = {l_in, c_out, -l_out, -c_in};
surf_main = news; Plane Surface(surf_main) = {loop_main};

// Step 2: create center disk Gamma_cool1
p_centerGamma1 = newp; Point(p_centerGamma1) = {265e-3, 265e-3 * Sin(alpha / 2), 0};

p_circle_bound1 = newp; Point(p_circle_bound1) = {265e-3 + r_cool1, 265e-3 * Sin(alpha / 2), 0};
p_circle_bound2 = newp; Point(p_circle_bound2) = {265e-3 - r_cool1, 265e-3 * Sin(alpha / 2), 0};

c_gamma1 = newl; Circle(c_gamma1) = {p_circle_bound1, p_centerGamma1, p_circle_bound2};
c_gamma2 = newl; Circle(c_gamma2) = {p_circle_bound2, p_centerGamma1, p_circle_bound1};

// Step 3: Create Gamma_cool2 holes

// Define radii for the two rows of holes
r_inner = 208e-3;  // Radius for inner holes
r_outer = 288e-3;  // Radius for outer holes

// Create the first row of holes
p1_gamma2_1 = newp; Point(p1_gamma2_1) = {r_inner - w2/2, r_inner * Sin(alpha / 4) + l2 /2, 0};
p1_gamma2_2 = newp; Point(p1_gamma2_2) = {r_inner - w2/2, r_inner * Sin(alpha / 4) - l2 /2 , 0};
l1_gamma2_1 = newl; Line(l1_gamma2_1) = {p1_gamma2_1, p1_gamma2_2};

p1_gamma2_12 = newp; Point(p1_gamma2_12) = {r_inner + w2/2, r_inner * Sin(alpha / 4) + l2 /2 , 0};
p1_gamma2_22 = newp; Point(p1_gamma2_22) = {r_inner + w2/2, r_inner * Sin(alpha / 4) - l2 /2 , 0};
l1_gamma2_2 = newl; Line(l1_gamma2_2) = {p1_gamma2_12, p1_gamma2_22};	

// l2_gamma2_1 = newl; Line(l2_gamma2_1) = {p1_gamma2_1, p1_gamma2_12}; // to check length
p_centerGamma2 = newp; Point(p_centerGamma2) = {r_inner, r_inner * Sin(alpha / 4) + l2 / 2, 0}; 
c_gamma2_1 = newl; Circle(c_gamma2_1) = {p1_gamma2_1, p_centerGamma2, p1_gamma2_12};

p_centerGamma22 = newp; Point(p_centerGamma22) = {r_inner, r_inner * Sin(alpha / 4) - l2 / 2, 0}; 
c_gamma2_12 = newl; Circle(c_gamma2_12) = {p1_gamma2_22, p_centerGamma22, p1_gamma2_2};


