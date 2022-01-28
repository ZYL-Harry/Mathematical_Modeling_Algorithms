"""
禁忌搜索算法求解TSP问题
随机在（0,101）二维平面生成20个点
得到最短路径
"""
import math
import random
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.pylab import mpl

mpl.rcParams['font.sans-serif'] = ['SimHei']  # 添加这条可以让图形显示中文


# 计算路径距离，即评价函数
def calFitness(line, dis_matrix):
    dis_sum = 0
    dis = 0
    for i in range(len(line)):  # 0,1,2,...,19
        if i < len(line) - 1:   # i<19：算节点与下一个节点的距离；i=19：算节点与最初点的距离:
            dis = dis_matrix.loc[line[i], line[i + 1]]  # 计算距离
            dis_sum = dis_sum + dis
        else:
            dis = dis_matrix.loc[line[i], line[0]]
            dis_sum = dis_sum + dis
    return round(dis_sum, 1)    # 返回路径距离


def traversal_search(line, dis_matrix, tabu_list):
    '''邻域随机遍历搜索'''
    traversal = 0  # 搜索次数
    traversal_list = []  # 存储局部搜索生成的解,也充当局部禁忌表
    traversal_value = []  # 存储局部解对应路径距离
    while traversal <= traversalMax:    # 局部进行traversalMax次搜索（100次）
        pos1, pos2 = random.randint(0, len(line) - 1), random.randint(0, len(line) - 1)  # 交换点：随即从城市中选择两个城市
        # 复制当前路径，并交换生成新路径
        new_line = line.copy()
        new_line[pos1], new_line[pos2] = new_line[pos2], new_line[pos1]     # 在新路径中将随机选出的两个城市进行交换
        new_value = calFitness(new_line, dis_matrix)  # 当前路径距离
        # 新生成路径不在局部禁忌表和全局禁忌表中，为有效搜索，否则重新继续搜索
        if (new_line not in traversal_list) & (new_line not in tabu_list):
            traversal_list.append(new_line)
            traversal_value.append(new_value)
            traversal += 1
    return min(traversal_value), traversal_list[traversal_value.index(min(traversal_value))]    # 返回局部搜索后路径距离最短的路线及其距离


def greedy(CityCoordinates, dis_matrix):
    '''贪婪策略构造初始解'''
    # 出来dis_matrix
    dis_matrix = dis_matrix.astype('float64')
    for i in range(len(CityCoordinates)):
        dis_matrix.loc[i, i] = math.pow(10, 10)     # 将自己与自己的距离定义为一个极大的数
    line = []  # 初始化
    now_city = random.randint(0, len(CityCoordinates) - 1)  # 随机生成出发城市
    line.append(now_city)  # 添加当前城市到路径
    dis_matrix.loc[:, now_city] = math.pow(10, 10)  # 更新距离矩阵(使该城市所在列为一个极大的数)，已经过城市不再被取出
    for i in range(len(CityCoordinates) - 1):
        next_city = dis_matrix.loc[now_city, :].idxmin()  # 在该城市所在行中寻找值最小的城市，即与其距离最近的城市
        line.append(next_city)  # 添加进路径
        dis_matrix.loc[:, next_city] = math.pow(10, 10)  # 更新距离矩阵（使该城市所在列为一个极大的数）
        now_city = next_city  # 更新当前城市
    return line     # 返回贪婪算法获得的最短路径


# 画路径图
def draw_path(line, CityCoordinates):
    x, y = [], []
    for i in line:
        Coordinate = CityCoordinates[i]
        x.append(Coordinate[0])
        y.append(Coordinate[1])
    x.append(x[0])
    y.append(y[0])

    plt.plot(x, y, 'r-', color='#4169E1', alpha=0.8, linewidth=0.8)
    plt.xlabel('x')
    plt.ylabel('y')
    plt.show()


if __name__ == '__main__':
    # 参数
    CityNum = 20  # 城市数量
    MinCoordinate = 0  # 二维坐标最小值
    MaxCoordinate = 101  # 二维坐标最大值

    # TS参数
    tabu_limit = 50  # 禁忌长度，该值定义时应小于(CityNum*(CityNum-1)/2）
    iterMax = 200  # 迭代次数
    traversalMax = 100  # 每一代局部搜索次数

    tabu_list = []  # 禁忌表
    tabu_time = []  # 禁忌次数
    best_value = math.pow(10, 10)  # 较大的初始值，用于存储最优解
    best_line = []  # 存储最优路径

    # 随机生成城市数据,城市序号为0,1,2,3...
    CityCoordinates = [(random.randint(MinCoordinate, MaxCoordinate), random.randint(MinCoordinate, MaxCoordinate)) for
                       i in range(CityNum)]
    print(CityCoordinates)
    '''
    CityCoordinates = [(88, 16), (42, 76), (5, 76), (69, 13), (73, 56), (100, 100), (22, 92), (48, 74), (73, 46),
                         (39, 1), (51, 75), (92, 2), (101, 44), (55, 26), (71, 27), (42, 81), (51, 91), (89, 54),
                         (33, 18), (40, 78)]
    '''
    # 计算城市之间的距离
    dis_matrix = pd.DataFrame(data=None, columns=range(len(CityCoordinates)), index=range(len(CityCoordinates)))
    for i in range(len(CityCoordinates)):
        xi, yi = CityCoordinates[i][0], CityCoordinates[i][1]
        for j in range(len(CityCoordinates)):
            xj, yj = CityCoordinates[j][0], CityCoordinates[j][1]
            dis_matrix.iloc[i, j] = round(math.sqrt((xi - xj) ** 2 + (yi - yj) ** 2), 2)

    # #初始化,随机构造
    # line = list(range(len(CityCoordinates)));random.shuffle(line)
    # value = calFitness(line,dis_matrix)#初始路径距离
    # 贪婪构造
    line = greedy(CityCoordinates, dis_matrix)  # 用贪婪算法得到最短路径
    value = calFitness(line, dis_matrix)        # 初始路径距离

    # 存储初始化后的最优解
    best_value, best_line = value, line
    draw_path(best_line, CityCoordinates)
    best_value_list = []
    best_value_list.append(best_value)

    # 更新禁忌表
    tabu_list.append(line)          # 将贪婪算法所得到的的最初的最短路径先放入禁忌表中
    tabu_time.append(tabu_limit)    # 初始化禁忌次数
    '''
    至此，已有:
        ·由贪婪算法得到的最短路径极其距离
        ·目前的最佳路径（仅含由贪婪算法得到的最短路径）及其距离
        ·初始禁忌表（仅含由贪婪算法得到的最短路径）
        ·各城市之间的距离矩阵
    '''

    itera = 0  # 已进行迭代的次数
    while itera <= iterMax:
        new_value, new_line = traversal_search(line, dis_matrix, tabu_list)     # 遍历搜索——获得局部搜索后得到的最短路径（最优解）
        if new_value < best_value:  # 判断新获得的最优解是否优于本来的最优解
            best_value, best_line = new_value, new_line  # 更新最优解
            best_value_list.append(best_value)
        line, value = new_line, new_value  # 更新当前解

        # 更新禁忌表：如果禁忌次数到0了，则意味着禁忌表中的第一个元素可以解禁了
        tabu_time = [x - 1 for x in tabu_time]
        if 0 in tabu_time:
            tabu_list.remove(tabu_list[tabu_time.index(0)])
            tabu_time.remove(0)
        tabu_list.append(line)  # 把当前最优解放入禁忌表中作为已经探索过的路径，接下来非特殊情况就不再对该路径重复探索
        tabu_time.append(tabu_limit)    # 重新初始化禁忌次数
        itera += 1
    '''
    经过这样的循环后便可以获得迭代200次且每次局部都进行100次搜索的最优解
    '''

    # 路径顺序
    print(best_line)
    print(best_value)

    # 画路径图
    draw_path(best_line, CityCoordinates)

