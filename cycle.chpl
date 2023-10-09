use List;
use IO;
use Time;
use Sort;
use DistributedDeque;

record Graph {
    var numVertices: int;
    var numEdges: int;
    var adjacencyList: [1..numVertices] list(int);
    var nodeLabels: [1..numVertices] string;
    var edgeLabels: [1..numVertices, 1..numVertices] string;
    var nodeDegree: [1..numVertices] int;

    proc init(numVertices: int, numEdges: int) {
        this.numVertices = numVertices;
        this.numEdges = numEdges;
        edgeLabels = "Grey";
        nodeDegree = 0;
    }

    proc addNodeLabel(nodeIndex: int, Tlabel: string) {
        if nodeIndex >= 1 && nodeIndex <= this.numVertices {
            nodeLabels[nodeIndex] = Tlabel;
        }
    }

    proc addEdgeLabel(i: int, j: int, Tlabel: string) {
        if i >= 1 && i <= this.numVertices && j >= 1 && j <= this.numVertices {
            edgeLabels[i, j] = Tlabel;
            nodeDegree[i] += 1;
            nodeDegree[j] += 1;
        }
    }
}

proc NodeCompare(u: int, v: int, G:Graph): bool {
    if G.nodeDegree[u] < G.nodeDegree[v] {
        return true;
    } else if G.nodeDegree[u] == G.nodeDegree[v] && u < v{
        return true ;
    }
    return false;
}


proc calculateDistinct4Cycles(G: Graph) {
    //writeln("G.numVertices = ", G.numVertices);
    //writeln("G.nodeDegree = ", G.nodeDegree);
    
    var L: [1..G.numVertices] int = 0;
    var CycleG = 0;

    for v in 1..G.numVertices {
        for u in G.adjacencyList[v] {
            //writeln("NodeCompare(",u ,", ", v,") = ", NodeCompare(u , v, G));
            if NodeCompare(u , v, G) {
                for y in G.adjacencyList[u] {
                    //writeln("                      NodeCompare(",y ,", ", v,") = ", NodeCompare(y , v, G));
                    if NodeCompare(y, v, G) {
                        CycleG = CycleG + L[y];
                        L[y] += 1;
                       // writeln("CycleG =", CycleG);
                     //   writeln("L[] = ", L);
                    }
                }
            }
        }
        for u in G.adjacencyList[v] {
            //writeln("********************************outer loop");
            //writeln("NodeCompare(",u ,", ", v,") = ", NodeCompare(u , v, G));
            if NodeCompare(u , v, G) {
                for y in G.adjacencyList[u] {
                    L[y] = 0;
                    //writeln("L[] = ", L);
                }
                
            }
        }
    }
    //writeln("Total number of distinct 4-cycles in G:", CycleG);
    //writeln("L[] = ", L);
}


proc readGraphFromFile(filename: string, GraphNumVertices: int, GraphNumEdges: int): Graph {
    var myFile = open(filename, ioMode.r);
    var myFileReader = myFile.reader();

    var graph = new Graph(GraphNumVertices, GraphNumEdges);
    var line: string;
    while (myFileReader.readLine(line)) {
        var tokens = line.split(" ");

        if tokens[0] == "v" {
            var nodeIndex = (tokens[1]: int);
            var nodeLabel = tokens[2];
            graph.addNodeLabel(nodeIndex, nodeLabel);
        } else if tokens[0] == "e" {
            var i = (tokens[1]: int);
            var j = (tokens[2]: int);
            var edgeLabel: string = tokens[3];

            graph.adjacencyList[i].pushBack(j);
            
            graph.addEdgeLabel(i, j, edgeLabel);
        }
    }
    myFileReader.close();
    myFile.close();

    return graph;
}


proc main() {
    var G = new Graph(4, 4);
    G = readGraphFromFile("graph.txt", 4, 4);
    writeln(G.adjacencyList);

    var H = new Graph(4, 4);
    H = readGraphFromFile("subgraph.txt", 4 , 4);

    // Call the compute4Cycles function to calculate distinct 4-cycles
calculateDistinct4Cycles(G);
}

