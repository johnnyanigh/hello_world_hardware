#include <iostream>
#include <stdio.h>
#include <math.h>

// Add all of the elements of the two arrays together using the device (GPU)
__global__ void add(int n, float *x, float *y) {

  // Calculate the starting value for the for loop's index
  int index = ( blockDim.x * blockIdx.x ) + threadIdx.x;

  // Calculate the stride between elements of the arrays
  int stride = blockDim.x * gridDim.x;

  // Add the elements from array x and array y within the block
  for (int i = index; i < n; i += stride)
    // Store the result in y
    y[i] = x[i] + y[i];
}

int main(void) {

  // Error code to check return values for CUDA calls
  cudaError_t err = cudaSuccess;

  // The number of elements in each array (1,048,576)
  int num_of_elements = 1<<20;

  // The total memory size for one array of the float data type
  int size = num_of_elements * sizeof(float);

  // Pointers (float) for the arrays
  float* x = NULL;
  float* y = NULL;

  // Print some intro. messages using the host (CPU)
  printf("Hello, world from CUDA C!\n");
  printf("Each array will have %d elements\n", num_of_elements);

  // Allocate memory for array x in the Unified Memory (shared memory between
  // the host and device)
  err = cudaMallocManaged(&x, size);

  // Display the error message (if applicable)
  if ( err != cudaSuccess) {
    printf("Failed to allocate memory for array x in the unified memory!\n");
    fprintf( stderr, "Error code: %s\n", cudaGetErrorString(err) );
    exit(EXIT_FAILURE);
  }

  // Allocate memory for array y in the Unified Memory
  err = cudaMallocManaged(&y, size);

  // Display the error message (if applicable)
  if ( err != cudaSuccess) {
    printf("Failed to allocate memory for array y in the unified memory!\n");
    fprintf( stderr, "Error code: %s\n", cudaGetErrorString(err) );
    exit(EXIT_FAILURE);
  }

  // Initialize the arrays on the host
  for ( int i = 0; i < num_of_elements; i++ ) {
    x[i] = 1.0f;
    y[i] = 2.0f;
  }

  // Tell the user we are launching the kernel
  printf("Launching the CUDA kernel\n");

  // The number of threads per block
  int block_size = 256;

  // The number of blocks in the grid
  int grid_size = (num_of_elements + block_size - 1)/(block_size);

  // Run the GPU kernel
  add<<<grid_size, block_size>>>(num_of_elements, x, y);

  // Get the status message from the device
  err = cudaGetLastError();

  // Display the error message (if applicable)
  if ( err != cudaSuccess ) {
    printf("Failed to launch CUDA kernel\n");
    fprintf( stderr, "Error code: %s\n", cudaGetErrorString(err) );
    exit(EXIT_FAILURE);
  }

  // Wait for GPU to finish before continuing on the host
  cudaDeviceSynchronize();

  // Check for errors (all of the values should equal 3.0f)
  float maxError = 0.0f;

  // Calculate the max. error (all of the sums were stored in the array y)
  for (int i = 0; i < num_of_elements; i++) {
    maxError = fmax(maxError, fabs(y[i] - 3.0f));
  }

  // Display the max. error
  printf("Max error: %f\n", maxError);

  // Free the Unified memory
  cudaFree(x);
  cudaFree(y);

  return 0;
}
