using System.Numerics;

namespace ScramblePlugin;

/// <summary>
/// Point-in-polygon containment tests using the ray-casting algorithm on the XZ plane.
/// The Y component of all vectors is ignored.
/// </summary>
public static class PolygonContainment
{
    /// <summary>
    /// Tests whether <paramref name="point"/> lies inside the polygon defined by
    /// <paramref name="vertices"/> using the even-odd ray-casting rule on the XZ plane.
    /// </summary>
    /// <param name="vertices">
    /// Polygon vertices. Each entry must have at least 2 elements.
    /// If 3 elements are present, index 0 = X and index 2 = Z.
    /// If 2 elements are present, index 0 = X and index 1 = Z.
    /// </param>
    /// <param name="point">World-space position to test.</param>
    /// <returns><c>true</c> if the point is inside the polygon.</returns>
    public static bool IsInside(IReadOnlyList<float[]> vertices, Vector3 point)
    {
        int count = vertices.Count;
        if (count < 3) return false;

        float px = point.X;
        float pz = point.Z;
        bool inside = false;

        for (int i = 0, j = count - 1; i < count; j = i++)
        {
            float xi = vertices[i][0];
            float zi = vertices[i].Length >= 3 ? vertices[i][2] : vertices[i][1];
            float xj = vertices[j][0];
            float zj = vertices[j].Length >= 3 ? vertices[j][2] : vertices[j][1];

            // Check if the ray from point in the +X direction crosses edge (i, j).
            bool intersects = ((zi > pz) != (zj > pz))
                              && (px < (xj - xi) * (pz - zi) / (zj - zi) + xi);

            if (intersects) inside = !inside;
        }

        return inside;
    }

    /// <summary>
    /// Returns the first <see cref="StartAreaConfig"/> whose polygon contains
    /// <paramref name="point"/>, or <c>null</c> if the point is outside all areas.
    /// </summary>
    public static StartAreaConfig? FindContainingArea(
        IEnumerable<StartAreaConfig> areas, Vector3 point)
    {
        foreach (var area in areas)
        {
            if (IsInside(area.Vertices, point))
                return area;
        }
        return null;
    }
}
