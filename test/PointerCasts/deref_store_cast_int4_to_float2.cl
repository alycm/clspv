// RUN: clspv %s -S -o %t.spvasm
// RUN: FileCheck %s < %t.spvasm
// RUN: clspv %s -o %t.spv
// RUN: spirv-dis -o %t2.spvasm %t.spv
// RUN: FileCheck %s < %t2.spvasm
// RUN: spirv-val --target-env vulkan1.0 %t.spv

// CHECK: ; SPIR-V
// CHECK: ; Version: 1.0
// CHECK: ; Generator: Codeplay; 0
// CHECK: ; Bound: 29
// CHECK: ; Schema: 0
// CHECK: OpCapability Shader
// CHECK: OpCapability VariablePointers
// CHECK: OpExtension "SPV_KHR_variable_pointers"
// CHECK: OpMemoryModel Logical GLSL450
// CHECK: OpEntryPoint GLCompute %[[FOO_ID:[a-zA-Z0-9_]*]] "foo"
// CHECK: OpExecutionMode %[[FOO_ID]] LocalSize 1 1 1
// CHECK: OpDecorate %[[INT4_DYNAMIC_ARRAY_TYPE_ID:[a-zA-Z0-9_]*]] ArrayStride 16
// CHECK: OpMemberDecorate %[[ARG0_STRUCT_TYPE_ID:[a-zA-Z0-9_]*]] 0 Offset 0
// CHECK: OpDecorate %[[ARG0_STRUCT_TYPE_ID]] BufferBlock

// CHECK: OpDecorate %[[FLOAT2_DYNAMIC_ARRAY_TYPE_ID:[a-zA-Z0-9_]*]] ArrayStride 8
// CHECK: OpMemberDecorate %[[ARG1_STRUCT_TYPE_ID:[a-zA-Z0-9_]*]] 0 Offset 0
// CHECK: OpDecorate %[[ARG1_STRUCT_TYPE_ID]] BufferBlock

// CHECK: OpDecorate %[[ARG0_ID:[a-zA-Z0-9_]*]] DescriptorSet 0
// CHECK: OpDecorate %[[ARG0_ID]] Binding 0
// CHECK: OpDecorate %[[ARG1_ID:[a-zA-Z0-9_]*]] DescriptorSet 0
// CHECK: OpDecorate %[[ARG1_ID]] Binding 1

// CHECK: %[[INT_TYPE_ID:[a-zA-Z0-9_]*]] = OpTypeInt 32 0
// CHECK: %[[INT4_TYPE_ID:[a-zA-Z0-9_]*]] = OpTypeVector %[[INT_TYPE_ID]] 4
// CHECK: %[[INT4_DYNAMIC_ARRAY_TYPE_ID]] = OpTypeRuntimeArray %[[INT4_TYPE_ID]]
// CHECK: %[[ARG0_STRUCT_TYPE_ID]] = OpTypeStruct %[[INT4_DYNAMIC_ARRAY_TYPE_ID]]
// CHECK: %[[ARG0_POINTER_TYPE_ID:[a-zA-Z0-9_]*]] = OpTypePointer StorageBuffer %[[ARG0_STRUCT_TYPE_ID]]

// CHECK: %[[FLOAT_TYPE_ID:[a-zA-Z0-9_]*]] = OpTypeFloat 32
// CHECK: %[[FLOAT2_TYPE_ID:[a-zA-Z0-9_]*]] = OpTypeVector %[[FLOAT_TYPE_ID]] 2
// CHECK: %[[FLOAT2_GLOBAL_POINTER_TYPE_ID:[a-zA-Z0-9_]*]] = OpTypePointer StorageBuffer %[[FLOAT2_TYPE_ID]]
// CHECK: %[[FLOAT2_DYNAMIC_ARRAY_TYPE_ID]] = OpTypeRuntimeArray %[[FLOAT2_TYPE_ID]]
// CHECK: %[[ARG1_STRUCT_TYPE_ID]] = OpTypeStruct %[[FLOAT2_DYNAMIC_ARRAY_TYPE_ID]]
// CHECK: %[[ARG1_POINTER_TYPE_ID:[a-zA-Z0-9_]*]] = OpTypePointer StorageBuffer %[[ARG1_STRUCT_TYPE_ID]]

// CHECK: %[[VOID_TYPE_ID:[a-zA-Z0-9_]*]] = OpTypeVoid
// CHECK: %[[FOO_TYPE_ID:[a-zA-Z0-9_]*]] = OpTypeFunction %[[VOID_TYPE_ID]]
// CHECK: %[[INT2_TYPE_ID:[a-zA-Z0-9_]*]] = OpTypeVector %[[INT_TYPE_ID]] 2
// CHECK: %[[INT_GLOBAL_POINTER_TYPE_ID:[a-zA-Z0-9_]*]] = OpTypePointer StorageBuffer %[[INT_TYPE_ID]]
// CHECK: %[[CONSTANT_0_ID:[a-zA-Z0-9_]*]] = OpConstant %[[INT_TYPE_ID]] 0
// CHECK: %[[CONSTANT_1_ID:[a-zA-Z0-9_]*]] = OpConstant %[[INT_TYPE_ID]] 1

// CHECK: %[[ARG0_ID]] = OpVariable %[[ARG0_POINTER_TYPE_ID]] StorageBuffer
// CHECK: %[[ARG1_ID]] = OpVariable %[[ARG1_POINTER_TYPE_ID]] StorageBuffer

// CHECK: %[[FOO_ID]] = OpFunction %[[VOID_TYPE_ID]] None %[[FOO_TYPE_ID]]
// CHECK: %[[LABEL_ID:[a-zA-Z0-9_]*]] = OpLabel

// CHECK: %[[B_ACCESS_CHAIN_ID:[a-zA-Z0-9_]*]] = OpAccessChain %[[FLOAT2_GLOBAL_POINTER_TYPE_ID]] %[[ARG1_ID]] %[[CONSTANT_0_ID]] %[[CONSTANT_0_ID]]
// CHECK: %[[B_LOAD_ID:[a-zA-Z0-9_]*]] = OpLoad %[[FLOAT2_TYPE_ID]] %[[B_ACCESS_CHAIN_ID]]
// CHECK: %[[B_BITCAST_ID:[a-zA-Z0-9_]*]] = OpBitcast %[[INT2_TYPE_ID]] %[[B_LOAD_ID]]
// CHECK: %[[X_ID:[a-zA-Z0-9_]*]] = OpCompositeExtract %[[INT_TYPE_ID]] %[[B_BITCAST_ID]] 0
// CHECK: %[[Y_ID:[a-zA-Z0-9_]*]] = OpCompositeExtract %[[INT_TYPE_ID]] %[[B_BITCAST_ID]] 1

// CHECK: %[[A0_ACCESS_CHAIN_ID:[a-zA-Z0-9_]*]] = OpAccessChain %[[INT_GLOBAL_POINTER_TYPE_ID]] %[[ARG0_ID]] %[[CONSTANT_0_ID]] %[[CONSTANT_0_ID]] %[[CONSTANT_0_ID]]
// CHECK: OpStore %[[A0_ACCESS_CHAIN_ID]] %[[X_ID]]

// CHECK: %[[A1_ACCESS_CHAIN_ID:[a-zA-Z0-9_]*]] = OpAccessChain %[[INT_GLOBAL_POINTER_TYPE_ID]] %[[ARG0_ID]] %[[CONSTANT_0_ID]] %[[CONSTANT_0_ID]] %[[CONSTANT_1_ID]]
// CHECK: OpStore %[[A1_ACCESS_CHAIN_ID]] %[[Y_ID]]

// CHECK: OpReturn
// CHECK: OpFunctionEnd


void kernel __attribute__((reqd_work_group_size(1, 1, 1))) foo(global int4* a, global float2* b)
{
  *((global float2*)a) = *b;
}
