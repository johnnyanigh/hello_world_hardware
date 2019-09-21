#include <iostream>
#include <math.h>

// For puts and fprintf.
#include <stdio.h>

// Kernel function to add the elements of two arrays
__global__ void add(int n, float *x, float *y) {

  int index = ( blockDim.x * blockIdx.x ) + threadIdx.x;

  int stride = blockDim.x * gridDim.x;

  for (int i = index; i < n; i += stride)
    y[i] = x[i] + y[i];
}

int main(void) {

  // Print a message.
  puts("Hello, world from CUDA C!");

  // Error code to check return values for CUDA calls
  cudaError_t err = cudaSuccess;

  // The number of elements in each array.
  int num_of_elements = 1<<20;

  // The size in memory of the array of floats.
  int size = num_of_elements * sizeof(float);

  // Print a message.
  printf("Each array will have %d elements\n", num_of_elements);

  // Allocate memory for the arrays in the Unified Memory.
  float *x = NULL;
  float *y = NULL;

  err = cudaMallocManaged(&x, size);

  // Display the error message.
  if ( err != cudaSuccess) {
    puts("Failed to allocate memory for array x in the unified memory!");
    fprintf( stderr, "Error code: %s\n", cudaGetErrorString(err) );
    exit(EXIT_FAILURE);
  }

  err = cudaMallocManaged(&y, size);

  // Display the error message.
  if ( err != cudaSuccess) {
    puts("Failed to allocate memory for array y in the unified memory!");
    fprintf( stderr, "Error code: %s\n", cudaGetErrorString(err) );
    exit(EXIT_FAILURE);
  }

  // initialize x and y arrays on the host
  for ( int i = 0; i < num_of_elements; i++ ) {
    x[i] = 1.0f;
    y[i] = 2.0f;
  }

  puts("Launching CUDA kernel");

  // The number of threads per block.
  int block_size = 256;

  int grid_size = ( num_of_elements + block_size - 1) / (block_size);

  // Run kernel on 1M elements on the GPU.
  add<<<grid_size, block_size>>>(num_of_elements, x, y);

  err = cudaGetLastError();

  if ( err != cudaSuccess ) {
    puts("Failed to launch CUDA kernel");
    fprintf( stderr, "Error code: %s\n", cudaGetErrorString(err) );
    exit(EXIT_FAILURE);
  }

  // Wait for GPU to finish before accessing on host
  cudaDeviceSynchronize();

  // Check for errors (all values should be 3.0f)
  float maxError = 0.0f;

  for (int i = 0; i < num_of_elements; i++) {
    maxError = fmax( maxError, fabs( y[i]-3.0f ) );
  }

  std::cout << "Max error: " << maxError << std::endl;

  // Free the unified memory.
  cudaFree(x);
  cudaFree(y);

  return 0;
}
