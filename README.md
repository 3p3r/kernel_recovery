# kernel recovery

Image effect kernel recovery with Matlab. This is an experimental algorithm which can reverse-extract a custom filter applied to an image in Photoshop. Its result is highly dependent on its input and output. Sample data is provided with their kernels.

Data sets 1,2,3 kernels:
```
    0.0000    2.0000   -1.0000   -1.0000    1.0000
    0.0000   -2.0000    1.0000    1.0000   -1.0000
   -1.0000   -2.0000    2.0000    0.0000    1.0000
    0.0000    1.0000    2.0000   -1.0000    0.0000
   -1.0000   -1.0000    1.0000   -1.0000    0.0000
```

Data set #4 kernel:
```
    0.0000    0.0000    0.0000    0.0000    0.0000
    0.0000    0.0000   -1.0000    0.0000    0.0000
    0.0000   -1.0000    3.0000   -1.0000    0.0000
    0.0000    0.0000   -1.0000    0.0000    0.0000
    0.0000    0.0000    0.0000    0.0000    0.0000
```

Data set #5 kernel:
```
    3.0000    0.0000    0.0000    0.0000    3.0000
    0.0000    0.0000   -1.0000    0.0000    0.0000
    1.0000   -1.0000   -2.0000   -1.0000    0.0000
    0.0000    0.0000   -1.0000    0.0000    0.0000
    1.0000    0.0000    0.0000    0.0000   -1.0000
```

Data sets 6,7, and 8 are inputs which this algorithm fails on.
