import torch
x=torch.rand(25, 20)
print(x)

if torch.cuda.is_available():
    print("CUDA works!")
else:
    print("CUDA doesn't work!")
