#pragma once

#include <iostream>
#include <vector>
#include "Tools/Serializer.cuh"
#include "Matrix.cuh"
#include "LayerShape.cuh"
#include "Optimizers.cuh"

class Layer
{
public:
    Layer();

    virtual ~Layer();

#if USE_GPU
    virtual const Matrix_GPU* FeedForward(const Matrix_GPU* input) = 0;

    virtual const Matrix_GPU* BackPropagate(const Matrix_GPU* delta, const Matrix_GPU* previousActivation) = 0;

    [[nodiscard]] virtual const Matrix_GPU* getResult() const = 0;
#else
    virtual const Matrix* FeedForward(const Matrix* input) = 0;

    virtual const Matrix* BackPropagate(const Matrix* delta, const Matrix* previousActivation) = 0;

    [[nodiscard]] virtual const Matrix* getResult() const = 0;
#endif
    virtual void ClearDelta() = 0;


    virtual void UpdateWeights(double learningRate, int batchSize) = 0;

    virtual void AddDeltaFrom(Layer* layer) = 0;

    virtual void AverageGradients(int batchSize) = 0;

    //Must define the layerShape !
    void Compile(LayerShape* previousOutput, Opti opti);

    virtual void Compile(LayerShape* previousOutput) = 0;

    LayerShape* GetLayerShape();

    virtual std::string getLayerTitle() = 0;

    virtual Layer* Clone() = 0;

    static Layer* Load(std::ifstream& reader);

    virtual void SpecificSave(std::ofstream& writer) = 0;

    void Save(std::ofstream& writer);

protected:
    int LayerID;
    LayerShape* layerShape;
    Optimizer* optimizer = nullptr;
};
