---
title: iOS Metal数组计算
date: 2024-08-23T21:57:07+08:00
tags: ["iOS", "Metal"]
categories: ["编程"]

---

将两个数组相应的位置相加，得到另外一个数组。比如：[1, 2, 3] + [1, 2, 3] = [1, 4, 6]。

```
void add_arrays(int *array1, 
                int *array2,
                int *result,
                int length)
{
  for(int i = 0; i < length; i++) {
     result[i] = array1[i] + array[i];
  }
}
```

上面的例子是单线程执行的，要循环多次才得到结果。我们可以利用 GPU 并发地计算。

![](/images/metal_compute_arrays.png)

如图，我们可以把上面的计算步骤放在不同的线程执行，这样可以更快得到结果。下面，我们用 GPU 计算数组结果。

## Metal Shading Language (MSL)

MSL 是一种为 GPU 编程设计的 C++ 变体语言。GPU 中运行的代码称为 Shader。

```
// device 设置地址空间 （GPU 读写）
// [thread_position_in_grid] 为参数属性
kernel void add_arrays(device const float* inA,
                       device const float* inB,
                       device float* result,
                       uint index [[thread_position_in_grid]])
{
    result[index] = inA[index] + inB[index];
} 
```

## Code

```
// Swift 实现

func addArrays() {
    // 1
    guard let device = MTLCreateSystemDefaultDevice() else {
        return
    }

    // 2 
    let library = device.makeDefaultLibrary()
    guard let function = library?.makeFunction(name: "add_arrays") else {
        return
    }
    
    // 3
    guard let pipelineState = try? device.makeComputePipelineState(function: function) else {
        return
    }}
    
    // 4
    guard let commandQueue = device.makeCommandQueue() else {
        return
    }

   // 5 
    let length = 5, floatStride = MemoryLayout<Float>.stride, bytesLength = length * floatStride
    guard let buffer1 = device.makeBuffer(length: bytesLength, options: .storageModeShared),
          let buffer2 = device.makeBuffer(length: bytesLength, options: .storageModeShared),
          let resultBuffer = device.makeBuffer(length: bytesLength, options: .storageModeShared) else {
        return
    }

    // 6
    let generateBuffer: ( (any MTLBuffer) -> Void ) = {
        var contents = $0.contents()
        for _ in 0...length - 1 {
            let random = Float(Int.random(in: 1...300))
            contents.storeBytes(of: random, as: Float.self)
            contents = contents.advanced(by: floatStride)
        }
    }
    generateBuffer(buffer1)
    generateBuffer(buffer2)
    
     // 6
    guard let commandBuffer = commandQueue.makeCommandBuffer() else {
        return
    }

    // 7
    guard let commandEncoder = commandBuffer.makeComputeCommandEncoder() else {
        return
    }
    
    // 8  
    commandEncoder.setComputePipelineState(pipelineState)
    commandEncoder.setBuffer(buffer1, offset: 0, index: 0)
    commandEncoder.setBuffer(buffer2, offset: 0, index: 1)
    commandEncoder.setBuffer(resultBuffer, offset: 0, index: 2)

    // 9
    var maxThreadGroup = pipelineState.maxTotalThreadsPerThreadgroup
    if maxThreadGroup > length {
        maxThreadGroup = length
    }
    commandEncoder.dispatchThreadgroups(MTLSizeMake(length, 1, 1), threadsPerThreadgroup: MTLSizeMake(maxThreadGroup, 1, 1))

    // 10
    commandEncoder.endEncoding()
    
    // 11
    commandBuffer.commit()
    commandBuffer.waitUntilCompleted()
```

1 获取 GPU 设备。

2 获取函数引用。

3 函数引用只是 MSL 函数的代理对象。通过 pipeline，把函数引用转换为 GPU 可执行的代码。pipeline 声明特定的任务。

4 通过命令队列，提交命令到 GPU。

5 创建缓存 MTLBuffer

6 加载缓存 MTLBuffer

7 创建 CommondBuffer

8 配置 CommandEncoder，设置 pipeline和参数（MTLBuffer）。

9 配置线程和数据组织。

10 CommandEncoder 编码

11 CommondBuffer 提交

## 参考

[Performing Calculations on a GPU](https://developer.apple.com/documentation/metal/performing_calculations_on_a_gpu)