#pragma once

#include "Network.cuh"
#include "Matrix.cuh"
#include <iostream>
#include <mutex>
#include <condition_variable>

class ThreadArg
{
public:
    ThreadArg(Network* network, Matrix*** data, std::mutex* mutex, std::condition_variable* cv, int batchSize,
              int numberOfBatch);

    Network* network;
    Matrix*** data;
    std::condition_variable* cv;
    int batchSize;
    int numberOfBatch;
    std::mutex* mutex;
};