# Flow Mapping 

This was a study of flow of a air tunnel. The tunnel has 500x500mm of section area, and we did measurement of pressure each 50mm until complete 400x400mm section area(X and Z axis), using a Pitot Tube with the a digital manometer, thus totaling 81 points of pressure measured. Was realized three mappings, each in different distance(Y axis) from the begin of tunnel face, the first mapping was done with 50mm of distance of begin of the tunnel, the next mappings was 200mm and 300mm. For the each mapping was generated a matrix of this results, with the coordinates of each pressure.

## Database Tratament

Importing, combining and identifying the results of each mapping.

| X axis  | Z axis  | Y aix   | Pressure |
|---------|---------|---------|----------|
| mm      | mm      | mm      | Pa       |
| 50      | 50      | 50      | 54.90 |
| 100     | 50      | 50      | 54.92 |
| 150     | 50      | 50      | 54.84 |
| 200     | 50      | 50      | 54.81 |
| 250     | 50      | 50      | 54.75 |
| 300     | 50      | 50      | 54.67 |
| ...     | ...      | ...      | ... |


## Plotting the mappings

Below we can see the heatmaps of mappings of each distance. Utilizing ```geom_raster()``` with ```Interpolate=TRUE```, thus we can see better the differences of pressure on flow.of flow in section area with 300mm of distance from the begin.

### 50mm Plot
This is a heatmap of flow in section area with 50mm of distance from the begin.

<div aling="center">
<img src = "https://github.com/user-attachments/assets/2950c9f5-3d93-46a0-8d87-b28312a609d6"
</div>


### 200mm Plot
This is a heatmap of flow in section area with 200mm of distance from the begin.

<div aling="center">
<img src = "https://github.com/user-attachments/assets/a4c01972-7184-44f9-b767-5eba2ba6f40d"
</div>
  
### 300mm Plot
This is a heatmap of flow in section area with 300mm of distance from the begin.

<div aling="center">
<img src = "https://github.com/user-attachments/assets/cad5572f-a32b-40ee-9872-5ca05d045e19"
</div>

  
## Conclusion
The differences between pressures is lower than 1% in each mapping, even with the distance of between they. We can admit that is very stable and uniform.And we created a gif of the heat map that goes 50mm until 300mm with an interpolation of intermediate results.

<div aling="center">
<img src = "https://github.com/user-attachments/assets/12c94394-3f50-431f-b42d-707976b4ffe5"
</div>
