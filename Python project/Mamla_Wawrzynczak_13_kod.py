import random
import networkx as nx
import matplotlib.pyplot as plt
import numpy as np

class DisjointSet:
    parent = {}

    def makeSet(self, n):
        # tworzenie n rozłącznych zbiorów (jeden dla każdego wierzchołka)
        for i in range(1,n):
            self.parent[i] = i

    # znajdowanie korzenia zbioru, do którego należy element 'k'
    def find(self, k):
        # gdy 'k' jest korzeniem
        if self.parent[k] == k:
            return k

        # Powtarzanie dla rodzica, aż znajdzie się korzeń
        return self.find(self.parent[k])

    # Połączenie dwóch podzbiorów
    def union(self, a, b):
        # Znajdowanie korzenia zbiorów, do których należą elementy x i y
        x = self.find(a)
        y = self.find(b)

        self.parent[x] = y

# 3 funkcje do rysowania
def CreateGraph(weight_matrix):
    G = nx.Graph()
    wtMatrix = []
    for i in range(len(weight_matrix)):
        list1 = weight_matrix[i]
        wtMatrix.append(list1)
    #print(wtMatrix)
    # Dodawanie krawędzi wraz z ich wagami do grafu
    for i in range(len(weight_matrix)):
        for j in range(len(weight_matrix))[i:]:
            if wtMatrix[i][j] > 0:
                G.add_edge(i+1, j+1, length=wtMatrix[i][j])
                #print(wtMatrix[i][j])

    return G

def DrawGraph(G):

    pos = nx.spring_layout(G)
    nx.draw(G, pos, with_labels=True)  # with_labels=true is to show the node number in the output graph

    #edge_labels = nx.get_edge_attributes(G, 'length')
    #print(edge_labels)
    #nx.draw_networkx_edge_labels(G, pos, edge_labels=edge_labels, font_size=11)  # prints weight on all the edges

    return pos

def draw(G,pos,mst):
    edge_labels = nx.get_edge_attributes(G, 'length')
    for X in mst:
        if (X[0], X[1]) in G.edges():
            nx.draw_networkx_edges(G, pos, edgelist=[(X[0], X[1])], width=2.5, alpha=0.6, edge_color='r')
    nx.draw_networkx_edge_labels(G, pos, edge_labels=edge_labels, font_size=11)  # dopisuje wagi do krawędzi

def heap_sort(arr):
    n = len(arr)

    # Budujemy kopiec
    for i in range(n//2-1, -1, -1):
        heapify(arr, n, i)

    # Iterujemy przez cały kopiec
    for i in range(n - 1, 0, -1):
        # Zamień największy element z ostatnim elementem
        arr[i], arr[0] = arr[0], arr[i]
        # Przeprowadź heapify na reszcie kopca
        heapify(arr, i, 0)

def heapify(arr, n, i):
    largest = i  # Największy element to obecnie sprawdzany element
    l = 2 * i + 1  # Lewe dziecko
    r = 2 * i + 2  # Prawe dziecko

    # Sprawdzamy, czy lewe dziecko jest większe od obecnego elementu
    if l < n and arr[l][2] > arr[i][2]:
        largest = l

    # Sprawdzamy, czy prawe dziecko jest większe od obecnego elementu lub lewego dziecka
    if r < n and arr[r][2] > arr[largest][2]:
        largest = r

    # Jeśli największy element nie jest już obecnym elementem, to zamień je miejscami
    if largest != i:
        arr[i], arr[largest] = arr[largest], arr[i]

        # Rekurencyjnie przeprowadź heapify na nowym podkopcu
        heapify(arr, n, largest)

# Implementacja algorytmu Kruskala
def runKruskalAlgorithm(edges, n):
    # listy przechowujące krawędzie należące do MST
    MST = []
    net = []

    # Tworzenie singletonów dla każdego wierzchołka
    ds = DisjointSet()
    ds.makeSet(n+1)

    index = 0
    cost = 0

    # Sortowanie względem wag krawędzi
    heap_sort(edges)

    while len(MST) != n - 1:

        # Rozważanie następnej krawędzi o minimalnej wadze z grafu
        (src, dest, weight) = edges[index]
        index = index + 1

        # Znajdowanie korzenia zbiorów, do których należą dwa końce wierzchołków następnej krawędzi
        x = ds.find(src)
        y = ds.find(dest)

        # Jeśli oba końce mają różnych rodziców, należą one do różnych połączonych podzbiorów i mogą być dodane do MST
        if x != y:
            MST.append((src, dest, weight))
            net.append((src, dest))
            ds.union(x, y)
            cost = cost + weight

    return MST, net, cost

if __name__ == '__main__':
    correct = 1  # tymczasowa zmienna
    while correct < 2:
        correct = 1
        print("Podaj naturalną liczbę miast n w zakresie [1,100]")
        n = input()
        n = int(n)
        while n <= 0 or n > 100 or type(n) != int:
            print("Niepoprawna liczba miast. Podaj nową liczbę miast:")
            n = input()
            n = int(n)
        print('Liczba miast:' + str(n))
        print("Podaj naturalną liczbę dróg m w zakresie [1,300]")
        m = input()
        m = int(m)
        while m <= 0 or m > 300 or type(m) != int:
            print("Niepoprawna liczba dróg. Podaj nową liczbę dróg:")
            m = input()
            m = int(m)
        print('Liczba dróg:' + str(m))


        # warunki konieczne do realizacji zadania
        if m < n:
            print("Jest mniej dróg niż miast, więć nie da się utworzyć autostrady, graf nie jest spójny! \n")
            correct = 0

        if m > n * (n - 1) // 2:
            m = n * (n - 1) // 2


        roads = []
        used_pairs = []
        while len(roads) < m:
            # Losujemy i i j z zakresu od 1 do n
            i = random.randint(1, n)
            j = random.randint(1, n)
            # Upewniamy się, że i jest różne od j
            while i == j:
                j = random.randint(1, n)
            # Sprawdzamy, czy para (i, j) lub (j, i) już wystąpiła na liście
            if (i, j) not in used_pairs and (j, i) not in used_pairs:
                # Jeśli nie, dodajemy parę do listy used_pairs
                used_pairs.append((i, j))

                k = round(random.uniform(0, 100), 2)
                roads.append((i, j, k))

        print(f"Ostateczna liczba dróg w zadaniu: {len(roads)} \n")
        print("Ciąg trójek (i, j, k):")
        print(roads)


        # Wprowadzamy macierz wag ozn.B
        B = np.zeros((n, n))
        for tuple in roads:
            B[tuple[0]-1][tuple[1]-1] = tuple[2]
            B[tuple[1]-1][tuple[0]-1] = tuple[2]
        for row in B:
            if all(element == 0 for element in row) == True:
                print("Nie ma połączenia pomiędzy dwoma miastami! \n")
                correct = 0
                break


        if correct == 1:
            mst, net_of_roads, sum_of_costs = runKruskalAlgorithm(roads, n)

            print(f"\nMST: \n {net_of_roads}")
            print(f"MST wraz z wagami: \n {mst}")
            print(f"Koszt autostrady: {round(sum_of_costs, 2)}")

            G = CreateGraph(B)
            pos = DrawGraph(G)
            draw(G, pos, mst)

            plt.show()



