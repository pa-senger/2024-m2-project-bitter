//------------------------------------------------------------
// Use OpenCASCADE geometry kernel
//------------------------------------------------------------
SetFactory("OpenCASCADE");

//------------------------------------------------------------
// Parameters
//------------------------------------------------------------
ri     = 200;      // internal radius [mm]
l      = 100;      // length of the bitter [mm]
alpha  = Pi/18;    // angle [rad]
r1     = 10;       // diameter of Γcool,1 [mm]
w2     = 1.1;      // width of Γcool,2 [mm]
l2     = 5.9;      // length of Γcool,2 [mm]
height = 4;         // height of the geometry [mm]

// Derived parameters
r_cool1 = r1/2;     // radius of the circular hole
r_major = l2/2;     // half of elliptical hole length
r_minor = w2/2;     // half of elliptical hole width

//------------------------------------------------------------
// Step 1: Create the annular sector (the main domain)
//------------------------------------------------------------
// The annular sector is defined by inner radius ri, outer radius (ri + l), 
// and angle alpha.
// We'll create four points and construct arcs and lines between them.

// Define boundary points
// Inner arc endpoints
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


