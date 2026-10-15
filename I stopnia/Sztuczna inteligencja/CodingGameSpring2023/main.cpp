#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
#include <vector>
#include <queue>

using namespace std;

#define N 10000
const int distParam = 2, eggParam = 10, crystalParam = 8;
/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

int BFS(int start_index, int dist[], queue<int> que, int graph[][6]){
    int maxDist = 0;
    que.push(start_index);
    bool visited[N];
    visited[start_index] = true;
    while (!que.empty()){
        int temp = que.front();
        que.pop();
        for(int i = 0; i < 6; i++)
            if(graph[temp][i] != -1){
                int index = graph[temp][i];
                if (!visited[index]){
                    dist[index] = dist[temp] + 1;
                    if(dist[index] > maxDist)
                        maxDist = dist[index];
                    visited[index] = true;
                    que.push(index);
                }
            }
    }
    return maxDist;
}

int main()
{
    int graph[N][6];
    int fieldType[N];
    int fieldResources[N];
    int number_of_cells; // amount of hexagonal cells in this map
    int dist[N];

    cin >> number_of_cells; cin.ignore();
    for (int i = 0; i < number_of_cells; i++) {
        int type; // 0 for empty, 1 for eggs, 2 for crystal
        int initial_resources; // the initial amount of eggs/crystals on this cell
        int neigh_0; // the index of the neighbouring cell for each direction
        int neigh_1;
        int neigh_2;
        int neigh_3;
        int neigh_4;
        int neigh_5;
        cin >> type >> initial_resources >> neigh_0 >> neigh_1 >> neigh_2 >> neigh_3 >> neigh_4 >> neigh_5; cin.ignore();

        fieldType[i] = type;
        fieldResources[i] = initial_resources;

        graph[i][0]=neigh_0;
        graph[i][1]=neigh_1;
        graph[i][2]=neigh_2;
        graph[i][3]=neigh_3;
        graph[i][4]=neigh_4;
        graph[i][5]=neigh_5;

        if (neigh_0 != -1)
            graph[neigh_0][3]=i;
        if (neigh_1 != -1)
            graph[neigh_1][4]=i;
        if (neigh_2 != -1)
            graph[neigh_2][5]=i;
        if (neigh_3 != -1)
            graph[neigh_3][0]=i;
        if (neigh_4 != -1)
            graph[neigh_4][1]=i;
        if (neigh_5 != -1)
            graph[neigh_5][2]=i;

    }

    int number_of_bases;
    queue<int> queBFS;
    int maxDist = 0;

    cin >> number_of_bases; cin.ignore();
    for (int i = 0; i < number_of_bases; i++) {
        int my_base_index;
        cin >> my_base_index; cin.ignore();

        int temp = BFS(my_base_index, dist, queBFS, graph);
        if(temp > maxDist)
            maxDist = temp;
    }
    for (int i = 0; i < number_of_bases; i++) {
        int opp_base_index;
        cin >> opp_base_index; cin.ignore();

    }

    for (int i = 0; i < number_of_cells; i++)
        cerr<<i <<":" << dist[i] << "\n";

    int beaconStr[N];
    for (int i = 0; i < number_of_cells; i++) {

        beaconStr[i] =( maxDist - dist[i]) * distParam + fieldResources[i];

        if (fieldType[i] == 1)
            beaconStr[i] *= eggParam;
        if (fieldType[i] == 2)
            beaconStr[i] *= crystalParam;

        cout<<"BEACON " << i << " " << beaconStr[i]<<";";
    }

    // game loop
    while (1) {
        for (int i = 0; i < number_of_cells; i++) {
            int resources; // the current amount of eggs/crystals on this cell
            int my_ants; // the amount of your ants on this cell
            int opp_ants; // the amount of opponent ants on this cell
            cin >> resources >> my_ants >> opp_ants; cin.ignore();
            fieldResources[i] = resources;
            if (fieldResources[i] == 0)
                fieldType[i] = 0;

            beaconStr[i] =( maxDist - dist[i]) * distParam + fieldResources[i];

            if (fieldType[i] == 1)
                beaconStr[i] *= eggParam;
            if (fieldType[i] == 2)
                beaconStr[i] *= crystalParam;
        }

        // Write an action using cout. DON'T FORGET THE "<< endl"
        // To debug: cerr << "Debug messages..." << endl;


        // WAIT | LINE <sourceIdx> <targetIdx> <strength> | BEACON <cellIdx> <strength> | MESSAGE <text>

        for (int i = 0; i < number_of_cells; i++)
            cout<<"BEACON " << i << " " << beaconStr[i]<<";";

//        cout << "WAIT" << endl;
    }
}