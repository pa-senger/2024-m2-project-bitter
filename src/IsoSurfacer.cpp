/*
  IsoSurfacer.cpp: Isosurface computation class.
  Copyright (C) 2013  Julien Tierny <tierny@telecom-paristech.fr>

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free Software
  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
*/

#include "IsoSurfacer.h"

// vtkCxxRevisionMacro(IsoSurfacer, "$Revision$");
vtkStandardNewMacro(IsoSurfacer);

IsoSurfacer::IsoSurfacer()
{
    Input = NULL;
    Output = NULL;
    pointSet_ = NULL;
    cellArray_ = NULL;
    fakeScalars_ = NULL;
    Type = SIMPLE;
}

IsoSurfacer::~IsoSurfacer()
{

    if (Output)
        Output->Delete();
    if (pointSet_)
        pointSet_->Delete();
    if (cellArray_)
        cellArray_->Delete();
    if (fakeScalars_)
        fakeScalars_->Delete();
}

int IsoSurfacer::ComputePartialIntersection(const int &tetId)
{

    return 0;
}

int IsoSurfacer::ComputeSimpleIntersection(vtkCell *tet)
{
    // TODO: Implement this function
    // Check if the tetrahedron intersects the level set
    if (!IsCellOnLevelSet(tet))
    {
        return 0; // No intersection
    }

    // Vector to store intersection points
    std::vector<std::vector<double>> intersectionPoints;

    // Iterate through each edge of the tetrahedron
    for (vtkIdType i = 0; i < tet->GetNumberOfEdges(); ++i)
    {
        vtkCell *edge = tet->GetEdge(i);
        if (!edge || edge->GetNumberOfPoints() != 2)
            continue;

        // Extract the edge's endpoints
        vtkIdType p0Id = edge->GetPointId(0);
        vtkIdType p1Id = edge->GetPointId(1);

        // Define the edge as a pair of point IDs
        std::pair<vtkIdType, vtkIdType> edgePair(p0Id, p1Id);

        // Compute the intersection point for this edge
        std::vector<double> intersection = ComputeEdgeIntersection(edgePair);

        if (!intersection.empty())
        {
            intersectionPoints.push_back(intersection);
        }
    }

    // If fewer than 3 points, there's no valid polygon
    if (intersectionPoints.size() < 3)
    {
        return 0; // Not enough points to form a polygon
    }

    // Return the number of vertices in the polygon
    return static_cast<int>(intersectionPoints.size());
}

int IsoSurfacer::FastExtraction()
{

    return 0;
}

int IsoSurfacer::ReOrderTetEdges(
    vector<pair<vtkIdType, vtkIdType>> &edgeList) const
{

    return 0;
}

int IsoSurfacer::SimpleExtraction()
{
    // TODO : Implement this function
    if (!Input)
    {
        std::cerr << "Error: No input mesh available for extraction."
                  << std::endl;
        return 0;
    }

    // Get the number of cells in the input mesh
    vtkIdType numCells = Input->GetNumberOfCells();
    if (numCells == 0)
    {
        std::cerr << "Error: Input mesh contains no cells." << std::endl;
        return 0;
    }

    int intersectionCount = 0;

    // Iterate over all cells in the mesh
    for (vtkIdType i = 0; i < numCells; ++i)
    {
        vtkCell *cell = Input->GetCell(i);

        // Check if the cell is a tetrahedron
        if (cell->GetCellType() == VTK_TETRA)
        {
            // Apply the ComputeSimpleIntersection function
            int result = ComputeSimpleIntersection(cell);

            // Count the number of intersections
            if (result > 0)
            {
                ++intersectionCount;
            }
        }
    }

    std::cout << "Total number of intersected tetrahedra: " << intersectionCount
              << std::endl;

    return intersectionCount;
}

int IsoSurfacer::StandardExtraction()
{

    return 0;
}

void IsoSurfacer::Update()
{

    if (!Input)
    {
        cerr << "[IsoSurfacer] No input defined..." << endl;
        return;
    }

    if (pointSet_)
        pointSet_->Delete();
    pointSet_ = vtkPoints::New();

    if (cellArray_)
        cellArray_->Delete();
    cellArray_ = vtkCellArray::New();

    if (Output)
        Output->Delete();

    if (!fakeScalars_)
        fakeScalars_ = vtkDoubleArray::New();

    Output = vtkPolyData::New();
    Output->SetPoints(pointSet_);
    Output->SetPolys(cellArray_);
    Output->GetPointData()->SetScalars(fakeScalars_);

    scalarField_ = Input->GetPointData()->GetScalars();

    DebugMemory memory;
    DebugTimer timer;

    switch (Type)
    {

    case SIMPLE:
        cout << "[IsoSurfacer] Using simple implementation..." << endl;
        SimpleExtraction();
        break;

    case STANDARD:
        cout << "[IsoSurfacer] Using standard implementation..." << endl;
        StandardExtraction();
        break;

    case FAST:
        cout << "[IsoSurfacer] Using fast implementation..." << endl;
        FastExtraction();
        break;
    }

    cout << setprecision(4);

    cout << "[IsoSurfacer] IsoSurface extracted ("
         << Output->GetNumberOfPoints() << " vertices, "
         << Output->GetNumberOfCells() << " faces)." << endl;
    cout << "[IsoSurfacer] Extraction performed in " << timer.getElapsedTime()
         << " s. (memory usage: " << memory.getInstantUsage() << " MB)."
         << endl;

    // add a scalar value to the isosurface to make sure it gets colored by the
    // rest of the pipeline
    fakeScalars_->SetNumberOfTuples(Output->GetNumberOfPoints());
    for (int i = 0; i < Output->GetNumberOfPoints(); i++)
        fakeScalars_->SetComponent(i, 0, Value);
}
