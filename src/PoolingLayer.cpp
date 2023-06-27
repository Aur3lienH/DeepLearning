#include "PoolingLayer.h"


void PoolingLayer::ClearDelta()
{

}

PoolingLayer::PoolingLayer(int filterSize, int stride) : filterSize(filterSize), stride(stride), result(nullptr), newDelta(nullptr)
{

}

void PoolingLayer::UpdateWeights(double learningRate, int batchSize)
{
    // No weights nor biases
}

void PoolingLayer::Compile(LayerShape* previousActivation)
{
    layerShape = new LayerShape(previousActivation->dimensions[0] / stride + 1, previousActivation->dimensions[1] / stride + 1, previousOutput->dimensions[2]);
    result = new Matrix(layerShape->dimensions[0], layerShape->dimensions[1]);
    newDelta = new Matrix(previousActivation->dimensions[0], previousActivation->dimensions[1], (double)0);
}

const Matrix* PoolingLayer::getResult() const
{
    return result;
}

void PoolingLayer::AddDeltaFrom(Layer* layer)
{

}

void PoolingLayer::SpecificSave(std::ofstream& writer)
{
    writer.write((char*)&filterSize, sizeof(int));
    writer.write((char*)&stride, sizeof(int));
}
