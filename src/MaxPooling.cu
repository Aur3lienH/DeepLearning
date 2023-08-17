#include "MaxPooling.cuh"


MaxPoolLayer::MaxPoolLayer(int filterSize, int stride) : PoolingLayer(filterSize, stride)
{
    LayerID = 4;
}

#if USE_GPU

const Matrix_GPU* MaxPoolLayer::FeedForward(const Matrix_GPU* input)
{
    result->Reshape(layerShape->dimensions[0], layerShape->dimensions[1], layerShape->dimensions[2]);
    Matrix::MaxPool(input, result, filterSize, stride);
    return result;
}

Matrix_GPU* MaxPoolLayer::BackPropagate(const Matrix* delta, const Matrix_GPU* previousActivation)
{
    // The idea is that if an element is the maximum than maxPool has selected, then the delta is
    // the same as the previous delta, because the current element is the only one affecting the result.

    for (int m = 0; m < layerShape->dimensions[2]; m++)
    {
        for (int i = 0; i < layerShape->dimensions[0]; ++i)
        {
            for (int j = 0; j < layerShape->dimensions[1]; ++j)
            {
                for (int k = 0; k < filterSize; ++k)
                {
                    for (int l = 0; l < filterSize; ++l)
                    {
                        const int r = i * stride + k;
                        //if (r >= previousActivation->getRows())
                        //    continue;
                        const int c = j * stride + l;
                        //if (c >= previousActivation->getCols())
                        //    continue;
                        //std::cout << m  << "  " << i << "  " << j << "  " << k << "  " << l << "\n";
                        //std::cout << r << " : x y : " << c << "\n";
                        //std::cout << (*previousActivation)(r,c) << "\n";

                        if (r >= previousActivation->getRows())
                            continue;
                        if (c >= previousActivation->getCols())
                            continue;


                        if ((*previousActivation)(r, c) == (*result)(i, j))
                            (*newDelta)(r, c) = (*delta)(i, j);
                        // Should already be 0
                        //else
                        //    (*newDelta)(r,c) = 0.0;
                    }
                }
            }
        }
        previousActivation->GoToNextMatrix();
        result->GoToNextMatrix();
        newDelta->GoToNextMatrix();
        delta->GoToNextMatrix();
    }


    previousActivation->ResetOffset();
    result->ResetOffset();
    newDelta->ResetOffset();
    delta->ResetOffset();


    return newDelta;
}

#else

const Matrix* MaxPoolLayer::FeedForward(const Matrix* input)
{
    result->Reshape(layerShape->dimensions[0], layerShape->dimensions[1], layerShape->dimensions[2]);
    Matrix::MaxPool(input, result, filterSize, stride);
    return result;
}

Matrix* MaxPoolLayer::BackPropagate(const Matrix* delta, const Matrix* previousActivation)
{
    // The idea is that if an element is the maximum than maxPool has selected, then the delta is
    // the same as the previous delta, because the current element is the only one affecting the result.

    for (int m = 0; m < layerShape->dimensions[2]; m++)
    {
        for (int i = 0; i < layerShape->dimensions[0]; ++i)
        {
            for (int j = 0; j < layerShape->dimensions[1]; ++j)
            {
                for (int k = 0; k < filterSize; ++k)
                {
                    for (int l = 0; l < filterSize; ++l)
                    {
                        const int r = i * stride + k;
                        //if (r >= previousActivation->getRows())
                        //    continue;
                        const int c = j * stride + l;
                        //if (c >= previousActivation->getCols())
                        //    continue;
                        //std::cout << m  << "  " << i << "  " << j << "  " << k << "  " << l << "\n";
                        //std::cout << r << " : x y : " << c << "\n";
                        //std::cout << (*previousActivation)(r,c) << "\n";

                        if (r >= previousActivation->getRows())
                            continue;
                        if (c >= previousActivation->getCols())
                            continue;


                        if ((*previousActivation)(r, c) == (*result)(i, j))
                            (*newDelta)(r, c) = (*delta)(i, j);
                        // Should already be 0
                        //else
                        //    (*newDelta)(r,c) = 0.0;
                    }
                }
            }
        }
        previousActivation->GoToNextMatrix();
        result->GoToNextMatrix();
        newDelta->GoToNextMatrix();
        delta->GoToNextMatrix();
    }


    previousActivation->ResetOffset();
    result->ResetOffset();
    newDelta->ResetOffset();
    delta->ResetOffset();


    return newDelta;
}

#endif

std::string MaxPoolLayer::getLayerTitle()
{
    std::string buf;
    buf += "MaxPool Layer\n";
    buf += "Size: " + std::to_string(filterSize) + "\n";
    buf += "Stride: " + std::to_string(stride) + "\n";
    buf += "Output : " + layerShape->GetDimensions() + "\n";
    return buf;
}

Layer* MaxPoolLayer::Clone()
{
    return new MaxPoolLayer(filterSize, stride);
}

Layer* MaxPoolLayer::Load(std::ifstream& reader)
{
    int _filterSize;
    int _tempStride;
    reader.read(reinterpret_cast<char*>(&_filterSize), sizeof(int));
    reader.read(reinterpret_cast<char*>(&_tempStride), sizeof(int));
    return new MaxPoolLayer(_filterSize, _tempStride);
}

void MaxPoolLayer::SpecificSave(std::ofstream& writer)
{
    int tempFilterSize = filterSize;
    int tempStride = stride;
    writer.write(reinterpret_cast<char*>(&tempFilterSize), sizeof(int));
    writer.write(reinterpret_cast<char*>(&tempStride), sizeof(int));
}