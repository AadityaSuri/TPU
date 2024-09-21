import numpy as np
import threading

class PE:
    def __init__(self):
        self.value = 0

    def step(self, x_in, y_in):
        self.value += x_in * y_in
    

class SystolicArray:
    def __init__(self, N):
        self.N = N
        self.sys_array = [[PE() for _ in range(N)] for _ in range(N)]

    def mult(self, A, B):
        in_A, in_B = self.arrange(A, B)

        for clk in range(2*self.N - 1):
            for i in range(self.N):
                for j in range(self.N):
                    if 0 <= clk - i < self.N and 0 <= clk - j < self.N:
                        a_val = in_A[i, clk - i] if clk - i < in_A.shape[1] else 0
                        b_val = in_B[clk - j, j] if clk - j < in_B.shape[0] else 0
                        self.sys_array[i][j].step(a_val, b_val)

        result = np.zeros((self.N, self.N))
        for i in range(self.N):
            for j in range(self.N):
                result[i, j] = self.sys_array[i][j].value

        return result


    def arrange(self, A, B):
        in_A = np.zeros((self.N, 2*self.N - 1))
        in_B = np.zeros((2*self.N - 1, self.N))

        for i in range(self.N):
            start_index = (2*self.N - 1) - i - self.N
            end_index = start_index + self.N


            in_A[i, start_index:end_index] = A[i, :]
            in_B[start_index:end_index, i] = B[:, i]
        
        return in_A, in_B
    
if __name__ == "__main__":
    N = 4
    A = np.random.randint(0, 5, size=(N, N))
    B = np.random.randint(0, 5, size=(N, N))

    print(A)
    print(B)
    print()

    sys_array = SystolicArray(N)
    print(sys_array.mult(A, B))

    actual_mult = np.matmul(A, B)
    print(actual_mult)
    
    # in_A, in_B = sys_array.arrange(A, B)

    # print(in_A)
    # print(in_B)




